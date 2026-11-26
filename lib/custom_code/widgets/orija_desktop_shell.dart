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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Shared desktop/web shell: a full-width top bar (logo, primary nav,
/// search, notifications) with a utility rail (Wallet, Ask the Community,
/// Sell on Orija, Settings) and a content slot below it, side by side.
///
/// Used ONLY behind `OrijaDesktopShell.isDesktop(context)` -- nothing calls
/// this widget yet (Phase 0 of the desktop rollout), so it cannot affect any
/// existing mobile page. Each page that later adopts it keeps its current
/// `build()` body completely untouched as `_mobileBody()`, and only wraps
/// with this shell inside a new, purely additive desktop branch.
class OrijaDesktopShell extends StatelessWidget {
  const OrijaDesktopShell({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.activeNav,
    this.rightRail,
    this.showUtilityRail = true,
  });

  final double? width;
  final double? height;
  final Widget child;

  /// One of 'home' | 'chat' | 'ojaStreet' | 'profile', or null. Highlights
  /// the matching top-bar nav item for the page currently showing.
  final String? activeNav;

  /// Optional third column (e.g. a notifications feed) -- laid out as its
  /// own card, same as the utility rail and content, with a real gutter
  /// between each. Pages that already have their own two-pane layout
  /// (list+detail splits) keep that inside `child` instead; this slot is
  /// specifically for a persistent global panel like notifications.
  final Widget? rightRail;

  /// False for pages whose own content already makes good use of the full
  /// width (e.g. chat's list+thread panes) -- the global Wallet/Ask/Sell/
  /// Settings rail is a distraction there, not a useful constant.
  final bool showUtilityRail;

  /// Desktop/web breakpoint shared by every page that adopts this shell.
  /// Real phones never reach this width, which is what makes the desktop
  /// branch structurally unreachable on mobile -- not just a convention.
  static const double breakpoint = 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      // Page background sits a shade darker than the card surfaces below,
      // so the gutters between cards actually read as gutters (LinkedIn-
      // style separated panels) instead of one continuous flat bar.
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _TopBar(theme: theme, activeNav: activeNav),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showUtilityRail) ...[
                      _UtilityRail(theme: theme),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: _Card(
                        theme: theme,
                        padding: EdgeInsets.zero,
                        backgroundColor: theme.primaryBackground,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: child,
                        ),
                      ),
                    ),
                    if (rightRail != null) ...[
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 300,
                        child: _Card(theme: theme, child: rightRail!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared rounded-card surface -- every panel (utility rail, content,
/// right rail) uses this so the LinkedIn-style separated-card look stays
/// consistent instead of each panel rolling its own decoration.
class _Card extends StatelessWidget {
  const _Card({
    required this.theme,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
  });

  final FlutterFlowTheme theme;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: child,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.theme, required this.activeNav});

  final FlutterFlowTheme theme;
  final String? activeNav;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(bottom: BorderSide(color: theme.alternate, width: 1)),
      ),
      child: Row(
        children: [
          _Logo(),
          const SizedBox(width: 20),
          _SearchAskSell(theme: theme),
          // Centered in the remaining space between the search group and
          // the bell/avatar group, not just left-aligned next to search.
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icons here match the real mobile NavBar component
                  // exactly (home_outlined, FontAwesome commentDots,
                  // FontAwesome shoePrints, notifications_none) rather
                  // than generic Material picks -- confirmed by
                  // inspecting NavBar's live widget tree.
                  _NavItem(
                    label: 'Home',
                    iconBuilder: (c) =>
                        Icon(Icons.home_outlined, size: 18, color: c),
                    active: activeNav == 'home',
                    theme: theme,
                    onTap: () => context.goNamed('HomePage'),
                  ),
                  _NavItem(
                    label: 'Chat',
                    iconBuilder: (c) => FaIcon(FontAwesomeIcons.commentDots,
                        size: 16, color: c),
                    active: activeNav == 'chat',
                    theme: theme,
                    onTap: () => context.goNamed('chatPage'),
                  ),
                  _NavItem(
                    label: 'OjaStreet',
                    iconBuilder: (c) =>
                        FaIcon(FontAwesomeIcons.shoePrints, size: 16, color: c),
                    active: activeNav == 'ojaStreet',
                    theme: theme,
                    onTap: () => context.goNamed('OjaStreetDesktopPage'),
                  ),
                ],
              ),
            ),
          ),
          // No bell here anymore -- the right-rail notifications panel
          // (OrijaDesktopShell's rightRail slot) now shows the real list
          // directly, so a top-bar shortcut to the same thing is redundant.
          _ProfileAvatar(
            active: activeNav == 'profile',
            theme: theme,
            onTap: () => context.goNamed('ProfileDesktopPage'),
          ),
        ],
      ),
    );
  }
}

