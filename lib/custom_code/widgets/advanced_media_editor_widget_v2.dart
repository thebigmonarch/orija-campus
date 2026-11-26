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
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class AdvancedMediaEditorWidgetV2 extends StatefulWidget {
  const AdvancedMediaEditorWidgetV2({
    super.key,
    this.width,
    this.height,
    this.mediaUrls,
    this.mediaTypes,
    this.uploadedFiles,
    this.uploadContext = 'post_media',
    this.maxImageSide = 2160,
    this.imageQuality = 84,
    this.maxVideoMb = 80,
    this.thumbnailUrls,
    this.aspectRatios,
    this.durations,
    this.onExport,
    this.onClose,
  });

  final double? width;
  final double? height;
  final List<String>? mediaUrls;
  final List<String>? mediaTypes;
  final List<FFUploadedFile>? uploadedFiles;
  final String uploadContext;
  final int maxImageSide;
  final int imageQuality;
  final int maxVideoMb;
  final List<String>? thumbnailUrls;
  final List<double>? aspectRatios;
  final List<int>? durations;

  /// Return the exported final Cloudinary payload from a FlutterFlow action.
  ///
  /// The recommended callback implementation is:
  /// 1. Render/process each edit plan with FFmpeg/image tools.
  /// 2. Call the same Supabase `cloudinary-sign` flow used by upload.
  /// 3. Upload final media to Cloudinary.
  /// 4. Return JSON:
  ///    {
  ///      "finalCloudinaryUrls": [...],
  ///      "finalThumbnailUrls": [...],
  ///      "finalMediaTypes": [...]
  ///    }
  final Future<dynamic> Function(List<dynamic> editPlan, String quality)?
      onExport;
  final Future Function()? onClose;

  @override
  State<AdvancedMediaEditorWidgetV2> createState() =>
      _AdvancedMediaEditorWidgetV2State();
}

