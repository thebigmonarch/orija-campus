// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

/// Final secure export upload action.
///
/// Return type in FlutterFlow: JSON.
Future<dynamic> exportEditedMediaToCloudinary(
  List<dynamic> editPlan,
  List<FFUploadedFile>? renderedFiles,
  List<String>? renderedLocalPaths,
  String context,
  String quality,
) async {
  final assets = <_RenderedAsset>[];

  for (final file in renderedFiles ?? const <FFUploadedFile>[]) {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) continue;
    final name =
        file.name ?? 'edited-media-${DateTime.now().millisecondsSinceEpoch}';
    assets.add(_RenderedAsset(
      bytes: bytes,
      fileName: name,
      mimeType: lookupMimeType(name, headerBytes: bytes) ??
          'application/octet-stream',
      // Already-rendered bytes: edits are baked in, nothing left to ask
      // Cloudinary to apply.
      editTransformation: null,
    ));
  }

  for (final path in renderedLocalPaths ?? const <String>[]) {
    final file = File(path);
    if (!await file.exists()) continue;
    final bytes = await file.readAsBytes();
    assets.add(_RenderedAsset(
      bytes: bytes,
      fileName: p.basename(path),
      mimeType: lookupMimeType(path, headerBytes: bytes) ??
          'application/octet-stream',
      editTransformation: null,
    ));
  }

  // No pre-rendered bytes were supplied (the normal case today -- nothing
  // renders edits client-side yet): fall back to the original, unedited
  // bytes, but ask Cloudinary itself to apply the user's crop/filter/
  // adjust/trim choices via a transformation string on upload. This is
  // what actually makes the editor's controls do something instead of
  // being cosmetic.
  if (assets.isEmpty) {
    for (final item in editPlan) {
      if (item is! Map) continue;
      final url = item['url']?.toString();
      if (url == null || url.isEmpty) continue;
      final bytes = await _downloadBytes(url);
      final mediaType =
          item['mediaType']?.toString() == 'video' ? 'video' : 'image';
      assets.add(_RenderedAsset(
        bytes: bytes,
        fileName:
            'edited-${DateTime.now().microsecondsSinceEpoch}.${mediaType == 'video' ? 'mp4' : 'jpg'}',
        mimeType: mediaType == 'video' ? 'video/mp4' : 'image/jpeg',
        editTransformation:
            _buildEditTransformation(Map<String, dynamic>.from(item)),
      ));
    }
  }

  final finalUrls = <String>[];
  final thumbnails = <String>[];
  final mediaTypes = <String>[];

  for (var i = 0; i < assets.length; i++) {
    final asset = assets[i];
    final mediaType = asset.mimeType.startsWith('video/') ? 'video' : 'image';
    final signed = await _signFinalUpload(
      context: context.ifEmpty('post_media'),
      mediaType: mediaType,
      resourceId:
          'edited-${quality.toLowerCase()}-${DateTime.now().millisecondsSinceEpoch}-$i',
      extraTransformation: asset.editTransformation,
    );
    final uploaded = await _uploadMultipart(
      uploadUrl: signed.uploadUrl,
      fields: {
        'api_key': signed.apiKey,
        'timestamp': signed.timestamp.toString(),
        'signature': signed.signature,
        'public_id': signed.publicId,
        'overwrite': signed.overwrite.toString(),
        if (signed.tags != null) 'tags': signed.tags!,
        if (signed.transformation != null)
          'transformation': signed.transformation!,
      },
      fileField: 'file',
      fileName: asset.fileName,
      mimeType: asset.mimeType,
      bytes: asset.bytes,
    );

    final publicId = uploaded['public_id']?.toString() ?? signed.publicId;
    final url =
        uploaded['secure_url']?.toString() ?? uploaded['url']?.toString() ?? '';
    final optimized =
        _optimizedUrl(signed.cloudName, signed.resourceType, publicId);
    finalUrls.add(url.ifEmpty(optimized));
    thumbnails.add(_thumbnailUrl(
        signed.cloudName, signed.resourceType, publicId, mediaType));
    mediaTypes.add(mediaType);
  }

  return {
    'finalCloudinaryUrls': finalUrls,
    'finalThumbnailUrls': thumbnails,
    'finalMediaTypes': mediaTypes,
  };
}

