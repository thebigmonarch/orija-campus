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

/// Inserts a faded Orija logo overlay into a listing image's Cloudinary URL
/// at display time (non-destructive).
String? withListingWatermark(String? url) {
  final raw = url ?? '';
  if (raw.isEmpty) return raw;
  const marker = '/upload/';
  final idx = raw.indexOf(marker);
  if (idx == -1) return raw;
  final insertAt = idx + marker.length;
  return raw.substring(0, insertAt) +
      'l_OrijaLogoLightMode_fzbtri,w_0.3,fl_relative,o_55,g_south_east,x_10,y_10/' +
      raw.substring(insertAt);
}