class _AdvancedMediaEditorWidgetV2State
    extends State<AdvancedMediaEditorWidgetV2> with TickerProviderStateMixin {
  late final PageController _pageController;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final List<_AeEditableMedia> _items = [];
  final List<List<_AeEditableMedia>> _history = [];
  int _historyIndex = -1;

  int _activeIndex = 0;
  int _activeTab = 0;
  int _activeLayer = -1;
  bool _showOriginal = false;
  bool _isExporting = false;
  bool _isUploadingInitialMedia = false;
  double _exportProgress = 0;
  String? _uploadError;
  String? _lastUploadKey;
  List<String>? _uploadedMediaUrls;
  List<String>? _uploadedMediaTypes;
  List<String>? _uploadedThumbnailUrls;
  List<double>? _uploadedAspectRatios;
  List<int>? _uploadedDurations;
  String _exportQuality = '1080p';
  double _timelineZoom = 1.0;
  bool _snapTimeline = true;
  double _playheadMs = 0;

  Color _accent = const Color(0xFF6750A4);
  Color _bg = Colors.black;
  Color _surface = const Color(0xFF101010);
  Color _border = const Color(0xFF303030);
  Size _previewSize = Size.zero;
  Color _primaryText = Colors.white;
  Color _secondaryText = Colors.white70;

  static const _tabs = <_AeEditorTab>[
    _AeEditorTab('Queue', Icons.video_library_rounded),
    _AeEditorTab('Timeline', Icons.view_timeline_rounded),
    _AeEditorTab('Filters', Icons.auto_awesome_rounded),
    _AeEditorTab('Adjust', Icons.tune_rounded),
    _AeEditorTab('Crop', Icons.crop_rotate_rounded),
    _AeEditorTab('Video', Icons.movie_filter_rounded),
    _AeEditorTab('Audio', Icons.graphic_eq_rounded),
    _AeEditorTab('Text', Icons.text_fields_rounded),
    _AeEditorTab('Stickers', Icons.emoji_emotions_outlined),
    _AeEditorTab('Export', Icons.cloud_upload_outlined),
  ];

  // 9 ("Export") is intentionally excluded -- the quality/compression
  // picker it held is gone; Done (top bar) now runs the export directly
  // with sensible defaults, no extra screen.
  List<int> get _visibleTabIndexes {
    if (_items.isEmpty) return const <int>[0, 2, 3, 4, 7, 8];
    if (_active.mediaType == 'video') {
      return const <int>[0, 1, 2, 3, 4, 5, 6, 7, 8];
    }
    return const <int>[0, 2, 3, 4, 7, 8];
  }

  int get _effectiveTab {
    final visible = _visibleTabIndexes;
    return visible.contains(_activeTab) ? _activeTab : visible.first;
  }

  static const _filters = <_AeFilterPreset>[
    _AeFilterPreset('Normal',
        <double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]),
    _AeFilterPreset('Vivid', <double>[
      1.35,
      0,
      0,
      0,
      -18,
      0,
      1.35,
      0,
      0,
      -18,
      0,
      0,
      1.35,
      0,
      -18,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Warm', <double>[
      1.15,
      .05,
      0,
      0,
      10,
      .02,
      1.05,
      0,
      0,
      0,
      0,
      0,
      .82,
      0,
      -12,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Cool', <double>[
      .87,
      0,
      .05,
      0,
      -5,
      0,
      .94,
      .04,
      0,
      5,
      .06,
      0,
      1.18,
      0,
      18,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Fade', <double>[
      .88,
      0,
      0,
      0,
      16,
      0,
      .88,
      0,
      0,
      16,
      0,
      0,
      .88,
      0,
      16,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Drama', <double>[
      1.45,
      0,
      0,
      0,
      -32,
      0,
      1.45,
      0,
      0,
      -32,
      0,
      0,
      1.45,
      0,
      -32,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Noir', <double>[
      .33,
      .59,
      .11,
      0,
      0,
      .33,
      .59,
      .11,
      0,
      0,
      .33,
      .59,
      .11,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Chrome', <double>[
      1.12,
      0,
      0,
      0,
      8,
      -.04,
      1,
      -.04,
      0,
      4,
      0,
      0,
      .94,
      0,
      -6,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Vintage', <double>[
      .90,
      .06,
      .04,
      0,
      5,
      .04,
      .88,
      .04,
      0,
      10,
      .02,
      .04,
      .76,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Cinematic', <double>[
      1.08,
      -.04,
      .06,
      0,
      -4,
      -.02,
      1.02,
      .04,
      0,
      0,
      .08,
      .02,
      1.12,
      0,
      4,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('VHS', <double>[
      1.12,
      .03,
      -.02,
      0,
      6,
      -.03,
      .98,
      .03,
      0,
      2,
      .04,
      -.02,
      1.05,
      0,
      5,
      0,
      0,
      0,
      1,
      0
    ]),
    _AeFilterPreset('Golden', <double>[
      1.2,
      .1,
      0,
      0,
      12,
      .05,
      1.05,
      0,
      0,
      5,
      0,
      0,
      .78,
      0,
      -8,
      0,
      0,
      0,
      1,
      0
    ]),
  ];

  _AeEditableMedia get _active => _items[_activeIndex];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _hydrateItems();
    _pushHistory();
    _warmVisibleControllers();
    _maybeUploadIncomingFiles();
  }

  @override
  void didUpdateWidget(covariant AdvancedMediaEditorWidgetV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mediaUrls != widget.mediaUrls ||
        oldWidget.mediaTypes != widget.mediaTypes ||
        oldWidget.uploadedFiles != widget.uploadedFiles ||
        oldWidget.uploadContext != widget.uploadContext) {
      _disposeVideoControllers();
      _items.clear();
      _uploadedMediaUrls = null;
      _uploadedMediaTypes = null;
      _uploadedThumbnailUrls = null;
      _uploadedAspectRatios = null;
      _uploadedDurations = null;
      _uploadError = null;
      _activeIndex = 0;
      _hydrateItems();
      _pushHistory();
      _warmVisibleControllers();
      _maybeUploadIncomingFiles();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeVideoControllers();
    super.dispose();
  }

  void _hydrateItems() {
    final widgetMediaUrls = _safeStringList(widget.mediaUrls);
    final widgetMediaTypes = _safeStringList(widget.mediaTypes);
    final widgetThumbnailUrls = _safeStringList(widget.thumbnailUrls);
    final widgetAspectRatios = _safeDoubleList(widget.aspectRatios);
    final widgetDurations = _safeIntList(widget.durations);
    final mediaUrls = widgetMediaUrls.isNotEmpty
        ? widgetMediaUrls
        : _safeStringList(_uploadedMediaUrls);
    final mediaTypes = widgetMediaTypes.isNotEmpty
        ? widgetMediaTypes
        : _safeStringList(_uploadedMediaTypes);
    final thumbnailUrls = widgetThumbnailUrls.isNotEmpty
        ? widgetThumbnailUrls
        : _safeStringList(_uploadedThumbnailUrls);
    final aspectRatios = widgetAspectRatios.isNotEmpty
        ? widgetAspectRatios
        : _safeDoubleList(_uploadedAspectRatios);
    final durations = widgetDurations.isNotEmpty
        ? widgetDurations
        : _safeIntList(_uploadedDurations);

    for (var i = 0; i < mediaUrls.length; i++) {
      final mediaUrl = _cleanUrl(mediaUrls[i]);
      if (mediaUrl.isEmpty) continue;
      final type = i < mediaTypes.length
          ? _inferType(mediaTypes[i])
          : _inferType(mediaUrl);
      final duration = i < durations.length
          ? durations[i]
          : (type == 'video' ? 15000 : 3500);
      final thumb =
          i < thumbnailUrls.length ? _cleanUrl(thumbnailUrls[i]) : mediaUrl;
      _items.add(_AeEditableMedia(
        id: 'media-$i-${DateTime.now().microsecondsSinceEpoch}',
        url: mediaUrl,
        mediaType: type == 'video' ? 'video' : 'image',
        thumbnailUrl: thumb.isNotEmpty ? thumb : mediaUrl,
        aspectRatio: i < aspectRatios.length
            ? aspectRatios[i].clamp(.1, 10).toDouble()
            : 1,
        durationMs: duration,
        trimStartMs: 0,
        trimEndMs: duration,
      ));
    }

    if (_items.isEmpty) {
      final files = widget.uploadedFiles ?? const <FFUploadedFile>[];
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = file.bytes;
        if (bytes == null || bytes.isEmpty) continue;
        final name = file.name ?? 'uploaded-media-$i';
        final type = _inferType(name);
        final isImage = type == 'image';
        _items.add(_AeEditableMedia(
          id: 'local-$i-${DateTime.now().microsecondsSinceEpoch}',
          url: '',
          mediaType: type,
          thumbnailUrl: '',
          localBytes: isImage ? bytes : null,
          aspectRatio: 1,
          durationMs: type == 'video' ? 15000 : 3500,
          trimStartMs: 0,
          trimEndMs: type == 'video' ? 15000 : 3500,
        ));
      }
    }

    if (_items.isEmpty) {
      _items.add(_AeEditableMedia.empty());
    }
  }

  Future<void> _maybeUploadIncomingFiles() async {
    final files = widget.uploadedFiles ?? const <FFUploadedFile>[];
    final hasRemoteUrls = _safeStringList(widget.mediaUrls).isNotEmpty;
    if (files.isEmpty || hasRemoteUrls || _isUploadingInitialMedia) return;

    final uploadKey = files
        .asMap()
        .entries
        .map((entry) => '${entry.key}:${entry.value.name ?? 'media'}')
        .join('|');
    if (uploadKey.isEmpty || uploadKey == _lastUploadKey) return;
    _lastUploadKey = uploadKey;

    setState(() {
      _isUploadingInitialMedia = true;
      _uploadError = null;
    });

    try {
      final result = await pickUploadCloudinaryMedia(
        files,
        null,
        true,
        widget.uploadContext,
        widget.maxImageSide,
        widget.imageQuality,
        widget.maxVideoMb,
      );
      if (result is! Map) {
        throw Exception('Upload action returned unexpected data: $result');
      }
      final json = Map<String, dynamic>.from(result);
      if (!mounted) return;
      setState(() {
        _uploadedMediaUrls = _jsonStringList(json['mediaUrls']);
        _uploadedMediaTypes = _jsonStringList(json['mediaTypes']);
        _uploadedThumbnailUrls = _jsonStringList(json['thumbnailUrls']);
        _uploadedAspectRatios = _jsonDoubleList(json['aspectRatios']);
        _uploadedDurations = _jsonIntList(json['durations']);
        _items.clear();
        _activeIndex = 0;
        _isUploadingInitialMedia = false;
      });
      _hydrateItems();
      _pushHistory();
      _warmVisibleControllers();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isUploadingInitialMedia = false;
        _uploadError = 'Initial upload failed: $error';
      });
    }
  }

  void _disposeVideoControllers() {
    for (final c in _videoControllers.values) {
      c.dispose();
    }
    _videoControllers.clear();
  }

  Future<void> _warmVisibleControllers() async {
    for (final i in {_activeIndex - 1, _activeIndex, _activeIndex + 1}) {
      if (i >= 0 && i < _items.length && _items[i].mediaType == 'video') {
        await _controllerFor(i);
      }
    }
    final keys = _videoControllers.keys.toList();
    for (final key in keys) {
      if ((key - _activeIndex).abs() > 1) {
        await _videoControllers.remove(key)?.dispose();
      }
    }
  }

  Future<VideoPlayerController?> _controllerFor(int index) async {
    if (_videoControllers.containsKey(index)) return _videoControllers[index];
    final item = _items[index];
    if (item.mediaType != 'video' || !_isUsableNetworkUrl(item.url))
      return null;
    final controller = VideoPlayerController.networkUrl(Uri.parse(item.url));
    _videoControllers[index] = controller;
    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(item.audio.muted ? 0 : item.audio.volume);
      if (mounted) setState(() {});
    } catch (_) {
      await controller.dispose();
      _videoControllers.remove(index);
      return null;
    }
    return controller;
  }

  void _pushHistory() {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(_items.map((e) => e.clone()).toList());
    _historyIndex = _history.length - 1;
    if (_history.length > 60) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  void _restoreHistory(int index) {
    setState(() {
      _items
        ..clear()
        ..addAll(_history[index].map((e) => e.clone()));
      _activeIndex = _activeIndex.clamp(0, _items.length - 1).toInt();
      _activeLayer = -1;
    });
  }

  void _undo() {
    if (_historyIndex <= 0) return;
    _historyIndex--;
    _restoreHistory(_historyIndex);
  }

  void _redo() {
    if (_historyIndex >= _history.length - 1) return;
    _historyIndex++;
    _restoreHistory(_historyIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    _accent = theme.primary;
    _bg = theme.primaryBackground;
    _surface = theme.secondaryBackground;
    _border = theme.alternate;
    _primaryText = theme.primaryText;
    _secondaryText = theme.secondaryText;

    final width = widget.width ?? MediaQuery.sizeOf(context).width;
    final height = widget.height ?? MediaQuery.sizeOf(context).height;

    return Container(
      width: width,
      height: height,
      color: _bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topBar(),
                Expanded(child: _previewStage()),
                // The Queue tab's own panel (_queuePanel(), below the rail)
                // already shows this exact thumbnail row -- plus reorder/
                // duplicate/delete controls the compact strip doesn't have.
                // Showing both at once duplicated the same thumbnails
                // on screen, so skip the compact strip while Queue is open.
                if (_effectiveTab != 0)
                  if (_active.mediaType == 'video')
                    _compactTimeline()
                  else
                    _imageQueueStrip(),
                _tabRail(),
                _activePanel(),
              ],
            ),
            if (_isUploadingInitialMedia || _uploadError != null)
              _initialUploadOverlay(),
            if (_isExporting) _exportOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _surface.withOpacity(.78),
            border: Border(bottom: BorderSide(color: _border.withOpacity(.7))),
          ),
          child: Row(
            children: [
              _toolButton(Icons.close_rounded, () {
                final close = widget.onClose;
                if (close != null) {
                  close();
                } else {
                  Navigator.of(context).maybePop();
                }
              }),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _active.mediaType == 'video'
                          ? 'Video Editor'
                          : 'Image Editor',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: _primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${_activeIndex + 1}/${_items.length}  ${_active.durationLabel}',
                      style: TextStyle(color: _secondaryText, fontSize: 11),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onLongPressStart: (_) => setState(() => _showOriginal = true),
                onLongPressEnd: (_) => setState(() => _showOriginal = false),
                child: _toolButton(Icons.compare_rounded, () {}),
              ),
              const SizedBox(width: 6),
              _toolButton(Icons.undo_rounded, _historyIndex > 0 ? _undo : null,
                  dim: _historyIndex <= 0),
              const SizedBox(width: 6),
              _toolButton(Icons.redo_rounded,
                  _historyIndex < _history.length - 1 ? _redo : null,
                  dim: _historyIndex >= _history.length - 1),
              const SizedBox(width: 8),
              _primaryPill(Icons.check_rounded, 'Done', _runExport),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewStage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Text/sticker layer x/y are dropped as Positioned(left:, top:)
        // inside the AspectRatio-fitted canvas box below -- recorded here
        // so export can convert them into a fraction of that same box
        // (see _fitAspect / _runExport) instead of a device-specific pixel
        // offset that means nothing once baked into the uploaded image.
        _previewSize = constraints.biggest;
        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (i) {
                setState(() {
                  _activeIndex = i;
                  _playheadMs = _items[i].trimStartMs.toDouble();
                  _activeLayer = -1;
                });
                _warmVisibleControllers();
              },
              itemBuilder: (_, i) => _mediaCanvas(i, constraints.biggest),
            ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  _glassChip(
                      Icons.layers_rounded, '${_active.layers.length} layers'),
                  const SizedBox(width: 8),
                  if (_active.mediaType == 'video')
                    _glassChip(Icons.content_cut_rounded,
                        '${_active.segments.length} clips'),
                  const Spacer(),
                  _glassChip(
                      _snapTimeline
                          ? Icons.grid_4x4_rounded
                          : Icons.grid_off_rounded,
                      _snapTimeline ? 'Snap' : 'Free'),
                ],
              ),
            ),
            if (_showOriginal)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(18)),
                      child: const Text('ORIGINAL',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 11)),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _mediaCanvas(int index, Size size) {
    final item = _items[index];
    return Center(
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: _effectiveAspectRatio(item),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width,
              maxHeight: size.height,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _activeLayer = -1),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _transformedMedia(index),
                  if (!_showOriginal && item.effects.vignette > 0)
                    _vignette(item.effects.vignette),
                  if (!_showOriginal && item.effects.glow > 0)
                    _glow(item.effects.glow),
                  if (!_showOriginal && item.effects.grain > 0)
                    CustomPaint(painter: _AeGrainPainter(item.effects.grain)),
                  if (_activeTab == 4)
                    CustomPaint(painter: _AeCropGridPainter(_accent)),
                  ...item.layers
                      .asMap()
                      .entries
                      .map((entry) => _editableLayer(entry.key, entry.value)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _transformedMedia(int index) {
    final item = _items[index];
    Widget media = item.mediaType == 'video'
        ? _videoPreview(index)
        : item.localBytes != null
            ? _memoryImagePreview(item.localBytes!, fit: _cropFit(item))
            : _imagePreview(item.url, fit: _cropFit(item));
    if (!_showOriginal && item.effects.blur > 0) {
      media = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
            sigmaX: item.effects.blur * 10, sigmaY: item.effects.blur * 10),
        child: media,
      );
    }
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..scale(item.crop.flipH ? -1.0 : 1.0, item.crop.flipV ? -1.0 : 1.0),
      child: Transform.rotate(
        angle: item.crop.rotationDeg * math.pi / 180,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
              _showOriginal ? _AeFilterPreset.identity : _matrixFor(item)),
          child: media,
        ),
      ),
    );
  }

  Widget _imagePreview(String url, {BoxFit fit = BoxFit.contain}) {
    if (!_isUsableNetworkUrl(url))
      return _placeholder(Icons.image_outlined, 'No media');
    return Image.network(
      url,
      fit: fit,
      filterQuality: FilterQuality.medium,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : _placeholder(Icons.downloading_rounded, 'Loading'),
      errorBuilder: (_, __, ___) =>
          _placeholder(Icons.broken_image_outlined, 'Image unavailable'),
    );
  }

  Widget _memoryImagePreview(Uint8List bytes, {BoxFit fit = BoxFit.contain}) {
    return Image.memory(
      bytes,
      fit: fit,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) =>
          _placeholder(Icons.broken_image_outlined, 'Image unavailable'),
    );
  }

  /// Once a crop aspect preset is chosen, the canvas box itself reshapes
  /// to that ratio (see _effectiveAspectRatio) -- the image then needs
  /// BoxFit.cover (fill + crop the overflow) instead of BoxFit.contain
  /// (letterbox), or the preview would just show empty bars instead of an
  /// actual crop, matching the c_fill Cloudinary applies on export.
  BoxFit _cropFit(_AeEditableMedia item) =>
      item.crop.aspectLabel == 'Free' ? BoxFit.contain : BoxFit.cover;

  /// The canvas shape a photo/video renders at and its layers are
  /// positioned against. Defaults to the media's own aspect ratio until a
  /// crop preset is picked, then switches to that preset's ratio -- this
  /// is what makes the Crop tab's aspect chips actually crop something
  /// visible instead of silently doing nothing.
  double _effectiveAspectRatio(_AeEditableMedia item) {
    switch (item.crop.aspectLabel) {
      case '1:1':
        return 1;
      case '4:5':
        return 4 / 5;
      case '9:16':
        return 9 / 16;
      case '16:9':
        return 16 / 9;
      default:
        return item.aspectRatio <= 0 ? 1 : item.aspectRatio;
    }
  }

  Widget _videoPreview(int index) {
    final item = _items[index];
    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) {
      _controllerFor(index);
      return Stack(
        fit: StackFit.expand,
        children: [
          _imagePreview(item.thumbnailUrl),
          Container(color: Colors.black26),
          Center(
              child: CircularProgressIndicator(color: _accent, strokeWidth: 2)),
        ],
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: Row(
            children: [
              _roundIcon(
                controller.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                () {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _accent,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: _accent,
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: controller.value.position.inMilliseconds
                        .clamp(
                            0,
                            math.max(
                                controller.value.duration.inMilliseconds, 1))
                        .toDouble(),
                    max: math
                        .max(controller.value.duration.inMilliseconds, 1)
                        .toDouble(),
                    onChanged: (value) {
                      controller.seekTo(Duration(milliseconds: value.round()));
                      setState(() => _playheadMs = value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _editableLayer(int index, _AeOverlayLayer layer) {
    final selected = _activeLayer == index;
    return Positioned(
      left: layer.x,
      top: layer.y,
      child: GestureDetector(
        onTap: () => setState(() => _activeLayer = index),
        onDoubleTap: () => _editTextLayer(index),
        onPanUpdate: (d) => setState(() {
          layer.x += d.delta.dx;
          layer.y += d.delta.dy;
        }),
        onScaleUpdate: (d) => setState(() {
          layer.scale = (layer.scale * d.scale).clamp(.25, 4.0);
          layer.rotation += d.rotation;
        }),
        child: Transform.rotate(
          angle: layer.rotation,
          child: Transform.scale(
            scale: layer.scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.all(5),
              decoration: selected
                  ? BoxDecoration(
                      border: Border.all(color: _accent, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: layer.kind == 'sticker'
                  ? Text(layer.value,
                      style: TextStyle(fontSize: layer.fontSize))
                  : Text(
                      layer.value,
                      style: TextStyle(
                        color: layer.color,
                        fontSize: layer.fontSize,
                        fontWeight: FontWeight.w800,
                        shadows: const [
                          Shadow(
                              color: Colors.black87,
                              blurRadius: 5,
                              offset: Offset(1, 1))
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactTimeline() {
    final totalMs =
        _items.fold<int>(0, (sum, item) => sum + item.editedDurationMs);
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: _surface.withOpacity(.96),
        border: Border(top: BorderSide(color: _border.withOpacity(.65))),
      ),
      child: Row(
        children: [
          _roundIcon(
              Icons.remove_rounded,
              () => setState(
                  () => _timelineZoom = (_timelineZoom - .25).clamp(.75, 3.0))),
          const SizedBox(width: 6),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _items.length,
              itemBuilder: (_, i) => _timelineClip(i, totalMs),
            ),
          ),
          const SizedBox(width: 6),
          _roundIcon(
              Icons.add_rounded,
              () => setState(
                  () => _timelineZoom = (_timelineZoom + .25).clamp(.75, 3.0))),
        ],
      ),
    );
  }

  Widget _imageQueueStrip() {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: _surface.withOpacity(.96),
        border: Border(top: BorderSide(color: _border.withOpacity(.65))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          final active = i == _activeIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _activeIndex = i);
              _pageController.animateToPage(i,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 56,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: active ? _accent : _border, width: active ? 2 : 1),
                image: _thumbnailDecoration(item),
                color: _primaryText.withOpacity(.06),
              ),
              child: item.mediaType == 'video'
                  ? const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.play_circle_fill_rounded,
                            color: Colors.white, size: 16),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _timelineClip(int index, int totalMs) {
    final item = _items[index];
    final active = index == _activeIndex;
    final width = math.max(72.0,
        item.editedDurationMs / math.max(totalMs, 1) * 320 * _timelineZoom);
    return GestureDetector(
      onTap: () {
        setState(() => _activeIndex = index);
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
      },
      onLongPress: () => _duplicateClip(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: width,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: active ? _accent : _border, width: active ? 2 : 1),
          image: _thumbnailDecoration(item, opacity: .58),
          color: _primaryText.withOpacity(.06),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.38),
                      Colors.transparent,
                      Colors.black.withOpacity(.45)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                left: 6,
                top: 5,
                child: Icon(
                    item.mediaType == 'video'
                        ? Icons.movie_rounded
                        : Icons.image_rounded,
                    color: Colors.white,
                    size: 14)),
            Positioned(
                left: 6,
                bottom: 5,
                child: Text(item.durationLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700))),
            if (active)
              Positioned(
                top: 0,
                bottom: 0,
                left: (width *
                        ((_playheadMs - item.trimStartMs) /
                            math.max(item.editedDurationMs, 1)))
                    .clamp(0, width - 2)
                    .toDouble(),
                child: Container(width: 2, color: _accent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tabRail() {
    final visibleTabs = _visibleTabIndexes;
    final effectiveTab = _effectiveTab;
    return Container(
      height: 64,
      color: _surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        itemCount: visibleTabs.length,
        itemBuilder: (_, i) {
          final tabIndex = visibleTabs[i];
          final tab = _tabs[tabIndex];
          final active = tabIndex == effectiveTab;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _activeTab = tabIndex);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 68,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: active ? _accent : Colors.transparent,
                        width: 2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tab.icon,
                      color: active ? _accent : _primaryText.withOpacity(.42),
                      size: 20),
                  const SizedBox(height: 3),
                  Text(tab.label,
                      style: TextStyle(
                          color: active ? _accent : _secondaryText,
                          fontSize: 9.5,
                          fontWeight:
                              active ? FontWeight.w800 : FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _activePanel() {
    final tab = _effectiveTab;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (tab) {
        0 => _queuePanel(),
        1 => _timelinePanel(),
        2 => _filtersPanel(),
        3 => _adjustPanel(),
        4 => _cropPanel(),
        5 => _videoPanel(),
        6 => _audioPanel(),
        7 => _textPanel(),
        8 => _stickerPanel(),
        9 => _exportPanel(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _queuePanel() {
    return _panel(
      key: const ValueKey('queue'),
      height: 154,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        itemCount: _items.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
            _activeIndex = newIndex;
          });
          _pushHistory();
        },
        itemBuilder: (_, i) {
          final item = _items[i];
          return Container(
            key: ValueKey(item.id),
            width: 92,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _activeIndex = i);
                      _pageController.jumpToPage(i);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: i == _activeIndex ? _accent : _border,
                            width: i == _activeIndex ? 2 : 1),
                        image: _thumbnailDecoration(item),
                        color: _primaryText.withOpacity(.05),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                              item.mediaType == 'video'
                                  ? Icons.play_circle_fill_rounded
                                  : Icons.image_rounded,
                              color: Colors.white,
                              size: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _miniIcon(Icons.copy_rounded, () => _duplicateClip(i)),
                    const SizedBox(width: 6),
                    _miniIcon(Icons.delete_outline_rounded,
                        _items.length > 1 ? () => _deleteClip(i) : null),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _timelinePanel() {
    final item = _active;
    return _panel(
      key: const ValueKey('timeline'),
      height: 178,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              // Split/Duplicate/Merge built a multi-clip `segments`/
              // `transition` edit plan that exportEditedMediaToCloudinary
              // explicitly never applies (Cloudinary can't express a
              // multi-segment timeline in one transformation; real
              // compositing needs a separate video pipeline, out of scope
              // today). They looked fully interactive but had zero effect
              // on the saved video, so they're hidden until that's built.
              // Delete (which does work -- it just drops the clip from the
              // export batch) stays.
              _actionChip(Icons.delete_sweep_rounded, 'Delete',
                  () => _deleteClip(_activeIndex)),
              const Spacer(),
              _roundIcon(
                  _snapTimeline
                      ? Icons.grid_on_rounded
                      : Icons.grid_off_rounded,
                  () => setState(() => _snapTimeline = !_snapTimeline)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Trim',
                  style: TextStyle(color: _secondaryText, fontSize: 11)),
              Expanded(
                child: RangeSlider(
                  values: RangeValues(
                      item.trimStartMs.toDouble(), item.trimEndMs.toDouble()),
                  min: 0,
                  max: math.max(item.durationMs, 1).toDouble(),
                  activeColor: _accent,
                  inactiveColor: _border,
                  onChanged: (values) => setState(() {
                    item.trimStartMs = _snap(values.start)
                        .clamp(0, item.durationMs - 1)
                        .toInt();
                    item.trimEndMs = _snap(values.end)
                        .clamp(item.trimStartMs + 1, item.durationMs)
                        .toInt();
                  }),
                  onChangeEnd: (_) => _pushHistory(),
                ),
              ),
              Text(item.durationLabel,
                  style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          Row(
            children: [
              Text('Zoom',
                  style: TextStyle(color: _secondaryText, fontSize: 11)),
              Expanded(
                child: Slider(
                  value: _timelineZoom,
                  min: .75,
                  max: 3,
                  activeColor: _accent,
                  inactiveColor: _border,
                  onChanged: (v) => setState(() => _timelineZoom = v),
                ),
              ),
              Text('${(_timelineZoom * 100).round()}%',
                  style: TextStyle(color: _secondaryText, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filtersPanel() {
    return _panel(
      key: const ValueKey('filters'),
      height: 170,
      child: Column(
        children: [
          SizedBox(
            height: 108,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final active = _active.filterIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _active.filterIndex = i);
                    _pushHistory();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 70,
                    margin: const EdgeInsets.only(right: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: active ? _accent : Colors.transparent,
                          width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColorFiltered(
                              colorFilter:
                                  ColorFilter.matrix(_filters[i].matrix),
                              child: _imagePreview(_active.thumbnailUrl)),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(_filters[i].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: active ? _accent : Colors.white,
                                      fontSize: 9)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _sliderRow(
              'Intensity',
              Icons.opacity_rounded,
              _active.filterIntensity,
              0,
              1,
              (v) => setState(() => _active.filterIntensity = v),
              onEnd: _pushHistory),
        ],
      ),
    );
  }

  Widget _adjustPanel() {
    final item = _active;
    return _panel(
      key: const ValueKey('adjust'),
      height: 244,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        child: Column(
          children: [
            _sliderRow(
                'Brightness',
                Icons.wb_sunny_outlined,
                item.adjust.brightness,
                -1,
                1,
                (v) => setState(() => item.adjust.brightness = v),
                onEnd: _pushHistory),
            _sliderRow('Contrast', Icons.contrast_rounded, item.adjust.contrast,
                -1, 1, (v) => setState(() => item.adjust.contrast = v),
                onEnd: _pushHistory),
            _sliderRow('Exposure', Icons.exposure_rounded, item.adjust.exposure,
                -1, 1, (v) => setState(() => item.adjust.exposure = v),
                onEnd: _pushHistory),
            _sliderRow(
                'Saturation',
                Icons.water_drop_outlined,
                item.adjust.saturation,
                -1,
                1,
                (v) => setState(() => item.adjust.saturation = v),
                onEnd: _pushHistory),
            _sliderRow('Warmth', Icons.thermostat_outlined, item.adjust.warmth,
                -1, 1, (v) => setState(() => item.adjust.warmth = v),
                onEnd: _pushHistory),
            _sliderRow(
                'Vibrance',
                Icons.colorize_outlined,
                item.adjust.vibrance,
                -1,
                1,
                (v) => setState(() => item.adjust.vibrance = v),
                onEnd: _pushHistory),
            _sliderRow(
                'Highlights',
                Icons.flare_rounded,
                item.adjust.highlights,
                -1,
                1,
                (v) => setState(() => item.adjust.highlights = v),
                onEnd: _pushHistory),
            _sliderRow(
                'Shadows',
                Icons.nights_stay_outlined,
                item.adjust.shadows,
                -1,
                1,
                (v) => setState(() => item.adjust.shadows = v),
                onEnd: _pushHistory),
            _sliderRow('Sharpness', Icons.deblur_rounded, item.adjust.sharpness,
                0, 1, (v) => setState(() => item.adjust.sharpness = v),
                onEnd: _pushHistory),
          ],
        ),
      ),
    );
  }

  Widget _cropPanel() {
    final crop = _active.crop;
    return _panel(
      key: const ValueKey('crop'),
      height: 164,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        children: [
          _sliderRow('Rotate', Icons.rotate_right_rounded, crop.rotationDeg,
              -45, 45, (v) => setState(() => crop.rotationDeg = v),
              suffix: '${crop.rotationDeg.toStringAsFixed(1)} deg',
              onEnd: _pushHistory),
          const SizedBox(height: 8),
          Row(
            children: [
              _actionChip(Icons.flip_rounded, 'Flip H', () {
                setState(() => crop.flipH = !crop.flipH);
                _pushHistory();
              }, active: crop.flipH),
              const SizedBox(width: 8),
              _actionChip(Icons.flip_rounded, 'Flip V', () {
                setState(() => crop.flipV = !crop.flipV);
                _pushHistory();
              }, active: crop.flipV),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        ['Free', '1:1', '4:5', '9:16', '16:9'].map((label) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _textChip(label, crop.aspectLabel == label, () {
                          setState(() => crop.aspectLabel = label);
                          _pushHistory();
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _videoPanel() {
    final item = _active;
    return _panel(
      key: const ValueKey('video'),
      height: 244,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                _actionChip(Icons.slow_motion_video_rounded, 'Slow',
                    item.mediaType == 'video' ? () => _setSpeed(.5) : null,
                    active: item.video.speed == .5),
                const SizedBox(width: 8),
                _actionChip(Icons.speed_rounded, 'Fast',
                    item.mediaType == 'video' ? () => _setSpeed(2) : null,
                    active: item.video.speed == 2),
                const SizedBox(width: 8),
                _actionChip(
                    Icons.keyboard_return_rounded,
                    'Reverse',
                    item.mediaType == 'video'
                        ? () {
                            setState(
                                () => item.video.reverse = !item.video.reverse);
                            _pushHistory();
                          }
                        : null,
                    active: item.video.reverse),
                const SizedBox(width: 8),
                _actionChip(
                    Icons.bolt_rounded,
                    'Beat sync',
                    item.mediaType == 'video'
                        ? () {
                            setState(() =>
                                item.video.beatSync = !item.video.beatSync);
                            _pushHistory();
                          }
                        : null,
                    active: item.video.beatSync),
              ],
            ),
            const SizedBox(height: 10),
            _sliderRow('Speed', Icons.speed_rounded, item.video.speed, .25, 4,
                (v) => setState(() => item.video.speed = (v * 4).round() / 4),
                suffix: '${item.video.speed.toStringAsFixed(2)}x',
                onEnd: _pushHistory),
            _sliderRow('Blur', Icons.blur_on_rounded, item.effects.blur, 0, 1,
                (v) => setState(() => item.effects.blur = v),
                onEnd: _pushHistory),
            _sliderRow('Glow', Icons.flare_rounded, item.effects.glow, 0, 1,
                (v) => setState(() => item.effects.glow = v),
                onEnd: _pushHistory),
            _sliderRow('Grain', Icons.noise_aware_rounded, item.effects.grain,
                0, 1, (v) => setState(() => item.effects.grain = v),
                onEnd: _pushHistory),
            _sliderRow(
                'Vignette',
                Icons.vignette_rounded,
                item.effects.vignette,
                0,
                1,
                (v) => setState(() => item.effects.vignette = v),
                onEnd: _pushHistory),
            const SizedBox(height: 8),
            _optionWrap(
                'Effects',
                const [
                  'None',
                  'Cinematic LUT',
                  'VHS',
                  'RGB Glitch',
                  'Motion Blur',
                  'Retro'
                ],
                item.video.effect, (v) {
              setState(() => item.video.effect = v);
              _pushHistory();
            }),
            const SizedBox(height: 8),
            _optionWrap(
                'Transition',
                const [
                  'None',
                  'Fade',
                  'Blur',
                  'Swipe',
                  'Zoom',
                  'Push',
                  'Flash',
                  'Stretch',
                  'Spin'
                ],
                item.transition, (v) {
              setState(() => item.transition = v);
              _pushHistory();
            }),
          ],
        ),
      ),
    );
  }

  Widget _audioPanel() {
    final audio = _active.audio;
    return _panel(
      key: const ValueKey('audio'),
      height: 210,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              _actionChip(
                  audio.muted
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  audio.muted ? 'Muted' : 'Audio', () {
                setState(() => audio.muted = !audio.muted);
                _videoControllers[_activeIndex]
                    ?.setVolume(audio.muted ? 0 : audio.volume);
                _pushHistory();
              }, active: !audio.muted),
              // Music/Voiceover/Beat-sync just flipped a highlighted flag --
              // there was never a file picker or audio track behind them,
              // and nothing downstream (export) read these fields. Hidden
              // until real audio attachment is built. Mute + the sliders
              // below stay -- those do work (setVolume is real).
            ],
          ),
          const SizedBox(height: 10),
          _sliderRow('Volume', Icons.graphic_eq_rounded, audio.volume, 0, 1,
              (v) {
            setState(() => audio.volume = v);
            _videoControllers[_activeIndex]?.setVolume(audio.muted ? 0 : v);
          }, suffix: '${(audio.volume * 100).round()}%', onEnd: _pushHistory),
          _sliderRow(
              'Fade in',
              Icons.trending_up_rounded,
              audio.fadeInMs.toDouble(),
              0,
              5000,
              (v) => setState(() => audio.fadeInMs = v.round()),
              suffix: '${(audio.fadeInMs / 1000).toStringAsFixed(1)}s',
              onEnd: _pushHistory),
          _sliderRow(
              'Fade out',
              Icons.trending_down_rounded,
              audio.fadeOutMs.toDouble(),
              0,
              5000,
              (v) => setState(() => audio.fadeOutMs = v.round()),
              suffix: '${(audio.fadeOutMs / 1000).toStringAsFixed(1)}s',
              onEnd: _pushHistory),
        ],
      ),
    );
  }

  Widget _textPanel() {
    return _panel(
      key: const ValueKey('text'),
      height: 150,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              _primaryPill(Icons.add_rounded, 'Text',
                  () => _addLayer('text', 'New Text')),
              const SizedBox(width: 8),
              _actionChip(Icons.subtitles_rounded, 'Caption',
                  () => _addLayer('text', 'Caption')),
              const SizedBox(width: 8),
              _actionChip(Icons.closed_caption_rounded, 'Subtitle',
                  () => _addLayer('text', 'Subtitle')),
              const Spacer(),
              if (_activeLayer >= 0)
                _miniIcon(Icons.delete_outline_rounded, _deleteActiveLayer),
            ],
          ),
          const SizedBox(height: 12),
          if (_activeLayer >= 0 && _active.layers[_activeLayer].kind == 'text')
            _sliderRow(
                'Size',
                Icons.format_size_rounded,
                _active.layers[_activeLayer].fontSize,
                12,
                84,
                (v) =>
                    setState(() => _active.layers[_activeLayer].fontSize = v),
                onEnd: _pushHistory)
          else
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Tap a text layer to resize, drag, rotate, or edit.',
                    style: TextStyle(color: _secondaryText, fontSize: 11))),
        ],
      ),
    );
  }

  Widget _stickerPanel() {
    const stickers = [
      '🔥',
      '✨',
      '💯',
      '❤️',
      '🎵',
      '⭐',
      '🚀',
      '💎',
      'GIF',
      'SALE',
      'NEW',
      'LOL'
    ];
    return _panel(
      key: const ValueKey('stickers'),
      height: 154,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: stickers.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _addLayer('sticker', stickers[i]),
          child: Container(
            width: 58,
            decoration: BoxDecoration(
                color: _primaryText.withOpacity(.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _border.withOpacity(.7))),
            child: Center(
                child: Text(stickers[i],
                    style: TextStyle(
                        color: _primaryText,
                        fontSize: stickers[i].length > 2 ? 13 : 25,
                        fontWeight: FontWeight.w800))),
          ),
        ),
      ),
    );
  }

  Widget _exportPanel() {
    const qualities = ['480p', '720p', '1080p', 'Original'];
    return _panel(
      key: const ValueKey('export'),
      height: 174,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        children: [
          Row(
            children: qualities.map((q) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _textChip(q, _exportQuality == q,
                      () => setState(() => _exportQuality = q)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _progressLabel('Compression', .33)),
              const SizedBox(width: 8),
              Expanded(child: _progressLabel('Render', .66)),
              const SizedBox(width: 8),
              Expanded(child: _progressLabel('Cloudinary', 1)),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _runExport,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: _accent.withOpacity(.32),
                      blurRadius: 18,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: _bg, size: 19),
                  const SizedBox(width: 8),
                  Text('Export final media',
                      style: TextStyle(
                          color: _bg,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Replicates AspectRatio's own sizing algorithm so export can compute,
  /// for any item, the exact on-screen box its layers were positioned
  /// against -- without needing a live RenderBox at export time.
  Size _fitAspect(Size available, double aspectRatio) {
    if (available.width <= 0 || available.height <= 0) return available;
    final ar = aspectRatio <= 0 ? 1.0 : aspectRatio;
    var w = available.width;
    var h = w / ar;
    if (h > available.height) {
      h = available.height;
      w = h * ar;
    }
    return Size(w, h);
  }

  Future<void> _runExport() async {
    setState(() {
      _isExporting = true;
      _exportProgress = 0;
    });
    HapticFeedback.mediumImpact();

    final timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() => _exportProgress = math.min(.92, _exportProgress + .025));
    });

    try {
      final payload = _items.map((item) {
        final plan = item.toExportPlan();
        final canvas = _fitAspect(_previewSize, _effectiveAspectRatio(item));
        plan['canvasWidth'] = canvas.width;
        plan['canvasHeight'] = canvas.height;
        return plan;
      }).toList();
      // onExport used to be able to throw (a network error, Cloudinary
      // rejecting the upload, anything) with nothing catching it here --
      // the exception just vanished up into the framework, the progress
      // overlay quietly closed in `finally` below, and Done looked like it
      // did nothing at all. Now a failure always ends with a visible
      // error instead of silence.
      await widget.onExport?.call(payload, _exportQuality);
      if (mounted) {
        setState(() => _exportProgress = 1);
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Could not save your edit. $e'),
            backgroundColor: Colors.red.shade700));
      }
    } finally {
      timer.cancel();
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportProgress = 0;
        });
      }
    }
  }

  Widget _exportOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(.58),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: _surface.withOpacity(.82),
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(18)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                        value: _exportProgress <= 0 ? null : _exportProgress,
                        color: _accent),
                    const SizedBox(height: 16),
                    Text('Exporting securely',
                        style: TextStyle(
                            color: _primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Just a moment, almost there.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _secondaryText, fontSize: 11, height: 1.35)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialUploadOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(.62),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _surface.withOpacity(.88),
                  border: Border.all(color: _border),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_uploadError == null) ...[
                      CircularProgressIndicator(
                          color: _accent, strokeWidth: 2.5),
                      const SizedBox(height: 16),
                      Text('Preparing media',
                          style: TextStyle(
                              color: _primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                        'Just a moment...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _secondaryText, fontSize: 11, height: 1.35),
                      ),
                    ] else ...[
                      Icon(Icons.error_outline_rounded,
                          color: FlutterFlowTheme.of(context).error, size: 34),
                      const SizedBox(height: 12),
                      Text('Upload failed',
                          style: TextStyle(
                              color: _primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                        _uploadError!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _secondaryText, fontSize: 11, height: 1.35),
                      ),
                      const SizedBox(height: 14),
                      _primaryPill(Icons.refresh_rounded, 'Retry', () {
                        setState(() {
                          _lastUploadKey = null;
                          _uploadError = null;
                        });
                        _maybeUploadIncomingFiles();
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<double> _matrixFor(_AeEditableMedia item) {
    const identity = _AeFilterPreset.identity;
    final preset =
        _filters[item.filterIndex.clamp(0, _filters.length - 1).toInt()].matrix;
    var m = List<double>.generate(20,
        (i) => identity[i] + (preset[i] - identity[i]) * item.filterIntensity);
    final a = item.adjust;

    if (a.brightness != 0) {
      final b = a.brightness * 80;
      m[4] += b;
      m[9] += b;
      m[14] += b;
    }
    if (a.exposure != 0) {
      final e = 1 + a.exposure * .7;
      for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 4; c++) m[r * 5 + c] *= e;
      }
    }
    if (a.contrast != 0) {
      final c = 1 + a.contrast * .85;
      final t = 128 * (1 - c);
      for (var r = 0; r < 3; r++) {
        m[r * 5] *= c;
        m[r * 5 + 1] *= c;
        m[r * 5 + 2] *= c;
        m[r * 5 + 4] = m[r * 5 + 4] * c + t;
      }
    }
    if (a.saturation != 0 || a.vibrance != 0) {
      final s = 1 + a.saturation + a.vibrance * .45;
      const rw = .2126, gw = .7152, bw = .0722;
      final inv = 1 - s;
      m = _compose(<double>[
        rw * inv + s,
        gw * inv,
        bw * inv,
        0,
        0,
        rw * inv,
        gw * inv + s,
        bw * inv,
        0,
        0,
        rw * inv,
        gw * inv,
        bw * inv + s,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ], m);
    }
    if (a.warmth != 0) {
      final w = a.warmth * 45;
      m[4] += w;
      m[14] -= w;
    }
    if (a.highlights != 0) {
      final h = a.highlights * 24;
      m[4] += h;
      m[9] += h;
      m[14] += h;
    }
    if (a.shadows != 0) {
      final s = a.shadows * 20;
      m[4] += s;
      m[9] += s;
      m[14] += s;
    }
    return m;
  }

  List<double> _compose(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0);
    for (var r = 0; r < 4; r++) {
      for (var c = 0; c < 4; c++) {
        var v = 0.0;
        for (var k = 0; k < 4; k++) v += a[r * 5 + k] * b[k * 5 + c];
        out[r * 5 + c] = v;
      }
      var t = a[r * 5 + 4];
      for (var k = 0; k < 4; k++) t += a[r * 5 + k] * b[k * 5 + 4];
      out[r * 5 + 4] = t;
    }
    return out;
  }

  void _splitActiveClip() {
    final item = _active;
    if (item.mediaType != 'video' || item.editedDurationMs < 1200) return;
    final localPlayhead =
        (_playheadMs <= item.trimStartMs || _playheadMs >= item.trimEndMs)
            ? item.trimStartMs + item.editedDurationMs / 2
            : _playheadMs;
    final first = item.clone()
      ..trimEndMs = _snap(localPlayhead)
          .clamp(item.trimStartMs + 1, item.trimEndMs)
          .toInt();
    final second = item.clone()
      ..id = '${item.id}-split-${DateTime.now().microsecondsSinceEpoch}'
      ..trimStartMs = first.trimEndMs;
    setState(() {
      _items[_activeIndex] = first;
      _items.insert(_activeIndex + 1, second);
      _activeIndex++;
    });
    _pushHistory();
  }

  void _duplicateClip(int index) {
    final clone = _items[index].clone()
      ..id =
          '${_items[index].id}-copy-${DateTime.now().microsecondsSinceEpoch}';
    setState(() {
      _items.insert(index + 1, clone);
      _activeIndex = index + 1;
    });
    _pushHistory();
  }

  void _deleteClip(int index) {
    if (_items.length <= 1) return;
    setState(() {
      _items.removeAt(index);
      _activeIndex = _activeIndex.clamp(0, _items.length - 1).toInt();
    });
    _pushHistory();
  }

  void _mergeAllClips() {
    if (_items.length < 2) return;
    setState(() {
      _activeIndex = 0;
      for (var i = 1; i < _items.length; i++) {
        _items[0].segments.addAll(_items[i].segments.map((e) => e.clone()));
      }
    });
    _pushHistory();
  }

  void _setSpeed(double speed) {
    setState(() => _active.video.speed = speed);
    _pushHistory();
  }

  int _snap(double value) {
    if (!_snapTimeline) return value.round();
    const grid = 250;
    return (value / grid).round() * grid;
  }

  void _addLayer(String kind, String value) {
    setState(() {
      _active.layers
          .add(_AeOverlayLayer(kind: kind, value: value, x: 72, y: 120));
      _activeLayer = _active.layers.length - 1;
    });
    _pushHistory();
  }

  void _deleteActiveLayer() {
    if (_activeLayer < 0) return;
    setState(() {
      _active.layers.removeAt(_activeLayer);
      _activeLayer = -1;
    });
    _pushHistory();
  }

  void _editTextLayer(int index) {
    final layer = _active.layers[index];
    if (layer.kind != 'text') return;
    final controller = TextEditingController(text: layer.value);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        title: Text('Edit text', style: TextStyle(color: _primaryText)),
        content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: _primaryText)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: _secondaryText))),
          TextButton(
            onPressed: () {
              setState(() => layer.value = controller.text);
              _pushHistory();
              Navigator.pop(context);
            },
            child: Text('Done',
                style: TextStyle(color: _accent, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _panel(
      {required Key key,
      required double height,
      EdgeInsets? padding,
      required Widget child}) {
    return Container(
      key: key,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
          color: _surface,
          border: Border(top: BorderSide(color: _border.withOpacity(.65)))),
      child: child,
    );
  }

  Widget _sliderRow(String label, IconData icon, double value, double min,
      double max, ValueChanged<double> onChanged,
      {VoidCallback? onEnd, String? suffix}) {
    return Row(
      children: [
        Icon(icon, color: _primaryText.withOpacity(.42), size: 15),
        const SizedBox(width: 7),
        SizedBox(
            width: 76,
            child: Text(label,
                style: TextStyle(color: _secondaryText, fontSize: 11))),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: _accent,
                inactiveTrackColor: _border,
                thumbColor: _accent,
                trackHeight: 2),
            child: Slider(
                value: value.clamp(min, max).toDouble(),
                min: min,
                max: max,
                onChanged: onChanged,
                onChangeEnd: (_) => onEnd?.call()),
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(suffix ?? ((value * 100).round()).toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: _accent, fontSize: 11, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _optionWrap(String label, List<String> values, String selected,
      ValueChanged<String> onSelected) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: _secondaryText, fontSize: 11)),
          const SizedBox(height: 7),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map((v) => _textChip(v, selected == v, () => onSelected(v)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, VoidCallback? onTap, {bool dim = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: dim ? .35 : 1,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: _primaryText.withOpacity(.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border.withOpacity(.45))),
          child: Icon(icon, color: _primaryText, size: 18),
        ),
      ),
    );
  }

  Widget _roundIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: _primaryText.withOpacity(.08), shape: BoxShape.circle),
        child: Icon(icon, color: _primaryText, size: 18),
      ),
    );
  }

  Widget _miniIcon(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? .35 : 1,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: _primaryText.withOpacity(.07),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: _primaryText, size: 15),
        ),
      ),
    );
  }

  Widget _primaryPill(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: _accent.withOpacity(.28),
                  blurRadius: 14,
                  offset: const Offset(0, 4))
            ]),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, VoidCallback? onTap,
      {bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? .35 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? _accent.withOpacity(.16)
                : _primaryText.withOpacity(.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? _accent : _border),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon,
                color: active ? _accent : _primaryText.withOpacity(.65),
                size: 14),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: active ? _accent : _primaryText.withOpacity(.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }

  Widget _textChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              active ? _accent.withOpacity(.16) : _primaryText.withOpacity(.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? _accent : _border),
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: active ? _accent : _secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800))),
      ),
    );
  }

  Widget _glassChip(IconData icon, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: Colors.white, size: 13),
            const SizedBox(width: 5),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
    );
  }

  Widget _progressLabel(String label, double threshold) {
    final active = _exportProgress >= threshold;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color:
              active ? _accent.withOpacity(.14) : _primaryText.withOpacity(.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? _accent : _border)),
      child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: active ? _accent : _secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w800)),
    );
  }

  Widget _placeholder(IconData icon, String label) {
    return Container(
      color: _surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _primaryText.withOpacity(.25), size: 48),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: _secondaryText, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  DecorationImage? _thumbnailDecoration(_AeEditableMedia item,
      {double opacity = 1}) {
    if (item.localBytes != null) {
      return DecorationImage(
        image: MemoryImage(item.localBytes!),
        fit: BoxFit.cover,
        opacity: opacity,
      );
    }
    if (_isUsableNetworkUrl(item.thumbnailUrl)) {
      return DecorationImage(
        image: NetworkImage(item.thumbnailUrl),
        fit: BoxFit.cover,
        opacity: opacity,
      );
    }
    return null;
  }

  List<String> _safeStringList(List<String>? values) {
    if (values == null) return const <String>[];
    return values
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty && value.toLowerCase() != 'null')
        .toList();
  }

  List<double> _safeDoubleList(List<double>? values) {
    if (values == null) return const <double>[];
    return values.where((value) => value.isFinite).toList();
  }

  List<int> _safeIntList(List<int>? values) {
    if (values == null) return const <int>[];
    return values.where((value) => value > 0).toList();
  }

  List<String> _jsonStringList(dynamic value) {
    if (value is! Iterable) return const <String>[];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty && item.toLowerCase() != 'null')
        .toList();
  }

  List<double> _jsonDoubleList(dynamic value) {
    if (value is! Iterable) return const <double>[];
    return value
        .map((item) {
          if (item is num) return item.toDouble();
          return double.tryParse(item?.toString() ?? '');
        })
        .whereType<double>()
        .where((item) => item.isFinite)
        .toList();
  }

  List<int> _jsonIntList(dynamic value) {
    if (value is! Iterable) return const <int>[];
    return value
        .map((item) {
          if (item is num) return item.toInt();
          return int.tryParse(item?.toString() ?? '');
        })
        .whereType<int>()
        .where((item) => item > 0)
        .toList();
  }

  String _cleanUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return '';
    return trimmed;
  }

  bool _isUsableNetworkUrl(String value) {
    final uri = Uri.tryParse(_cleanUrl(value));
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Widget _vignette(double amount) => IgnorePointer(
        child: CustomPaint(painter: _AeVignettePainter(amount)),
      );

  Widget _glow(double amount) => IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [_accent.withOpacity(amount * .32), Colors.transparent],
                radius: .75),
          ),
        ),
      );

  String _inferType(String url) {
    final lower = url.toLowerCase();
    if (lower == 'video' ||
        lower.contains('/video/') ||
        lower.startsWith('video/')) return 'video';
    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv')) {
      return 'video';
    }
    return 'image';
  }
}