// ── Edit-plan -> Cloudinary transformation translator ──────────────────
//
// Best-effort translation of AdvancedMediaEditorWidgetV2's declarative edit
// plan into a single Cloudinary transformation string, so crop/filter/
// adjust/trim actually affect the uploaded asset instead of being purely
// cosmetic in the editor's own live preview.
//
// Deliberately NOT covered (see the media-editor rebuild plan):
// - exposure/warmth/highlights/shadows adjustments -- no clean single-
//   parameter Cloudinary equivalent.
// - Multi-clip `segments`/`transition` -- Cloudinary can't express a
//   multi-segment timeline in one transformation string; real compositing
//   needs a separate video-processing pipeline.
// - The 12 filter presets are client-side RGBA colour matrices built for
//   live preview; they have no exact Cloudinary equivalent, so the mapping
//   below is a visual approximation, not a pixel-exact reproduction.
//
// Text/sticker overlay layers (`layers`) ARE now baked in, as Cloudinary
// `l_text:` overlays (see `_cloudinaryOpsForLayers`) -- each layer's on-
// screen position/size/rotation is converted to a fraction of the editor's
// own preview canvas box (via `canvasWidth`/`canvasHeight`, computed in
// the widget from the same AspectRatio sizing it renders with) and
// re-applied with `fl_relative` so it lands in roughly the same spot
// regardless of the final image's resolution. This is a best-effort
// reproduction, not a pixel-exact one: Cloudinary text rendering (font
// metrics, emoji glyph support) won't exactly match Flutter's.

const List<String> _kFilterOrder = [
  'Normal',
  'Vivid',
  'Warm',
  'Cool',
  'Fade',
  'Drama',
  'Noir',
  'Chrome',
  'Vintage',
  'Cinematic',
  'VHS',
  'Golden',
];

/// Builds the full transformation string for one edit-plan item, or null if
/// nothing in it actually changes the output.
String? _buildEditTransformation(Map<String, dynamic> item) {
  final ops = <String>[];

  final crop = item['crop'];
  if (crop is Map) {
    ops.addAll(_cloudinaryOpsForCrop(Map<String, dynamic>.from(crop)));
  }

  final filterIndex = (item['filterIndex'] as num?)?.toInt() ?? 0;
  final filterIntensity = (item['filterIntensity'] as num?)?.toDouble() ?? 1;
  ops.addAll(_cloudinaryOpsForFilter(filterIndex, filterIntensity));

  final adjust = item['adjust'];
  if (adjust is Map) {
    ops.addAll(_cloudinaryOpsForAdjust(Map<String, dynamic>.from(adjust)));
  }

  if (item['mediaType']?.toString() == 'video') {
    ops.addAll(_cloudinaryOpsForVideo(item));
  }

  // Layer overlays must each be their own `/`-separated transformation
  // component (a Cloudinary overlay + its `fl_layer_apply` step) -- they
  // can't be folded into the single comma-joined `ops` list above.
  final segments = <String>[];
  if (ops.isNotEmpty) segments.add(ops.join(','));
  segments.addAll(_cloudinaryOpsForLayers(item));

  return segments.isEmpty ? null : segments.join('/');
}

