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
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/nav/nav.dart';

enum _Probe { online, offline, slow }

/// App-wide connectivity watcher. Start it once (OrijaExplore does, and it
/// is idempotent); from then on it probes the backend and, on a confirmed
/// failure, pushes the full-screen [OrijaNetworkError] onto the root
/// navigator immediately -- over whatever screen the user is on. The screen
/// pops itself as soon as the connection is back, returning the user to
/// exactly where they were.
///
/// Detection is a one-row backend query rather than a connectivity plugin:
/// "connected to Wi-Fi" is not "can reach Orija", and it needs no new
/// dependency and works on web (no dart:io). A hard network error
/// (socket/handshake/client failure) redirects at once -- that only fires
/// when the network is actually down, not merely slow. A timed-out probe
/// (12s) has to happen three times in a row before it counts (roughly a
/// minute of sustained bad signal), so an ordinary slow-connection blip on
/// a working network never throws the user out. Any answer from the
/// server -- even an error -- means the network is fine.
class OrijaNetworkWatcher with WidgetsBindingObserver {
  OrijaNetworkWatcher._();
  static final OrijaNetworkWatcher _instance = OrijaNetworkWatcher._();

  /// true while the backend is reachable; the offline screen listens.
  static final ValueNotifier<bool> online = ValueNotifier<bool>(true);

  static bool _started = false;
  static bool _showing = false;
  static bool _checking = false;
  static bool _paused = false;
  static int _tick = 0;
  static int _slowStrikes = 0;

  static void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(_instance);
    Timer.periodic(const Duration(seconds: 4), (_) {
      _tick++;
      // Every 8s while online; every 4s while the offline screen is up.
      if (_showing || _tick.isEven) check();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _paused = state != AppLifecycleState.resumed;
    if (state == AppLifecycleState.resumed) check();
  }

  static Future<_Probe> _probe() async {
    try {
      await Future<void>(() async {
        await Supabase.instance.client
            .from('categories')
            .select('slug')
            .limit(1);
      }).timeout(const Duration(seconds: 12));
      return _Probe.online;
    } on TimeoutException {
      return _Probe.slow;
    } catch (e) {
      final t = e.runtimeType.toString();
      if (t.contains('SocketException') ||
          t.contains('ClientException') ||
          t.contains('HandshakeException') ||
          t.contains('XMLHttpRequest') ||
          t.contains('WebSocketException')) {
        return _Probe.offline;
      }
      // The server answered (e.g. a Postgrest error) or something
      // unrelated failed: don't raise a false offline alarm.
      return _Probe.online;
    }
  }

  static Future<bool> check() async {
    if (_checking || _paused) return online.value;
    _checking = true;
    final result = await _probe();
    _checking = false;
    if (result == _Probe.online) {
      _slowStrikes = 0;
      online.value = true;
      return true;
    }
    if (result == _Probe.slow && ++_slowStrikes < 3) return online.value;
    online.value = false;
    _show();
    return false;
  }

  static void _show() {
    if (_showing) return;
    final nav = appNavigatorKey.currentState;
    if (nav == null) return;
    _showing = true;
    nav
        .push(MaterialPageRoute<void>(
          fullscreenDialog: true,
          settings: const RouteSettings(name: 'networkError'),
          builder: (_) => const OrijaNetworkError(),
        ))
        .whenComplete(() => _showing = false);
  }
}

/// Full-screen "you're offline" page. Back is blocked (the app can't do
/// much without a connection); it closes itself the moment
/// [OrijaNetworkWatcher] sees the backend again, or on a successful
/// "Try again".
class OrijaNetworkError extends StatefulWidget {
  const OrijaNetworkError({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaNetworkError> createState() => _OrijaNetworkErrorState();
}

class _OrijaNetworkErrorState extends State<OrijaNetworkError> {
  bool _retrying = false;
  bool _stillOffline = false;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    OrijaNetworkWatcher.online.addListener(_onStatus);
  }

  @override
  void dispose() {
    OrijaNetworkWatcher.online.removeListener(_onStatus);
    super.dispose();
  }

  void _onStatus() {
    if (OrijaNetworkWatcher.online.value) _close();
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
  }

  Future<void> _retry() async {
    if (_retrying) return;
    setState(() {
      _retrying = true;
      _stillOffline = false;
    });
    final ok = await OrijaNetworkWatcher.check();
    if (!mounted) return;
    if (ok) {
      _close();
    } else {
      setState(() {
        _retrying = false;
        _stillOffline = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 124,
                    height: 124,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [theme.secondary, theme.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withValues(alpha: 0.28),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.wifi_off_rounded,
                        size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 28),
                  Text('You\'re offline',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(
                      'Check your Wi-Fi or mobile data. We\'ll take you right '
                      'back to where you were the moment you\'re connected.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 14,
                          height: 1.4)),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _retrying ? null : _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            theme.primary.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _retrying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Try again',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _stillOffline
                        ? Text('Still no connection. Trying again shortly...',
                            key: const ValueKey('still'),
                            style: TextStyle(
                                color: theme.error,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600))
                        : Row(
                            key: const ValueKey('auto'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.6,
                                    color: theme.secondaryText),
                              ),
                              const SizedBox(width: 8),
                              Text('Reconnecting automatically',
                                  style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 12.5)),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
