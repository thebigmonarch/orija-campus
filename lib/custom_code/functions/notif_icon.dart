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

String notifIcon(String notifType) {
  const map = {
    'new_dm': 'chat_bubble',
    'ask_replied_dm': 'reply',
    'order_status_update': 'shopping_bag',
    'payment_confirmed': 'check_circle',
    'rider_assigned': 'delivery_dining',
    'delivery_confirmed_vendor': 'done_all',
    'outbid': 'gavel',
    'bid_won_payment_reminder': 'emoji_events',
    'live_now_purchased_vendor': 'live_tv',
    'live_now_followed_vendor': 'live_tv',
    'post_recommended': 'share',
    'post_interactions': 'favorite',
    'community_new_post': 'groups',
    'community_new_vendor': 'store',
    'live_upcoming_community': 'event',
    'platform_announcement': 'campaign',
    'account_flagged': 'flag',
    'account_banned': 'block',
    'subscription_expiry_24h': 'timer',
    'subscription_expiry_7d': 'schedule',
    'dispute_resolved': 'handshake',
    'ask_category_match': 'search',
    'trending_content': 'trending_up',
    'suggested_community': 'explore',
    'area_vendor_weekly': 'location_on',
  };
  return map[notifType] ?? 'notifications';
}
