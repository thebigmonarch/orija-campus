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
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// The Join / Joined (or Link / Linked, for a store) button on a community card.
///
/// It asks the database whether you are in, and every tap goes through
/// signed-in database functions that use your real identity, never a user id
/// sent by the app, so nobody can join or remove someone else. With a
/// [storeId] the button lists or unlists that store (markets ask the community
/// head to approve first, shown as Pending); without one it joins or leaves the
/// community as a member.
class OrijaCommunityAction extends StatefulWidget {
  const OrijaCommunityAction({
    super.key,
    this.width,
    this.height,
    required this.communityId,
    this.storeId,
    this.isLink,
    this.isJoined,
  });

  final double? width;
  final double? height;
  final String? communityId;
  final String? storeId;
  final bool? isLink;
  final bool? isJoined;

  @override
  State<OrijaCommunityAction> createState() => _OrijaCommunityActionState();
}

class _OrijaCommunityActionState extends State<OrijaCommunityAction> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  bool _busy = false;
  bool _joined = false;
  String? _link; // approved | pending | null
  String? _type; // community | market | institution

  bool get _forStore => (widget.storeId ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _joined = widget.isJoined ?? false;
    _load();
  }

  @override
  void didUpdateWidget(covariant OrijaCommunityAction old) {
    super.didUpdateWidget(old);
    if (old.communityId != widget.communityId || old.storeId != widget.storeId)
      _load();
  }

  Future<void> _load() async {
    final id = widget.communityId ?? '';
    if (id.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final res = await _db.rpc('get_community_card', params: {
        'p_community_id': id,
        if (_forStore) 'p_store_id': widget.storeId,
      });
      if (!mounted) return;
      setState(() {
        if (res is Map && res['success'] == true) {
          _joined = res['joined'] == true;
          _link = res['link_status'] as String?;
          _type = res['type'] as String?;
        }
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: error ? theme.error : theme.secondary));
  }

  Future<void> _act() async {
    if (_busy) return;
    setState(() => _busy = true);
    final id = widget.communityId ?? '';
    try {
      dynamic res;
      if (_forStore) {
        res = await _db.rpc(
            _link != null
                ? 'leave_my_community'
                : 'join_my_storefront_to_community',
            params: {'p_storefront_id': widget.storeId, 'p_community_id': id});
      } else {
        res = await _db.rpc(
            _joined ? 'leave_community_member' : 'join_community_member',
            params: {'p_community_id': id});
      }
      final ok = res is Map && res['success'] == true;
      _toast(
          '${res is Map ? (res['message'] ?? (ok ? 'Done.' : 'That did not work.')) : 'That did not work.'}',
          error: !ok);
      if (ok) await _load();
    } catch (_) {
      _toast('No connection. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) return const SizedBox(width: 78, height: 30);
    // School communities are linked automatically, one per person: no Link button.
    if (_forStore && _type == 'institution') return const SizedBox.shrink();
    final String label;
    final bool on;
    if (_forStore) {
      on = _link != null;
      label = _link == 'approved'
          ? 'Linked'
          : (_link == 'pending' ? 'Pending' : 'Link');
    } else {
      on = _joined;
      label = on ? 'Joined' : 'Join';
    }
    return SizedBox(
      height: 30,
      child: OutlinedButton(
        onPressed: _busy ? null : _act,
        style: OutlinedButton.styleFrom(
          backgroundColor: on ? Colors.transparent : theme.secondary,
          foregroundColor: on ? theme.secondary : Colors.white,
          side: BorderSide(color: theme.secondary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          minimumSize: const Size(78, 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _busy
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: on ? theme.secondary : Colors.white))
            : Text(label,
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
