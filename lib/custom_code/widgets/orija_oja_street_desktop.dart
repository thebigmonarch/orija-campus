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

/// Desktop OjaStreet destination (Pattern F, theater reel). Reuses the
/// real OrijaOjaFeed widget unchanged -- the reel stays portrait-
/// proportioned and centered rather than stretched full-width, with the
/// reclaimed side space going to a simple "what this is" panel for now.
/// oja_street_page itself (native tree, hybrid: OrijaOjaFeed + a native
/// search-bar overlay) is left untouched, same reasoning as Profile: a
/// brand-new page + widget instead of risky native-tree patching, reached
/// only from the top bar's OjaStreet nav item, which only exists in a
/// desktop context. No utility rail here either -- same as Chat, an
/// immersive reel view doesn't want the Wallet/Ask/Sell/Settings rail
/// competing for space.
class OrijaOjaStreetDesktop extends StatelessWidget {
  const OrijaOjaStreetDesktop({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return OrijaDesktopShell(
      activeNav: 'ojaStreet',
      showUtilityRail: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: const OrijaOjaFeed(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: theme.alternate, width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OjaStreet',
                    style: theme.titleMedium.override(color: theme.primaryText),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scroll through sellers showing what they\'ve got -- same reel as mobile, just kept portrait here instead of stretched full-width.',
                    style: theme.bodySmall.override(color: theme.secondaryText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
