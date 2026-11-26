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
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_post_card.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Street Post -- same look as before (back arrow, "Street Post", a Post
/// button, the big "What's happening in your store?" area, "Tag communities"
/// chips, and a photo / video toolbar at the bottom), rebuilt underneath:
///
///  * Media goes straight to Cloudinary the moment it's added, signed by the
///    existing cloudinary-sign function into orija/posts/<you>/..., with a
///    progress ring on each tile. Nothing touches Supabase Storage any more.
///    Removing a tile (or leaving without posting) deletes what was uploaded.
///  * Tapping a finished tile (photo OR video) opens the full
///    AdvancedMediaEditorWidgetV2 editor (crop/rotate, filters, brightness/
///    contrast/saturation, video trim/speed) -- always seeded from the
///    original picked bytes, never a previously-edited URL, so repeated
///    edits never stack on top of each other. Each edit session holds
///    exactly one item, so the editor's multi-clip merge/segments feature
///    (which needs several source clips in one session) is never reachable
///    here -- that's a deliberate scope limit, not an oversight, since
///    Cloudinary can't render a multi-segment timeline from a single
///    transformation string. Export re-uploads through
///    exportEditedMediaToCloudinary, which now actually applies crop/
///    filter/adjust/trim via a real Cloudinary transformation.
///  * Drag tiles to reorder (the first is the cover).
///  * Photos or a video are optional -- text alone is a valid post. Tagging
///    communities is optional too. (The old page refused to post without
///    both.)
///  * "Posting as" picker: any of your storefronts, or your own profile.
///  * Posting goes through the create-post function with your own id.
///  * Leaving with unsaved work asks first.
class OrijaCreatePost extends StatefulWidget {
  const OrijaCreatePost({super.key, this.width, this.height, this.storeId});

  final double? width;
  final double? height;
  final String? storeId;

  @override
  State<OrijaCreatePost> createState() => _OrijaCreatePostState();
}

enum _MediaState { uploading, done, failed }

class _MediaItem {
  _MediaItem(
      {required this.id,
      required this.name,
      required this.bytes,
      required this.isVideo});

  final int id;
  String name;
  Uint8List bytes;
  final bool isVideo;
  _MediaState state = _MediaState.uploading;
  String? url;
}

class _OrijaCreatePostState extends State<OrijaCreatePost> {
  static const _maxItems = 10;
  static const _maxVideoMb = 60;
  static const _maxChars = 2000;

  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  final List<_MediaItem> _media = [];
  int _nextId = 0;

  List<Map<String, dynamic>> _stores = [];
  Map<String, dynamic>? _store;
  List<Map<String, dynamic>> _communities = [];
  final Set<String> _tagged = {};
  bool _ready = false;
  bool _posting = false;
  bool _posted = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    if (!_posted)
      _cleanupUploads(_media.map((m) => m.url).whereType<String>().toList());
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final supabase = Supabase.instance.client;
      final stores = await supabase
          .from('storefronts')
          .select('id, name, logo_url, category')
          .eq('owner_id', currentUserUid)
          .eq('is_active', true)
          .order('created_at');
      _stores = List<Map<String, dynamic>>.from(stores as List);
      final want = widget.storeId;
      _store = _stores.isEmpty
          ? null
          : _stores.firstWhere((s) => s['id'] == want,
              orElse: () => _stores.first);

      final members = await supabase
          .from('community_members')
          .select('community_id')
          .eq('user_id', currentUserUid);
      final ids = List<Map<String, dynamic>>.from(members as List)
          .map((m) => m['community_id'] as String)
          .toList();
      if (ids.isNotEmpty) {
        final rows = await supabase
            .from('communities')
            .select('id, name')
            .inFilter('id', ids)
            .eq('is_active', true)
            .order('name');
        _communities = List<Map<String, dynamic>>.from(rows as List);
      }
    } catch (_) {}
    if (mounted) setState(() => _ready = true);
  }

  // -------------------------------------------------------------- media

  bool get _uploading => _media.any((m) => m.state == _MediaState.uploading);
  bool get _hasContent => _text.text.trim().isNotEmpty || _media.isNotEmpty;
  bool get _canPost =>
      !_posting &&
      !_uploading &&
      _ready &&
      _stores.isNotEmpty &&
      (_text.text.trim().isNotEmpty ||
          _media.any((m) => m.state == _MediaState.done)) &&
      !_media.any((m) => m.state == _MediaState.failed);

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickImages() async {
    if (_media.length >= _maxItems)
      return _toast('You can add up to $_maxItems items.');
    final res = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true, withData: true);
    if (res == null) return;
    final added = <_MediaItem>[];
    for (final f in res.files) {
      if (_media.length >= _maxItems) {
        _toast('Only the first $_maxItems items were added.');
        break;
      }
      final bytes = f.bytes;
      if (bytes == null || bytes.isEmpty) continue;
      final item =
          _MediaItem(id: _nextId++, name: f.name, bytes: bytes, isVideo: false);
      setState(() => _media.add(item));
      added.add(item);
    }
    await _uploadThenAutoEdit(added);
  }

  Future<void> _pickVideo() async {
    if (_media.any((m) => m.isVideo)) return _toast('One video per post.');
    if (_media.length >= _maxItems)
      return _toast('You can add up to $_maxItems items.');
    final res = await FilePicker.platform
        .pickFiles(type: FileType.video, withData: true);
    final f = res?.files.firstOrNull;
    final bytes = f?.bytes;
    if (f == null || bytes == null || bytes.isEmpty) return;
    if (bytes.length > _maxVideoMb * 1024 * 1024) {
      return _toast(
          'That video is over $_maxVideoMb MB. Trim it or pick a shorter one.');
    }
    final item =
        _MediaItem(id: _nextId++, name: f.name, bytes: bytes, isVideo: true);
    setState(() => _media.add(item));
    await _uploadThenAutoEdit([item]);
  }

  /// Uploads every newly-picked item, then opens ONE rich-editor session
  /// covering all of them -- editing is the default right after picking.
  /// The editor's own Queue lets the user move between multiple items in
  /// that one session, instead of a separate full-screen editor popping up
  /// per photo. Cancelling just leaves every item's already-uploaded,
  /// unedited version in place -- no extra prompt needed.
  Future<void> _uploadThenAutoEdit(List<_MediaItem> items) async {
    await Future.wait(items.map(_upload));
    final ready = items
        .where(
            (i) => mounted && _media.contains(i) && i.state == _MediaState.done)
        .toList();
    if (ready.isEmpty) return;
    await _editBatch(ready);
  }

  Future<void> _upload(_MediaItem item) async {
    setState(() => item.state = _MediaState.uploading);
    try {
      final res = await pickUploadCloudinaryMedia(
        [FFUploadedFile(name: item.name, bytes: item.bytes)],
        null,
        false,
        'post_media',
        1600,
        84,
        _maxVideoMb,
      );
      final urls = List<String>.from((res as Map)['mediaUrls'] as List? ?? []);
      if (urls.isEmpty) throw Exception('no url');
      if (!mounted || !_media.contains(item)) {
        _cleanupUploads(urls);
        return;
      }
      setState(() {
        item.url = urls.first;
        item.state = _MediaState.done;
      });
    } catch (_) {
      if (mounted && _media.contains(item)) {
        setState(() => item.state = _MediaState.failed);
      }
    }
  }

  /// Best-effort delete of orphaned Cloudinary uploads (function only lets
  /// you delete your own assets).
  void _cleanupUploads(List<String> urls) {
    if (urls.isEmpty) return;
    Supabase.instance.client.functions.invoke('cloudinary-delete',
        body: {'urls': urls}).then((_) {}, onError: (_) {});
  }

  void _remove(_MediaItem item) {
    setState(() => _media.remove(item));
    if (item.url != null) _cleanupUploads([item.url!]);
  }

  /// Tap-to-edit a single already-uploaded tile later -- thin wrapper
  /// around [_editBatch] so there's one implementation of the editor
  /// plumbing, single- or multi-item.
  Future<void> _edit(_MediaItem item) => _editBatch([item]);

  /// Opens ONE rich-editor session covering every item in [items] at once
  /// (the editor's own Queue tab lets the user move between them) --
  /// always from each item's ORIGINAL picked bytes, never the
  /// already-uploaded URL, so a second edit pass never stacks a new
  /// transformation on top of an earlier one. On export, each item's
  /// previous uploaded asset is cleaned up and replaced with its freshly
  /// exported counterpart, matched back by order.
  Future<void> _editBatch(List<_MediaItem> items) async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute<List<String>>(
        fullscreenDialog: true,
        builder: (sheetContext) => Scaffold(
          backgroundColor: Colors.black,
          body: AdvancedMediaEditorWidgetV2(
            // Pass the already-uploaded URLs, not raw bytes: with
            // uploadedFiles the editor builds each item with url: '' (pure
            // local bytes), which toExportPlan() then carries through as an
            // empty url -- exportEditedMediaToCloudinary silently skips any
            // plan item with no url, so finalCloudinaryUrls came back empty
            // and the `urls.length == items.length` check below never
            // passed, leaving Done stuck with no error and no navigation.
            mediaUrls: items.map((i) => i.url!).toList(),
            mediaTypes:
                items.map((i) => i.isVideo ? 'video' : 'image').toList(),
            uploadContext: 'post_media',
            maxImageSide: 1600,
            imageQuality: 84,
            maxVideoMb: _maxVideoMb,
            onExport: (editPlan, quality) async {
              try {
                final exported = await exportEditedMediaToCloudinary(
                    editPlan, null, null, 'post_media', quality);
                final urls = List<String>.from(
                    (exported as Map)['finalCloudinaryUrls'] as List? ?? []);
                if (urls.length == items.length) {
                  Navigator.of(sheetContext).pop(urls);
                } else {
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Could not save the edit. Try again.')));
                }
              } catch (e) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                    SnackBar(content: Text('Could not save the edit. $e')));
              }
            },
            onClose: () async {
              Navigator.of(sheetContext).pop();
            },
          ),
        ),
      ),
    );
    if (result == null || !mounted) return;
    for (var i = 0; i < items.length && i < result.length; i++) {
      final item = items[i];
      if (!_media.contains(item)) continue;
      final oldUrl = item.url;
      final newUrl = result[i];
      setState(() {
        item.url = newUrl;
        item.state = _MediaState.done;
      });
      if (oldUrl != null && oldUrl != newUrl) _cleanupUploads([oldUrl]);
    }
  }

  // ------------------------------------------------------------ posting

  Future<void> _post() async {
    if (!_canPost) return;
    setState(() => _posting = true);
    try {
      final res =
          await Supabase.instance.client.functions.invoke('create-post', body: {
        'p_author_id': currentUserUid,
        'p_type': 'standard',
        'p_content': _text.text.trim(),
        'p_media_urls':
            _media.where((m) => m.url != null).map((m) => m.url).toList(),
        'p_storefront_id': _store?['id'],
        'p_community_ids': _tagged.toList(),
      });
      final data = res.data;
      final ok = data is Map && data['success'] == true;
      if (!mounted) return;
      if (!ok) {
        final msg = data is Map ? (data['message'] ?? data['error']) : null;
        setState(() => _posting = false);
        return _toast('${msg ?? 'Could not post. Please try again.'}');
      }
      _posted = true;
      OrijaPostEvents.notifyChanged();
      _toast('Posted');
      if (context.canPop()) {
        context.pop();
      } else {
        context.goNamed('HomePage');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _posting = false);
      _toast('Could not post. Please try again.');
    }
  }

  Future<void> _back() async {
    if (_hasContent && !_posted) {
      final leave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Discard this post?'),
          content:
              const Text('What you\'ve written and uploaded will be lost.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Keep editing')),
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('Discard',
                    style: TextStyle(
                        color: FlutterFlowTheme.of(dialogContext).error))),
          ],
        ),
      );
      if (leave != true) return;
    }
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('HomePage');
    }
  }

  Future<void> _pickIdentity() async {
    final theme = FlutterFlowTheme.of(context);
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text('Post as',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            for (final s in _stores)
              ListTile(
                leading: _avatar(
                    theme, s['logo_url'] as String?, Icons.storefront_outlined),
                title: Text(s['name'] as String? ?? '',
                    style: TextStyle(color: theme.primaryText)),
                subtitle: Text('Storefront',
                    style: TextStyle(color: theme.secondaryText, fontSize: 12)),
                trailing: _store?['id'] == s['id']
                    ? Icon(Icons.check_circle, color: theme.primary)
                    : null,
                onTap: () => Navigator.pop(sheetContext, s['id'] as String),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() => _store = _stores.firstWhere((s) => s['id'] == picked));
  }

  Widget _avatar(FlutterFlowTheme theme, String? url, IconData fallback,
      {double r = 16}) {
    return CircleAvatar(
      radius: r,
      backgroundColor: theme.alternate,
      backgroundImage: (url ?? '').isNotEmpty ? NetworkImage(url!) : null,
      child: (url ?? '').isEmpty
          ? Icon(fallback, size: r, color: theme.secondaryText)
          : null,
    );
  }

  // ----------------------------------------------------------------- UI

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
    final theme = FlutterFlowTheme.of(context);
    if (_ready && _stores.isEmpty) {
      return Container(
        color: theme.primaryBackground,
        child: Column(
          children: [
            _topBarPlain(theme),
            Expanded(child: _noStoreState(theme)),
          ],
        ),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Container(
        color: theme.primaryBackground,
        child: Column(
          children: [
            _topBar(theme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _identityRow(theme),
                    const SizedBox(height: 8),
                    Text('Bring your Oja to the Street',
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 180),
                      child: TextField(
                        controller: _text,
                        focusNode: _focus,
                        maxLines: null,
                        maxLength: _maxChars,
                        buildCounter: (_,
                                {required currentLength,
                                required isFocused,
                                maxLength}) =>
                            currentLength > _maxChars - 200
                                ? Text('$currentLength/$maxLength',
                                    style: TextStyle(
                                        color: theme.secondaryText,
                                        fontSize: 11))
                                : null,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 16,
                            height: 1.4),
                        decoration: InputDecoration(
                          hintText: 'What\'s happening in your store?',
                          hintStyle: TextStyle(
                              color: theme.secondaryText, fontSize: 16),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_media.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _tray(theme),
                    ],
                  ],
                ),
              ),
            ),
            _bottom(theme),
          ],
        ),
      ),
    );
  }

  Widget _topBar(FlutterFlowTheme theme) {
    return Container(
      color: theme.secondaryBackground,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
                onPressed: _back,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Street Post',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _canPost ? _post : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          theme.primary.withValues(alpha: 0.4),
                      disabledForegroundColor: Colors.white70,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _posting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(_uploading ? 'Uploading…' : 'Post',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top bar for the no-storefront state -- just back + title, no Post
  /// button since there is nothing to post as.
  Widget _topBarPlain(FlutterFlowTheme theme) {
    return Container(
      color: theme.secondaryBackground,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.goNamed('HomePage'),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Street Post',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Posts belong to a storefront -- this isn't a personal feed. A user with
  /// no store yet is sent to create one instead of posting without context.
  Widget _noStoreState(FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined,
                size: 56, color: theme.secondaryText),
            const SizedBox(height: 16),
            Text('Create a storefront to post',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Posts advertise what a storefront is selling, so you need one before you can post.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.secondaryText, fontSize: 13.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushNamed('SellPage'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Create storefront',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identityRow(FlutterFlowTheme theme) {
    final name = _store?['name'] as String? ?? 'Select a store';
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _ready && _stores.isNotEmpty ? _pickIdentity : null,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _avatar(theme, _store?['logo_url'] as String?,
                Icons.storefront_outlined,
                r: 13),
            const SizedBox(width: 8),
            Flexible(
              child: Text('Posting as $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
            ),
            if (_stores.isNotEmpty) ...[
              const SizedBox(width: 4),
              Icon(Icons.expand_more_rounded,
                  size: 18, color: theme.secondaryText),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tray(FlutterFlowTheme theme) {
    return SizedBox(
      height: 112,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: true,
        itemCount: _media.length,
        onReorder: (from, to) {
          setState(() {
            if (to > from) to -= 1;
            _media.insert(to, _media.removeAt(from));
          });
        },
        proxyDecorator: (child, _, __) =>
            Material(color: Colors.transparent, child: child),
        itemBuilder: (context, i) {
          final m = _media[i];
          return Padding(
            key: ValueKey(m.id),
            padding: const EdgeInsets.only(right: 10),
            child: _tile(theme, m, cover: i == 0),
          );
        },
      ),
    );
  }

  Widget _tile(FlutterFlowTheme theme, _MediaItem m, {required bool cover}) {
    return GestureDetector(
      onTap: m.state == _MediaState.done ? () => _edit(m) : null,
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: m.isVideo
                  ? Container(
                      color: theme.secondaryBackground,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_creation_outlined,
                              color: theme.secondary, size: 30),
                          const SizedBox(height: 6),
                          Text(m.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 10)),
                          Text(
                              '${(m.bytes.length / 1048576).toStringAsFixed(1)} MB',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 10)),
                        ],
                      ),
                    )
                  : Image.memory(m.bytes, fit: BoxFit.cover),
            ),
            if (m.state == _MediaState.uploading)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                      child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white))),
                ),
              ),
            if (m.state == _MediaState.failed)
              GestureDetector(
                onTap: () => _upload(m),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: const Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, color: Colors.white),
                        Text('Retry',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    )),
                  ),
                ),
              ),
            if (cover)
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Cover',
                      style: TextStyle(color: Colors.white, fontSize: 9.5)),
                ),
              ),
            if (m.state == _MediaState.done)
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.tune_rounded,
                      color: Colors.white, size: 13),
                ),
              ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () => _remove(m),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottom(FlutterFlowTheme theme) {
    return Container(
      color: theme.primaryBackground,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_communities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tag communities',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final c in _communities) _communityChip(theme, c),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                border: Border(top: BorderSide(color: theme.alternate)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Add photos',
                    icon: Icon(Icons.add_photo_alternate_outlined,
                        color: theme.secondary, size: 30),
                    onPressed: _pickImages,
                  ),
                  IconButton(
                    tooltip: 'Add a video',
                    icon: Icon(Icons.video_library_outlined,
                        color: theme.secondary, size: 28),
                    onPressed: _pickVideo,
                  ),
                  const Spacer(),
                  if (_media.isNotEmpty)
                    Text('${_media.length}/$_maxItems',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _communityChip(FlutterFlowTheme theme, Map<String, dynamic> c) {
    final id = c['id'] as String;
    final on = _tagged.contains(id);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => setState(() => on ? _tagged.remove(id) : _tagged.add(id)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: on
              ? theme.primary.withValues(alpha: 0.18)
              : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: on ? theme.primary : Colors.transparent),
        ),
        child: Text(c['name'] as String? ?? '',
            style: TextStyle(
                color: on ? theme.primary : theme.secondaryText,
                fontSize: 14.5,
                fontWeight: on ? FontWeight.w600 : FontWeight.w400)),
      ),
    );
  }
}
