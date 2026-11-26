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

/// Custom Action: Validate YouTube URL
///
/// This function validates if a given URL is a valid YouTube URL.
/// It supports various YouTube URL formats including:
/// - Standard: https://www.youtube.com/watch?v=VIDEO_ID
/// - Shortened: https://youtu.be/VIDEO_ID
/// - Mobile: https://m.youtube.com/watch?v=VIDEO_ID
/// - Embedded: https://www.youtube.com/embed/VIDEO_ID
/// - No-cookie embedded: https://www.youtube-nocookie.com/embed/VIDEO_ID
/// - Playlist URLs: https://www.youtube.com/playlist?list=PLAYLIST_ID
///
/// Parameters:
/// - url: String - The URL to validate
///
/// Returns:
/// - bool - true if valid YouTube URL, false otherwise

Future<bool> validateYouTubeUrl(String url) async {
  // Check if URL is empty or null
  if (url.isEmpty) {
    return false;
  }

  // Clean the URL - remove whitespace
  url = url.trim();

  // Regular expressions for different YouTube URL formats
  final List<RegExp> patterns = [
    // Standard YouTube URL
    RegExp(
        r'^https?://(www\.)?youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})(&.*)?$',
        caseSensitive: false),
    // Standard YouTube URL with additional parameters
    RegExp(
        r'^https?://(www\.)?youtube\.com/watch\?.*[&?]v=([a-zA-Z0-9_-]{11})(&.*)?$',
        caseSensitive: false),
    // Shortened YouTube URL
    RegExp(r'^https?://youtu\.be/([a-zA-Z0-9_-]{11})(\?.*)?$',
        caseSensitive: false),
    // Mobile YouTube URL
    RegExp(
        r'^https?://(www\.)?m\.youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})(&.*)?$',
        caseSensitive: false),
    // Embedded YouTube URL
    RegExp(r'^https?://(www\.)?youtube\.com/embed/([a-zA-Z0-9_-]{11})(\?.*)?$',
        caseSensitive: false),
    // No-cookie embedded YouTube URL
    RegExp(
        r'^https?://(www\.)?youtube-nocookie\.com/embed/([a-zA-Z0-9_-]{11})(\?.*)?$',
        caseSensitive: false),
    // YouTube v/ format
    RegExp(r'^https?://(www\.)?youtube\.com/v/([a-zA-Z0-9_-]{11})(\?.*)?$',
        caseSensitive: false),
    // YouTube playlist URL
    RegExp(
        r'^https?://(www\.)?youtube\.com/playlist\?list=([a-zA-Z0-9_-]+)(&.*)?$',
        caseSensitive: false)
  ];

  // Test each pattern
  for (final pattern in patterns) {
    if (pattern.hasMatch(url)) {
      return true;
    }
  }

  return false;
}
