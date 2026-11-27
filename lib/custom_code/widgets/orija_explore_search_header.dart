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

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/widgets/orija_chat_list.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Standalone, reusable search header for Explore: gradient-glow search bar
/// + Ask?/Sell? buttons, with FULL inline search -- typing runs a debounced
/// call against the real orija_search RPC (the same backend the dedicated
/// Search page uses) and renders results (stores / listings / communities)
/// directly under the bar. Submitting the search does NOT navigate to a
/// separate search page; only tapping a specific result does (to that
/// result's own detail page), which is expected.
class OrijaExploreSearchHeader extends StatefulWidget {
  const OrijaExploreSearchHeader(
      {super.key, this.width, this.height, this.onExpandedChanged});

  final double? width;
  final double? height;

  /// Fires with `true` when the inline results panel opens (a query became
  /// non-empty) and `false` when it closes -- lets a parent embedding this
  /// in a sliver (e.g. a collapsible SliverAppBar) resize itself instead of
  /// clipping or leaving dead space around the results dropdown.
  final ValueChanged<bool>? onExpandedChanged;

  /// True while the "You have N bags" banner is showing, so the page can make
  /// the header sliver tall enough for it.
  static final ValueNotifier<bool> bagBannerShown = ValueNotifier<bool>(false);

  @override
  State<OrijaExploreSearchHeader> createState() =>
      _OrijaExploreSearchHeaderState();
}

class _OrijaExploreSearchHeaderState extends State<OrijaExploreSearchHeader> {
  final _controller = TextEditingController();
  Timer? _debounce;
  bool _loading = false;
  bool _searched = false;
  String _lastQuery = '';
  List<Map<String, dynamic>> _storefronts = [];
  List<Map<String, dynamic>> _listings = [];
  List<Map<String, dynamic>> _communities = [];

  int _bagCount = 0;
  List<String> _bagIds = [];
  Set<String> _dismissedBags = {};
  Timer? _bagTimer;

  // Shown when at least one bag has not been dismissed. A bag that appears
  // later has a new id, so the banner comes back for it.
  bool get _showBagBanner => _bagIds.any((id) => !_dismissedBags.contains(id));

  @override
  void initState() {
    super.initState();
    _loadBagCount();
    _bagTimer =
        Timer.periodic(const Duration(seconds: 45), (_) => _loadBagCount());
  }

  /// Conversations that have a bag in progress (yours to send or check out, or
  /// one waiting for your review). Best effort: no count is shown on failure.
  Future<void> _loadBagCount() async {
    try {
      final rows = await Supabase.instance.client
          .from('all_threads_view')
          .select('thread_id, active_bag_id')
          .eq('is_bag', true);
      final ids = (rows as List)
          .map((r) => '${(r as Map)['active_bag_id'] ?? r['thread_id']}')
          .toList();
      final prefs = await SharedPreferences.getInstance();
      final saved = (prefs.getStringList('orija_bag_banner_dismissed') ??
              const <String>[])
          .toSet();
      // Forget dismissals for bags that no longer exist.
      final kept = saved.where(ids.contains).toSet();
      if (kept.length != saved.length) {
        await prefs.setStringList('orija_bag_banner_dismissed', kept.toList());
      }
      if (!mounted) return;
      setState(() {
        _bagCount = ids.length;
        _bagIds = ids;
        _dismissedBags = kept;
      });
      OrijaExploreSearchHeader.bagBannerShown.value = _showBagBanner;
    } catch (_) {}
  }

