import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

Color getUserColor(String userId) {
  const colorPalette = [
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFF4511E), // Orange
    Color(0xFF8E24AA), // Purple
    Color(0xFF3949AB), // Indigo
    Color(0xFF00897B), // Teal
    Color(0xFFFB8C00), // Amber
    Color(0xFF5E35B1), // Deep Purple
    Color(0xFFD81B60), // Pink
    Color(0xFF6D4C41), // Brown
    Color(0xFF039BE5), // Light Blue
    Color(0xFF7CB342), // Light Green
    Color(0xFFFFB300), // Vivid Amber
    Color(0xFF00ACC1), // Cyan
    Color(0xFF8D6E63), // Tan
    Color(0xFFBA68C8), // Soft Violet
    Color(0xFFE53935), // Red
    Color(0xFF26A69A), // Turquoise
    Color(0xFF9CCC65), // Lime
    Color(0xFFAB47BC), // Bright Purple
    Color(0xFFFF7043), // Coral
    Color(0xFF78909C), // Slate
    Color(0xFF00796B), // Dark Teal
    Color(0xFFEC407A), // Magenta
  ];

  // Return a default color if input is empty
  if (userId.isEmpty) {
    return Colors.grey;
  }

  // Convert userId to a simple integer hash
  int hash = userId.codeUnits.fold(0, (prev, elem) => prev + elem);

  // Pick a color from the palette using the hash
  int colorIndex = hash % colorPalette.length;

  return colorPalette[colorIndex];
}
