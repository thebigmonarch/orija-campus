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

String convertOrijaLink(String inputUrl) {
  if (inputUrl.isEmpty) return inputUrl;

  final uri = Uri.tryParse(inputUrl);
  if (uri == null) return inputUrl;

  // Only transform your custom deep link
  if (uri.scheme == 'orija') {
    return Uri(
      scheme: 'https',
      host: 'app.orijahq.com',
      path: uri.path, // keeps /storefrontPage
      queryParameters: uri.queryParameters.isEmpty
          ? null
          : uri.queryParameters, // keeps ?storefontslug=...
      fragment: uri.fragment.isEmpty ? null : uri.fragment,
    ).toString();
  }

  return inputUrl; // leave other URLs untouched
}