/// Turns each text/sticker layer into a Cloudinary text-overlay pair:
/// `l_text:<font>_<size>:<text>,co_rgb:<hex>` then
/// `fl_layer_apply,fl_relative,g_north_west,x_<fx>,y_<fy>[,a_<deg>]`.
/// Position/size are expressed as a fraction of the editor's own preview
/// canvas (`canvasWidth`/`canvasHeight`, set by the widget before export)
/// so they scale to whatever size the final image actually uploads at.
List<String> _cloudinaryOpsForLayers(Map<String, dynamic> item) {
  final layers = item['layers'];
  if (layers is! List || layers.isEmpty) return const [];
  final canvasWidth = (item['canvasWidth'] as num?)?.toDouble() ?? 0;
  final canvasHeight = (item['canvasHeight'] as num?)?.toDouble() ?? 0;
  if (canvasWidth <= 0 || canvasHeight <= 0) return const [];

  // Scales the editor's logical-pixel font size (relative to its own
  // on-screen canvas) to roughly match how big it should look once baked
  // into an image of any resolution -- anchored to the app's standard
  // upload width so on-screen and final sizing stay visually consistent.
  const referenceWidth = 1600.0;

  final ops = <String>[];
  for (final raw in layers) {
    if (raw is! Map) continue;
    final layer = Map<String, dynamic>.from(raw);
    final value = layer['value']?.toString() ?? '';
    if (value.isEmpty) continue;

    final x = (layer['x'] as num?)?.toDouble() ?? 0;
    final y = (layer['y'] as num?)?.toDouble() ?? 0;
    final scale = (layer['scale'] as num?)?.toDouble() ?? 1;
    final rotationRad = (layer['rotation'] as num?)?.toDouble() ?? 0;
    final fontSize = (layer['fontSize'] as num?)?.toDouble() ?? 28;
    final colorValue = (layer['color'] as num?)?.toInt() ?? 0xFFFFFFFF;

    final fx = (x / canvasWidth).clamp(0.0, 1.0);
    final fy = (y / canvasHeight).clamp(0.0, 1.0);
    final scaledFontSize = ((fontSize * scale) / canvasWidth * referenceWidth)
        .round()
        .clamp(8, 400);
    final hex = (colorValue & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    final rotationDeg = rotationRad * 180 / math.pi;

    ops.add('l_text:Arial_${scaledFontSize}_bold:${Uri.encodeComponent(value)}'
        ',co_rgb:$hex');
    final applyOps = <String>[
      'fl_layer_apply',
      'fl_relative',
      'g_north_west',
      'x_${fx.toStringAsFixed(4)}',
      'y_${fy.toStringAsFixed(4)}',
    ];
    if (rotationDeg.abs() > 0.5) {
      applyOps.add('a_${rotationDeg.toStringAsFixed(1)}');
    }
    ops.add(applyOps.join(','));
  }
  return ops;
}

List<String> _cloudinaryOpsForCrop(Map<String, dynamic> crop) {
  final ops = <String>[];
  final rotation = (crop['rotationDeg'] as num?)?.toDouble() ?? 0;
  final flipH = crop['flipH'] == true;
  final flipV = crop['flipV'] == true;

  final angleParts = <String>[];
  if (flipH) angleParts.add('hflip');
  if (flipV) angleParts.add('vflip');
  if (rotation != 0) angleParts.add(rotation.toStringAsFixed(1));
  if (angleParts.isNotEmpty) ops.add('a_${angleParts.join('.')}');

  const aspectRatios = {'1:1', '4:5', '9:16', '16:9'};
  final aspectLabel = '${crop['aspectLabel'] ?? 'Free'}';
  if (aspectRatios.contains(aspectLabel)) {
    ops.add('ar_$aspectLabel');
    ops.add('c_fill');
    ops.add('g_auto');
  }
  return ops;
}

/// Approximate nearest-equivalent Cloudinary effect(s) for each of the
/// editor's 12 color-matrix filter presets, scaled by [intensity] (0-1,
/// matching the editor's own Intensity slider range).
List<String> _cloudinaryOpsForFilter(int filterIndex, double intensity) {
  final name = (filterIndex >= 0 && filterIndex < _kFilterOrder.length)
      ? _kFilterOrder[filterIndex]
      : 'Normal';
  final clamped = intensity.clamp(0, 1);
  int scaled(num base) => (base * clamped).round();

  switch (name) {
    case 'Vivid':
      return ['e_saturation:${scaled(45)}'];
    case 'Warm':
      return ['e_tint:${scaled(25)}:ffaa55'];
    case 'Cool':
      return ['e_tint:${scaled(25)}:55aaff'];
    case 'Fade':
      return ['e_saturation:${scaled(-35)}', 'e_brightness:${scaled(12)}'];
    case 'Drama':
      return ['e_contrast:${scaled(35)}', 'e_saturation:${scaled(15)}'];
    case 'Noir':
      // This preset's matrix is the exact standard grayscale luminance
      // weighting -- the one filter with a true 1:1 Cloudinary equivalent.
      return ['e_grayscale'];
    case 'Chrome':
      return ['e_saturation:${scaled(18)}', 'e_contrast:${scaled(10)}'];
    case 'Vintage':
      return ['e_sepia:${scaled(45)}', 'e_saturation:${scaled(-20)}'];
    case 'Cinematic':
      return ['e_contrast:${scaled(15)}', 'e_tint:${scaled(12)}:1a3a4a'];
    case 'VHS':
      return ['e_sepia:${scaled(15)}', 'e_saturation:${scaled(-10)}'];
    case 'Golden':
      return ['e_tint:${scaled(30)}:ffb833', 'e_saturation:${scaled(10)}'];
    case 'Normal':
    default:
      return [];
  }
}

/// Adjust sliders are all -1..1 (sharpness 0..1) in the editor; Cloudinary's
/// numeric effects use roughly -100..100, so values are scaled by 100.
List<String> _cloudinaryOpsForAdjust(Map<String, dynamic> adjust) {
  final ops = <String>[];
  void addScaled(String effect, String key) {
    final v = (adjust[key] as num?)?.toDouble() ?? 0;
    final scaled = (v * 100).round();
    if (scaled != 0) ops.add('$effect:$scaled');
  }

  addScaled('e_brightness', 'brightness');
  addScaled('e_contrast', 'contrast');
  addScaled('e_saturation', 'saturation');
  addScaled('e_vibrance', 'vibrance');

  final sharpness = (adjust['sharpness'] as num?)?.toDouble() ?? 0;
  if (sharpness > 0) ops.add('e_sharpen:${(sharpness * 300).round()}');

  return ops;
}

List<String> _cloudinaryOpsForVideo(Map<String, dynamic> item) {
  final ops = <String>[];

  final trimStartMs = (item['trimStartMs'] as num?)?.toInt() ?? 0;
  final trimEndMs = (item['trimEndMs'] as num?)?.toInt() ?? 0;
  final durationMs = (item['durationMs'] as num?)?.toInt() ?? 0;
  if (trimStartMs > 0 || (trimEndMs > 0 && trimEndMs < durationMs)) {
    ops.add('so_${(trimStartMs / 1000).toStringAsFixed(2)}');
    if (trimEndMs > trimStartMs) {
      ops.add('eo_${(trimEndMs / 1000).toStringAsFixed(2)}');
    }
  }

  final video = item['video'];
  if (video is Map) {
    final speed = (video['speed'] as num?)?.toDouble() ?? 1;
    if (speed != 1 && speed > 0) {
      final pct = ((speed - 1) * 100).round().clamp(-50, 100);
      ops.add('e_accelerate:$pct');
    }
    if (video['reverse'] == true) ops.add('e_reverse');
  }

  final audio = item['audio'];
  if (audio is Map && audio['muted'] == true) {
    ops.add('ac_none');
  }

  return ops;
}

Future<_SignedFinalUpload> _signFinalUpload({
  required String context,
  required String mediaType,
  required String resourceId,
  String? extraTransformation,
}) async {
  final baseTransformation = 'q_auto,f_auto';
  // A layer overlay's own transformation component (l_text:...) must never
  // get merged into the same comma-list as q_auto,f_auto -- those flags
  // would then apply to the overlay definition instead of the final
  // output. Multi-component edit transformations (anything with a `/`,
  // i.e. once layers are involved) get q_auto,f_auto as their own
  // leading component instead.
  final transformation =
      (extraTransformation == null || extraTransformation.isEmpty)
          ? baseTransformation
          : extraTransformation.contains('/')
              ? '$baseTransformation/$extraTransformation'
              : '$baseTransformation,$extraTransformation';
  final response = await SupaFlow.client.functions.invoke(
    'cloudinary-sign',
    body: {
      'context': context,
      'resource_type': mediaType == 'video' ? 'video' : 'image',
      'resource_id': resourceId,
      'overwrite': true,
      'tags': 'flutterflow,media_editor,final,$mediaType',
      'transformation': transformation,
    },
  );
  final data = response.data;
  final json = data is Map<String, dynamic>
      ? data
      : Map<String, dynamic>.from(data as Map);
  if (json['success'] != true) {
    throw Exception(
        json['message'] ?? json['error'] ?? 'cloudinary-sign failed');
  }
  return _SignedFinalUpload(
    uploadUrl: json['upload_url'] as String,
    apiKey: json['api_key'] as String,
    timestamp: (json['timestamp'] as num).toInt(),
    signature: json['signature'] as String,
    publicId: json['public_id'] as String,
    cloudName: json['cloud_name'] as String,
    resourceType: json['resource_type'] as String,
    overwrite: json['overwrite'] as bool? ?? true,
    tags: json['tags'] as String?,
    transformation: json['transformation'] as String?,
  );
}

// dart:io's HttpClient is socket-based and has no implementation on
// Flutter Web -- every member throws UnsupportedError('Platform._version')
// there. That's the exact "Could not save the edit. Unsupported
// operation: Platform._version" the Done button started surfacing the
// moment it got real error handling: this was failing on web all along,
// just silently. package:http works on every platform FlutterFlow
// targets (web included), so both network calls below now use it.

Future<Uint8List> _downloadBytes(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Could not download source media: ${response.statusCode}');
  }
  return response.bodyBytes;
}