class _AeEditableMedia {
  _AeEditableMedia({
    required this.id,
    required this.url,
    required this.mediaType,
    required this.thumbnailUrl,
    this.localBytes,
    required this.aspectRatio,
    required this.durationMs,
    required this.trimStartMs,
    required this.trimEndMs,
    this.filterIndex = 0,
    this.filterIntensity = 1,
    _AeAdjustments? adjust,
    _AeCropState? crop,
    _AeEffectsState? effects,
    _AeVideoState? video,
    _AeAudioState? audio,
    List<_AeOverlayLayer>? layers,
    List<_AeClipSegment>? segments,
    this.transition = 'None',
  })  : adjust = adjust ?? _AeAdjustments(),
        crop = crop ?? _AeCropState(),
        effects = effects ?? _AeEffectsState(),
        video = video ?? _AeVideoState(),
        audio = audio ?? _AeAudioState(),
        layers = layers ?? <_AeOverlayLayer>[],
        segments = segments ?? <_AeClipSegment>[];

  String id;
  String url;
  String mediaType;
  String thumbnailUrl;
  Uint8List? localBytes;
  double aspectRatio;
  int durationMs;
  int trimStartMs;
  int trimEndMs;
  int filterIndex;
  double filterIntensity;
  _AeAdjustments adjust;
  _AeCropState crop;
  _AeEffectsState effects;
  _AeVideoState video;
  _AeAudioState audio;
  List<_AeOverlayLayer> layers;
  List<_AeClipSegment> segments;
  String transition;

