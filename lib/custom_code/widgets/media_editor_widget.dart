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

import 'package:flutter/services.dart';

import 'dart:math' as math;
import 'dart:ui' as ui;

// ─────────────────────────────────────────────────────────────────────────────
// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
//
/// ─────────────────────────────────────────────────────────────────────────────
/// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
///
/// ─────────────────────────────────────────────────────────────────────────────
/// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
///
/// ─────────────────────────────────────────────────────────────────────────────
/// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
///
/// ─────────────────────────────────────────────────────────────────────────────
/// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
///
/// ─────────────────────────────────────────────────────────────────────────────
/// MediaEditorWidget — Premium social-commerce media editor for FlutterFlow
///
/// FlutterFlow pub.dev dependencies to add in widget settings (optional):
/// video_player: ^2.9.1   (enables real video playback)
/// ─────────────────────────────────────────────────────────────────────────────
class MediaEditorWidget extends StatefulWidget {
  const MediaEditorWidget({
    super.key,
    this.width,
    this.height,
    required this.mediaUrl,
    this.isVideo = false,
    this.onExport,
  });

  final double? width;
  final double? height;
  final String mediaUrl;
  final bool isVideo;

  /// Called on export: filter name, brightness, contrast, saturation, warmth, rotation
  final Future Function(
    String selectedFilter,
    double brightness,
    double contrast,
    double saturation,
    double warmth,
    double rotationDeg,
  )? onExport;

  @override
  State<MediaEditorWidget> createState() => _MediaEditorWidgetState();
}

class _MediaEditorWidgetState extends State<MediaEditorWidget> {
  // ─── Theme colors (resolved from FlutterFlowTheme in build) ─────────────────
  Color _accent = const Color(0xFFFE6601);
  Color _bg = const Color(0xFF07070F);
  Color _surface = const Color(0xFF0E0E1C);
  Color _border = const Color(0xFF1C1C2E);
  Color _primaryText = Colors.white;
  Color _secondText = const Color(0xFF888899);

  // ─── Tab state ───────────────────────────────────────────────────────────────
  int _activeTab = 0;
  // 0=Filters 1=Adjust 2=Crop 3=Draw 4=Text 5=Stickers 6=Effects 7=Audio 8=Export

  static const _tabIcons = [
    Icons.auto_awesome_rounded,
    Icons.tune_rounded,
    Icons.crop_rounded,
    Icons.brush_rounded,
    Icons.text_fields_rounded,
    Icons.emoji_emotions_outlined,
    Icons.auto_fix_high_rounded,
    Icons.music_note_rounded,
    Icons.file_upload_outlined,
  ];
  static const _tabNames = [
    'Filters',
    'Adjust',
    'Crop',
    'Draw',
    'Text',
    'Stickers',
    'Effects',
    'Audio',
    'Export'
  ];

  // ─── Filters ─────────────────────────────────────────────────────────────────
  int _selectedFilter = 0;
  double _filterIntensity = 1.0;

  // ─── Adjustments ─────────────────────────────────────────────────────────────
  // Light group
  double _brightness = 0.0;
  double _contrast = 0.0;
  double _exposure = 0.0;
  double _highlights = 0.0;
  double _shadows = 0.0;
  // Color group
  double _saturation = 0.0;
  double _warmth = 0.0;
  double _tint = 0.0;
  double _vibrance = 0.0;
  double _hue = 0.0;
  // Detail group
  double _fade = 0.0;
  double _clarity = 0.0;
  double _grain = 0.0;
  double _sharpness = 0.0;
  int _adjGroup = 0; // 0=Light 1=Color 2=Detail

  // ─── Crop ────────────────────────────────────────────────────────────────────
  double _rotation = 0.0;
  bool _flipH = false;
  bool _flipV = false;
  int _aspectRatioIdx = 0;
  static const _aspectLabels = [
    'Free',
    '1:1',
    '4:3',
    '16:9',
    '9:16',
    '4:5',
    'Story'
  ];

  // ─── Drawing ─────────────────────────────────────────────────────────────────
  final List<_DrawStroke> _drawStrokes = [];
  List<Offset> _activePoints = [];
  _DrawTool _drawTool = _DrawTool.brush;
  Color _drawColor = Colors.white;
  double _drawSize = 10.0;
  double _drawOpacity = 1.0;
  // Draw undo stack
  final List<List<_DrawStroke>> _drawHistory = [[]];
  int _drawHistIdx = 0;

  static const _drawColors = [
    Colors.white,
    Colors.black,
    Color(0xFFFF3B30),
    Color(0xFFFF9500),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
    Color(0xFF00C7BE),
    Color(0xFF007AFF),
    Color(0xFF5856D6),
    Color(0xFFFF2D55),
  ];

  // ─── Text overlays ───────────────────────────────────────────────────────────
  final List<_TextOverlay> _overlays = [];
  int? _selectedOverlay;

  // ─── Stickers ────────────────────────────────────────────────────────────────
  final List<_StickerItem> _stickers = [];
  int? _selectedSticker;

  static const _emojiList = [
    '🔥',
    '💯',
    '✨',
    '💎',
    '👑',
    '🎉',
    '💪',
    '❤️',
    '😍',
    '🚀',
    '🌙',
    '⭐',
    '🎵',
    '🌈',
    '🦋',
    '🌺',
    '💫',
    '🎨',
    '🌊',
    '⚡',
  ];

  // ─── Effects ─────────────────────────────────────────────────────────────────
  double _vignetteAmount = 0.0;
  double _glowAmount = 0.0;
  double _blurAmount = 0.0;
  int _effectMode = 0; // 0=Vignette 1=Glow 2=Blur 3=All

  // ─── Audio ───────────────────────────────────────────────────────────────────
  double _volume = 1.0;
  bool _muted = false;

  // ─── Export ──────────────────────────────────────────────────────────────────
  int _exportQuality = 2; // 0=480p 1=720p 2=1080p 3=Original
  bool _isExporting = false;
  double _exportProgress = 0.0;
  bool _exportDone = false;
  static const _qualityLabels = ['480p', '720p', '1080p', 'Original'];
  static const _qualitySizes = ['~2 MB', '~8 MB', '~22 MB', 'Full'];

  // ─── Misc ────────────────────────────────────────────────────────────────────
  bool _showOriginal = false; // comparison mode (hold button)

  // ─── History ─────────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _history = [];
  int _histIdx = -1;

