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

/// Edit an existing community's own details. Head-only: enforced client-side
/// here (a non-head sees a blocked state) and by the database's own
/// `comm_head_update` RLS policy (`auth.uid() = head_user_id`), which is
/// what actually stops a write either way -- there is no new backend
/// function for this; saves go straight to the `communities` row.
///
/// Deliberately NOT editable here: type (locked to how it was created --
/// Market/Institution come from the admin section), slug (would break
/// existing links), status, verification, fees/subscription, and
/// member/vendor counts -- all system- or admin-managed.
class OrijaEditCommunity extends StatefulWidget {
  const OrijaEditCommunity(
      {super.key, this.width, this.height, this.communityId});

  final double? width;
  final double? height;
  final String? communityId;

  @override
  State<OrijaEditCommunity> createState() => _OrijaEditCommunityState();
}

class _OrijaEditCommunityState extends State<OrijaEditCommunity> {
  final _supabase = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  bool _isHead = false;
  Map<String, dynamic> _community = {};

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
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
  String? _initialCity;
  String? _initialState;
  String? _city;
  String? _stateName;

  bool _saving = false;

  String get _id => widget.communityId ?? '';

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
    if (_id.isEmpty) {
      setState(() {
        _error = 'No community selected.';
        _loading = false;
      });
      return;
    }
    try {
      final row = await _supabase
          .from('communities')
          .select()
          .eq('id', _id)
          .maybeSingle();
      if (row == null) {
        if (mounted) {
          setState(() {
            _error = 'Community not found.';
            _loading = false;
          });
        }
        return;
      }
      final isHead = row['head_user_id'] == currentUserUid;
      final topRows = await _supabase
          .from('categories')
          .select('name, slug, parent_slug')
          .isFilter('parent_slug', null)
          .order('name');

      if (!mounted) return;
      _community = row;
      _nameCtrl.text = '${row['name'] ?? ''}';
      _descCtrl.text = '${row['description'] ?? ''}';
      _rule1Ctrl.text = '${row['rules'] ?? ''}';
      _rule2Ctrl.text = '${row['Rule2'] ?? ''}';
      _rule3Ctrl.text = '${row['Rule3'] ?? ''}';
      _tagsCtrl.text = ((row['tags'] as List?) ?? const []).join(', ');
      _coverUrl = row['cover_url'] as String?;
      _iconUrl = row['icon_url'] as String?;
      _isPublic = row['is_public'] != false;
      _initialCity = row['city'] as String?;
      _initialState = row['state'] as String?;
      _city = _initialCity;
      _stateName = _initialState;
      _category = row['category'] as String?;
      _subcategories
        ..clear()
        ..addAll(
            ((row['sub_categories'] as List?) ?? const []).map((e) => '$e'));

      _topCategories = List<Map<String, dynamic>>.from(topRows as List)
          .map((r) => CategoriesRow(r))
          .toList();
      String? matchedSlug;
      for (final c in _topCategories) {
        // `communities.category` stores the category slug.
        if (c.slug == _category || c.name == _category) {
          matchedSlug = c.slug;
          break;
        }
      }
      _categorySlug = matchedSlug;

      setState(() {
        _isHead = isHead;
        _loading = false;
      });

      if (_categorySlug != null) await _loadSubOptions(_categorySlug!);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load this community.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadSubOptions(String slug) async {
    setState(() => _loadingSub = true);
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

  Future<void> _onCategoryChanged(String? slug) async {
    CategoriesRow? cat;
    for (final c in _topCategories) {
      if (c.slug == slug) {
        cat = c;
        break;
      }
    }
    setState(() {
      // Save the slug: communities.category is a foreign key to categories.slug.
      _category = cat?.slug;
      _categorySlug = slug;
      _subOptions = [];
      _subcategories.clear();
    });
    if (slug != null) await _loadSubOptions(slug);
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
        showUploadMessage(context, 'Failed to upload photo');
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

  Future<void> _save() async {
    if (_saving || !_isHead) return;
    if (_nameCtrl.text.trim().isEmpty) {
      _snack('Please enter a community name', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final tags = _tagsCtrl.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      await _supabase.from('communities').update({
        'name': _nameCtrl.text.trim(),
        'description':
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'category': _category,
        'sub_categories': _subcategories.toList(),
        'cover_url': _coverUrl,
        'icon_url': _iconUrl,
        'city': _city,
        'state': _stateName,
        'is_public': _isPublic,
        'tags': tags,
        'rules': _rule1Ctrl.text.trim().isEmpty ? null : _rule1Ctrl.text.trim(),
        'Rule2': _rule2Ctrl.text.trim().isEmpty ? null : _rule2Ctrl.text.trim(),
        'Rule3': _rule3Ctrl.text.trim().isEmpty ? null : _rule3Ctrl.text.trim(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', _id);
      if (!mounted) return;
      _snack('Community updated.');
      context.pop(true);
    } catch (_) {
      _snack('Could not save your changes. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // --------------------------------------------------------------- pieces

  InputDecoration _decoration(FlutterFlowTheme t, String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
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
    // Desktop Shell rollout, Phase 8 (Pattern D bulk pass). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
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
    final t = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: t.primaryBackground,
      appBar: AppBar(
        backgroundColor: t.secondaryBackground,
        elevation: 1,
        iconTheme: IconThemeData(color: t.primaryText),
        title: Text('Edit community',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: t.secondary))
          : (_error != null)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!,
                        style: TextStyle(color: t.secondaryText, fontSize: 14)),
                  ),
                )
              : !_isHead
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline_rounded,
                                color: t.secondaryText, size: 36),
                            const SizedBox(height: 12),
                            Text('Only the community head can edit this.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: t.primaryText, fontSize: 14.5)),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
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
                            decoration: _decoration(t, 'Community name'),
                          ),
                          _label(t, 'Category'),
                          DropdownButtonFormField<String>(
                            initialValue: _categorySlug,
                            decoration: _decoration(t, 'Select category'),
                            dropdownColor: t.secondaryBackground,
                            style:
                                TextStyle(color: t.primaryText, fontSize: 14),
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: t.secondaryText),
                            items: [
                              for (final c in _topCategories)
                                DropdownMenuItem(
                                    value: c.slug, child: Text(c.name)),
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
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))),
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
                                      selectedColor:
                                          t.secondary.withValues(alpha: 0.18),
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
                            decoration: _decoration(
                                t, 'Tell people what this community is about'),
                          ),
                          _label(t, 'Location (optional)'),
                          OrijaLocationPicker(
                            showStreet: false,
                            initialState: _initialState,
                            initialCity: _initialCity,
                            onChanged: (v) => setState(() {
                              _city = v.city;
                              _stateName = v.stateName;
                            }),
                          ),
                          _label(t, 'Tags (optional, comma-separated)'),
                          TextFormField(
                            controller: _tagsCtrl,
                            style: TextStyle(color: t.primaryText),
                            decoration:
                                _decoration(t, 'fashion, lagos, thrift'),
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
                          _label(t, 'Cover photo'),
                          _photoPicker(t,
                              isIcon: false,
                              url: _coverUrl,
                              uploading: _uploadingCover),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _photoPicker(t,
                                  isIcon: true,
                                  url: _iconUrl,
                                  uploading: _uploadingIcon),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Icon / logo',
                                    style: TextStyle(
                                        color: t.primaryText,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700)),
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
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: t.secondary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Text('Save changes',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
    );
  }
}