  int get editedDurationMs => math.max(
      1, ((trimEndMs - trimStartMs) / math.max(video.speed, .1)).round());
  String get durationLabel =>
      '${(editedDurationMs / 1000).toStringAsFixed(1)}s';

  _AeEditableMedia clone() => _AeEditableMedia(
        id: id,
        url: url,
        mediaType: mediaType,
        thumbnailUrl: thumbnailUrl,
        localBytes: localBytes,
        aspectRatio: aspectRatio,
        durationMs: durationMs,
        trimStartMs: trimStartMs,
        trimEndMs: trimEndMs,
        filterIndex: filterIndex,
        filterIntensity: filterIntensity,
        adjust: adjust.clone(),
        crop: crop.clone(),
        effects: effects.clone(),
        video: video.clone(),
        audio: audio.clone(),
        layers: layers.map((e) => e.clone()).toList(),
        segments: segments.map((e) => e.clone()).toList(),
        transition: transition,
      );

  Map<String, dynamic> toExportPlan() => {
        'id': id,
        'url': url,
        'mediaType': mediaType,
        'thumbnailUrl': thumbnailUrl,
        'hasLocalBytes': localBytes != null,
        'aspectRatio': aspectRatio,
        'durationMs': durationMs,
        'trimStartMs': trimStartMs,
        'trimEndMs': trimEndMs,
        'filterIndex': filterIndex,
        'filterIntensity': filterIntensity,
        'adjust': adjust.toJson(),
        'crop': crop.toJson(),
        'effects': effects.toJson(),
        'video': video.toJson(),
        'audio': audio.toJson(),
        'layers': layers.map((e) => e.toJson()).toList(),
        'segments': segments.map((e) => e.toJson()).toList(),
        'transition': transition,
      };

