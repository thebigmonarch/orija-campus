// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// One image, uploaded straight to Cloudinary, with the old one cleaned up.
///
/// Used everywhere a person sets a picture of themselves or their shop
/// (avatar, storefront logo/cover, verification photo), so upload and cleanup
/// behave the same on every page:
///
///  1. pick from the gallery, shrink and upload via `cloudinary-sign`
///     (signed, direct to Cloudinary, stored under the caller's own folder);
///  2. hand the new URL to [onSave] so the page can write it to its row;
///  3. only when that save succeeds, delete the image it replaced through
///     `cloudinary-delete`. If the save fails the NEW upload is deleted
///     instead, so a failed edit leaves nothing behind and the old image
///     stays in place.
///
/// Older images that predate the per-user folder layout are not deletable by
/// the server (it answers `not_owned_by_caller`) and are simply left.
class OrijaMediaField extends StatefulWidget {
  const OrijaMediaField({
    super.key,
    this.width,
    this.height,
    this.uploadContext,
    this.imageUrl,
    this.label,
    this.shape,
    this.onSave,
  });

  final double? width;
  final double? height;

  /// cloudinary-sign context: avatar | storefront_logo | storefront_cover |
  /// verification_doc. Defaults to avatar.
  final String? uploadContext;

  /// The image currently saved, if any.
  final String? imageUrl;

  /// Caption shown in the empty state ("Add a logo").
  final String? label;

  /// circle | wide | square. Defaults to square.
  final String? shape;

  /// Persist the new URL. Return true when saved. Dart-only callback: not a
  /// FlutterFlow parameter, so it is supplied by other custom widgets.
  final Future<bool> Function(String newUrl)? onSave;

  @override
  State<OrijaMediaField> createState() => _OrijaMediaFieldState();
}

class _OrijaMediaFieldState extends State<OrijaMediaField> {
  String? _url;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _url = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant OrijaMediaField old) {
    super.didUpdateWidget(old);
    if (!_busy && widget.imageUrl != old.imageUrl) _url = widget.imageUrl;
  }

  String get _context =>
      (widget.uploadContext ?? '').isEmpty ? 'avatar' : widget.uploadContext!;

  int get _maxSide => _context == 'storefront_cover' ? 1600 : 1000;

  Future<void> _deleteQuietly(String url) async {
    if (url.isEmpty) return;
    try {
      await Supabase.instance.client.functions
          .invoke('cloudinary-delete', body: {'url': url});
    } catch (_) {
      // Cleanup is best effort; the picture itself is already correct.
    }
  }

  Future<void> _pick() async {
    if (_busy) return;
    XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: _maxSide.toDouble(),
        imageQuality: 90,
      );
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not open your photos.');
      return;
    }
    if (picked == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    String? uploaded;
    try {
      final bytes = await picked.readAsBytes();
      if (bytes.isEmpty) throw Exception('empty file');
      final res = await pickUploadCloudinaryMedia(
        [FFUploadedFile(name: picked.name, bytes: bytes)],
        null,
        false,
        _context,
        _maxSide,
        85,
        0,
      );
      final urls = (res is Map ? res['mediaUrls'] : null) as List?;
      if (urls == null || urls.isEmpty) throw Exception('no url');
      uploaded = urls.first.toString();

      final saved =
          widget.onSave == null ? true : await widget.onSave!(uploaded);
      if (!saved) {
        unawaited(_deleteQuietly(uploaded));
        if (!mounted) return;
        setState(() {
          _busy = false;
          _error = 'Could not save the new picture. Nothing was changed.';
        });
        return;
      }

      final previous = _url;
      if (!mounted) return;
      setState(() {
        _url = uploaded;
        _busy = false;
      });
      if (previous != null && previous.isNotEmpty && previous != uploaded) {
        unawaited(_deleteQuietly(previous));
      }
    } catch (_) {
      if (uploaded != null) unawaited(_deleteQuietly(uploaded));
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Upload failed. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImage = (_url ?? '').isNotEmpty;
    final shape = widget.shape ?? 'square';
    final label = widget.label ?? 'Add a photo';

    Widget image(BorderRadius radius) => ClipRRect(
          borderRadius: radius,
          child: hasImage
              ? Image.network(
                  _url!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => _placeholder(theme, label),
                )
              : _placeholder(theme, label),
        );

    Widget overlay(BorderRadius radius) => _busy
        ? Positioned.fill(
            child: ClipRRect(
              borderRadius: radius,
              child: Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: Colors.white),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    final w = (widget.width ?? 0) > 0 ? widget.width : null;
    final h = (widget.height ?? 0) > 0 ? widget.height : null;

    Widget core;
    if (shape == 'circle') {
      final size = [if (w != null) w, if (h != null) h]
          .fold<double>(96, (a, b) => a == 96 ? b : (a < b ? a : b));
      final radius = BorderRadius.circular(size / 2);
      core = SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned.fill(child: image(radius)),
            overlay(radius),
            Positioned(right: 0, bottom: 0, child: _badge(theme)),
          ],
        ),
      );
    } else {
      final radius = BorderRadius.circular(14);
      core = SizedBox(
        width: w ?? (shape == 'wide' ? double.infinity : 120.0),
        height: h ?? (shape == 'wide' ? 140.0 : 120.0),
        child: Stack(
          children: [
            Positioned.fill(child: image(radius)),
            overlay(radius),
            Positioned(right: 8, bottom: 8, child: _badge(theme)),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: shape == 'wide'
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _busy ? null : _pick,
          behavior: HitTestBehavior.opaque,
          child: core,
        ),
        if (_error != null) ...[
          const SizedBox(height: 6),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.error, fontSize: 11.5),
          ),
        ],
      ],
    );
  }

  Widget _badge(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.secondary,
        shape: BoxShape.circle,
        border: Border.all(color: theme.primaryBackground, width: 2),
      ),
      child:
          const Icon(Icons.photo_camera_rounded, size: 14, color: Colors.white),
    );
  }

  Widget _placeholder(FlutterFlowTheme theme, String label) {
    return Container(
      color: theme.secondaryBackground,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              color: theme.secondaryText, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
