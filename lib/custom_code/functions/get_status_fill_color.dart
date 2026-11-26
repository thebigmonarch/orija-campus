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

Color getStatusFillColor(String? status) {
  switch (status?.trim().toLowerCase()) {
    case 'trialing':
      return const Color(0xFF7B2FBE);
    case 'active':
      return const Color(0xFF4CAF50);
    case 'past_due':
      return const Color(0xFFFF9800);
    case 'canceled':
      return const Color(0xFFF44336);
    case 'dormant':
      return const Color(0xFF9E9E9E);
    default:
      return const Color(0xFF9E9E9E);
  }
}
