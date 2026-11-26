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

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

/// Picks/prepares media, asks the existing Supabase `cloudinary-sign` function
/// for signed credentials, then uploads to Cloudinary with those credentials.
///
/// Uses `package:http` for every network call (signing already goes through
/// the Supabase client). `dart:io`'s `HttpClient` and `File` compile on web
/// but throw `UnsupportedError` the moment they're actually used there — the
/// earlier version of this action used `HttpClient` for the Cloudinary
/// upload/download, which meant every upload silently failed on web (caught
/// by the caller's try/catch) while working fine on iOS/Android. `File` reads
/// for local paths are still native-only; on web that branch is skipped, since
/// `inputUrlsOrPaths` from a browser is never a real filesystem path anyway.
///
/// Return type in FlutterFlow: JSON.
Future<dynamic> pickUploadCloudinaryMedia(
  List<FFUploadedFile>? uploadedFiles,
  List<String>? inputUrlsOrPaths,
  bool allowMultiple,
  String context,
  int maxImageSide,
  int imageQuality,
  int maxVideoMb,
) async {
  final result = _CloudinaryUploadResult();
  final prepared = <_PreparedMedia>[];

  for (final file in uploadedFiles ?? const <FFUploadedFile>[]) {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) continue;
    final name = file.name ??
        'flutterflow-upload-${DateTime.now().millisecondsSinceEpoch}';
    prepared.add(await _prepareMedia(
      bytes: bytes,
      fileName: name,
      mimeType: lookupMimeType(name, headerBytes: bytes) ??
          'application/octet-stream',
      maxImageSide: maxImageSide,
      imageQuality: imageQuality,
    ));
  }

  for (final source in inputUrlsOrPaths ?? const <String>[]) {
    if (source.trim().isEmpty) continue;
    if (_isNetworkUrl(source)) {
      final bytes = await _downloadBytes(source);
      if (bytes == null) continue;
      final name = p.basename(Uri.parse(source).path).ifEmpty('remote-media');
      prepared.add(await _prepareMedia(
        bytes: bytes,
        fileName: name,
        mimeType: lookupMimeType(name, headerBytes: bytes) ??
            'application/octet-stream',
        maxImageSide: maxImageSide,
        imageQuality: imageQuality,
      ));
    } else if (!kIsWeb) {
      final file = File(source);
      if (!await file.exists()) continue;
      final bytes = await file.readAsBytes();
      prepared.add(await _prepareMedia(
        bytes: bytes,
        fileName: p.basename(source),
        mimeType: lookupMimeType(source, headerBytes: bytes) ??
            'application/octet-stream',
        maxImageSide: maxImageSide,
        imageQuality: imageQuality,
      ));
    }
  }

  if (prepared.isEmpty) {
    final selection = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      withData: true,
      type: FileType.media,
    );
    for (final file in selection?.files ?? const <PlatformFile>[]) {
      final bytes = file.bytes ??
          ((kIsWeb || file.path == null)
              ? null
              : await File(file.path!).readAsBytes());
      if (bytes == null || bytes.isEmpty) continue;
      prepared.add(await _prepareMedia(
        bytes: bytes,
        fileName: file.name,
        mimeType: lookupMimeType(file.name, headerBytes: bytes) ??
            'application/octet-stream',
        maxImageSide: maxImageSide,
        imageQuality: imageQuality,
      ));
    }
  }

  for (final media in prepared) {
    final signed = await _signCloudinaryUpload(
      context: context.ifEmpty('post_media'),
      mediaType: media.mediaType,
      resourceId: _resourceId(media.fileName),
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
      fileName: media.fileName,
      mimeType: media.mimeType,
      bytes: media.bytes,
    );

    final publicId = uploaded['public_id']?.toString() ?? signed.publicId;
    final secureUrl =
        uploaded['secure_url']?.toString() ?? uploaded['url']?.toString() ?? '';
    final optimized =
        _optimizedUrl(signed.cloudName, signed.resourceType, publicId);
    result.mediaUrls.add(secureUrl.ifEmpty(optimized));
    result.thumbnailUrls.add(_thumbnailUrl(
        signed.cloudName, signed.resourceType, publicId, media.mediaType));
    result.mediaTypes.add(media.mediaType);
    result.aspectRatios.add(media.aspectRatio);
    result.durations.add(media.durationMs);
    result.optimizedUrls.add(optimized);
  }

  return result.toJson();
}

