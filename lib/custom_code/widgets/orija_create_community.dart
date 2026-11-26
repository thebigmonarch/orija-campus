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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_location_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';

/// Create-a-community form. Always creates `type = 'community'` -- the
/// backend function (`create_community`) hardcodes that type and has no
/// parameter to change it; Market and Institution communities are created
/// from the admin section instead, not from here.
///
/// Gated client-side on Oja Tier 5+ (the same gate the backend enforces) so
/// a below-tier user sees why before filling the whole form, not a generic
/// failure after.
///
/// Fields beyond what `create_community` accepts directly (icon, city,
/// state, public/private, tags) are written in a follow-up direct update
/// to the new row -- RLS already lets the creator (auto-added as head)
/// update their own community, so no new backend function was needed.
class OrijaCreateCommunity extends StatefulWidget {
  const OrijaCreateCommunity({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaCreateCommunity> createState() => _OrijaCreateCommunityState();
}

class _OrijaCreateCommunityState extends State<OrijaCreateCommunity> {
  final _supabase = Supabase.instance.client;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _city;
  String? _stateName;
  final _tagsCtrl = TextEditingController();
  final _rule1Ctrl = TextEditingController();
  final _rule2Ctrl = TextEditingController();
  final _rule3Ctrl = TextEditingController();

  List<CategoriesRow> _topCategories = [];
  List<CategoriesRow> _subOptions = [];
  String? _category;
  String? _categorySlug;
  final Set<String> _subcategories = {};
  bool _loadingSub = false;

  String? _coverUrl;
  String? _iconUrl;
  bool _uploadingCover = false;
  bool _uploadingIcon = false;
  bool _isPublic = true;

  bool _loadingGate = true;
  int? _ojaTier;
  double _annualFee = 5000;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    _rule1Ctrl.dispose();
    _rule2Ctrl.dispose();
    _rule3Ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _supabase
            .from('users')
            .select('oja_tier')
            .eq('id', currentUserUid)
            .maybeSingle(),
        _supabase
            .from('categories')
            .select('name, slug, parent_slug')
            .isFilter('parent_slug', null)
            .order('name'),
        _supabase
            .from('platform_config')
            .select('value')
            .eq('key', 'community_fee')
            .maybeSingle(),
      ]);
      final userRow = results[0] as Map<String, dynamic>?;
      final catRows = List<Map<String, dynamic>>.from(results[1] as List);
      final feeRow = results[2] as Map<String, dynamic>?;
      if (!mounted) return;
      setState(() {
        _ojaTier = (userRow?['oja_tier'] as num?)?.toInt();
        _topCategories = catRows.map((r) => CategoriesRow(r)).toList();
        final annual = (feeRow?['value'] as Map?)?['annual'];
        _annualFee = (annual as num?)?.toDouble() ?? 5000;
        _loadingGate = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingGate = false);
    }
  }

  Future<void> _onCategoryChanged(String? slug) async {
    CategoriesRow? cat;
    for (final c in _topCategories) {
      if (c.slug == slug) {
        cat = c;
        break;
      }
    }
    setState(() {
      _category = cat?.name;
      _categorySlug = slug;
      _subOptions = [];
      _subcategories.clear();
      _loadingSub = slug != null;
    });
    if (slug == null) return;
    try {
      final rows = await _supabase
          .from('categories')
          .select('name, slug, parent_slug')
          .eq('parent_slug', slug)
          .order('name');
      if (!mounted) return;
      setState(() {
        _subOptions = List<Map<String, dynamic>>.from(rows as List)
            .map((r) => CategoriesRow(r))
            .toList();
        _loadingSub = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingSub = false);
    }
  }

  Future<void> _pickImage({required bool isIcon}) async {
    final selected = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: isIcon ? 'communityIcon' : 'communityCover',
      allowPhoto: true,
    );
    if (selected == null || selected.isEmpty) return;
    setState(() {
      if (isIcon) {
        _uploadingIcon = true;
      } else {
        _uploadingCover = true;
      }
    });
    try {
      showUploadMessage(context, 'Uploading photo...', showLoading: true);
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'storefontmedia',
        selectedFiles: selected,
      );
      if (!mounted) return;
      if (urls.isNotEmpty) {
        setState(() {
          if (isIcon) {
            _iconUrl = urls.first;
          } else {
            _coverUrl = urls.first;
          }
        });
        showUploadMessage(context, 'Success!');
      } else {
        showUploadMessage(context, 'Failed to upload photo',
            showLoading: false);
      }
    } catch (_) {
      if (mounted) showUploadMessage(context, 'Failed to upload photo');
    } finally {
      if (mounted) {
        setState(() {
          if (isIcon) {
            _uploadingIcon = false;
          } else {
            _uploadingCover = false;
          }
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: error ? theme.error : theme.secondary));
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (_nameCtrl.text.trim().isEmpty) {
      _snack('Please enter a community name', error: true);
      return;
    }
    if (_category == null) {
      _snack('Please select a category', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      final res = await _supabase.rpc('create_community', params: {
        'p_user_id': currentUserUid,
        'p_name': _nameCtrl.text.trim(),
        'p_category': _category,
        'p_sub_categories': _subcategories.toList(),
        'p_description':
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'p_cover_url': _coverUrl,
        'p_rule1':
            _rule1Ctrl.text.trim().isEmpty ? null : _rule1Ctrl.text.trim(),
        'p_rule2':
            _rule2Ctrl.text.trim().isEmpty ? null : _rule2Ctrl.text.trim(),
        'p_rule3':
            _rule3Ctrl.text.trim().isEmpty ? null : _rule3Ctrl.text.trim(),
      });
      final ok = res is Map && res['success'] == true;
      if (!ok) {
        _snack(
            (res is Map ? res['message'] : null)?.toString() ??
                'Could not create this community.',
            error: true);
        return;
      }
      final communityId = res['community_id'] as String?;

      // Fields create_community doesn't accept yet: enrich the new row
      // directly (RLS lets the creator, now head, update their own
      // community).
      final extra = <String, dynamic>{};
      if ((_iconUrl ?? '').isNotEmpty) extra['icon_url'] = _iconUrl;
      if ((_city ?? '').isNotEmpty) extra['city'] = _city;
      if ((_stateName ?? '').isNotEmpty) extra['state'] = _stateName;
      if (!_isPublic) extra['is_public'] = false;
      final tags = _tagsCtrl.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      if (tags.isNotEmpty) extra['tags'] = tags;
      if (extra.isNotEmpty && communityId != null) {
        try {
          await _supabase
              .from('communities')
              .update(extra)
              .eq('id', communityId);
        } catch (_) {
          // Best effort -- the community itself was created successfully.
        }
      }

      if (!mounted) return;
      _snack((res['message'] as String?) ?? 'Community created.');
      if (communityId != null) {
        context.pushReplacementNamed('community',
            queryParameters: {'communityID': communityId});
      } else {
        context.pop();
      }
    } catch (_) {
      _snack('Could not create this community. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // --------------------------------------------------------------- pieces

  InputDecoration _decoration(FlutterFlowTheme t, String hint,
      {String? label}) {
    return InputDecoration(
      isDense: true,
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: t.secondaryText),
      hintStyle: TextStyle(color: t.secondaryText, fontSize: 13.5),
      filled: true,
      fillColor: t.secondaryBackground,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: t.alternate),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: t.secondary),
          borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    );
  }

  Widget _label(FlutterFlowTheme t, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 4),
        child: Text(text,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      );

  Widget _photoPicker(FlutterFlowTheme t,
      {required bool isIcon, required String? url, required bool uploading}) {
    return InkWell(
      borderRadius: BorderRadius.circular(isIcon ? 40 : 12),
      onTap: uploading ? null : () => _pickImage(isIcon: isIcon),
      child: Container(
        width: isIcon ? 80 : double.infinity,
        height: isIcon ? 80 : 140,
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          shape: isIcon ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isIcon ? null : BorderRadius.circular(12),
          border: Border.all(color: t.alternate),
          image: (url ?? '').isEmpty
              ? null
              : DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: uploading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: t.secondary))
            : (url ?? '').isEmpty
                ? Icon(Icons.add_a_photo_outlined,
                    color: t.secondaryText, size: isIcon ? 22 : 28)
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    if (_loadingGate) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }

    if ((_ojaTier ?? 0) < 5) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, color: t.secondaryText, size: 40),
            const SizedBox(height: 14),
            Text('Oja Tier 5 required',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
                'Creating a community needs Oja Tier 5. You are currently Tier ${_ojaTier ?? 0}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: t.secondaryText, fontSize: 13.5)),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => context.pushNamed('ojaRankTier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.secondary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
              child: const Text('View Oja Rank'),
            ),
          ],
        ),
      );
    }

    return Container(
      color: t.primaryBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(t, 'Community name'),
            TextFormField(
              controller: _nameCtrl,
              maxLength: 50,
              textCapitalization: TextCapitalization.sentences,
              buildCounter: (_,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              style: TextStyle(color: t.primaryText),
              decoration: _decoration(t, 'Enter community name'),
            ),
            _label(t, 'Category'),
            DropdownButtonFormField<String>(
              initialValue: _categorySlug,
              decoration: _decoration(t, 'Select category'),
              dropdownColor: t.secondaryBackground,
              style: TextStyle(color: t.primaryText, fontSize: 14),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: t.secondaryText),
              items: [
                for (final c in _topCategories)
                  DropdownMenuItem(value: c.slug, child: Text(c.name)),
              ],
              onChanged: _onCategoryChanged,
            ),
            if (_categorySlug != null) ...[
              _label(t, 'Sub-categories (optional)'),
              if (_loadingSub)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))),
                )
              else if (_subOptions.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in _subOptions)
                      FilterChip(
                        label: Text(s.name),
                        selected: _subcategories.contains(s.name),
                        onSelected: (sel) => setState(() {
                          if (sel) {
                            _subcategories.add(s.name);
                          } else {
                            _subcategories.remove(s.name);
                          }
                        }),
                        selectedColor: t.secondary.withValues(alpha: 0.18),
                        checkmarkColor: t.secondary,
                        backgroundColor: t.secondaryBackground,
                        side: BorderSide(color: t.alternate),
                        labelStyle: TextStyle(
                            color: _subcategories.contains(s.name)
                                ? t.secondary
                                : t.primaryText,
                            fontSize: 12.5),
                      ),
                  ],
                ),
            ],
            _label(t, 'About this community'),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: t.primaryText),
              decoration:
                  _decoration(t, 'Tell people what this community is about'),
            ),
            _label(t, 'Location (optional)'),
            OrijaLocationPicker(
              showStreet: false,
              onChanged: (v) => setState(() {
                _city = v.city;
                _stateName = v.stateName;
              }),
            ),
            _label(t, 'Tags (optional, comma-separated)'),
            TextFormField(
              controller: _tagsCtrl,
              style: TextStyle(color: t.primaryText),
              decoration: _decoration(t, 'fashion, lagos, thrift'),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text('Open to everyone',
                      style: TextStyle(
                          color: t.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600)),
                ),
                Switch(
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                  activeColor: t.secondary,
                ),
              ],
            ),
            Text(
                _isPublic
                    ? 'Anyone can find and join this community.'
                    : 'People will need to request to join.',
                style: TextStyle(color: t.secondaryText, fontSize: 11.5)),
            _label(t, 'Cover photo'),
            _photoPicker(t,
                isIcon: false, url: _coverUrl, uploading: _uploadingCover),
            const SizedBox(height: 14),
            Row(
              children: [
                _photoPicker(t,
                    isIcon: true, url: _iconUrl, uploading: _uploadingIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Icon / logo',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('Shown on cards and in member lists.',
                          style: TextStyle(
                              color: t.secondaryText, fontSize: 11.5)),
                    ],
                  ),
                ),
              ],
            ),
            _label(t, 'Rules & regulations'),
            TextFormField(
              controller: _rule1Ctrl,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: t.primaryText),
              decoration: _decoration(t, 'Rule 1'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _rule2Ctrl,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: t.primaryText),
              decoration: _decoration(t, 'Rule 2'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _rule3Ctrl,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: t.primaryText),
              decoration: _decoration(t, 'Rule 3'),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: t.secondary, width: 3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outlined, color: t.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        '₦${_annualFee.toStringAsFixed(0)}/year community fee -- payment is requested after your community is created.',
                        style: TextStyle(
                            color: t.primaryText, fontSize: 12.5, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('Create & Pay ₦${_annualFee.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
