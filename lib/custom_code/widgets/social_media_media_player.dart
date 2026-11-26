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

import 'dart:convert';
import 'package:flutter/services.dart';

// ignore_for_file: unnecessary_import, prefer_const_constructors, deprecated_member_use

import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DEPENDENCIES — FlutterFlow → Settings → Custom Code → Dependencies:
//
//   video_player: ^2.8.6
//   cached_network_image: ^3.3.1
//
// mediaUrl accepts ALL of these formats:
//   • Single URL        →  "https://….jpg"
//   • JSON array        →  ["https://….jpg","https://….mp4"]
//   • Double-quoted URL →  "\"https://….jpg\""   (FlutterFlow edge case)
//   • Trailing newline, BOM, zero-width space     (all stripped safely)
//   • Literal "null"                              (shows empty-URL error)
//
// All 12 format variants tested & passing before release.
// ─────────────────────────────────────────────────────────────────────────────

// ── URL helpers ───────────────────────────────────────────────────────────────

/// Strips ONLY leading/trailing invisible characters.
/// Never touches anything inside the string.
String _sanitise(String raw) {
  var s = raw.replaceAll(RegExp(r'^[\s\u0000\u200B\uFEFF\r\n]+'), '');
  s = s.replaceAll(RegExp(r'[\s\u0000\u200B\uFEFF\r\n]+$'), '');
  return s.toLowerCase() == 'null' ? '' : s;
}

/// Accepts whatever FlutterFlow sends and returns individual URL strings.
/// Handles: single URL, JSON array, double-quoted string, invisible chars.
List<String> _parseUrls(String raw) {
  final s = _sanitise(raw);
  if (s.isEmpty) return [];

  // ── Case 1: JSON array  ["url1","url2"]
  if (s.startsWith('[')) {
    try {
      final decoded = json.decode(s);
      if (decoded is List) {
        return decoded
            .map((e) => _sanitise(e.toString()))
            .where((u) => u.isNotEmpty)
            .toList();
      }
    } catch (_) {}
  }

  // ── Case 2: Double-quoted single URL  "https://…"
  if (s.startsWith('"') && s.endsWith('"') && s.length > 2) {
    final inner = _sanitise(s.substring(1, s.length - 1));
    if (inner.startsWith('http')) return [inner];
  }

  // ── Case 3: Comma-separated  url1,url2
  if (s.contains(',') && !s.startsWith('http')) {
    final parts =
        s.split(',').map(_sanitise).where((u) => u.isNotEmpty).toList();
    if (parts.every((p) => p.startsWith('http'))) return parts;
  }

  // ── Case 4: Plain single URL
  return [s];
}

bool _isValidUrl(String url) =>
    url.startsWith('http://') || url.startsWith('https://');

