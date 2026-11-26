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

String formatSubscriptionLabel(String value) {
  const Map<String, String> labels = {
    // Tiers
    'starter': 'Starter',
    'trader': 'Trader',
    'market_boss': 'Market Boss',
    // Statuses
    'active': 'Active',
    'trialing': 'Free Trial',
    'past_due': 'Past Due',
    'canceled': 'Canceled',
    'dormant': 'Dormant',
    'goods': 'Goods',
    'services': 'Services',
    'fixed': 'Fixed',
    'negotiable': 'Negotiable',
    'new': 'New',
    'used': 'Used',
    'refurbished': 'Refurbished',
    'ask_question': 'Ask Question',
    'ask_opinion': 'Ask Opinion',
    'ask_looking_for': 'Looking for',
    'Ask Question': 'ask_question',
    'Ask Opinion': 'ask_opinion',
    'Looking for': 'ask_looking_for',
    'standard': 'Standard',
    'product_feature': 'Product Feature',
    'ask': 'Ask',
    'Spam': 'spam',
    'Misinformation': 'misinformation',
    'Harassment': 'harassment',
    'Hate Speech': 'hate_speech',
    'Nudity or Sexual': 'nudity_or_sexual',
    'Violence': 'violence',
    'Fraud or Scam': 'fraud_or_scam',
    'Counterfeit Goods': 'counterfeit_goods',
    'intellectual Property': 'intellectual_property',
    'Self Harm': 'self_harm',
    'Others': 'others',
    'Markets': 'market',
    'Communities': 'community',
    'Institutions': 'institution',
    'pending': 'Pending',
    'completed': 'Completed',
    'paid': 'Paid'
  };

  return labels[value.toLowerCase().trim()] ?? value;
}