  factory _AeEditableMedia.empty() => _AeEditableMedia(
        id: 'empty',
        url: '',
        mediaType: 'image',
        thumbnailUrl: '',
        aspectRatio: 1,
        durationMs: 3500,
        trimStartMs: 0,
        trimEndMs: 3500,
      );
}

class _AeAdjustments {
  double brightness = 0;
  double contrast = 0;
  double exposure = 0;
  double saturation = 0;
  double warmth = 0;
  double vibrance = 0;
  double highlights = 0;
  double shadows = 0;
  double sharpness = 0;
  _AeAdjustments clone() => _AeAdjustments()
    ..brightness = brightness
    ..contrast = contrast
    ..exposure = exposure
    ..saturation = saturation
    ..warmth = warmth
    ..vibrance = vibrance
    ..highlights = highlights
    ..shadows = shadows
    ..sharpness = sharpness;
  Map<String, dynamic> toJson() => {
        'brightness': brightness,
        'contrast': contrast,
        'exposure': exposure,
        'saturation': saturation,
        'warmth': warmth,
        'vibrance': vibrance,
        'highlights': highlights,
        'shadows': shadows,
        'sharpness': sharpness,
      };
}

class _AeCropState {
  double rotationDeg = 0;
  bool flipH = false;
  bool flipV = false;
  String aspectLabel = 'Free';
  _AeCropState clone() => _AeCropState()
    ..rotationDeg = rotationDeg
    ..flipH = flipH
    ..flipV = flipV
    ..aspectLabel = aspectLabel;
  Map<String, dynamic> toJson() => {
        'rotationDeg': rotationDeg,
        'flipH': flipH,
        'flipV': flipV,
        'aspectLabel': aspectLabel
      };
}