/// The search field + Ask?/Sell? quick buttons, mirroring Explore's own
/// OrijaExploreSearchHeader (same hint text, same AskCommunity/SellPage
/// targets) but as a plain static row rather than the full sliver-aware
/// widget with its inline expanding results panel -- embedding that
/// directly in this fixed-height top bar would have nowhere to grow into
/// when results open. Tapping the field still reaches real search, just
/// via a push to the search page instead of inline results.
class _SearchAskSell extends StatefulWidget {
  const _SearchAskSell({required this.theme});

  final FlutterFlowTheme theme;

  @override
  State<_SearchAskSell> createState() => _SearchAskSellState();
}

class _SearchAskSellState extends State<_SearchAskSell> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  Timer? _debounce;
  OverlayEntry? _overlay;
  bool _loading = false;
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _closeOverlay();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _closeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      setState(() => _results = []);
      _closeOverlay();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _run(query));
  }

  Future<void> _run(String query) async {
    setState(() => _loading = true);
    _showOverlay();
    try {
      final rows = await Supabase.instance.client
          .from('listings')
          .select('id, title, price, primary_image_url, storefront_id')
          .ilike('title', '%$query%')
          .eq('is_available', true)
          .limit(6);
      if (!mounted) return;
      setState(() {
        _results = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
      _overlay?.markNeedsBuild();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      _overlay?.markNeedsBuild();
    }
  }

  void _showOverlay() {
    if (_overlay != null) return;
    _overlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 320,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 42),
          child: _ResultsDropdown(
            theme: widget.theme,
            loading: _loading,
            results: _results,
            onTapResult: (r) {
              context.pushNamed('listingdetailPage', queryParameters: {
                'listingId': '${r['id']}',
                'storefrontId': '${r['storefront_id'] ?? ''}',
              });
              _controller.clear();
              setState(() => _results = []);
              _closeOverlay();
              _focusNode.unfocus();
            },
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _closeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Row(
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: SizedBox(
            width: 260,
            height: 36,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onSubmitted: (_) => context.pushNamed('searchPage'),
              style: theme.bodyMedium.override(color: theme.primaryText),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Make your search',
                hintStyle:
                    theme.bodyMedium.override(color: theme.secondaryText),
                prefixIcon:
                    Icon(Icons.search, size: 18, color: theme.secondaryText),
                filled: true,
                fillColor: theme.secondaryBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.alternate),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.alternate),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.primary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => context.pushNamed('AskCommunity'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            side: BorderSide(color: theme.alternate),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Ask?',
              style: TextStyle(color: theme.primaryText, fontSize: 13)),
        ),
        const SizedBox(width: 6),
        OutlinedButton(
          onPressed: () => context.pushNamed('SellPage'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            side: BorderSide(color: theme.alternate),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Sell?',
              style: TextStyle(color: theme.primaryText, fontSize: 13)),
        ),
      ],
    );
  }
}

class _ResultsDropdown extends StatelessWidget {
  const _ResultsDropdown({
    required this.theme,
    required this.loading,
    required this.results,
    required this.onTapResult,
  });

  final FlutterFlowTheme theme;
  final bool loading;
  final List<Map<String, dynamic>> results;
  final ValueChanged<Map<String, dynamic>> onTapResult;

