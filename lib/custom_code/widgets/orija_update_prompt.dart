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

import 'dart:async';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/nav/nav.dart';

/// App-update watcher. Start it once per session (OrijaExplore does, and it
/// is idempotent); it reads the running app's own version via
/// package_info_plus, looks up the matching row in `app_versions` for this
/// platform, and -- only if the installed build is behind -- shows
/// [OrijaUpdatePrompt] over whatever screen the user is on. A build below
/// `minimum_version`, or a row with `force_update` set, blocks the app (no
/// dismiss, no back) until the user updates; anything else behind
/// `latest_version` is a dismissible nudge the user can defer.
class OrijaUpdateWatcher {
  OrijaUpdateWatcher._();

  static bool _started = false;
  static bool _showing = false;

  static Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      final platform = _platformSlug();
      if (platform == null) return; // web/desktop: no app_versions row applies

      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final rows = await Supabase.instance.client
          .from('app_versions')
          .select()
          .eq('platform', platform)
          .limit(1);
      final rowList = List<Map<String, dynamic>>.from(rows as List);
      if (rowList.isEmpty) return;
      final row = rowList.first;

      final latest = (row['latest_version'] as String?)?.trim() ?? '';
      final minimum = (row['minimum_version'] as String?)?.trim() ?? '';
      final updateUrl = (row['update_url'] as String?)?.trim() ?? '';
      final notesRaw = row['release_notes'] as String?;
      if (updateUrl.isEmpty) return;

      final belowMinimum =
          minimum.isNotEmpty && _compareVersions(current, minimum) < 0;
      final belowLatest =
          latest.isNotEmpty && _compareVersions(current, latest) < 0;
      final forced = belowMinimum || row['force_update'] == true;

      if (!forced && !belowLatest) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _show(
          forced: forced,
          updateUrl: updateUrl,
          releaseNotes: (notesRaw != null && notesRaw.trim().isNotEmpty)
              ? notesRaw
              : null,
          latestVersion: latest.isNotEmpty ? latest : null,
        );
      });
    } catch (_) {
      // Unreachable backend, missing table, or a parse hiccup: never block
      // app startup over a version check.
    }
  }

  static String? _platformSlug() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return null;
    }
  }

  /// Compares two dotted version strings ("1.2.0" vs "1.10.0") segment by
  /// segment as integers rather than lexically, so "1.10.0" correctly counts
  /// as newer than "1.2.0". Returns <0, 0, or >0 like [Comparable].
  static int _compareVersions(String a, String b) {
    final pa = a.split('.').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    final pb = b.split('.').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    final len = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < len; i++) {
      final va = i < pa.length ? pa[i] : 0;
      final vb = i < pb.length ? pb[i] : 0;
      if (va != vb) return va.compareTo(vb);
    }
    return 0;
  }

  static void _show({
    required bool forced,
    required String updateUrl,
    String? releaseNotes,
    String? latestVersion,
  }) {
    if (_showing) return;
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;
    _showing = true;
    showDialog<void>(
      context: ctx,
      barrierDismissible: !forced,
      builder: (_) => OrijaUpdatePrompt(
        forced: forced,
        updateUrl: updateUrl,
        releaseNotes: releaseNotes,
        latestVersion: latestVersion,
      ),
    ).whenComplete(() => _showing = false);
  }
}

/// The update dialog itself. [forced] drives both the copy and whether the
/// dialog can be dismissed: a forced update has no "Later" button and
/// [PopScope] blocks the back gesture, leaving "Update now" as the only way
/// out.
class OrijaUpdatePrompt extends StatelessWidget {
  const OrijaUpdatePrompt({
    super.key,
    this.width,
    this.height,
    this.forced = false,
    this.updateUrl = '',
    this.releaseNotes,
    this.latestVersion,
  });

  final double? width;
  final double? height;
  final bool forced;
  final String updateUrl;
  final String? releaseNotes;
  final String? latestVersion;

  Future<void> _openStore() async {
    final uri = Uri.tryParse(updateUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: !forced,
      child: Dialog(
        backgroundColor: theme.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [theme.secondary, theme.primary],
                  ),
                ),
                child: const Icon(Icons.system_update_rounded,
                    size: 34, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                forced ? 'Update required' : 'Update available',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                forced
                    ? 'This version of Orija is no longer supported. Update now to keep using the app.'
                    : (latestVersion != null
                        ? 'Version $latestVersion is here. Update for the latest features and fixes.'
                        : 'A new version of Orija is available.'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 13.5, height: 1.4),
              ),
              if (releaseNotes != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    releaseNotes!,
                    style: TextStyle(
                        color: theme.primaryText, fontSize: 12.5, height: 1.4),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _openStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Update now',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              if (!forced) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Later',
                      style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
