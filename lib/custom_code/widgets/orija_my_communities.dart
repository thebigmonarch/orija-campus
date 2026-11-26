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
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Every community the signed-in user has joined, read straight from
/// community_members (the old get_my_communities RPC only returns seed
/// communities, so it would hide anything else you belong to). Search,
/// filter by kind (community / market / institution), open one, or leave it
/// -- leaving removes any of your storefronts listed there first (through
/// the existing leave_my_community function, which keeps the vendor count
/// and group thread right) and then your membership. The head of a
/// community can't leave from here.
class OrijaMyCommunities extends StatefulWidget {
  const OrijaMyCommunities({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyCommunities> createState() => _OrijaMyCommunitiesState();
}

class _OrijaMyCommunitiesState extends State<OrijaMyCommunities> {
  final TextEditingController _search = TextEditingController();
  bool _loading = true;
  bool _failed = false;
  String _type = 'all';
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final supabase = Supabase.instance.client;
      final members = await supabase
          .from('community_members')
          .select('community_id, role, joined_at')
          .eq('user_id', currentUserUid)
          .order('joined_at', ascending: false);
      final memberRows = List<Map<String, dynamic>>.from(members as List);
      final ids = memberRows.map((m) => m['community_id'] as String).toList();
      final byId = <String, Map<String, dynamic>>{};
      if (ids.isNotEmpty) {
        final rows = await supabase
            .from('communities')
            .select(
                'id, name, description, category, cover_url, icon_url, member_count, vendor_count, is_verified, type, status, city, state')
            .inFilter('id', ids);
        for (final r in List<Map<String, dynamic>>.from(rows as List)) {
          byId[r['id'] as String] = r;
        }
      }
      final items = <Map<String, dynamic>>[];
      for (final m in memberRows) {
        final c = byId[m['community_id']];
        if (c == null || c['status'] == 'archived') continue;
        items.add({...c, 'role': m['role'], 'joined_at': m['joined_at']});
      }
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _visible {
    final q = _search.text.trim().toLowerCase();
    return _items.where((c) {
      if (_type != 'all' && c['type'] != _type) return false;
      if (q.isEmpty) return true;
      return '${c['name']} ${c['category'] ?? ''} ${c['city'] ?? ''}'
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  String _ago(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inDays < 1) return 'today';
    if (d.inDays < 30) return '${d.inDays}d ago';
    if (d.inDays < 365) return '${(d.inDays / 30).floor()}mo ago';
    return '${(d.inDays / 365).floor()}y ago';
  }

  String _titleCase(String s) => s
      .replaceAll(RegExp(r'[-_]+'), ' ')
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  Future<void> _leave(Map<String, dynamic> c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Leave ${c['name']}?'),
        content: const Text(
            'You\'ll stop receiving updates from this community. Any of your storefronts listed there will be removed from it.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Leave',
                  style: TextStyle(
                      color: FlutterFlowTheme.of(dialogContext).error))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final supabase = Supabase.instance.client;
      final cid = c['id'] as String;
      final mine = await supabase
          .from('storefronts')
          .select('id')
          .eq('owner_id', currentUserUid);
      final myIds = List<Map<String, dynamic>>.from(mine as List)
          .map((s) => s['id'] as String)
          .toList();
      if (myIds.isNotEmpty) {
        final listed = await supabase
            .from('community_storefronts')
            .select('storefront_id')
            .eq('community_id', cid)
            .inFilter('storefront_id', myIds);
        for (final l in List<Map<String, dynamic>>.from(listed as List)) {
          await supabase.rpc('leave_my_community', params: {
            'p_storefront_id': l['storefront_id'],
            'p_community_id': cid,
          });
        }
      }
      final left = await supabase
          .rpc('leave_community_member', params: {'p_community_id': cid});
      if (left is Map && left['success'] != true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${left['message'] ?? 'Could not leave.'}')));
        return;
      }
      if (!mounted) return;
      setState(() => _items.removeWhere((x) => x['id'] == cid));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You left ${c['name']}')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not leave. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 2 (Pattern A). Mobile body below is
    // untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }
    if (_failed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 42, color: theme.secondaryText),
            const SizedBox(height: 10),
            Text('Couldn\'t load your communities.',
                style: TextStyle(color: theme.secondaryText)),
            TextButton(onPressed: _load, child: const Text('Try again')),
          ],
        ),
      );
    }
    if (_items.isEmpty) return _empty(theme);
    final list = _visible;
    final types =
        _items.map((c) => c['type'] as String? ?? 'community').toSet();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          Text(
              'You\'re in ${_items.length} ${_items.length == 1 ? 'community' : 'communities'}',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          TextField(
            controller: _search,
            style: TextStyle(color: theme.primaryText, fontSize: 13.5),
            decoration: InputDecoration(
              hintText: 'Search your communities',
              hintStyle: TextStyle(color: theme.secondaryText),
              prefixIcon: Icon(Icons.search, color: theme.secondaryText),
              filled: true,
              fillColor: theme.secondaryBackground,
              isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none),
            ),
          ),
          if (types.length > 1) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                for (final t in ['all', ...types])
                  ChoiceChip(
                    label: Text(t == 'all' ? 'All' : '${_titleCase(t)}s'),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                  child: Text('No communities match.',
                      style: TextStyle(color: theme.secondaryText))),
            )
          else
            for (final c in list) _card(theme, c),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.pushNamed('communitiesByInterest'),
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: const Text('Discover more communities'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primary,
              side: BorderSide(color: theme.primary),
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(FlutterFlowTheme theme, Map<String, dynamic> c) {
    final img = ((c['icon_url'] ?? c['cover_url']) as String?) ?? '';
    final role = c['role'] as String? ?? 'member';
    final isHead = role == 'head';
    final roleLabel =
        isHead ? 'Head' : (role == 'vendor_member' ? 'Vendor' : 'Member');
    final category = c['category'] as String?;
    final place = [c['city'], c['state']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(', ');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Opens the community's listings; "Open dashboard" there leads to the
        // community page.
        onTap: () => context.pushNamed('listlngPage', queryParameters: {
          'communityID': '${c['id']}',
          'name': '${c['name'] ?? ''}',
        }),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 64,
                  height: 64,
                  color: theme.alternate,
                  child: img.isEmpty
                      ? Icon(Icons.groups_rounded,
                          color: theme.secondaryText, size: 30)
                      : Image.network(img, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text('${c['name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700)),
                        ),
                        if (c['is_verified'] == true) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified_rounded,
                              size: 15, color: theme.secondary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                        [
                          '${c['member_count'] ?? 0} members',
                          if ((c['vendor_count'] as int? ?? 0) > 0)
                            '${c['vendor_count']} vendors',
                          if (place.isNotEmpty) place,
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _badge(theme, roleLabel,
                            isHead ? theme.primary : theme.secondary),
                        if (category != null && category.isNotEmpty)
                          _badge(
                              theme, _titleCase(category), theme.secondaryText),
                        Text('Joined ${_ago(c['joined_at'] as String?)}',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 10.5)),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: theme.secondaryText),
                onSelected: (v) {
                  if (v == 'open') {
                    context.pushNamed('community',
                        queryParameters: {'communityID': '${c['id']}'});
                  } else if (v == 'leave') {
                    _leave(c);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'open', child: Text('Open dashboard')),
                  if (!isHead)
                    const PopupMenuItem(value: 'leave', child: Text('Leave')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(FlutterFlowTheme theme, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );

  Widget _empty(FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_2_outlined, size: 60, color: theme.secondaryText),
            const SizedBox(height: 14),
            Text('No communities yet',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
                'Join a market or community to see its posts, vendors and updates here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 13, height: 1.4)),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => context.pushNamed('communitiesByInterest'),
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: const Text('Discover communities'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
