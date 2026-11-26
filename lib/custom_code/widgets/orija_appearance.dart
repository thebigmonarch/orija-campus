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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

enum _ThemeChoice { light, dark, system }

/// Replaces the native Appearance page. Tapping a card applies and persists
/// that theme immediately (through `setDarkModeSetting`/
/// `FlutterFlowTheme.saveThemeMode`), and the initial selection is read from
/// `FlutterFlowTheme.themeMode` -- the same source of truth MyApp uses on
/// startup -- so the page always shows what's actually active instead of
/// defaulting to System every time it's reopened.
class OrijaAppearance extends StatefulWidget {
  const OrijaAppearance({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaAppearance> createState() => _OrijaAppearanceState();
}

class _OrijaAppearanceState extends State<OrijaAppearance> {
  late _ThemeChoice _choice;

  @override
  void initState() {
    super.initState();
    _choice = switch (FlutterFlowTheme.themeMode) {
      ThemeMode.light => _ThemeChoice.light,
      ThemeMode.dark => _ThemeChoice.dark,
      ThemeMode.system => _ThemeChoice.system,
    };
  }

  void _choose(_ThemeChoice value) {
    if (_choice == value) return;
    setState(() => _choice = value);
    switch (value) {
      case _ThemeChoice.light:
        setDarkModeSetting(context, ThemeMode.light);
        break;
      case _ThemeChoice.dark:
        setDarkModeSetting(context, ThemeMode.dark);
        break;
      case _ThemeChoice.system:
        setDarkModeSetting(context, ThemeMode.system);
        break;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Theme updated.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text('Appearance',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.alternate),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: theme.secondary.withValues(alpha: 0.1),
                        shape: BoxShape.circle),
                    child: Icon(Icons.brightness_auto_rounded,
                        color: theme.secondary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('System Default',
                            style: TextStyle(
                                color: theme.primaryText,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Automatically matches your device settings.',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Choose Theme',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Applies as soon as you pick one.',
                style: TextStyle(color: theme.secondaryText, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _themeCard(theme, _ThemeChoice.light, 'Light',
                        'Bright & clean', Icons.light_mode_rounded)),
                const SizedBox(width: 10),
                Expanded(
                    child: _themeCard(theme, _ThemeChoice.dark, 'Dark',
                        'Low light', Icons.dark_mode_rounded)),
                const SizedBox(width: 10),
                Expanded(
                    child: _themeCard(theme, _ThemeChoice.system, 'System',
                        'Auto match', Icons.brightness_auto_rounded)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeCard(FlutterFlowTheme theme, _ThemeChoice value, String title,
      String desc, IconData icon) {
    final selected = _choice == value;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _choose(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? theme.primary : theme.alternate,
              width: selected ? 2 : 1),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: theme.primaryText, size: 20),
                if (selected)
                  Positioned(
                    right: -10,
                    top: -6,
                    child: Icon(Icons.check_circle_rounded,
                        color: theme.primary, size: 14),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(desc,
                style: TextStyle(color: theme.secondaryText, fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}
