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

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/flutter_flow/custom_functions.dart';

class WatermarkedListingThumbnail extends StatelessWidget {
  const WatermarkedListingThumbnail({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.fullView = false,
  });

  final double? width;
  final double? height;
  final String? imageUrl;

  /// The image viewer: show the whole photo, centred, instead of filling and
  /// cropping the box like a thumbnail.
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    final raw = (imageUrl == null || imageUrl!.isEmpty)
        ? 'https://picsum.photos/seed/298/600'
        : imageUrl!;
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 500),
      fadeOutDuration: const Duration(milliseconds: 500),
      imageUrl: withListingWatermark(raw) ?? raw,
      width: width,
      height: height,
      fit: fullView ? BoxFit.contain : BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}