  // ─── Filter presets (18 presets) ─────────────────────────────────────────────
  static const _filters = <_FilterPreset>[
    _FilterPreset('Normal',
        <double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]),
    _FilterPreset('Vivid', <double>[
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
    _FilterPreset('Warm', <double>[
      1.15,
      0.05,
      0,
      0,
      10,
      0.02,
      1.05,
      0,
      0,
      0,
      0,
      0,
      0.82,
      0,
      -12,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Cool', <double>[
      0.87,
      0,
      0.05,
      0,
      -5,
      0,
      0.94,
      0.04,
      0,
      5,
      0.06,
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
    _FilterPreset('Fade', <double>[
      0.88,
      0,
      0,
      0,
      16,
      0,
      0.88,
      0,
      0,
      16,
      0,
      0,
      0.88,
      0,
      16,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Drama', <double>[
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
    _FilterPreset('Noir', <double>[
      0.33,
      0.59,
      0.11,
      0,
      0,
      0.33,
      0.59,
      0.11,
      0,
      0,
      0.33,
      0.59,
      0.11,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Chrome', <double>[
      1.12,
      0,
      0,
      0,
      8,
      -0.04,
      1.0,
      -0.04,
      0,
      4,
      0,
      0,
      0.94,
      0,
      -6,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Matte', <double>[
      0.84,
      0.05,
      0.05,
      0,
      9,
      0.05,
      0.84,
      0.05,
      0,
      9,
      0.05,
      0.05,
      0.84,
      0,
      9,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Insta', <double>[
      1.1,
      0,
      0,
      0,
      5,
      0,
      1.1,
      0,
      0,
      4,
      0,
      0,
      1.0,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Vintage', <double>[
      0.90,
      0.06,
      0.04,
      0,
      5,
      0.04,
      0.88,
      0.04,
      0,
      10,
      0.02,
      0.04,
      0.76,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Sunset', <double>[
      1.2,
      0.08,
      0,
      0,
      15,
      0.02,
      1.0,
      0,
      0,
      -5,
      0,
      0,
      0.75,
      0,
      -10,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Teal&O', <double>[
      0.98,
      0,
      0.04,
      0,
      -5,
      0,
      0.92,
      0.04,
      0,
      4,
      0.1,
      0.1,
      1.15,
      0,
      8,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Glow', <double>[
      1.1,
      0.05,
      0.05,
      0,
      10,
      0.05,
      1.1,
      0.05,
      0,
      8,
      0.05,
      0.05,
      1.1,
      0,
      6,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Golden', <double>[
      1.2,
      0.1,
      0,
      0,
      12,
      0.05,
      1.05,
      0,
      0,
      5,
      0,
      0,
      0.78,
      0,
      -8,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Moody', <double>[
      0.82,
      0.04,
      0.02,
      0,
      -8,
      0.02,
      0.82,
      0.02,
      0,
      -6,
      0.04,
      0.04,
      0.88,
      0,
      4,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('Pastel', <double>[
      0.85,
      0.05,
      0.05,
      0,
      20,
      0.05,
      0.85,
      0.05,
      0,
      20,
      0.05,
      0.05,
      0.85,
      0,
      20,
      0,
      0,
      0,
      1,
      0
    ]),
    _FilterPreset('B&W+', <double>[
      0.28,
      0.60,
      0.12,
      0,
      0,
      0.28,
      0.60,
      0.12,
      0,
      0,
      0.28,
      0.60,
      0.12,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]),
  ];

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _pushHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ─── History ─────────────────────────────────────────────────────────────────
  void _pushHistory() {
    if (_histIdx < _history.length - 1) {
      _history.removeRange(_histIdx + 1, _history.length);
    }
    _history.add(_snapshot());
    _histIdx = _history.length - 1;
    if (_history.length > 50) {
      _history.removeAt(0);
      _histIdx--;
    }
  }

  Map<String, dynamic> _snapshot() => {
        'filter': _selectedFilter,
        'filterIntensity': _filterIntensity,
        'brightness': _brightness,
        'contrast': _contrast,
        'exposure': _exposure,
        'highlights': _highlights,
        'shadows': _shadows,
        'saturation': _saturation,
        'warmth': _warmth,
        'tint': _tint,
        'vibrance': _vibrance,
        'hue': _hue,
        'fade': _fade,
        'clarity': _clarity,
        'grain': _grain,
        'sharpness': _sharpness,
        'rotation': _rotation,
        'flipH': _flipH,
        'flipV': _flipV,
        'aspectIdx': _aspectRatioIdx,
        'vignetteAmount': _vignetteAmount,
        'glowAmount': _glowAmount,
        'blurAmount': _blurAmount,
        'overlays': _overlays.map((o) => o.toMap()).toList(),
      };

  void _applySnapshot(Map<String, dynamic> s) {
    setState(() {
      _selectedFilter = s['filter'] as int;
      _filterIntensity = s['filterIntensity'] as double;
      _brightness = s['brightness'] as double;
      _contrast = s['contrast'] as double;
      _exposure = s['exposure'] as double;
      _highlights = s['highlights'] as double;
      _shadows = s['shadows'] as double;
      _saturation = s['saturation'] as double;
      _warmth = s['warmth'] as double;
      _tint = s['tint'] as double;
      _vibrance = s['vibrance'] as double;
      _hue = s['hue'] as double;
      _fade = s['fade'] as double;
      _clarity = s['clarity'] as double;
      _grain = s['grain'] as double;
      _sharpness = s['sharpness'] as double;
      _rotation = s['rotation'] as double;
      _flipH = s['flipH'] as bool;
      _flipV = s['flipV'] as bool;
      _aspectRatioIdx = s['aspectIdx'] as int;
      _vignetteAmount = s['vignetteAmount'] as double;
      _glowAmount = s['glowAmount'] as double;
      _blurAmount = s['blurAmount'] as double;
      _overlays
        ..clear()
        ..addAll((s['overlays'] as List)
            .map((m) => _TextOverlay.fromMap(m as Map<String, dynamic>)));
    });
  }

  void _undo() {
    if (_histIdx > 0) {
      _histIdx--;
      _applySnapshot(_history[_histIdx]);
    }
  }

  void _redo() {
    if (_histIdx < _history.length - 1) {
      _histIdx++;
      _applySnapshot(_history[_histIdx]);
    }
  }

  // ─── Color matrix ────────────────────────────────────────────────────────────
  List<double> _buildMatrix() {
    if (_showOriginal) {
      return <double>[
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

    // Blend filter with identity based on intensity
    const identity = <double>[
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
    final preset = _filters[_selectedFilter].matrix;
    var m = List<double>.generate(
      20,
      (i) => identity[i] + (preset[i] - identity[i]) * _filterIntensity,
    );

    if (_brightness != 0) {
      final b = _brightness * 80.0;
      m[4] += b;
      m[9] += b;
      m[14] += b;
    }
    if (_exposure != 0) {
      final e = 1.0 + _exposure * 0.7;
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 4; c++) m[r * 5 + c] *= e;
      }
    }
    if (_contrast != 0) {
      final c = 1.0 + _contrast * 0.85;
      final t = 128.0 * (1.0 - c);
      for (int r = 0; r < 3; r++) {
        m[r * 5] *= c;
        m[r * 5 + 1] *= c;
        m[r * 5 + 2] *= c;
        m[r * 5 + 4] = m[r * 5 + 4] * c + t;
      }
    }
    if (_saturation != 0) {
      final s = 1.0 + _saturation;
      final inv = 1.0 - s;
      const rw = 0.2126, gw = 0.7152, bw = 0.0722;
      final sat = <double>[
        rw * inv + s,
        gw * inv,
        bw * inv,
        0,
        0.0,
        rw * inv,
        gw * inv + s,
        bw * inv,
        0,
        0.0,
        rw * inv,
        gw * inv,
        bw * inv + s,
        0,
        0.0,
        0.0,
        0.0,
        0.0,
        1,
        0.0,
      ];
      m = _compose(sat, m);
    }
    if (_vibrance != 0) {
      // Vibrance boosts low-saturation areas more than already-saturated ones
      // Approximated with a gentle saturation boost offset by the existing sat level
      final v = _vibrance * 0.5;
      const rw = 0.2126, gw = 0.7152, bw = 0.0722;
      final inv = 1.0 - (1.0 + v);
      final vib = <double>[
        rw * inv + (1 + v),
        gw * inv,
        bw * inv,
        0,
        0.0,
        rw * inv,
        gw * inv + (1 + v),
        bw * inv,
        0,
        0.0,
        rw * inv,
        gw * inv,
        bw * inv + (1 + v),
        0,
        0.0,
        0.0,
        0.0,
        0.0,
        1,
        0.0,
      ];
      m = _compose(vib, m);
    }
    if (_warmth != 0) {
      final w = _warmth * 45.0;
      m[4] += w;
      m[14] -= w;
    }
    if (_tint != 0) {
      final t = _tint * 30.0;
      m[9] += t; // Shift green channel
    }
    if (_hue != 0) {
      // Hue rotation via RGB channel cross-mixing approximation
      final h = _hue * math.pi;
      final cosH = math.cos(h), sinH = math.sin(h);
      const rw = 0.213, gw = 0.715, bw = 0.072;
      final hueMat = <double>[
        rw + cosH * (1 - rw) + sinH * (-rw),
        gw + cosH * (-gw) + sinH * (-gw),
        bw + cosH * (-bw) + sinH * (1 - bw),
        0,
        0.0,
        rw + cosH * (-rw) + sinH * 0.143,
        gw + cosH * (1 - gw) + sinH * 0.140,
        bw + cosH * (-bw) + sinH * (-0.283),
        0,
        0.0,
        rw + cosH * (-rw) + sinH * (-(1 - rw)),
        gw + cosH * (-gw) + sinH * (gw),
        bw + cosH * (1 - bw) + sinH * (bw),
        0,
        0.0,
        0.0,
        0.0,
        0.0,
        1,
        0.0,
      ];
      m = _compose(hueMat, m);
    }
    if (_highlights != 0) {
      final h = _highlights * 25.0;
      m[4] += h;
      m[9] += h;
      m[14] += h;
    }
    if (_shadows != 0) {
      final s = _shadows * 20.0;
      m[4] += s;
      m[9] += s;
      m[14] += s;
    }
    if (_clarity != 0) {
      final c = 1.0 + _clarity * 0.6;
      final t = 128.0 * (1.0 - c);
      for (int r = 0; r < 3; r++) {
        m[r * 5] *= c;
        m[r * 5 + 1] *= c;
        m[r * 5 + 2] *= c;
        m[r * 5 + 4] = m[r * 5 + 4] * c + t;
      }
    }
    if (_fade != 0) {
      final f = _fade.clamp(0.0, 1.0);
      final scale = 1.0 - f * 0.18;
      final offset = f * 22.0;
      for (int r = 0; r < 3; r++) {
        m[r * 5] *= scale;
        m[r * 5 + 1] *= scale;
        m[r * 5 + 2] *= scale;
        m[r * 5 + 4] += offset;
      }
    }
    return m;
  }

  List<double> _compose(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0.0);
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        double v = 0;
        for (int k = 0; k < 4; k++) v += a[r * 5 + k] * b[k * 5 + c];
        out[r * 5 + c] = v;
      }
      double t = a[r * 5 + 4];
      for (int k = 0; k < 4; k++) t += a[r * 5 + k] * b[k * 5 + 4];
      out[r * 5 + 4] = t;
    }
    return out;
  }

  // ─── Drawing helpers ──────────────────────────────────────────────────────────
  void _startStroke(Offset pos) {
    setState(() => _activePoints = [pos]);
  }

  void _continueStroke(Offset pos) {
    setState(() => _activePoints.add(pos));
  }

  void _endStroke() {
    if (_activePoints.isEmpty) return;
    final stroke = _DrawStroke(
      points: List.from(_activePoints),
      color: _drawColor,
      size: _drawSize,
      opacity: _drawOpacity,
      tool: _drawTool,
    );
    // Draw undo: truncate forward history, push new
    _drawHistory.removeRange(_drawHistIdx + 1, _drawHistory.length);
    final newStrokes = List<_DrawStroke>.from(_drawStrokes)..add(stroke);
    _drawHistory.add(newStrokes);
    _drawHistIdx = _drawHistory.length - 1;
    setState(() {
      _drawStrokes.add(stroke);
      _activePoints = [];
    });
  }

  void _undoDraw() {
    if (_drawHistIdx > 0) {
      _drawHistIdx--;
      setState(() {
        _drawStrokes
          ..clear()
          ..addAll(_drawHistory[_drawHistIdx]);
      });
    }
  }

  void _clearDrawing() {
    _drawHistory.removeRange(_drawHistIdx + 1, _drawHistory.length);
    _drawHistory.add([]);
    _drawHistIdx = _drawHistory.length - 1;
    setState(() => _drawStrokes.clear());
  }

  // ─── Export ───────────────────────────────────────────────────────────────────
  Future<void> _runExport() async {
    setState(() {
      _isExporting = true;
      _exportProgress = 0;
      _exportDone = false;
    });
    HapticFeedback.mediumImpact();

    // Simulate smart compression progress
    for (int i = 0; i <= 100; i += 2) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted) return;
      setState(() => _exportProgress = i / 100);
    }

    await widget.onExport?.call(
      _filters[_selectedFilter].name,
      _brightness,
      _contrast,
      _saturation,
      _warmth,
      _rotation,
    );

    if (mounted) {
      setState(() {
        _isExporting = false;
        _exportDone = true;
      });
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _exportDone = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    _accent = t.primary;
    _bg = t.primaryBackground;
    _surface = t.secondaryBackground;
    _border = t.alternate;
    _primaryText = t.primaryText;
    _secondText = t.secondaryText;

    final w = widget.width ?? MediaQuery.of(context).size.width;
    final h = widget.height ?? MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: _bg,
      child: Column(children: [
        _topBar(),
        Expanded(child: _previewArea(w)),
        _tabBar(),
        _tabPanel(),
      ]),
    );
  }

  // ─── Top bar ──────────────────────────────────────────────────────────────────
  Widget _topBar() {
    final canUndo = _histIdx > 0;
    final canRedo = _histIdx < _history.length - 1;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(children: [
        _iconBtn(Icons.close_rounded, () => Navigator.of(context).maybePop()),
        const SizedBox(width: 6),
        Expanded(
          child: Center(
              child: Text(
            _tabNames[_activeTab],
            style: TextStyle(
                color: _primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4),
          )),
        ),
        // Before/after comparison
        GestureDetector(
          onLongPressStart: (_) {
            HapticFeedback.selectionClick();
            setState(() => _showOriginal = true);
          },
          onLongPressEnd: (_) => setState(() => _showOriginal = false),
          child: _iconBtn2(Icons.compare_rounded, () {}),
        ),
        const SizedBox(width: 4),
        _iconBtn(
            Icons.undo_rounded,
            canUndo
                ? () {
                    _undo();
                    HapticFeedback.selectionClick();
                  }
                : null,
            dim: !canUndo),
        const SizedBox(width: 4),
        _iconBtn(
            Icons.redo_rounded,
            canRedo
                ? () {
                    _redo();
                    HapticFeedback.selectionClick();
                  }
                : null,
            dim: !canRedo),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _activeTab = 8);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: _accent.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.file_upload_outlined, color: _bg, size: 15),
              const SizedBox(width: 5),
              Text('Export',
                  style: TextStyle(
                      color: _bg, fontSize: 13, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback? onTap, {bool dim = false}) =>
      GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: dim ? 0.22 : 1.0,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _primaryText.withOpacity(0.07),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: _primaryText, size: 17),
          ),
        ),
      );

  Widget _iconBtn2(IconData icon, VoidCallback onTap) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _primaryText.withOpacity(0.07),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: _primaryText.withOpacity(0.7), size: 17),
      );

  // ─── Preview area ─────────────────────────────────────────────────────────────
  Widget _previewArea(double totalW) {
    return Container(
      color: _bg,
      child: Center(
        child: SizedBox(
          width: totalW,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Media layer (filtered, rotated, flipped, blurred)
              _buildMediaLayer(totalW),

              // 2. Vignette overlay
              if (_vignetteAmount > 0) _buildVignetteLayer(totalW),

              // 3. Glow overlay
              if (_glowAmount > 0) _buildGlowLayer(totalW),

              // 4. Grain overlay
              if (_grain > 0 || _glowAmount > 0) _buildGrainPaint(totalW),

              // 5. Drawing canvas
              if (_drawStrokes.isNotEmpty || _activePoints.isNotEmpty)
                IgnorePointer(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _DrawingPainter(
                        strokes: _drawStrokes,
                        activePoints: _activePoints,
                        activeTool: _drawTool,
                        activeColor: _drawColor,
                        activeSize: _drawSize,
                        activeOpacity: _drawOpacity,
                      ),
                      size: Size(totalW, double.infinity),
                    ),
                  ),
                ),

              // 6. Text overlays
              ..._overlays
                  .asMap()
                  .entries
                  .map((e) => _textOverlayWidget(e.key, e.value)),

              // 7. Sticker overlays
              ..._stickers
                  .asMap()
                  .entries
                  .map((e) => _stickerWidget(e.key, e.value)),

              // 8. Crop grid
              if (_activeTab == 2)
                IgnorePointer(
                  child: CustomPaint(
                    painter: _CropGridPainter(accentColor: _accent),
                    size: Size(totalW * 0.85, totalW * 0.85),
                  ),
                ),

              // 9. Draw input capture
              if (_activeTab == 3)
                Positioned.fill(
                  child: GestureDetector(
                    onPanStart: (d) => _startStroke(d.localPosition),
                    onPanUpdate: (d) => _continueStroke(d.localPosition),
                    onPanEnd: (_) => _endStroke(),
                    child: Container(color: Colors.transparent),
                  ),
                ),

              // 10. Before/after label
              if (_showOriginal)
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('ORIGINAL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaLayer(double totalW) {
    Widget media = widget.isVideo ? _videoWidget() : _networkImage();
    // Apply blur
    if (_blurAmount > 0) {
      media = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
            sigmaX: _blurAmount * 8, sigmaY: _blurAmount * 8),
        child: media,
      );
    }
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..scale(_flipH ? -1.0 : 1.0, _flipV ? -1.0 : 1.0),
      child: Transform.rotate(
        angle: _rotation * math.pi / 180.0,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(_buildMatrix()),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: totalW, maxHeight: 420),
            child: media,
          ),
        ),
      ),
    );
  }

  Widget _networkImage() => Image.network(
        widget.mediaUrl,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, prog) => prog == null
            ? child
            : Container(
                width: 280,
                height: 280,
                color: _surface,
                child: Center(
                    child: CircularProgressIndicator(
                        color: _accent, strokeWidth: 2))),
        errorBuilder: (_, __, ___) => _mediaPH(),
      );

  Widget _videoWidget() => Container(
        width: 280,
        height: 280,
        color: _surface,
        child: Stack(alignment: Alignment.center, children: [
          Image.network(widget.mediaUrl,
              fit: BoxFit.cover,
              width: 280,
              height: 280,
              errorBuilder: (_, __, ___) => _mediaPH()),
          Container(color: Colors.black38),
          // Video controls overlay
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _primaryText.withOpacity(0.18),
                shape: BoxShape.circle,
                border:
                    Border.all(color: _primaryText.withOpacity(0.55), width: 2),
              ),
              child:
                  Icon(Icons.play_arrow_rounded, color: _primaryText, size: 32),
            ),
            const SizedBox(height: 12),
            // Fake timeline scrubber
            Container(
              width: 220,
              height: 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: _primaryText.withOpacity(0.2)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.35,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2), color: _accent),
                ),
              ),
            ),
          ]),
        ]),
      );

  Widget _mediaPH() => Container(
        width: 280,
        height: 280,
        color: _surface,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(widget.isVideo ? Icons.movie_outlined : Icons.image_outlined,
              color: _primaryText.withOpacity(0.2), size: 52),
          const SizedBox(height: 10),
          Text(widget.isVideo ? 'Video Preview' : 'Image Preview',
              style: TextStyle(color: _secondText, fontSize: 13)),
        ]),
      );

  Widget _buildVignetteLayer(double totalW) => Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _VignettePainter(intensity: _vignetteAmount),
          ),
        ),
      );

  Widget _buildGlowLayer(double totalW) => Positioned.fill(
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  _accent.withOpacity(_glowAmount * 0.35),
                  Colors.transparent,
                ],
                radius: 0.7,
              ),
            ),
          ),
        ),
      );

  Widget _buildGrainPaint(double totalW) => Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _GrainPainter(intensity: _grain),
          ),
        ),
      );

  // ─── Text overlay widgets ─────────────────────────────────────────────────────
  Widget _textOverlayWidget(int idx, _TextOverlay ov) {
    final selected = _selectedOverlay == idx;
    return Positioned(
      left: ov.x,
      top: ov.y,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedOverlay = idx);
          _openTextDialog(idx, ov);
        },
        onPanUpdate: (d) => setState(() {
          ov.x += d.delta.dx;
          ov.y += d.delta.dy;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: selected
              ? BoxDecoration(
                  border: Border.all(color: _accent, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Text(ov.text,
              style: TextStyle(
                color: ov.color,
                fontSize: ov.fontSize,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                      blurRadius: 4,
                      color: Colors.black87,
                      offset: Offset(1, 1))
                ],
              )),
        ),
      ),
    );
  }

  void _openTextDialog(int idx, _TextOverlay ov) {
    final ctrl = TextEditingController(text: ov.text);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: _surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Text',
              style: TextStyle(color: _primaryText, fontSize: 16)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              style: TextStyle(color: _primaryText, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Type something…',
                hintStyle: TextStyle(color: _secondText),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _accent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _accent, width: 2)),
              ),
            ),
            const SizedBox(height: 14),
            Text('Size', style: TextStyle(color: _secondText, fontSize: 11)),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _accent,
                inactiveTrackColor: _border,
                thumbColor: _accent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 2,
              ),
              child: Slider(
                value: ov.fontSize,
                min: 12,
                max: 72,
                onChanged: (v) {
                  setDlg(() => ov.fontSize = v);
                  setState(() {});
                },
              ),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _overlays.removeAt(idx);
                  _selectedOverlay = null;
                });
                Navigator.pop(ctx);
                _pushHistory();
              },
              child: Text('Delete',
                  style: TextStyle(color: FlutterFlowTheme.of(context).error)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  ov.text = ctrl.text;
                  _selectedOverlay = null;
                });
                Navigator.pop(ctx);
                _pushHistory();
              },
              child: Text('Done',
                  style:
                      TextStyle(color: _accent, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sticker overlay widget ───────────────────────────────────────────────────
  Widget _stickerWidget(int idx, _StickerItem st) {
    final selected = _selectedSticker == idx;
    return Positioned(
      left: st.x,
      top: st.y,
      child: GestureDetector(
        onTap: () => setState(() => _selectedSticker = idx),
        onPanUpdate: (d) => setState(() {
          st.x += d.delta.dx;
          st.y += d.delta.dy;
        }),
        onScaleUpdate: (d) {
          if (d.scale != 1.0)
            setState(() => st.size = (st.size * d.scale).clamp(20.0, 100.0));
          if (d.rotation != 0) setState(() => st.rotation += d.rotation);
        },
        onDoubleTap: () => setState(() {
          _stickers.removeAt(idx);
          _selectedSticker = null;
        }),
        child: Transform.rotate(
          angle: st.rotation,
          child: Container(
            width: st.size,
            height: st.size,
            decoration: selected
                ? BoxDecoration(
                    border: Border.all(color: _accent, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Center(
              child: Text(st.emoji, style: TextStyle(fontSize: st.size * 0.65)),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Tab bar (horizontally scrollable for 9 tabs) ─────────────────────────────
  Widget _tabBar() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: List.generate(_tabNames.length, (i) {
            final active = _activeTab == i;
            final col = active ? _accent : _primaryText.withOpacity(0.35);
            return GestureDetector(
              onTap: () {
                setState(() => _activeTab = i);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 66,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: active ? _accent : Colors.transparent, width: 2),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_tabIcons[i], size: 20, color: col),
                      const SizedBox(height: 3),
                      Text(_tabNames[i],
                          style: TextStyle(
                            color: col,
                            fontSize: 9.5,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w400,
                            letterSpacing: 0.3,
                          )),
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Tab panel switcher ───────────────────────────────────────────────────────
  Widget _tabPanel() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: switch (_activeTab) {
        0 => _filtersPanel(),
        1 => _adjustPanel(),
        2 => _cropPanel(),
        3 => _drawPanel(),
        4 => _textPanel(),
        5 => _stickersPanel(),
        6 => _effectsPanel(),
        7 => _audioPanel(),
        8 => _exportPanel(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  // ─── 0. Filters panel ────────────────────────────────────────────────────────
  Widget _filtersPanel() {
    return Container(
      key: const ValueKey(0),
      color: _surface,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Filter strip
        SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            itemCount: _filters.length,
            itemBuilder: (_, i) {
              final active = _selectedFilter == i;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedFilter = i);
                  HapticFeedback.selectionClick();
                  _pushHistory();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 66,
                  margin: const EdgeInsets.only(right: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: active ? _accent : Colors.transparent, width: 2),
                    boxShadow: active
                        ? [
                            BoxShadow(
                                color: _accent.withOpacity(0.3), blurRadius: 8)
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.matrix(_filters[i].matrix),
                        child: Image.network(widget.mediaUrl,
                            width: 66,
                            height: 76,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                  width: 66,
                                  height: 76,
                                  color: _border,
                                  child: Icon(Icons.image,
                                      color: _primaryText.withOpacity(0.2),
                                      size: 20),
                                )),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          color: Colors.black.withOpacity(0.58),
                          child: Text(_filters[i].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: active ? _accent : Colors.white70,
                                fontSize: 9,
                                fontWeight:
                                    active ? FontWeight.w800 : FontWeight.w400,
                              )),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
        // Filter intensity slider
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(children: [
            Icon(Icons.opacity_rounded, color: _secondText, size: 15),
            const SizedBox(width: 8),
            Text('Intensity',
                style: TextStyle(color: _secondText, fontSize: 11)),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _accent,
                  inactiveTrackColor: _border,
                  thumbColor: _accent,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 5.5),
                  trackHeight: 1.5,
                ),
                child: Slider(
                  value: _filterIntensity,
                  min: 0,
                  max: 1,
                  onChanged: (v) => setState(() => _filterIntensity = v),
                  onChangeEnd: (_) => _pushHistory(),
                ),
              ),
            ),
            SizedBox(
              width: 34,
              child: Text('${(_filterIntensity * 100).toInt()}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ]),
    );
  }

  // ─── 1. Adjust panel (3 sub-groups) ──────────────────────────────────────────
  Widget _adjustPanel() {
    final groups = ['Light', 'Color', 'Detail'];
    return Container(
      key: const ValueKey(1),
      color: _surface,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Sub-group selector
        Container(
          color: _bg,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Row(
              children: List.generate(3, (i) {
            final active = _adjGroup == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _adjGroup = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color:
                        active ? _accent.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: active ? _accent : _border, width: 1),
                  ),
                  child: Text(groups[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active ? _accent : _secondText,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      )),
                ),
              ),
            );
          })),
        ),
        // Sliders for selected group
        SizedBox(
          height: 220,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: Column(children: _getAdjSliders()),
          ),
        ),
      ]),
    );
  }

  List<Widget> _getAdjSliders() {
    switch (_adjGroup) {
      case 0:
        return [
          _aSlider('Brightness', Icons.wb_sunny_outlined, _brightness,
              (v) => setState(() => _brightness = v)),
          _aSlider('Contrast', Icons.contrast_rounded, _contrast,
              (v) => setState(() => _contrast = v)),
          _aSlider('Exposure', Icons.exposure_rounded, _exposure,
              (v) => setState(() => _exposure = v)),
          _aSlider('Highlights', Icons.flare_rounded, _highlights,
              (v) => setState(() => _highlights = v)),
          _aSlider('Shadows', Icons.nights_stay_outlined, _shadows,
              (v) => setState(() => _shadows = v)),
        ];
      case 1:
        return [
          _aSlider('Saturation', Icons.water_drop_outlined, _saturation,
              (v) => setState(() => _saturation = v)),
          _aSlider('Warmth', Icons.thermostat_outlined, _warmth,
              (v) => setState(() => _warmth = v)),
          _aSlider('Tint', Icons.palette_outlined, _tint,
              (v) => setState(() => _tint = v)),
          _aSlider('Vibrance', Icons.colorize_outlined, _vibrance,
              (v) => setState(() => _vibrance = v)),
          _aSlider('Hue', Icons.invert_colors_rounded, _hue,
              (v) => setState(() => _hue = v)),
        ];
      default:
        return [
          _aSlider('Fade', Icons.blur_on_rounded, _fade,
              (v) => setState(() => _fade = v)),
          _aSlider('Clarity', Icons.grain_rounded, _clarity,
              (v) => setState(() => _clarity = v)),
          _aSlider('Sharpness', Icons.deblur_rounded, _sharpness,
              (v) => setState(() => _sharpness = v)),
          _aSlider('Grain', Icons.noise_aware_rounded, _grain,
              (v) => setState(() => _grain = v)),
        ];
    }
  }

  Widget _aSlider(String label, IconData icon, double value,
      ValueChanged<double> onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(children: [
        Icon(icon, color: _primaryText.withOpacity(0.35), size: 15),
        const SizedBox(width: 7),
        SizedBox(
            width: 76,
            child: Text(label,
                style: TextStyle(
                    color: _primaryText.withOpacity(0.55),
                    fontSize: 11,
                    letterSpacing: 0.1))),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _accent,
              inactiveTrackColor: _border,
              thumbColor: _accent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              trackHeight: 1.5,
            ),
            child: Slider(
              value: value,
              min: -1,
              max: 1,
              onChanged: onChange,
              onChangeEnd: (_) => _pushHistory(),
            ),
          ),
        ),
        SizedBox(
            width: 30,
            child: Text(
              (value * 100).toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color:
                      value == 0.0 ? _primaryText.withOpacity(0.25) : _accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            )),
      ]),
    );
  }

  // ─── 2. Crop panel ────────────────────────────────────────────────────────────
  Widget _cropPanel() {
    return Container(
      key: const ValueKey(2),
      color: _surface,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Rotation slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Icon(Icons.rotate_right_rounded, color: _secondText, size: 15),
            const SizedBox(width: 7),
            SizedBox(
                width: 50,
                child: Text('Rotate',
                    style: TextStyle(color: _secondText, fontSize: 11))),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _accent,
                  inactiveTrackColor: _border,
                  thumbColor: _accent,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 5.5),
                  trackHeight: 1.5,
                ),
                child: Slider(
                  value: _rotation,
                  min: -45,
                  max: 45,
                  onChanged: (v) => setState(() => _rotation = v),
                  onChangeEnd: (_) => _pushHistory(),
                ),
              ),
            ),
            SizedBox(
                width: 38,
                child: Text(
                  '${_rotation.toStringAsFixed(1)}°',
                  style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                )),
          ]),
        ),
        const SizedBox(height: 6),
        // Flip controls + aspect ratios
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: [
              // Flip H
              _cropChip(Icons.flip_rounded, 'Flip H', _flipH, () {
                setState(() => _flipH = !_flipH);
                _pushHistory();
              }, isIcon: true),
              const SizedBox(width: 8),
              // Flip V
              _cropChip(Icons.flip_rounded, 'Flip V', _flipV, () {
                setState(() => _flipV = !_flipV);
                _pushHistory();
              }, isIcon: true, iconFlipV: true),
              const SizedBox(width: 12),
              // Aspect ratios
              ..._aspectLabels.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child:
                        _cropChip(null, e.value, _aspectRatioIdx == e.key, () {
                      setState(() => _aspectRatioIdx = e.key);
                    }),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ]),
    );
  }

  Widget _cropChip(
      IconData? icon, String label, bool active, VoidCallback onTap,
      {bool isIcon = false, bool iconFlipV = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? _accent.withOpacity(0.14)
              : _primaryText.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: active ? _accent : _primaryText.withOpacity(0.1),
              width: 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Transform(
              alignment: Alignment.center,
              transform: iconFlipV
                  ? (Matrix4.identity()..rotateZ(math.pi / 2))
                  : Matrix4.identity(),
              child: Icon(icon,
                  size: 13,
                  color: active ? _accent : _primaryText.withOpacity(0.45)),
            ),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: active ? _accent : _primaryText.withOpacity(0.45),
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
        ]),
      ),
    );
  }

  // ─── 3. Draw panel ────────────────────────────────────────────────────────────
  Widget _drawPanel() {
    final tools = [
      _DrawTool.brush,
      _DrawTool.neon,
      _DrawTool.marker,
      _DrawTool.highlighter,
      _DrawTool.eraser
    ];
    final toolIcons = [
      Icons.brush_rounded,
      Icons.auto_awesome_rounded,
      Icons.edit_rounded,
      Icons.highlight_rounded,
      Icons.cleaning_services_rounded
    ];
    final toolNames = ['Brush', 'Neon', 'Marker', 'Glow', 'Eraser'];

    return Container(
      key: const ValueKey(3),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Tool selector
        Row(children: [
          ...List.generate(5, (i) {
            final active = _drawTool == tools[i];
            return Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() => _drawTool = tools[i]);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active
                      ? _accent.withOpacity(0.15)
                      : _primaryText.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: active ? _accent : _border, width: 1),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(toolIcons[i],
                      size: 18,
                      color: active ? _accent : _primaryText.withOpacity(0.4)),
                  const SizedBox(height: 2),
                  Text(toolNames[i],
                      style: TextStyle(
                        color: active ? _accent : _primaryText.withOpacity(0.4),
                        fontSize: 8.5,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      )),
                ]),
              ),
            ));
          }),
          const SizedBox(width: 6),
          // Undo draw
          GestureDetector(
            onTap: _undoDraw,
            child: Container(
              width: 38,
              height: 50,
              decoration: BoxDecoration(
                  color: _primaryText.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _border)),
              child: Icon(Icons.undo_rounded,
                  color: _primaryText.withOpacity(0.4), size: 18),
            ),
          ),
          const SizedBox(width: 6),
          // Clear all
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _clearDrawing();
            },
            child: Container(
              width: 38,
              height: 50,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: FlutterFlowTheme.of(context).error.withOpacity(0.4)),
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: FlutterFlowTheme.of(context).error, size: 18),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        // Color palette + size
        Row(children: [
          // Colors
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ..._drawColors.map((c) => GestureDetector(
                      onTap: () {
                        setState(() => _drawColor = c);
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 130),
                        width: _drawColor == c ? 26 : 22,
                        height: _drawColor == c ? 26 : 22,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: _drawColor == c
                                  ? _accent
                                  : Colors.transparent,
                              width: 2),
                          boxShadow: _drawColor == c
                              ? [
                                  BoxShadow(
                                      color: _accent.withOpacity(0.5),
                                      blurRadius: 6)
                                ]
                              : null,
                        ),
                      ),
                    )),
              ]),
            ),
          ),
          const SizedBox(width: 10),
          // Size indicator
          Column(children: [
            Text('Size', style: TextStyle(color: _secondText, fontSize: 9)),
            const SizedBox(height: 2),
            Container(
              width: 26,
              height: _drawSize.clamp(4, 18),
              decoration: BoxDecoration(
                  color: _drawColor, borderRadius: BorderRadius.circular(4)),
            ),
          ]),
        ]),
        // Size slider
        Row(children: [
          Icon(Icons.circle, color: _primaryText.withOpacity(0.3), size: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _accent,
                inactiveTrackColor: _border,
                thumbColor: _accent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                trackHeight: 1.5,
              ),
              child: Slider(
                value: _drawSize,
                min: 2,
                max: 30,
                onChanged: (v) => setState(() => _drawSize = v),
              ),
            ),
          ),
          Icon(Icons.circle, color: _primaryText.withOpacity(0.3), size: 16),
        ]),
      ]),
    );
  }

  // ─── 4. Text panel ────────────────────────────────────────────────────────────
  Widget _textPanel() {
    const textColors = [
      Colors.white,
      Colors.black,
      Color(0xFFFF3B30),
      Color(0xFFFF9500),
      Color(0xFFFFCC00),
      Color(0xFF34C759),
      Color(0xFF007AFF),
      Color(0xFFAF52DE),
    ];
    return Container(
      key: const ValueKey(4),
      height: 124,
      color: _surface,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _overlays.add(_TextOverlay(
                    text: 'New Text',
                    x: 60,
                    y: 120,
                    fontSize: 26,
                    color: _primaryText));
                _selectedOverlay = _overlays.length - 1;
              });
              HapticFeedback.lightImpact();
              _pushHistory();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: _accent.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_rounded, color: _bg, size: 15),
                const SizedBox(width: 4),
                Text('Add Text',
                    style: TextStyle(
                        color: _bg, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          const SizedBox(width: 10),
          if (_overlays.isNotEmpty)
            Text('Tap text to edit',
                style: TextStyle(color: _secondText, fontSize: 11)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Text('Color  ', style: TextStyle(color: _secondText, fontSize: 11)),
          ...textColors.map((c) => GestureDetector(
                onTap: () {
                  if (_selectedOverlay != null)
                    setState(() => _overlays[_selectedOverlay!].color = c);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: _primaryText.withOpacity(0.2), width: 1),
                  ),
                ),
              )),
        ]),
      ]),
    );
  }

  // ─── 5. Stickers panel ────────────────────────────────────────────────────────
  Widget _stickersPanel() {
    return Container(
      key: const ValueKey(5),
      height: 160,
      color: _surface,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(children: [
            Icon(Icons.emoji_emotions_outlined, color: _secondText, size: 14),
            const SizedBox(width: 6),
            Text(
                'Tap to add • Drag to move • Pinch to resize • Double-tap to remove',
                style: TextStyle(color: _secondText, fontSize: 10)),
          ]),
        ),
        Expanded(
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _emojiList.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _stickers.add(_StickerItem(
                    emoji: _emojiList[i],
                    x: 80,
                    y: 100,
                    size: 52,
                    rotation: 0,
                  ));
                  _selectedSticker = _stickers.length - 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _primaryText.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                    child: Text(_emojiList[i],
                        style: const TextStyle(fontSize: 26))),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ─── 6. Effects panel ─────────────────────────────────────────────────────────
  Widget _effectsPanel() {
    return Container(
      key: const ValueKey(6),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _effectSlider('Vignette', Icons.vignette_rounded, _vignetteAmount,
            (v) => setState(() => _vignetteAmount = v)),
        _effectSlider('Glow', Icons.flare_rounded, _glowAmount,
            (v) => setState(() => _glowAmount = v),
            clampPositive: true),
        _effectSlider('Blur', Icons.blur_on_rounded, _blurAmount,
            (v) => setState(() => _blurAmount = v),
            clampPositive: true),
        _effectSlider('Grain', Icons.noise_aware_rounded, _grain,
            (v) => setState(() => _grain = v),
            clampPositive: true),
      ]),
    );
  }

  Widget _effectSlider(
      String label, IconData icon, double value, ValueChanged<double> onChange,
      {bool clampPositive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Icon(icon, color: _primaryText.withOpacity(0.35), size: 15),
        const SizedBox(width: 7),
        SizedBox(
            width: 76,
            child: Text(label,
                style: TextStyle(
                    color: _primaryText.withOpacity(0.55), fontSize: 11))),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _accent,
              inactiveTrackColor: _border,
              thumbColor: _accent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
              trackHeight: 1.5,
            ),
            child: Slider(
              value: value,
              min: clampPositive ? 0 : -1,
              max: 1,
              onChanged: onChange,
              onChangeEnd: (_) => _pushHistory(),
            ),
          ),
        ),
        SizedBox(
            width: 30,
            child: Text(
              '${(value * 100).toInt()}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color:
                      value == 0.0 ? _primaryText.withOpacity(0.25) : _accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            )),
      ]),
    );
  }

  // ─── 7. Audio panel ───────────────────────────────────────────────────────────
  Widget _audioPanel() {
    return Container(
      key: const ValueKey(7),
      height: 130,
      color: _surface,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.music_note_rounded, color: _accent, size: 16),
          const SizedBox(width: 6),
          Text('Audio Controls',
              style: TextStyle(
                  color: _primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          // Mute toggle
          GestureDetector(
            onTap: () {
              setState(() => _muted = !_muted);
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _muted
                    ? FlutterFlowTheme.of(context).error.withOpacity(0.15)
                    : _accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        _muted ? FlutterFlowTheme.of(context).error : _accent),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                    _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color:
                        _muted ? FlutterFlowTheme.of(context).error : _accent,
                    size: 15),
                const SizedBox(width: 5),
                Text(_muted ? 'Muted' : 'Audio On',
                    style: TextStyle(
                        color: _muted
                            ? FlutterFlowTheme.of(context).error
                            : _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        // Volume slider
        Row(children: [
          Icon(Icons.volume_down_rounded,
              color: _primaryText.withOpacity(0.35), size: 16),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _muted ? _border : _accent,
                inactiveTrackColor: _border,
                thumbColor: _muted ? _border : _accent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 2,
              ),
              child: Slider(
                value: _muted ? 0 : _volume,
                min: 0,
                max: 1,
                onChanged: _muted ? null : (v) => setState(() => _volume = v),
              ),
            ),
          ),
          Icon(Icons.volume_up_rounded,
              color: _primaryText.withOpacity(0.35), size: 16),
          const SizedBox(width: 8),
          Text('${(_volume * 100).toInt()}%',
              style: TextStyle(
                  color: _muted ? _secondText : _accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }

  // ─── 8. Export panel ─────────────────────────────────────────────────────────
  Widget _exportPanel() {
    return Container(
      key: const ValueKey(8),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Quality selector
        Row(children: [
          Icon(Icons.high_quality_rounded, color: _accent, size: 16),
          const SizedBox(width: 6),
          Text('Export Quality',
              style: TextStyle(
                  color: _primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 10),
        Row(
            children: List.generate(4, (i) {
          final active = _exportQuality == i;
          return Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() => _exportQuality = i);
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? _accent.withOpacity(0.15)
                    : _primaryText.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: active ? _accent : _border, width: 1.5),
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: _accent.withOpacity(0.2), blurRadius: 8)
                      ]
                    : null,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_qualityLabels[i],
                    style: TextStyle(
                        color: active ? _accent : _primaryText,
                        fontSize: 13,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500)),
                const SizedBox(height: 2),
                Text(_qualitySizes[i],
                    style: TextStyle(color: _secondText, fontSize: 9)),
              ]),
            ),
          ));
        })),
        const SizedBox(height: 14),
        // Export button / progress
        if (_isExporting) ...[
          Row(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _exportProgress,
                  backgroundColor: _border,
                  valueColor: AlwaysStoppedAnimation(_accent),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('${(_exportProgress * 100).toInt()}%',
                style: TextStyle(
                    color: _accent, fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          Text('Optimizing media…',
              style: TextStyle(color: _secondText, fontSize: 11)),
        ] else if (_exportDone) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: FlutterFlowTheme.of(context).success.withOpacity(0.5)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle_rounded,
                  color: FlutterFlowTheme.of(context).success, size: 20),
              const SizedBox(width: 8),
              Text('Export complete!',
                  style: TextStyle(
                      color: FlutterFlowTheme.of(context).success,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ]),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _runExport,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: _accent.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4))
                  ],
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.file_upload_outlined, color: _bg, size: 20),
                  const SizedBox(width: 8),
                  Text(
                      'Export ${widget.isVideo ? 'Video' : 'Image'} · ${_qualityLabels[_exportQuality]}',
                      style: TextStyle(
                          color: _bg,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

// ─── Data models ──────────────────────────────────────────────────────────────

class _FilterPreset {
  final String name;
  final List<double> matrix;
  const _FilterPreset(this.name, this.matrix);
}

enum _DrawTool { brush, neon, marker, highlighter, eraser }

class _DrawStroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final double opacity;
  final _DrawTool tool;
  const _DrawStroke({
    required this.points,
    required this.color,
    required this.size,
    required this.opacity,
    required this.tool,
  });
}

class _TextOverlay {
  String text;
  double x, y, fontSize;
  Color color;
  _TextOverlay(
      {required this.text,
      required this.x,
      required this.y,
      required this.fontSize,
      required this.color});
  Map<String, dynamic> toMap() => {
        'text': text,
        'x': x,
        'y': y,
        'fontSize': fontSize,
        'colorValue': color.value,
      };
  factory _TextOverlay.fromMap(Map<String, dynamic> m) => _TextOverlay(
        text: m['text'] as String,
        x: m['x'] as double,
        y: m['y'] as double,
        fontSize: m['fontSize'] as double,
        color: Color(m['colorValue'] as int),
      );
}

class _StickerItem {
  String emoji;
  double x, y, size, rotation;
  _StickerItem(
      {required this.emoji,
      required this.x,
      required this.y,
      required this.size,
      required this.rotation});
}

// ─── Drawing painter ──────────────────────────────────────────────────────────

class _DrawingPainter extends CustomPainter {
  final List<_DrawStroke> strokes;
  final List<Offset> activePoints;
  final _DrawTool activeTool;
  final Color activeColor;
  final double activeSize;
  final double activeOpacity;

  const _DrawingPainter({
    required this.strokes,
    required this.activePoints,
    required this.activeTool,
    required this.activeColor,
    required this.activeSize,
    required this.activeOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    for (final stroke in strokes) _paintStroke(canvas, stroke);
    if (activePoints.isNotEmpty) {
      _paintStroke(
          canvas,
          _DrawStroke(
            points: activePoints,
            color: activeColor,
            size: activeSize,
            opacity: activeOpacity,
            tool: activeTool,
          ));
    }
    canvas.restore();
  }

  void _paintStroke(Canvas canvas, _DrawStroke stroke) {
    if (stroke.points.length < 2) return;
    final isEraser = stroke.tool == _DrawTool.eraser;
    final isNeon = stroke.tool == _DrawTool.neon;
    final isHigh = stroke.tool == _DrawTool.highlighter;

    if (isNeon) {
      // Neon: outer glow + bright core
      for (int layer = 3; layer >= 0; layer--) {
        final paint = Paint()
          ..color =
              stroke.color.withOpacity(stroke.opacity * (0.15 + layer * 0.2))
          ..strokeWidth = stroke.size + layer * 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..blendMode = BlendMode.srcOver;
        canvas.drawPath(_buildPath(stroke.points), paint);
      }
      return;
    }

    final paint = Paint()
      ..color = isEraser
          ? Colors.transparent
          : stroke.color
              .withOpacity(isHigh ? stroke.opacity * 0.45 : stroke.opacity)
      ..strokeWidth = isHigh ? stroke.size * 2.5 : stroke.size
      ..strokeCap =
          stroke.tool == _DrawTool.marker ? StrokeCap.square : StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..blendMode = isEraser ? BlendMode.clear : BlendMode.srcOver;

    canvas.drawPath(_buildPath(stroke.points), paint);
  }

  Path _buildPath(List<Offset> pts) {
    final path = Path();
    path.moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length - 1; i++) {
      final mid = Offset(
          (pts[i].dx + pts[i + 1].dx) / 2, (pts[i].dy + pts[i + 1].dy) / 2);
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  @override
  bool shouldRepaint(_DrawingPainter old) =>
      old.strokes != strokes || old.activePoints != activePoints;
}

// ─── Vignette painter ─────────────────────────────────────────────────────────

class _VignettePainter extends CustomPainter {
  final double intensity;
  const _VignettePainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(intensity * 0.75),
        ],
        stops: const [0.0, 0.45, 1.0],
        center: Alignment.center,
        radius: 0.85,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_VignettePainter old) => old.intensity != intensity;
}

// ─── Grain painter ────────────────────────────────────────────────────────────

class _GrainPainter extends CustomPainter {
  final double intensity;
  const _GrainPainter({required this.intensity});

  double _hash(int x, int y) {
    double n = (math.sin(x * 127.1 + y * 311.7) * 43758.5453123).abs();
    return n - n.floor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;
    final rng = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    final count = (size.width * size.height * intensity * 0.012).toInt();
    for (int i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final bright = rng.nextBool();
      paint.color = (bright ? Colors.white : Colors.black)
          .withOpacity(intensity * 0.35 * rng.nextDouble());
      canvas.drawCircle(Offset(x, y), 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.intensity != intensity;
}

// ─── Crop grid painter ────────────────────────────────────────────────────────

class _CropGridPainter extends CustomPainter {
  final Color accentColor;
  const _CropGridPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.28)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    final handlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(Offset(size.width * i / 3, 0),
          Offset(size.width * i / 3, size.height), gridPaint);
      canvas.drawLine(Offset(0, size.height * i / 3),
          Offset(size.width, size.height * i / 3), gridPaint);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
    const h = 20.0;
    final w = size.width, ht = size.height;
    canvas.drawLine(const Offset(0, h), Offset.zero, handlePaint);
    canvas.drawLine(Offset.zero, const Offset(h, 0), handlePaint);
    canvas.drawLine(Offset(w - h, 0), Offset(w, 0), handlePaint);
    canvas.drawLine(Offset(w, 0), Offset(w, h), handlePaint);
    canvas.drawLine(Offset(0, ht - h), Offset(0, ht), handlePaint);
    canvas.drawLine(Offset(0, ht), Offset(h, ht), handlePaint);
    canvas.drawLine(Offset(w - h, ht), Offset(w, ht), handlePaint);
    canvas.drawLine(Offset(w, ht - h), Offset(w, ht), handlePaint);
  }

  @override
  bool shouldRepaint(_CropGridPainter old) => old.accentColor != accentColor;
}