Future<_PreparedMedia> _prepareMedia({
  required Uint8List bytes,
  required String fileName,
  required String mimeType,
  required int maxImageSide,
  required int imageQuality,
}) async {
  final isVideo = mimeType.startsWith('video/') || _looksLikeVideo(fileName);
  if (isVideo) {
    return _PreparedMedia(
      bytes: bytes,
      fileName: _withExtension(fileName, 'mp4'),
      mimeType: mimeType.startsWith('video/') ? mimeType : 'video/mp4',
      mediaType: 'video',
      aspectRatio: 1,
      durationMs: 0,
    );
  }

  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return _PreparedMedia(
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
      mediaType: 'image',
      aspectRatio: 1,
      durationMs: 0,
    );
  }

  img.Image output = decoded;
  final longest = math.max(decoded.width, decoded.height);
  if (maxImageSide > 0 && longest > maxImageSide) {
    final scale = maxImageSide / longest;
    output = img.copyResize(
      decoded,
      width: (decoded.width * scale).round(),
      height: (decoded.height * scale).round(),
      interpolation: img.Interpolation.average,
    );
  }

  final jpg = Uint8List.fromList(
      img.encodeJpg(output, quality: imageQuality.clamp(62, 95).toInt()));
  return _PreparedMedia(
    bytes: jpg,
    fileName: _withExtension(fileName, 'jpg'),
    mimeType: 'image/jpeg',
    mediaType: 'image',
    aspectRatio: output.width / math.max(output.height, 1),
    durationMs: 0,
  );
}

Future<_SignedUpload> _signCloudinaryUpload({
  required String context,
  required String mediaType,
  required String resourceId,
}) async {
  final response = await SupaFlow.client.functions.invoke(
    'cloudinary-sign',
    body: {
      'context': context,
      'resource_type': mediaType == 'video' ? 'video' : 'image',
      'resource_id': resourceId,
      'overwrite': true,
      'tags': 'flutterflow,media_editor,$mediaType',
      'transformation': 'q_auto,f_auto',
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
  return _SignedUpload(
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

/// Returns null (rather than throwing) on failure — the only caller already
/// skips a source that produced no bytes.
Future<Uint8List?> _downloadBytes(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode < 200 || response.statusCode >= 300) return null;
    return response.bodyBytes;
  } catch (_) {
    return null;
  }
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
    ..files.add(http.MultipartFile.fromBytes(
      fileField,
      bytes,
      filename: fileName,
      contentType: _mediaTypeOf(mimeType),
    ));

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);
  final decoded = jsonDecode(response.body);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Cloudinary upload failed: ${response.body}');
  }
  return Map<String, dynamic>.from(decoded as Map);
}

MediaType? _mediaTypeOf(String mimeType) {
  try {
    return MediaType.parse(mimeType);
  } catch (_) {
    return null;
  }
}

String _resourceId(String fileName) {
  final base = p
      .basenameWithoutExtension(fileName)
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return '${DateTime.now().millisecondsSinceEpoch}-${base.ifEmpty('media')}';
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

String _withExtension(String fileName, String extension) {
  return '${p.basenameWithoutExtension(fileName).ifEmpty('media')}.$extension';
}

bool _isNetworkUrl(String value) {
  final uri = Uri.tryParse(value);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

bool _looksLikeVideo(String fileName) {
  final ext = p.extension(fileName).toLowerCase();
  return const {'.mp4', '.mov', '.m4v', '.webm', '.avi', '.mkv'}.contains(ext);
}

class _CloudinaryUploadResult {
  final mediaUrls = <String>[];
  final thumbnailUrls = <String>[];
  final mediaTypes = <String>[];
  final aspectRatios = <double>[];
  final durations = <int>[];
  final optimizedUrls = <String>[];

  Map<String, dynamic> toJson() => {
        'mediaUrls': mediaUrls,
        'thumbnailUrls': thumbnailUrls,
        'mediaTypes': mediaTypes,
        'aspectRatios': aspectRatios,
        'durations': durations,
        'optimizedUrls': optimizedUrls,
      };
}

class _PreparedMedia {
  const _PreparedMedia({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    required this.mediaType,
    required this.aspectRatio,
    required this.durationMs,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final String mediaType;
  final double aspectRatio;
  final int durationMs;
}

class _SignedUpload {
  const _SignedUpload({
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