class _AeEffectsState {
  double vignette = 0;
  double glow = 0;
  double blur = 0;
  double grain = 0;
  _AeEffectsState clone() => _AeEffectsState()
    ..vignette = vignette
    ..glow = glow
    ..blur = blur
    ..grain = grain;
  Map<String, dynamic> toJson() =>
      {'vignette': vignette, 'glow': glow, 'blur': blur, 'grain': grain};
}

class _AeVideoState {
  double speed = 1;
  bool reverse = false;
  bool beatSync = false;
  String effect = 'None';
  _AeVideoState clone() => _AeVideoState()
    ..speed = speed
    ..reverse = reverse
    ..beatSync = beatSync
    ..effect = effect;
  Map<String, dynamic> toJson() => {
        'speed': speed,
        'reverse': reverse,
        'beatSync': beatSync,
        'effect': effect
      };
}

class _AeAudioState {
  double volume = 1;
  bool muted = false;
  bool hasMusic = false;
  bool hasVoiceover = false;
  int fadeInMs = 0;
  int fadeOutMs = 0;
  _AeAudioState clone() => _AeAudioState()
    ..volume = volume
    ..muted = muted
    ..hasMusic = hasMusic
    ..hasVoiceover = hasVoiceover
    ..fadeInMs = fadeInMs
    ..fadeOutMs = fadeOutMs;
  Map<String, dynamic> toJson() => {
        'volume': volume,
        'muted': muted,
        'hasMusic': hasMusic,
        'hasVoiceover': hasVoiceover,
        'fadeInMs': fadeInMs,
        'fadeOutMs': fadeOutMs,
      };
}

