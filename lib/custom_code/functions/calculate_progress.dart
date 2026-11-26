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

double calculateProgress(
  double startNumber,
  double endNumber,
  double currentNumber,
) {
  // Guard against division by zero
  if (endNumber == startNumber) return 0.0;

  // Clamp the result between 0.0 and 1.0
  double progress = (currentNumber - startNumber) / (endNumber - startNumber);
  return progress.clamp(0.0, 1.0);
}