  String _naira(num v) {
    final n = v.round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(10),
      color: theme.secondaryBackground,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 360),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.alternate),
        ),
        child: loading
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.primary),
                  ),
                ),
              )
            : results.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No listings found',
                        style: theme.bodySmall
                            .override(color: theme.secondaryText)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final r = results[i];
                      final img = r['primary_image_url'] as String?;
                      return InkWell(
                        onTap: () => onTapResult(r),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  color: theme.primaryBackground,
                                  child: (img?.isNotEmpty ?? false)
                                      ? Image.network(img!, fit: BoxFit.cover)
                                      : Icon(Icons.image_outlined,
                                          size: 18, color: theme.secondaryText),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${r['title'] ?? ''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.bodySmall
                                      .override(color: theme.primaryText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _naira((r['price'] as num?) ?? 0),
                                style: theme.bodySmall
                                    .override(color: theme.primary),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// Same real asset pair OrijaAuth uses for its own logo -- dark-mode and
// light-mode PNGs uploaded to the project's asset store.
const String _kOrijaLogoDark =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/zwwd502l5bt6/OrijaLogo2.png';
const String _kOrijaLogoLight =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/jllbgd2olh64/OrijaLogoLightMode.png';

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final logoUrl = isDarkMode ? _kOrijaLogoDark : _kOrijaLogoLight;
    // Height-constrained only (not forced into a square) -- the asset is
    // an icon+wordmark lockup, not a square icon, so a fixed-width box
    // was squashing it. BoxFit.contain scales width proportionally.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: SizedBox(
        height: 32,
        child: Image.network(logoUrl, fit: BoxFit.contain),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.iconBuilder,
    required this.active,
    required this.theme,
    required this.onTap,
  });

  final String label;

  // Widget, not IconData -- FontAwesomeIcons constants are typed
  // FaIconData in font_awesome_flutter 11.x, which does not satisfy a
  // plain IconData parameter (confirmed by a real wasm/web build failure),
  // so callers build their own Icon(...)/FaIcon(...) with the given color.
  final Widget Function(Color color) iconBuilder;
  final bool active;
  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? theme.primary : theme.secondaryText;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            iconBuilder(color),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.bodyMedium.override(
                color: color,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mirrors the real NavBar component's profile slot -- an actual avatar
/// image, not a generic person icon, with the same active/inactive ring
/// treatment as the other nav items.
class _ProfileAvatar extends StatefulWidget {
  const _ProfileAvatar({
    required this.active,
    required this.theme,
    required this.onTap,
  });

  final bool active;
  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) return;
      final row = await Supabase.instance.client
          .from('users')
          .select('avatar_url')
          .eq('id', uid)
          .maybeSingle();
      if (!mounted) return;
      setState(() => _avatarUrl = row?['avatar_url'] as String?);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: widget.onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.active ? theme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: ClipOval(
          child: (_avatarUrl?.isNotEmpty ?? false)
              ? Image.network(_avatarUrl!, fit: BoxFit.cover)
              : Container(
                  color: theme.secondaryBackground,
                  alignment: Alignment.center,
                  child: Icon(Icons.person_outline,
                      size: 16, color: theme.secondaryText),
                ),
        ),
      ),
    );
  }
}

/// LinkedIn-style profile summary at the top of the left sidebar: avatar,
/// name, Oja tier. Tapping it opens the real profile page.
class _ProfileCard extends StatefulWidget {
  const _ProfileCard({required this.theme});