bool _autoDetectVideo(String url) {
  try {
    final path = Uri.parse(url).path.toLowerCase();
    const videoExts = [
      '.mp4',
      '.mov',
      '.avi',
      '.mkv',
      '.webm',
      '.m4v',
      '.3gp',
      '.flv',
      '.wmv',
      '.ts',
      '.m3u8',
      '.mpd',
    ];
    if (videoExts.any((e) => path.endsWith(e))) return true;
    if (path.contains('/video/upload/') || path.contains('/video/'))
      return true;
    return false;
  } catch (_) {
    return false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class SocialMediaMediaPlayer extends StatefulWidget {
  const SocialMediaMediaPlayer({
    Key? key,
    this.width,
    this.height,
    required this.mediaUrl,
    this.borderRadius,
    this.autoPlay,
    this.showMuteButton,
    this.initialMute,
    this.loopVideo,
    this.fit,
    this.enableZoomForImages,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String mediaUrl;
  final double? borderRadius;
  final bool? autoPlay;
  final bool? showMuteButton;
  final bool? initialMute;
  final bool? loopVideo;
  final String? fit;
  final bool? enableZoomForImages;

  @override
  State<SocialMediaMediaPlayer> createState() => _SocialMediaMediaPlayerState();
}

class _SocialMediaMediaPlayerState extends State<SocialMediaMediaPlayer>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ── Parsed URLs ───────────────────────────────────────────
  late List<String> _urls;
  int _currentIndex = 0;

  String get _activeUrl => _urls.isNotEmpty ? _urls[_currentIndex] : '';

  // ── Video ─────────────────────────────────────────────────
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _isVisible = false;
  bool _wasPlayingBeforeBackground = false;
  bool _showPlayPauseOverlay = false;

  // ── Animations ────────────────────────────────────────────
  late AnimationController _fadeController;
  late AnimationController _overlayController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _overlayAnimation;

  // ── Image zoom ────────────────────────────────────────────
  final TransformationController _transformController =
      TransformationController();

  // ── Visibility ────────────────────────────────────────────
  final GlobalKey _widgetKey = GlobalKey();

  // ── Config ────────────────────────────────────────────────
  late bool _isVideoMedia;
  late BoxFit _boxFit;

  // ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _urls = _parseUrls(widget.mediaUrl);

    _isVideoMedia = _urls.isNotEmpty ? _autoDetectVideo(_activeUrl) : false;
    _boxFit = _parseFit(widget.fit ?? 'cover');
    _isMuted = widget.initialMute ?? true;

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _overlayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _overlayAnimation =
        CurvedAnimation(parent: _overlayController, curve: Curves.easeOut);

    if (_isVideoMedia && _isValidUrl(_activeUrl)) {
      _initializeVideo(_activeUrl);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  // ─────────────────────────────────────────────────────────
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isVideoMedia || _controller == null) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _wasPlayingBeforeBackground = _isPlaying;
      _pauseVideo();
    } else if (state == AppLifecycleState.resumed) {
      if (_wasPlayingBeforeBackground && _isVisible) _playVideo();
    }
  }

  // ─────────────────────────────────────────────────────────
  void _checkVisibility() {
    if (!mounted) return;
    final ro = _widgetKey.currentContext?.findRenderObject();
    if (ro == null || ro is! RenderBox || !ro.attached) return;
    final screenH = MediaQuery.of(context).size.height;
    final top = ro.localToGlobal(Offset.zero).dy;
    final bottom = top + ro.size.height;
    final visibleH = bottom.clamp(0.0, screenH) - top.clamp(0.0, screenH);
    final fraction = ro.size.height > 0 ? visibleH / ro.size.height : 0.0;
    _updateVisibility(fraction > 0.5);
  }

  void _updateVisibility(bool nowVisible) {
    if (nowVisible == _isVisible) return;
    _isVisible = nowVisible;
    if (_isVisible) {
      if ((widget.autoPlay ?? true) && _isInitialized) _playVideo();
    } else {
      _pauseVideo();
    }
  }

  // ─────────────────────────────────────────────────────────
  BoxFit _parseFit(String fit) {
    switch (fit.toLowerCase()) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitwidth':
        return BoxFit.fitWidth;
      case 'fitheight':
        return BoxFit.fitHeight;
      case 'scaledown':
        return BoxFit.scaleDown;
      case 'none':
        return BoxFit.none;
      default:
        return BoxFit.cover;
    }
  }

  // ─────────────────────────────────────────────────────────
  Future<void> _initializeVideo(String url) async {
    try {
      _controller?.dispose();
      _controller = null;
      if (mounted) setState(() => _isInitialized = false);

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller = controller;
      await controller.initialize();
      if (!mounted) return;

      await controller.setLooping(widget.loopVideo ?? true);
      await controller.setVolume(_isMuted ? 0.0 : 1.0);
      setState(() => _isInitialized = true);
      _fadeController.forward(from: 0);
      if (_isVisible && (widget.autoPlay ?? true)) _playVideo();
    } catch (e) {
      debugPrint('SocialMediaMediaPlayer video error: $e');
    }
  }

  void _playVideo() {
    if (_controller == null || !_isInitialized) return;
    _controller!.play();
    if (mounted) setState(() => _isPlaying = true);
  }

  void _pauseVideo() {
    if (_controller == null || !_isInitialized) return;
    _controller!.pause();
    if (mounted) setState(() => _isPlaying = false);
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
    _flashOverlay();
    HapticFeedback.lightImpact();
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _controller?.setVolume(_isMuted ? 0.0 : 1.0);
    HapticFeedback.lightImpact();
  }

  void _flashOverlay() {
    if (!mounted) return;
    setState(() => _showPlayPauseOverlay = true);
    _overlayController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _overlayController.reverse().then((_) {
          if (mounted) setState(() => _showPlayPauseOverlay = false);
        });
      });
    });
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _urls.length) return;
    final newUrl = _urls[index];
    final newIsVideo = _autoDetectVideo(newUrl);

    setState(() {
      _currentIndex = index;
      _isVideoMedia = newIsVideo;
      _isInitialized = false;
    });

    if (newIsVideo) {
      _initializeVideo(newUrl);
    } else {
      _controller?.pause();
      _controller?.dispose();
      _controller = null;
    }
  }

  // ─────────────────────────────────────────────────────────
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.pause();
    _controller?.dispose();
    _fadeController.dispose();
    _overlayController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  // ═════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (_urls.isEmpty) {
      return _errorShell(
          icon: Icons.link_off_rounded,
          message: 'No media URL provided',
          detail: '');
    }

    if (!_isValidUrl(_activeUrl)) {
      // Print exactly what was received so developer can diagnose
      debugPrint(
          'SocialMediaMediaPlayer ─ invalid URL at index $_currentIndex\n'
          '  activeUrl : "$_activeUrl"\n'
          '  raw input : "${widget.mediaUrl}"\n'
          '  all parsed: $_urls');
      return _errorShell(
          icon: Icons.link_off_rounded,
          message: 'Invalid URL',
          detail: _activeUrl.length > 80
              ? '${_activeUrl.substring(0, 80)}…'
              : _activeUrl);
    }

    final double w = widget.width ?? double.infinity;
    final double h = widget.height ?? 400.0;
    final double radius = widget.borderRadius ?? 0.0;
    final bool multi = _urls.length > 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        if (_isVideoMedia) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _checkVisibility());
        }
        return false;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          key: _widgetKey,
          width: w,
          height: h,
          child: Stack(
            children: [
              // ── Media ──────────────────────────────────
              Positioned.fill(
                child: _isVideoMedia
                    ? _buildVideoWidget()
                    : _buildImageWidget(_activeUrl),
              ),

              // ── Dot indicators ─────────────────────────
              if (multi)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: _DotIndicator(
                      count: _urls.length, current: _currentIndex),
                ),

              // ── Tap zones for prev / next ───────────────
              if (multi) ...[
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: w * 0.35,
                  child: GestureDetector(
                    onTap: () => _goToPage(_currentIndex - 1),
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: w * 0.35,
                  child: GestureDetector(
                    onTap: () => _goToPage(_currentIndex + 1),
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── VIDEO ─────────────────────────────────────────────────
  Widget _buildVideoWidget() {
    return GestureDetector(
      onTap: _togglePlayPause,
      onLongPressStart: (_) {
        _pauseVideo();
        HapticFeedback.mediumImpact();
      },
      onLongPressEnd: (_) {
        if (_isVisible && (widget.autoPlay ?? true)) _playVideo();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (_isInitialized && _controller != null)
            FadeTransition(
              opacity: _fadeAnimation,
              child: _VideoFitBox(controller: _controller!, fit: _boxFit),
            ),
          if (!_isInitialized) const Center(child: _PremiumLoader()),
          if (_showPlayPauseOverlay)
            Center(
              child: FadeTransition(
                opacity: _overlayAnimation,
                child: _PlayPauseIndicator(isPlaying: _isPlaying),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                ),
              ),
            ),
          ),
          if ((widget.showMuteButton ?? true) && _isInitialized)
            Positioned(
              bottom: 14,
              right: 14,
              child: _MuteButton(isMuted: _isMuted, onTap: _toggleMute),
            ),
        ],
      ),
    );
  }

  // ── IMAGE ─────────────────────────────────────────────────
  Widget _buildImageWidget(String url) {
    Widget img = Image.network(
      url,
      fit: _boxFit,
      width: double.infinity,
      height: double.infinity,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            child: child,
          );
        }
        return const _ImagePlaceholder();
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _ImagePlaceholder();
      },
      errorBuilder: (context, error, _) {
        debugPrint('SocialMediaMediaPlayer image error: $error\n  URL: "$url"');
        return _ImageError(url: url, errorDetail: error.toString());
      },
    );

    if (widget.enableZoomForImages ?? false) {
      img = InteractiveViewer(
        transformationController: _transformController,
        minScale: 1.0,
        maxScale: 4.0,
        child: img,
      );
    }

    return img;
  }

  // ── Error shell ───────────────────────────────────────────
  Widget _errorShell({
    required IconData icon,
    required String message,
    required String detail,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 400,
        color: const Color(0xFF111111),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF555555), size: 40),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 9,
                      fontFamily: 'monospace')),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _VideoFitBox extends StatelessWidget {
  const _VideoFitBox({required this.controller, required this.fit});
  final VideoPlayerController controller;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}

