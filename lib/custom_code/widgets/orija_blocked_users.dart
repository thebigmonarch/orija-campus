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

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// New page -- Settings had no surface for this at all. block_user/
/// unblock_user/get_my_blocked_users already existed and are already
/// correctly auth.uid()-scoped (built earlier this session for chat), so
/// this is pure UI: list + unblock, zero new backend.
class OrijaBlockedUsers extends StatefulWidget {
  const OrijaBlockedUsers({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaBlockedUsers> createState() => _OrijaBlockedUsersState();
}

class _OrijaBlockedUsersState extends State<OrijaBlockedUsers> {
  bool _loading = true;
  List<Map<String, dynamic>> _blocked = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.rpc('get_my_blocked_users');
      if (!mounted) return;
      setState(() {
        _blocked = List<Map<String, dynamic>>.from(res as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unblock(Map<String, dynamic> row) async {
    final id = row['user_id'] as String?;
    if (id == null) return;
    setState(() => _blocked.remove(row));
    try {
      final res = await Supabase.instance.client
          .rpc('unblock_user', params: {'p_blocked_id': id});
      if (res is! Map || res['success'] != true) {
        if (mounted) {
          setState(() => _blocked.add(row));
          _snack('Could not unblock. Try again.');
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _blocked.add(row));
        _snack('No connection. Try again.');
      }
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Blocked Users',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _blocked.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block,
                              size: 40, color: theme.secondaryText),
                          const SizedBox(height: 10),
                          Text("You haven't blocked anyone.",
                              style: TextStyle(color: theme.secondaryText)),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _blocked.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final row = _blocked[i];
                      final name = row['name'] as String? ?? 'User';
                      final avatar = row['avatar_url'] as String?;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.alternate,
                              backgroundImage: (avatar ?? '').isNotEmpty
                                  ? NetworkImage(avatar!)
                                  : null,
                              child: (avatar ?? '').isEmpty
                                  ? Icon(Icons.person,
                                      color: theme.secondaryText)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(name.isEmpty ? 'User' : name,
                                  style: TextStyle(
                                      color: theme.primaryText, fontSize: 14)),
                            ),
                            TextButton(
                              onPressed: () => _unblock(row),
                              child: Text('Unblock',
                                  style: TextStyle(
                                      color: theme.secondary,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