class _AeOverlayLayer {
  _AeOverlayLayer({
    required this.kind,
    required this.value,
    this.x = 60,
    this.y = 120,
    this.scale = 1,
    this.rotation = 0,
    this.fontSize = 28,
    this.color = Colors.white,
  });

  String kind;
  String value;
  double x;
  double y;
  double scale;
  double rotation;
  double fontSize;
  Color color;

  _AeOverlayLayer clone() => _AeOverlayLayer(
        kind: kind,
        value: value,
        x: x,
        y: y,
        scale: scale,
        rotation: rotation,
        fontSize: fontSize,
        color: color,
      );
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'value': value,
        'x': x,
        'y': y,
        'scale': scale,
        'rotation': rotation,
        'fontSize': fontSize,
        'color': color.value,
      };
}

class _AeClipSegment {
  _AeClipSegment(
      {required this.sourceUrl, required this.startMs, required this.endMs});
  String sourceUrl;
  int startMs;
  int endMs;
  _AeClipSegment clone() =>
      _AeClipSegment(sourceUrl: sourceUrl, startMs: startMs, endMs: endMs);
  Map<String, dynamic> toJson() =>
      {'sourceUrl': sourceUrl, 'startMs': startMs, 'endMs': endMs};
}

class _AeFilterPreset {
  const _AeFilterPreset(this.name, this.matrix);
  final String name;
  final List<double> matrix;
  static const identity = <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
}

