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

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A heart that saves / un-saves one listing to the signed-in user's Saved
/// list (listing_saves). Self-contained: it reads its own state, flips
/// optimistically, and rolls back if the write fails. Drop it anywhere a
/// listing is shown -- the listing page's top bar and Explore's For You tiles
/// use it. [compact] is the smaller overlay style for tiles.
class OrijaListingSaveButton extends StatefulWidget {
  const OrijaListingSaveButton({
    super.key,
    this.width,
    this.height,
    this.listingId,
    this.compact = false,
  });

  final double? width;
  final double? height;
  final String? listingId;
  final bool compact;

  @override
  State<OrijaListingSaveButton> createState() => _OrijaListingSaveButtonState();
}

class _OrijaListingSaveButtonState extends State<OrijaListingSaveButton> {
  bool _saved = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant OrijaListingSaveButton old) {
    super.didUpdateWidget(old);
    if (old.listingId != widget.listingId) _load();
  }

  Future<void> _load() async {
    final id = widget.listingId;
    if (id == null || id.isEmpty) return;
    try {
      final r = await Supabase.instance.client
          .from('listing_saves')
          .select('listing_id')
          .eq('user_id', currentUserUid)
          .eq('listing_id', id)
          .limit(1);
      if (mounted) setState(() => _saved = (r as List).isNotEmpty);
    } catch (_) {}
  }

  Future<void> _toggle() async {
    final id = widget.listingId;
    if (id == null || id.isEmpty || _busy) return;
    final was = _saved;
    setState(() {
      _saved = !was;
      _busy = true;
    });
    try {
      final db = Supabase.instance.client;
      if (was) {
        await db
            .from('listing_saves')
            .delete()
            .match({'user_id': currentUserUid, 'listing_id': id});
      } else {
        await db
            .from('listing_saves')
            .insert({'user_id': currentUserUid, 'listing_id': id});
      }
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      const shownFor = Duration(seconds: 5);
      final controller = messenger.showSnackBar(SnackBar(
        content: Text(was ? 'Removed from Saved' : 'Saved'),
        duration: shownFor,
        action: was
            ? null
            : SnackBarAction(
                label: 'View',
                onPressed: () => context.pushNamed('SavedItems')),
      ));
      // Belt-and-suspenders: force it closed even if something (a rapid
      // second save, a route change) leaves the built-in timer never firing.
      Timer(shownFor, () => controller.close());
    } catch (_) {
      if (mounted) setState(() => _saved = was);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final size = widget.compact ? 30.0 : 42.0;
    return Tooltip(
      message: _saved ? 'Remove from Saved' : 'Save',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _toggle,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(
            _saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: widget.compact ? 17 : 22,
            color: _saved ? theme.error : Colors.black87,
          ),
        ),
      ),
    );
  }
}