  Future<void> _dismissBanner() async {
    setState(() => _dismissedBags = {..._dismissedBags, ..._bagIds});
    OrijaExploreSearchHeader.bagBannerShown.value = _showBagBanner;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          'orija_bag_banner_dismissed', _dismissedBags.toList());
    } catch (_) {}
  }

  /// One quiet line under the search bar: there is a bag to look at.
  Widget _bagBanner(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _openBags,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 16, color: theme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    _bagCount == 1
                        ? 'You have a bag in your chats'
                        : 'You have $_bagCount bags in your chats',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: theme.primary),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _dismissBanner,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded,
                      size: 16, color: theme.secondaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openBags() async {
    orijaChatListFilterRequest.value = 'Bags';
    await context.pushNamed('chatPage');
    if (mounted) _loadBagCount();
  }

  @override
  void dispose() {
    OrijaExploreSearchHeader.bagBannerShown.value = false;
    _bagTimer?.cancel();
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      widget.onExpandedChanged?.call(false);
      setState(() {
        _searched = false;
        _loading = false;
        _storefronts = [];
        _listings = [];
        _communities = [];
      });
      return;
    }
    widget.onExpandedChanged?.call(true);
    _debounce =
        Timer(const Duration(milliseconds: 400), () => _runSearch(query));
  }

  Future<void> _runSearch(String query) async {
    setState(() => _loading = true);
    try {
      final res = await OrijasearchCall.call(
        pSearch: query,
        pUserId: currentUserUid,
        pLimit: 20,
        pOffset: 0,
      );
      if (!mounted || _controller.text.trim() != query) return;
      if (!res.succeeded) {
        setState(() {
          _lastQuery = query;
          _searched = true;
          _loading = false;
          _storefronts = [];
          _listings = [];
          _communities = [];
        });
        return;
      }
      final data = res.jsonBody as Map<String, dynamic>;
      setState(() {
        _lastQuery = query;
        _searched = true;
        _loading = false;
        _storefronts = List<Map<String, dynamic>>.from(
            (data['storefronts']?['items'] as List?) ?? const []);
        _listings = List<Map<String, dynamic>>.from(
            (data['listings']?['items'] as List?) ?? const []);
        _communities = List<Map<String, dynamic>>.from(
            (data['communities']?['items'] as List?) ?? const []);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searched = true;
        _loading = false;
        _storefronts = [];
        _listings = [];
        _communities = [];
      });
    }
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onExpandedChanged?.call(false);
    setState(() {
      _searched = false;
      _loading = false;
      _storefronts = [];
      _listings = [];
      _communities = [];
    });
  }

  String _naira(num? v) {
    final n = (v ?? 0).round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  Widget _resultTile(FlutterFlowTheme theme,
      {required String? imageUrl,
      required String title,
      required String subtitle,
      required IconData fallbackIcon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 42,
                height: 42,
                color: theme.alternate,
                child: (imageUrl ?? '').isEmpty
                    ? Icon(fallbackIcon, color: theme.secondaryText, size: 18)
                    : Image.network(imageUrl!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: theme.secondaryText, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _resultSection(
      FlutterFlowTheme theme, String label, List<Widget> tiles) {
    if (tiles.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 2),
          child: Text(label.toUpperCase(),
              style: TextStyle(
                  color: theme.secondaryText,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ),
        ...tiles,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasQuery = _controller.text.trim().isNotEmpty;
    final hasResults = _storefronts.isNotEmpty ||
        _listings.isNotEmpty ||
        _communities.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: theme.primary,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [theme.secondary, theme.primary],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(1, 0),
                      end: const AlignmentDirectional(-1, 0),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: TextFormField(
                      controller: _controller,
                      onChanged: _onChanged,
                      style: TextStyle(color: theme.primaryText),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Make your search',
                        hintStyle: TextStyle(color: theme.secondaryText),
                        filled: true,
                        fillColor: theme.primaryBackground,
                        prefixIcon: const Icon(Icons.search_sharp),
                        suffixIcon: hasQuery
                            ? IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: theme.secondaryText, size: 18),
                                onPressed: _clear,
                              )
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0x00000000)),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.secondary),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Ask and Sell live in the + Create button now, so search
              // takes the full width.
            ],
          ),
          if (_showBagBanner && !hasQuery) _bagBanner(theme),
          if (hasQuery)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              constraints: const BoxConstraints(maxHeight: 360),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.alternate),
              ),
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                          child: SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : (!_searched || !hasResults)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    _searched
                                        ? "No results for \"$_lastQuery\""
                                        : 'Searching...',
                                    style: TextStyle(
                                        color: theme.secondaryText,
                                        fontSize: 13)),
                                if (_searched) ...[
                                  const SizedBox(height: 10),
                                  OutlinedButton.icon(
                                    onPressed: () => context.pushNamed(
                                        'AskCommunity',
                                        queryParameters:
                                            _lastQuery.trim().isEmpty
                                                ? {}
                                                : {'q': _lastQuery.trim()}),
                                    icon: const Icon(Icons.campaign_outlined,
                                        size: 16),
                                    label: const Text(
                                        "Can't find it? Ask the community"),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _resultSection(
                                  theme,
                                  'Stores',
                                  _storefronts
                                      .map((s) => _resultTile(
                                            theme,
                                            imageUrl: s['logo_url'] as String?,
                                            title: s['name'] as String? ?? '',
                                            subtitle:
                                                s['city'] as String? ?? '',
                                            fallbackIcon:
                                                Icons.storefront_outlined,
                                            onTap: () => context.pushNamed(
                                                'storefrontPage',
                                                queryParameters: {
                                                  'storefontslug':
                                                      '${s['slug']}'
                                                }),
                                          ))
                                      .toList()),
                              _resultSection(
                                  theme,
                                  'Listings',
                                  _listings
                                      .map((l) => _resultTile(
                                            theme,
                                            imageUrl: withListingWatermark(
                                                l['primary_image'] as String? ??
                                                    ''),
                                            title: l['title'] as String? ?? '',
                                            subtitle:
                                                _naira(l['price'] as num?),
                                            fallbackIcon: Icons.image_outlined,
                                            onTap: () => context.pushNamed(
                                                'listingdetailPage',
                                                queryParameters: {
                                                  'listingId': '${l['id']}'
                                                }),
                                          ))
                                      .toList()),
                              _resultSection(
                                  theme,
                                  'Communities',
                                  _communities
                                      .map((c) => _resultTile(
                                            theme,
                                            imageUrl:
                                                c['icon_url'] as String? ??
                                                    c['cover_url'] as String?,
                                            title: c['name'] as String? ?? '',
                                            subtitle:
                                                '${c['member_count'] ?? 0} members',
                                            fallbackIcon: Icons.groups_outlined,
                                            onTap: () => context.pushNamed(
                                                'community',
                                                queryParameters: {
                                                  'communityID': '${c['id']}'
                                                }),
                                          ))
                                      .toList()),
                              const SizedBox(height: 6),
                            ],
                          ),
                        ),
            ),
        ],
      ),
    );
  }
}
