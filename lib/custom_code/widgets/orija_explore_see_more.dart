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
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Full listing for one Explore rail. `section` selects which one:
/// 'forYou' | 'rising' | 'communities' | 'declutter'. Mirrors the query each
/// rail on Explore already runs, just without the 10-item cap.
class OrijaExploreSeeMore extends StatefulWidget {
  const OrijaExploreSeeMore(
      {super.key, this.width, this.height, required this.section});

  final double? width;
  final double? height;
  // FlutterFlow page-level string params are always nullable, so the
  // generated page shell passes `widget!.section` (String?) into here --
  // declaring this non-nullable broke the web build with a type error.
  final String? section;

  @override
  State<OrijaExploreSeeMore> createState() => _OrijaExploreSeeMoreState();
}

class _OrijaExploreSeeMoreState extends State<OrijaExploreSeeMore> {
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];
  Map<String, List<String>> _communityAvatars = {};
  String? _myCity;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supabase = Supabase.instance.client;
    try {
      switch (widget.section) {
        case 'forYou':
          final interests = await supabase
              .from('user_interests')
              .select('category')
              .eq('user_id', currentUserUid);
          final categories = List<Map<String, dynamic>>.from(interests as List)
              .map((r) => r['category'] as String?)
              .whereType<String>()
              .toSet()
              .toList();
          var q = supabase
              .from('listings')
              .select(
                  'id, title, price, primary_image_url, photos, storefronts!listings_storefront_id_fkey(name, logo_url, slug)')
              .eq('is_available', true);
          if (categories.isNotEmpty) q = q.inFilter('category', categories);
          final rows = await q.order('created_at', ascending: false).limit(60);
          _items = List<Map<String, dynamic>>.from(rows as List);
          break;

        case 'rising':
          final me = await supabase
              .from('users')
              .select('state, city')
              .eq('id', currentUserUid)
              .maybeSingle();
          _myCity = me?['city'] as String?;
          var q = supabase.from('storefronts_with_review_summary').select(
              'id, slug, name, logo_url, cover_url, category, city, state, avg_rating, is_verified');
          if (me?['state'] != null) q = q.eq('state', me!['state'] as String);
          final rows = await q.order('created_at', ascending: false).limit(60);
          _items = List<Map<String, dynamic>>.from(rows as List);
          break;

        case 'communities':
          final interests = await supabase
              .from('user_interests')
              .select('category')
              .eq('user_id', currentUserUid);
          final categories = List<Map<String, dynamic>>.from(interests as List)
              .map((r) => r['category'] as String?)
              .whereType<String>()
              .toSet()
              .toList();
          final joined = await supabase
              .from('community_members')
              .select('community_id')
              .eq('user_id', currentUserUid);
          final joinedIds = List<Map<String, dynamic>>.from(joined as List)
              .map((r) => r['community_id'] as String?)
              .whereType<String>()
              .toList();
          var q = supabase
              .from('communities')
              .select('id, name, cover_url, category, member_count')
              .eq('is_active', true);
          if (categories.isNotEmpty) q = q.inFilter('category', categories);
          final raw = await q.order('member_count', ascending: false).limit(60);
          _items = List<Map<String, dynamic>>.from(raw as List)
              .where((c) => !joinedIds.contains(c['id']))
              .toList();

          final communityIds = _items.map((c) => c['id'] as String).toList();
          final avatars = <String, List<String>>{};
          if (communityIds.isNotEmpty) {
            final memberRows = await supabase
                .from('community_members')
                .select(
                    'community_id, users!community_members_user_id_fkey(avatar_url)')
                .inFilter('community_id', communityIds)
                .limit(180);
            for (final r
                in List<Map<String, dynamic>>.from(memberRows as List)) {
              final cid = r['community_id'] as String?;
              final avatar = (r['users'] as Map?)?['avatar_url'] as String?;
              if (cid == null) continue;
              final list = avatars.putIfAbsent(cid, () => []);
              if (avatar != null && avatar.isNotEmpty && list.length < 3)
                list.add(avatar);
            }
          }
          _communityAvatars = avatars;
          break;

        case 'declutter':
          final rows = await supabase
              .from('declutter_submissions')
              .select('id, title, asking_price, photos, category')
              .eq('status', 'listed')
              .order('submitted_at', ascending: false)
              .limit(60);
          _items = List<Map<String, dynamic>>.from(rows as List);
          break;
      }
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _title() {
    switch (widget.section) {
      case 'forYou':
        return 'For You';
      case 'rising':
        return 'Rising in your market';
      case 'communities':
        return "Communities you'd vibe with";
      case 'declutter':
        return 'Declutter finds';
      default:
        return 'Explore';
    }
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

  String _titleCase(String s) {
    return s
        .replaceAll(RegExp(r'[-_]+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
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
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(_title(),
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _items.isEmpty
                ? Center(
                    child: Text('Nothing here yet.',
                        style: TextStyle(color: theme.secondaryText)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, i) => _buildCard(theme, _items[i]),
                  ),
      ),
    );
  }

  Widget _buildCard(FlutterFlowTheme theme, Map<String, dynamic> item) {
    switch (widget.section) {
      case 'forYou':
        final store = (item['storefronts'] as Map?) ?? {};
        final photos = List<String>.from(item['photos'] as List? ?? []);
        final img = item['primary_image_url'] as String? ??
            (photos.isNotEmpty ? photos.first : null);
        return InkWell(
          onTap: () => context.pushNamed('listingdetailPage',
              queryParameters: {'listingId': '${item['id']}'}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    color: theme.alternate,
                    child: (img ?? '').isEmpty
                        ? Icon(Icons.image_outlined, color: theme.secondaryText)
                        : Image.network(img!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(item['title'] as String? ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.primaryText, fontSize: 12)),
              Text(_naira(item['price'] as num?),
                  style: TextStyle(
                      color: theme.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700)),
              Text(store['name'] as String? ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.secondaryText, fontSize: 10.5)),
            ],
          ),
        );

      case 'declutter':
        final photos = List<String>.from(item['photos'] as List? ?? []);
        final img = photos.isNotEmpty ? photos.first : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  color: theme.alternate,
                  child: (img ?? '').isEmpty
                      ? Icon(Icons.image_outlined, color: theme.secondaryText)
                      : Image.network(img!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(item['title'] as String? ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.primaryText, fontSize: 12)),
            Text(_naira(item['asking_price'] as num?),
                style: TextStyle(
                    color: theme.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
          ],
        );

      case 'rising':
        final img = (item['cover_url'] as String?)?.isNotEmpty == true
            ? item['cover_url'] as String?
            : item['logo_url'] as String?;
        final rating = (item['avg_rating'] as num?)?.toDouble();
        final nearYou =
            _myCity != null && _myCity!.isNotEmpty && item['city'] == _myCity;
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.pushNamed('storefrontPage',
              queryParameters: {'storefontslug': '${item['slug']}'}),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.primary.withValues(alpha: 0.22)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                (img ?? '').isEmpty
                    ? Container(color: theme.alternate)
                    : Image.network(img!, fit: BoxFit.cover),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.35, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.82)
                        ],
                      ),
                    ),
                  ),
                ),
                if (nearYou)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Near you',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 5,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: (item['logo_url'] as String? ?? '').isEmpty
                            ? Container(
                                color: theme.alternate,
                                alignment: Alignment.center,
                                child: Icon(Icons.storefront_outlined,
                                    size: 16, color: theme.secondaryText),
                              )
                            : Image.network(item['logo_url'] as String,
                                fit: BoxFit.cover),
                      ),
                      if (item['is_verified'] == true)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(Icons.verified_rounded,
                                size: 12, color: theme.secondary),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['name'] as String? ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (rating != null && rating > 0) ...[
                            Icon(Icons.star_rounded,
                                size: 12, color: const Color(0xFFFFC94D)),
                            const SizedBox(width: 2),
                            Text(rating.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10)),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(item['city'] as String? ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'communities':
      default:
        final avatars = _communityAvatars[item['id']] ?? const <String>[];
        final category = (item['category'] as String?) ?? '';
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.pushNamed('community',
              queryParameters: {'communityID': '${item['id']}'}),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: theme.secondary.withValues(alpha: 0.24)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                (item['cover_url'] as String? ?? '').isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [theme.secondary, theme.primary],
                          ),
                        ),
                      )
                    : Image.network(item['cover_url'] as String,
                        fit: BoxFit.cover),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.80)
                        ],
                      ),
                    ),
                  ),
                ),
                if (category.isNotEmpty)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_titleCase(category),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['name'] as String? ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (avatars.isNotEmpty) ...[
                            SizedBox(
                              width: 16.0 + (avatars.length - 1) * 10.0,
                              height: 18,
                              child: Stack(
                                children: [
                                  for (var j = 0; j < avatars.length; j++)
                                    Positioned(
                                      left: j * 10.0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1.3),
                                          image: DecorationImage(
                                              image: NetworkImage(avatars[j]),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text('${item['member_count'] ?? 0} members',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
