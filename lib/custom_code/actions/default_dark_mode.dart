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
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shared_preferences/shared_preferences.dart';

/// Orija Campus opens in dark mode by default.
///
/// Runs once at app start (MainDart initialActions). The first time, if no
/// Appearance choice has been saved yet, it saves Dark. After that it never
/// runs again, so whatever is picked later in Settings > Appearance (Light,
/// Dark or Same as phone) always wins.
Future defaultDarkMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('orija_dark_default_applied') == true) return;
    // The theme's saved-choice store may not be set up yet this early.
    await FlutterFlowTheme.initialize();
    // Nothing chosen yet (FlutterFlow treats "no saved choice" as system).
    if (FlutterFlowTheme.themeMode == ThemeMode.system) {
      FlutterFlowTheme.saveThemeMode(ThemeMode.dark);
    }
    await prefs.setBool('orija_dark_default_applied', true);
  } catch (_) {
    // Never block the app from starting over a theme preference.
  }
}