  final FlutterFlowTheme theme;

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  String? _avatarUrl;
  String _name = '';
  String? _tier;
  int? _ojaPoints;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) return;
      final row = await Supabase.instance.client
          .from('users')
          .select(
              'avatar_url, first_name, last_name, oja_tier_title, oja_points')
          .eq('id', uid)
          .maybeSingle();
      if (!mounted || row == null) return;
      setState(() {
        _avatarUrl = row['avatar_url'] as String?;
        _name = [row['first_name'], row['last_name']]
            .where((e) => e != null && '$e'.isNotEmpty)
            .join(' ');
        _tier = row['oja_tier_title'] as String?;
        _ojaPoints = row['oja_points'] as int?;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.goNamed('ProfileDesktopPage'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryBackground,
              ),
              child: ClipOval(
                child: (_avatarUrl?.isNotEmpty ?? false)
                    ? Image.network(_avatarUrl!, fit: BoxFit.cover)
                    : Icon(Icons.person_outline,
                        size: 28, color: theme.secondaryText),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _name.isEmpty ? 'Your profile' : _name,
              style: theme.titleSmall.override(color: theme.primaryText),
            ),
            if (_tier != null) ...[
              const SizedBox(height: 2),
              Text(
                _tier!,
                style: theme.bodySmall.override(color: theme.secondaryText),
              ),
            ],
            if (_ojaPoints != null) ...[
              const SizedBox(height: 6),
              Text(
                '$_ojaPoints Oja points',
                style: theme.bodySmall.override(color: theme.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UtilityRail extends StatefulWidget {
  const _UtilityRail({required this.theme});

  final FlutterFlowTheme theme;

  @override
  State<_UtilityRail> createState() => _UtilityRailState();
}

class _UtilityRailState extends State<_UtilityRail> {
  bool _sellExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return _Card(
      theme: theme,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      backgroundColor: theme.primaryBackground,
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileCard(theme: theme),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: theme.alternate, height: 1),
            ),
            _RailItem(
              label: 'Wallet',
              icon: Icons.account_balance_wallet_outlined,
              theme: theme,
              onTap: () => context.pushNamed('walletPage'),
            ),
            _RailItem(
              label: 'Ask the Community',
              icon: Icons.forum_outlined,
              theme: theme,
              onTap: () => context.pushNamed('AskCommunity'),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _sellExpanded = !_sellExpanded),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.sell_outlined,
                        size: 18, color: theme.primaryText),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sell on Orija',
                        style:
                            theme.bodyMedium.override(color: theme.primaryText),
                      ),
                    ),
                    Icon(
                      _sellExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: theme.secondaryText,
                    ),
                  ],
                ),
              ),
            ),
            if (_sellExpanded) ...[
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: _RailItem(
                  label: 'Open Storefront',
                  icon: Icons.storefront_outlined,
                  theme: theme,
                  dense: true,
                  onTap: () => context.pushNamed('storefrontSetup'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: _RailItem(
                  label: 'Quick Sell',
                  icon: Icons.flash_on_outlined,
                  theme: theme,
                  dense: true,
                  onTap: () => context.pushNamed('SellPage'),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Divider(color: theme.alternate, height: 1),
            const SizedBox(height: 10),
            _RailItem(
              label: 'Orders',
              icon: Icons.receipt_long_outlined,
              theme: theme,
              onTap: () => context.pushNamed('OrijaMyOrdersPage'),
            ),
            _RailItem(
              label: 'My Bids',
              icon: Icons.gavel_outlined,
              theme: theme,
              onTap: () => context.pushNamed('myBids'),
            ),
            _RailItem(
              label: 'Saved Listings',
              icon: Icons.bookmark_border,
              theme: theme,
              onTap: () => context.pushNamed('SavedItems'),
            ),
            const Spacer(),
            Divider(color: theme.alternate, height: 1),
            const SizedBox(height: 8),
            _RailItem(
              label: 'Settings',
              icon: Icons.settings_outlined,
              theme: theme,
              onTap: () => context.pushNamed('SettingsMain'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.label,
    required this.icon,
    required this.theme,
    required this.onTap,
    this.dense = false,
  });

  final String label;
  final IconData icon;
  final FlutterFlowTheme theme;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: dense ? 6 : 10,
        ),
        child: Row(
          children: [
            Icon(icon, size: dense ? 16 : 18, color: theme.primaryText),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.bodyMedium.override(
                  color: theme.primaryText,
                  fontSize: dense ? 13 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