class _AeEditorTab {
  const _AeEditorTab(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _AeVignettePainter extends CustomPainter {
  const _AeVignettePainter(this.amount);
  final double amount;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(amount * .75)
        ],
        stops: const [0, .52, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _AeVignettePainter oldDelegate) =>
      oldDelegate.amount != amount;
}

class _AeGrainPainter extends CustomPainter {
  const _AeGrainPainter(this.amount);
  final double amount;
  @override
  void paint(Canvas canvas, Size size) {
    if (amount <= 0) return;
    final random = math.Random(42);
    final paint = Paint();
    final count = (size.width * size.height * amount * .01).round();
    for (var i = 0; i < count; i++) {
      paint.color = (random.nextBool() ? Colors.white : Colors.black)
          .withOpacity(amount * .28 * random.nextDouble());
      canvas.drawCircle(
          Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height),
          .65,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AeGrainPainter oldDelegate) =>
      oldDelegate.amount != amount;
}

class _AeCropGridPainter extends CustomPainter {
  const _AeCropGridPainter(this.accent);
  final Color accent;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withOpacity(.28)
      ..strokeWidth = .8;
    final border = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var i = 1; i < 3; i++) {
      canvas.drawLine(Offset(size.width * i / 3, 0),
          Offset(size.width * i / 3, size.height), grid);
      canvas.drawLine(Offset(0, size.height * i / 3),
          Offset(size.width, size.height * i / 3), grid);
    }
    canvas.drawRect(Offset.zero & size, border);
  }

  @override
  bool shouldRepaint(covariant _AeCropGridPainter oldDelegate) =>
      oldDelegate.accent != accent;
}