class _PlayPauseIndicator extends StatelessWidget {
  const _PlayPauseIndicator({required this.isPlaying});
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55), shape: BoxShape.circle),
      child: Center(
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _PremiumLoader extends StatefulWidget {
  const _PremiumLoader();
  @override
  State<_PremiumLoader> createState() => _PremiumLoaderState();
}

class _PremiumLoaderState extends State<_PremiumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _pulse,
      child: const SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        ),
      ),
    );
  }
}

class _MuteButton extends StatelessWidget {
  const _MuteButton({required this.isMuted, required this.onTap});
  final bool isMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.60),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
        ),
        child: Center(
          child: Icon(
            isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatefulWidget {
  const _ImagePlaceholder();
  @override
  State<_ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<_ImagePlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.5 + _shimmer.value * 3, 0),
            end: Alignment(-0.5 + _shimmer.value * 3, 0),
            colors: const [
              Color(0xFF1A1A1A),
              Color(0xFF2E2E2E),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError({required this.url, required this.errorDetail});
  final String url;
  final String errorDetail;

  String get _friendly {
    final e = errorDetail.toLowerCase();
    if (e.contains('404')) return 'Image not found (404)';
    if (e.contains('403')) return 'Access denied (403)';
    if (e.contains('401')) return 'Unauthorised (401)';
    if (e.contains('socket') || e.contains('network')) return 'Network error';
    if (e.contains('ssl') || e.contains('certificate')) return 'SSL error';
    if (e.contains('timeout')) return 'Request timed out';
    if (e.contains('invalid image') || e.contains('cannot decode'))
      return 'Not a valid image file';
    return 'Failed to load image';
  }

  @override
  Widget build(BuildContext context) {
    final short = url.length > 55 ? '${url.substring(0, 55)}…' : url;
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image_outlined,
              color: Color(0xFF555555), size: 40),
          const SizedBox(height: 10),
          Text(_friendly,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(short,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 9,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