Future<Map<String, dynamic>> _uploadMultipart({
  required String uploadUrl,
  required Map<String, String> fields,
  required String fileField,
  required String fileName,
  required String mimeType,
  required Uint8List bytes,
}) async {
  final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
    ..fields.addAll(fields)
    ..files.add(http.MultipartFile.fromBytes(fileField, bytes,
        filename: fileName, contentType: MediaType.parse(mimeType)));
  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Cloudinary upload failed: ${response.body}');
  }
  return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
}

String _thumbnailUrl(
    String cloudName, String resourceType, String publicId, String mediaType) {
  final transform = mediaType == 'video'
      ? 'so_auto,w_480,h_480,c_fill,q_auto,f_jpg'
      : 'w_480,h_480,c_fill,q_auto,f_auto';
  return 'https://res.cloudinary.com/$cloudName/$resourceType/upload/$transform/$publicId';
}

String _optimizedUrl(String cloudName, String resourceType, String publicId) {
  return 'https://res.cloudinary.com/$cloudName/$resourceType/upload/q_auto,f_auto/$publicId';
}

class _RenderedAsset {
  const _RenderedAsset({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.editTransformation,
  });
  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final String? editTransformation;
}

class _SignedFinalUpload {
  const _SignedFinalUpload({
    required this.uploadUrl,
    required this.apiKey,
    required this.timestamp,
    required this.signature,
    required this.publicId,
    required this.cloudName,
    required this.resourceType,
    required this.overwrite,
    this.tags,
    this.transformation,
  });

  final String uploadUrl;
  final String apiKey;
  final int timestamp;
  final String signature;
  final String publicId;
  final String cloudName;
  final String resourceType;
  final bool overwrite;
  final String? tags;
  final String? transformation;
}

extension _StringX on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
