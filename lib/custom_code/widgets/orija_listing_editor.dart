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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';

/// Create and edit a listing, in one widget.
///
/// Replaces the separate `createlisting_page` and `editlisting_page`, which
/// duplicated every field between them and drifted apart.
///
/// Two things are deliberately different from the pages it replaces:
///
/// 1. **Photos go straight to Cloudinary.** The old create path uploaded to
///    Supabase Storage, then the `create-listing` edge function downloaded
///    each file, re-uploaded it to Cloudinary and deleted the original — a
///    round trip through storage we pay for twice and that fails in the
///    middle often enough to need `migration_warnings`. Here the client gets
///    a signature from `cloudinary-sign` and POSTs the bytes directly.
///    `create-listing` already passes non-Storage URLs through untouched, so
///    its migration step simply becomes a no-op.
///
/// 2. **Parcel size is a band, not a number.** The old form asked for
///    "Weight (KG)" and 27 of 34 goods listings left it empty, so courier
///    quotes fell back to a hardcoded 0.5 kg and were fiction. A band with a
///    concrete example gets answered; `delivery_size_bands` converts it to
///    the kg Terminal wants. An exact weight can still be given and wins
///    over the band, matching `listing_ship_weight_kg()`.
class OrijaListingEditor extends StatefulWidget {
  const OrijaListingEditor({
    super.key,
    this.width,
    this.height,
    required this.listingId,
    required this.storefrontId,
  });

  final double? width;
  final double? height;

  /// Empty or null means "create". Anything else loads that listing to edit.
  final String? listingId;

  /// Required when creating; ignored when editing (taken from the listing).
  final String? storefrontId;

  @override
  State<OrijaListingEditor> createState() => _OrijaListingEditorState();
}

class _OrijaListingEditorState extends State<OrijaListingEditor> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  String get _listingId => widget.listingId ?? '';
  bool get _isEdit => _listingId.isNotEmpty;

  bool _loading = true;
  String? _loadError;
  bool _saving = false;
  String? _saveError;

  // ── Form state ────────────────────────────────────────────────────────
  String _type = 'goods';
  String _serviceMode = 'at_vendor';
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _startingPrice = TextEditingController();
  final _stock = TextEditingController();
  final _turnaround = TextEditingController();
  final _youtube = TextEditingController();
  final _exactWeight = TextEditingController();

  String _pricingType = 'fixed';
  String _condition = 'new';
  bool _isNegotiable = false;
  bool _isFragile = false;
  bool _isDigital =
      false; // delivered by download/link; skips fulfilment at checkout
  bool _isMadeToOrder =
      false; // goods only: made/sourced after the order, not kept in stock
  String _returnPolicyTier = ''; // '' = inherit the storefront's default

  /// Inherited from the storefront, never chosen here. A vendor listing
  /// outside their own store's category is what this prevents.
  String? _categorySlug;
  String? _categoryName;

  String? _subcategorySlug;
  String? _sizeBand;

  List<String> _photos = [];
  // Photos uploaded during THIS editing session (not pre-existing ones
  // loaded for an edit) -- these are the only ones we ever delete from
  // Cloudinary on remove/abandon, so an edit that doesn't touch an
  // existing photo never risks orphaning it.
  final Set<String> _newlyUploaded = {};
  // Maps a currently-displayed photo URL back to the ORIGINAL upload before
  // any edits, so re-opening the rich editor always starts from the
  // pristine source instead of stacking a new transformation on top of an
  // earlier one.
  final Map<String, String> _originalUrlFor = {};
  bool _saved = false;
  bool _uploading = false;

  String _storefrontId = '';
  String? _storefrontSlug;

  // ── Reference data ────────────────────────────────────────────────────
  /// Only the subcategories belonging to this store's category, sorted A–Z.
  List<Map<String, dynamic>> _subcategories = [];
  List<Map<String, dynamic>> _bands = [];

  // ── Category / subcategory specifications ───────────────────────────
  // Driven by category_attribute_defs: once a category (and then a
  // subcategory) is picked, its extra fields render here and save into
  // listings.attributes. Not hardcoded per category -- adding a new
  // category's fields is a data change, not a code change.
  List<Map<String, dynamic>> _categoryAttrDefs = []; // subcategory_slug IS NULL
  List<Map<String, dynamic>> _subcategoryAttrDefs = [];
  Map<String, dynamic> _attrValues = {};
  bool _attrDefsLoading = false;
  final Map<String, TextEditingController> _attrTextControllers = {};

  List<Map<String, dynamic>> get _activeAttrDefs =>
      [..._categoryAttrDefs, ..._subcategoryAttrDefs];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    // Abandoned without saving: anything uploaded this session that never
    // made it into a saved listing is an orphan on Cloudinary. Pre-existing
    // photos (loaded for an edit) are never touched here.
    if (!_saved && _newlyUploaded.isNotEmpty) {
      _cleanupUploads(_newlyUploaded.toList());
    }
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _startingPrice.dispose();
    _stock.dispose();
    _turnaround.dispose();
    _youtube.dispose();
    _exactWeight.dispose();
    for (final c in _attrTextControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Best-effort, fire-and-forget delete of Cloudinary assets this session
  /// uploaded but no longer needs (same pattern as orija_create_post.dart).
  void _cleanupUploads(List<String> urls) {
    if (urls.isEmpty) return;
    Supabase.instance.client.functions.invoke('cloudinary-delete',
        body: {'urls': urls}).then((_) {}, onError: (_) {});
  }

  // ── Load ──────────────────────────────────────────────────────────────

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final bands = await _supabase
          .from('delivery_size_bands')
          .select('code, label, example, weight_kg, sort_order')
          .order('sort_order', ascending: true);
      _bands = List<Map<String, dynamic>>.from(bands);

      _storefrontId = widget.storefrontId ?? '';

      if (_isEdit) {
        final row = await _supabase
            .from('listings')
            .select()
            .eq('id', _listingId)
            .maybeSingle();

        if (row == null) {
          setState(() {
            _loading = false;
            _loadError = 'This listing could not be found.';
          });
          return;
        }

        final l = Map<String, dynamic>.from(row);
        _storefrontId = '${l['storefront_id'] ?? ''}';
        _type = '${l['type'] ?? 'goods'}';
        _title.text = '${l['title'] ?? ''}';
        _description.text = '${l['description'] ?? ''}';
        _price.text = l['price'] == null ? '' : '${l['price']}';
        _startingPrice.text =
            l['starting_price'] == null ? '' : '${l['starting_price']}';
        _stock.text =
            l['stock_quantity'] == null ? '' : '${l['stock_quantity']}';
        _turnaround.text =
            l['turnaround_hours'] == null ? '' : '${l['turnaround_hours']}';
        _youtube.text = '${l['youtube_url'] ?? ''}';
        _exactWeight.text = l['weight_kg'] == null ? '' : '${l['weight_kg']}';
        _pricingType = '${l['pricing_type'] ?? 'fixed'}';
        _condition = '${l['condition'] ?? 'new'}';
        _isNegotiable = l['is_negotiable'] == true;
        _serviceMode = '${l['service_mode'] ?? 'at_vendor'}';
        _isFragile = l['is_fragile'] == true;
        _isDigital = l['is_digital'] == true;
        _isMadeToOrder = l['is_made_to_order'] == true;
        _returnPolicyTier = '${l['return_policy_tier'] ?? ''}';
        // category deliberately NOT read from the listing — the store's
        // current category is the source of truth, so a listing that predates
        // a category change is corrected on next save rather than preserved.
        _subcategorySlug = l['subcategory'] as String?;
        _sizeBand = l['size_band'] as String?;
        _attrValues = l['attributes'] is Map
            ? Map<String, dynamic>.from(l['attributes'] as Map)
            : {};
        _photos = (l['photos'] as List?)?.map((p) => '$p').toList() ?? [];
      }

      if (_storefrontId.isEmpty) {
        setState(() {
          _loading = false;
          _loadError = 'No storefront was supplied for this listing.';
        });
        return;
      }

      // The store's own category decides what can be listed under it. Read
      // after the edit branch, because that is where storefront_id comes from
      // when editing an existing listing.
      final store = await _supabase
          .from('storefronts')
          .select('category, slug')
          .eq('id', _storefrontId)
          .maybeSingle();

      _categorySlug = store == null ? null : store['category'] as String?;
      _storefrontSlug = store == null ? null : store['slug'] as String?;

      if (_categorySlug != null && _categorySlug!.isNotEmpty) {
        final cat = await _supabase
            .from('categories')
            .select('name')
            .eq('slug', _categorySlug!)
            .maybeSingle();
        _categoryName = cat == null ? null : cat['name'] as String?;

        // Ordered by name so the picker is A–Z, not by an internal sort_order
        // nobody outside the data can predict.
        final subs = await _supabase
            .from('subcategories')
            .select('slug, name, category_slug')
            .eq('is_active', true)
            .eq('category_slug', _categorySlug!)
            .order('name', ascending: true);

        _subcategories = List<Map<String, dynamic>>.from(subs);

        final catDefs = await _supabase
            .from('category_attribute_defs')
            .select()
            .eq('category_slug', _categorySlug!)
            .filter('subcategory_slug', 'is', null)
            .order('sort_order', ascending: true);
        _categoryAttrDefs = List<Map<String, dynamic>>.from(catDefs);

        if ((_subcategorySlug ?? '').isNotEmpty) {
          await _loadSubcategoryAttrDefs(_subcategorySlug!);
        }
      }

      if (!mounted) return;
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Could not load the form. $e';
      });
    }
  }

  /// Loads (and caches per-widget-lifetime) the extra fields for one
  /// subcategory, then rebuilds their text controllers from [_attrValues].
  Future<void> _loadSubcategoryAttrDefs(String subcategorySlug) async {
    setState(() => _attrDefsLoading = true);
    try {
      final rows = await _supabase
          .from('category_attribute_defs')
          .select()
          .eq('category_slug', _categorySlug ?? '')
          .eq('subcategory_slug', subcategorySlug)
          .order('sort_order', ascending: true);
      if (!mounted) return;
      setState(() {
        _subcategoryAttrDefs = List<Map<String, dynamic>>.from(rows);
        _attrDefsLoading = false;
      });
      _syncAttrTextControllers();
    } catch (_) {
      if (mounted) setState(() => _attrDefsLoading = false);
    }
  }

  void _syncAttrTextControllers() {
    for (final d in _activeAttrDefs) {
      final key = '${d['field_key']}';
      final type = '${d['field_type']}';
      if (type != 'text' && type != 'textarea' && type != 'number') continue;
      _attrTextControllers.putIfAbsent(key, () => TextEditingController());
      final v = _attrValues[key];
      _attrTextControllers[key]!.text = v == null ? '' : '${v}';
    }
  }

  /// Everything the active fields hold, trimmed of anything for a field that
  /// no longer applies (subcategory changed). Text/number fields read from
  /// their controller; the rest were written straight into [_attrValues].
  Map<String, dynamic> _collectAttrValues() {
    final out = <String, dynamic>{};
    for (final d in _activeAttrDefs) {
      final key = '${d['field_key']}';
      final type = '${d['field_type']}';
      dynamic v;
      if (type == 'text' || type == 'textarea') {
        v = _attrTextControllers[key]?.text.trim();
        if (v == '') v = null;
      } else if (type == 'number') {
        v = num.tryParse((_attrTextControllers[key]?.text ?? '').trim());
      } else {
        v = _attrValues[key];
      }
      if (v != null) out[key] = v;
      if ((type == 'dropdown' || type == 'choice_chip') && v == 'other') {
        final otherKey = '${key}_other';
        final otherText = _attrTextControllers[otherKey]?.text.trim();
        if (otherText != null && otherText.isNotEmpty)
          out[otherKey] = otherText;
      }
    }
    return out;
  }

  // ── Photos: direct to Cloudinary ──────────────────────────────────────
  //
  // Uploads go through the same shared action Create Post uses
  // (pickUploadCloudinaryMedia), instead of a private reimplementation --
  // this gets client-side resize and the standard q_auto,f_auto
  // transformation for free, and keeps the sign+upload dance in one place.

  Future<void> _addPhotos() async {
    if (_photos.length >= 4) return;

    setState(() => _saveError = null);

    // The picker itself can throw (permission denial, a platform channel
    // error, etc.) -- it used to sit outside this try/catch, so a picker
    // failure was an uncaught exception instead of the usual error banner,
    // which looked like nothing happened at all.
    try {
      final selected = await selectMedia(
        mediaSource: MediaSource.photoGallery,
        multiImage: true,
        imageQuality: 85,
      );
      if (selected == null || selected.isEmpty) return;

      setState(() => _uploading = true);

      final room = 4 - _photos.length;
      // Upload everything first, then open ONE editor session covering all
      // of them -- the editor's own Queue tab lets the user move between
      // multiple photos in that one session, instead of a separate
      // full-screen editor popping up per photo.
      final uploaded = <(SelectedFile, String)>[];
      for (final file in selected.take(room)) {
        try {
          final res = await pickUploadCloudinaryMedia(
            [
              FFUploadedFile(
                name: file.originalFilename.isNotEmpty
                    ? file.originalFilename
                    : 'listing.jpg',
                bytes: file.bytes,
              )
            ],
            null,
            false,
            'listing',
            1600,
            85,
            0,
          );
          final urls =
              List<String>.from((res as Map)['mediaUrls'] as List? ?? []);
          if (urls.isEmpty) throw Exception('no url');
          final url = urls.first;
          if (!mounted) {
            _cleanupUploads([url]);
            return;
          }
          setState(() {
            _photos = [..._photos, url];
            _newlyUploaded.add(url);
            _originalUrlFor[url] = url;
          });
          uploaded.add((file, url));
        } catch (e) {
          if (mounted) {
            setState(() => _saveError = 'Photo upload failed. $e');
          }
        }
      }
      if (uploaded.isNotEmpty && mounted) {
        await _editPhotosBatch(uploaded);
      }
    } catch (e) {
      if (mounted) setState(() => _saveError = 'Photo upload failed. $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  /// Opens ONE rich-editor session covering every just-uploaded photo in
  /// [uploaded] at once -- always from each photo's ORIGINAL picked bytes
  /// (still in hand from the picker), never the already-uploaded URL, so
  /// repeated edits never stack. Matches each result back to the photo by
  /// its current (pre-edit) URL.
  Future<void> _editPhotosBatch(List<(SelectedFile, String)> uploaded) async {
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
            // and the `urls.length == uploaded.length` check below never
            // passed, leaving Done stuck with no error and no navigation.
            mediaUrls: uploaded.map((p) => p.$2).toList(),
            uploadContext: 'listing',
            maxImageSide: 1600,
            imageQuality: 85,
            maxVideoMb: 0,
            onExport: (editPlan, quality) async {
              try {
                final exported = await exportEditedMediaToCloudinary(
                    editPlan, null, null, 'listing', quality);
                final urls = List<String>.from(
                    (exported as Map)['finalCloudinaryUrls'] as List? ?? []);
                if (urls.length == uploaded.length) {
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
    for (var i = 0; i < uploaded.length && i < result.length; i++) {
      final oldUrl = uploaded[i].$2;
      final newUrl = result[i];
      final index = _photos.indexOf(oldUrl);
      if (index == -1) continue;
      setState(() {
        final next = [..._photos];
        next[index] = newUrl;
        _photos = next;
      });
      _originalUrlFor.remove(oldUrl);
      _originalUrlFor[newUrl] = oldUrl;
      if (_newlyUploaded.remove(oldUrl)) {
        _newlyUploaded.add(newUrl);
        _cleanupUploads([oldUrl]);
      }
    }
  }

  void _removePhoto(int index) {
    final url = _photos[index];
    setState(() {
      final next = [..._photos];
      next.removeAt(index);
      _photos = next;
    });
    _originalUrlFor.remove(url);
    // Only delete assets this session uploaded -- a pre-existing photo
    // (loaded for an edit) stays untouched on Cloudinary until a save
    // actually drops it from the listing.
    if (_newlyUploaded.remove(url)) {
      _cleanupUploads([url]);
    }
  }

  /// Opens the rich editor (crop/filters/adjust) on this photo, always
  /// starting from its ORIGINAL upload (never an already-edited URL), so
  /// a second edit pass never stacks a new transformation on top of an
  /// earlier one.
  Future<void> _editPhoto(int index) async {
    final currentUrl = _photos[index];
    final sourceUrl = _originalUrlFor[currentUrl] ?? currentUrl;
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        fullscreenDialog: true,
        builder: (sheetContext) => Scaffold(
          backgroundColor: Colors.black,
          body: AdvancedMediaEditorWidgetV2(
            mediaUrls: [sourceUrl],
            mediaTypes: const ['image'],
            uploadContext: 'listing',
            maxImageSide: 1600,
            imageQuality: 85,
            maxVideoMb: 0,
            onExport: (editPlan, quality) async {
              try {
                final exported = await exportEditedMediaToCloudinary(
                    editPlan, null, null, 'listing', quality);
                final urls = List<String>.from(
                    (exported as Map)['finalCloudinaryUrls'] as List? ?? []);
                if (urls.isNotEmpty) {
                  Navigator.of(sheetContext).pop(urls.first);
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
    final newUrl = result;
    setState(() {
      final next = [..._photos];
      next[index] = newUrl;
      _photos = next;
    });
    _originalUrlFor[newUrl] = sourceUrl;
    if (_newlyUploaded.remove(currentUrl)) {
      _cleanupUploads([currentUrl]);
    }
    _newlyUploaded.add(newUrl);
  }

  // ── Save ──────────────────────────────────────────────────────────────

  /// For the create path: `create_listing` declares every parameter as text
  /// and normalises internally, so the raw string is what it wants.
  String? _numOrNull(TextEditingController c) {
    final t = _digitsAndDot(c.text);
    return t.isEmpty ? null : t;
  }

  /// For the edit path: this writes straight to `listings`, where these are
  /// numeric columns, so send real numbers rather than relying on PostgREST
  /// to coerce a string. Unparseable input becomes null instead of throwing.
  num? _numValue(TextEditingController c) {
    final t = _digitsAndDot(c.text);
    if (t.isEmpty) return null;
    return num.tryParse(t);
  }

  String _digitsAndDot(String raw) {
    final t = raw.trim().replaceAll(RegExp(r'[^0-9.]'), '');
    return t.isEmpty || t == '.' ? '' : t;
  }

  int? _intValue(TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  /// Shown just before popping. ScaffoldMessenger sits above this route, so
  /// the bar survives the pop and lands on the screen the vendor returns to.
  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// The 11-character video id from any normal YouTube link (watch?v=,
  /// youtu.be/, /shorts/, /embed/, /live/, m.youtube.com), or null.
  String? _youtubeId(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    final uri = Uri.tryParse(t.startsWith('http') ? t : 'https://$t');
    if (uri == null) return null;
    final host =
        uri.host.toLowerCase().replaceFirst('www.', '').replaceFirst('m.', '');
    String? id;
    if (host == 'youtu.be') {
      id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else if (host == 'youtube.com' || host == 'youtube-nocookie.com') {
      if (uri.path == '/watch') {
        id = uri.queryParameters['v'];
      } else if (uri.pathSegments.length >= 2 &&
          const {'shorts', 'embed', 'live', 'v'}
              .contains(uri.pathSegments.first)) {
        id = uri.pathSegments[1];
      }
    }
    return (id != null && RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id))
        ? id
        : null;
  }

  /// The link as saved: always the canonical watch URL, or '' when empty.
  String _youtubeUrl() {
    final id = _youtubeId(_youtube.text);
    return id == null ? '' : 'https://www.youtube.com/watch?v=$id';
  }

  /// Where a service is delivered (at the seller's place, the buyer's, or
  /// remotely). Saved separately because the listing RPCs predate it; a failure
  /// here never blocks the listing itself.
  Future<void> _saveServiceMode(String id) async {
    if (_type != 'services' || id.isEmpty) return;
    try {
      await _supabase.rpc('set_listing_service_mode',
          params: {'p_listing_id': id, 'p_mode': _serviceMode});
    } catch (_) {}
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_youtube.text.trim().isNotEmpty && _youtubeId(_youtube.text) == null) {
      setState(() => _saveError =
          'That doesn\'t look like a YouTube link. Paste the link from YouTube\'s Share button, or clear the Video box.');
      return;
    }

    if (_storefrontId.isEmpty) {
      setState(
          () => _saveError = 'No storefront was supplied for this listing.');
      return;
    }

    setState(() {
      _saving = true;
      _saveError = null;
    });

    try {
      if (_isEdit) {
        final res = await _supabase.rpc('update_listing', params: {
          'p_listing_id': _listingId,
          'p_title': _title.text.trim(),
          'p_type': _type,
          'p_description': _description.text.trim(),
          'p_category': _categorySlug,
          'p_subcategory': _subcategorySlug,
          'p_price': _numOrNull(_price),
          'p_starting_price': _numOrNull(_startingPrice),
          'p_pricing_type': _pricingType,
          'p_condition': _condition,
          'p_stock_quantity': _type == 'services' ? null : _numOrNull(_stock),
          'p_is_negotiable': _isNegotiable ? 'true' : 'false',
          'p_primary_image_url': _photos.isNotEmpty ? _photos.first : null,
          'p_photos': jsonEncode(_photos),
          'p_youtube_url': _youtubeUrl(),
          'p_turnaround_hours': _numOrNull(_turnaround),
          'p_weight_kg': _numOrNull(_exactWeight),
          'p_is_fragile': _isFragile ? 'true' : 'false',
          'p_size_band': _sizeBand,
          'p_is_made_to_order': _isMadeToOrder ? 'true' : 'false',
          'p_return_policy_tier':
              _returnPolicyTier.isEmpty ? null : _returnPolicyTier,
        });

        final ok = res is Map && res['success'] == true;
        if (ok) {
          // update_listing has no attributes param yet, so this is a second,
          // narrow write the owner is already allowed (RLS: listings_owner).
          await _supabase.from('listings').update({
            'attributes': _collectAttrValues(),
            'is_digital': _isDigital,
          }).eq('id', _listingId);
        }
        if (!mounted) return;
        if (!ok) {
          final code = res is Map ? '${res['error'] ?? ''}' : '';
          setState(() {
            _saving = false;
            _saveError =
                code.isNotEmpty ? code : 'Could not update this listing.';
          });
          return;
        }

        await _saveServiceMode(_listingId);
        _toast('Listing updated');
        _saved = true;
        Navigator.of(context).pop(true);
        return;
      }

      // Create goes through the edge function, which enforces the listing
      // limit via the RPC. Photos are already Cloudinary URLs, so its
      // Storage-migration step is a no-op.
      final res = await _supabase.functions.invoke(
        'create-listing',
        body: {
          'p_storefront_id': _storefrontId,
          'p_title': _title.text.trim(),
          'p_type': _type,
          'p_description': _description.text.trim(),
          'p_category': _categorySlug,
          'p_subcategory': _subcategorySlug,
          'p_price': _numOrNull(_price),
          'p_starting_price': _numOrNull(_startingPrice),
          'p_pricing_type': _pricingType,
          'p_condition': _condition,
          'p_currency': 'NGN',
          'p_stock_quantity': _type == 'services' ? null : _numOrNull(_stock),
          'p_is_negotiable': _isNegotiable ? 'true' : 'false',
          'p_primary_image_url': _photos.isNotEmpty ? _photos.first : null,
          'p_photos': jsonEncode(_photos),
          'p_youtube_url': _youtubeUrl(),
          'p_turnaround_hours': _numOrNull(_turnaround),
          'p_weight_kg': _numOrNull(_exactWeight),
          'p_is_fragile': _isFragile ? 'true' : 'false',
          'p_size_band': _sizeBand,
          'p_is_made_to_order': _isMadeToOrder ? 'true' : 'false',
          'p_return_policy_tier':
              _returnPolicyTier.isEmpty ? null : _returnPolicyTier,
        },
      );

      final data = res.data;
      final ok = data is Map && data['success'] == true;

      if (ok) {
        final newId = data['listing_id'] ?? data['id'];
        if (newId != null) {
          await _supabase.from('listings').update({
            'attributes': _collectAttrValues(),
            'is_digital': _isDigital,
          }).eq('id', newId);
        }
      }

      if (!mounted) return;

      if (!ok) {
        final code = data is Map ? '${data['error'] ?? ''}' : '';
        setState(() {
          _saving = false;
          _saveError = code == 'LISTING_LIMIT_REACHED'
              ? (data as Map)['message']?.toString() ??
                  'You have reached your listing limit.'
              : code.isNotEmpty
                  ? code
                  : 'Could not create this listing.';
        });
        return;
      }

      final newListingId = '${(data as Map)['listing_id'] ?? ''}';
      await _saveServiceMode(newListingId);
      _toast('Listing created successfully');
      _saved = true;
      // Go straight to the new listing instead of just popping back to
      // wherever Create Listing was opened from. Replace this screen with
      // the storefront (not push it) so Back from the listing lands on
      // the storefront, not back on the create form.
      if (newListingId.isNotEmpty &&
          _storefrontSlug != null &&
          _storefrontSlug!.isNotEmpty) {
        context.pushReplacementNamed('storefrontPage',
            queryParameters: {'storefontslug': _storefrontSlug!});
        context.pushNamed('listingdetailPage',
            queryParameters: {'listingId': newListingId});
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Could not save. $e';
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────

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

    if (_loading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    if (_loadError != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: theme.primaryBackground,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            _loadError!,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.primaryText, fontSize: 14),
          ),
        ),
      );
    }

    final isGoods = _type == 'goods';

    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The host page (createlisting_page_widget.dart) already has
              // its own AppBar titled "Create listing"/"Edit listing" --
              // this repeated it as a second heading right below it.
              if (_saveError != null) ...[
                _errorBanner(theme, _saveError!),
                const SizedBox(height: 12),
              ],
              _sectionLabel(
                  theme, 'Photos', 'Up to 4. The first is the cover.'),
              const SizedBox(height: 8),
              // A plain bool spinner tucked into the small add-photo tile is
              // easy to miss, especially once the strip already has photos
              // and the add tile sits scrolled to one side. This banner
              // sits right under the section label -- always in view --
              // so upload progress is unmistakable.
              if (_uploading) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: theme.primary),
                    ),
                    const SizedBox(width: 8),
                    Text('Uploading photo…',
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              _photoStrip(theme),
              const SizedBox(height: 20),
              _sectionLabel(theme, 'What are you listing?', null),
              const SizedBox(height: 8),
              _typeToggle(theme),
              const SizedBox(height: 20),
              _field(theme, _title, 'Listing title'),
              _field(theme, _description, 'Description',
                  required: false, maxLines: 4),
              _categoryPickers(theme),
              _specificationsSection(theme),
              const SizedBox(height: 4),
              _sectionLabel(theme, 'Pricing', null),
              const SizedBox(height: 8),
              // The pricing_type enum is fixed | negotiable. This dropdown used
              // to offer "Auction", which the database rejects, so saving a
              // listing set to it failed.
              _dropdown(
                theme,
                label: 'Pricing type',
                value: _pricingType == 'negotiable' ? 'negotiable' : 'fixed',
                items: const {
                  'fixed': 'Fixed price',
                  'negotiable': 'Negotiable',
                },
                onChanged: (v) => setState(() {
                  _pricingType = v ?? 'fixed';
                  if (_pricingType == 'negotiable') _isNegotiable = true;
                }),
              ),
              _field(theme, _price, 'Price (₦)',
                  keyboardType: TextInputType.number),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _isNegotiable,
                onChanged: (v) => setState(() => _isNegotiable = v),
                activeThumbColor: theme.secondary,
                title: Text('Open to offers',
                    style: TextStyle(color: theme.primaryText, fontSize: 13.5)),
                subtitle: Text(
                  'Buyers can propose a different price in their bag.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
                ),
              ),
              const SizedBox(height: 4),
              _sectionLabel(theme, 'Return policy',
                  'Leave on storefront default unless this item needs its own rule.'),
              const SizedBox(height: 8),
              _dropdown(
                theme,
                label: 'Return policy',
                value: _returnPolicyTier,
                items: const {
                  '': 'Storefront default',
                  'none': 'No returns',
                  'standard': '7-day returns',
                  'extended': '14-day returns',
                },
                onChanged: (v) => setState(() => _returnPolicyTier = v ?? ''),
              ),
              if (isGoods) ...[
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _isDigital,
                  onChanged: (v) => setState(() => _isDigital = v),
                  activeThumbColor: theme.secondary,
                  title: Text('This is a digital product',
                      style:
                          TextStyle(color: theme.primaryText, fontSize: 13.5)),
                  subtitle: Text(
                    'Delivered by download or link -- checkout skips shipping and pickup.',
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 11.5),
                  ),
                ),
                if (!_isDigital)
                  _dropdown(
                    theme,
                    label: 'Condition',
                    value: _condition,
                    items: const {
                      'new': 'New',
                      'used': 'Used',
                      'refurbished': 'Refurbished',
                    },
                    onChanged: (v) => setState(() => _condition = v ?? 'new'),
                  ),
                _field(theme, _stock, 'Stock quantity',
                    keyboardType: TextInputType.number, required: false),
                if (!_isDigital) ...[
                  const SizedBox(height: 12),
                  _deliverySection(theme),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _isMadeToOrder,
                    onChanged: (v) => setState(() => _isMadeToOrder = v),
                    activeThumbColor: theme.secondary,
                    title: Text('Made to order',
                        style: TextStyle(
                            color: theme.primaryText, fontSize: 13.5)),
                    subtitle: Text(
                      'Not kept in stock -- you make or source it after the order comes in.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11.5),
                    ),
                  ),
                  if (_isMadeToOrder)
                    _field(
                        theme, _turnaround, 'Typical time to make it (hours)',
                        keyboardType: TextInputType.number, required: false),
                ],
              ] else ...[
                const SizedBox(height: 8),
                _field(theme, _turnaround, 'Turnaround time (hours)',
                    keyboardType: TextInputType.number, required: false),
                _dropdown(
                  theme,
                  label: 'How is it delivered?',
                  value: const ['remote', 'at_vendor', 'at_buyer']
                          .contains(_serviceMode)
                      ? _serviceMode
                      : 'at_vendor',
                  items: const {
                    'at_vendor': 'At my place',
                    'at_buyer': 'At the buyer’s place',
                    'remote': 'Remotely / online',
                  },
                  onChanged: (v) =>
                      setState(() => _serviceMode = v ?? 'at_vendor'),
                ),
              ],
              _videoSection(theme),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_saving || _uploading) ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: theme.alternate,
                    disabledForegroundColor: theme.secondaryText,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    _saving
                        ? 'Saving…'
                        : _uploading
                            ? 'Waiting for photos…'
                            : (_isEdit ? 'Save changes' : 'Add listing'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Pieces ────────────────────────────────────────────────────────────

  Widget _videoSection(FlutterFlowTheme theme) {
    final raw = _youtube.text.trim();
    final id = _youtubeId(raw);
    final invalid = raw.isNotEmpty && id == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _sectionLabel(theme, 'Video (optional)',
            'Show your product or service in action with a YouTube link.'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _youtube,
          keyboardType: TextInputType.url,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: theme.primaryText, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Paste a YouTube link',
            hintStyle: TextStyle(color: theme.secondaryText, fontSize: 14),
            prefixIcon: Icon(Icons.play_circle_outline_rounded,
                color: theme.secondaryText),
            suffixIcon: raw.isEmpty
                ? null
                : IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.secondaryText),
                    onPressed: () => setState(_youtube.clear),
                  ),
            filled: true,
            fillColor: theme.secondaryBackground,
            isDense: true,
            errorText: invalid
                ? 'That doesn\'t look like a YouTube link. Use the link from YouTube\'s Share button.'
                : null,
            errorMaxLines: 2,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.alternate)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.alternate)),
          ),
        ),
        if (id != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network('https://img.youtube.com/vi/$id/hqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: theme.alternate,
                          alignment: Alignment.center,
                          child: Text(
                              'Preview unavailable. The link may be private.',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 12)))),
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 34),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, size: 15, color: theme.success),
              const SizedBox(width: 6),
              Text('Buyers will see this video on your listing.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
            ],
          ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _showYoutubeGuide,
            icon: const Icon(Icons.help_outline_rounded, size: 18),
            label: const Text('How do I upload a video to YouTube?'),
            style: TextButton.styleFrom(
                foregroundColor: theme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 2)),
          ),
        ),
      ],
    );
  }

  void _showYoutubeGuide() {
    final theme = FlutterFlowTheme.of(context);
    Widget step(int n, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: theme.primary),
                child: Text('$n',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(body,
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 12.5,
                            height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            Text('Add a video to your listing',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
                'Videos are hosted on YouTube, so they load fast and cost you no storage. It takes about five minutes.',
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 12.5, height: 1.4)),
            const SizedBox(height: 18),
            step(1, 'Record your video',
                'Hold your phone sideways. 30 to 90 seconds is plenty: show the item from a few angles, mention the price and what\'s included, and say how to reach you.'),
            step(2, 'Open YouTube and sign in',
                'Use the YouTube app on your phone, or go to studio.youtube.com on a computer. You need a Google account. Create a free channel if it asks.'),
            step(3, 'Upload it',
                'Phone: tap the + button, then "Upload a video", and pick your video. Computer: click the camera "Create" button, then "Upload videos", and choose the file.'),
            step(4, 'Give it a title and choose "Unlisted"',
                'Title it with your product name. When asked about kids, choose "No, it\'s not made for kids". For visibility choose Unlisted: only people with the link can watch, which is perfect. Public also works. Do not choose Private, because buyers won\'t be able to play it.'),
            step(5, 'Wait for it to finish, then copy the link',
                'Tap Upload or Publish and wait until processing completes. Open the video, tap Share, then Copy link. It looks like youtu.be/AbC123xyz_0.'),
            step(6, 'Paste it here',
                'Come back to this screen, paste the link into the Video box, and you\'ll see a preview. Save the listing and buyers will see the video on it.'),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.alternate)),
              child: Text(
                  'Tip: you can change or remove the video any time by editing the listing. If you delete the video on YouTube, remove the link here too.',
                  style: TextStyle(
                      color: theme.secondaryText, fontSize: 12, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner(FlutterFlowTheme theme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.error.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: theme.primaryText, fontSize: 12.5, height: 1.4),
      ),
    );
  }

  Widget _sectionLabel(FlutterFlowTheme theme, String title, String? hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (hint != null)
          Text(hint,
              style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
      ],
    );
  }

  Widget _photoStrip(FlutterFlowTheme theme) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _photos.length + (_photos.length < 4 ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i >= _photos.length) {
            return InkWell(
              onTap: _uploading ? null : _addPhotos,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 92,
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.alternate),
                ),
                child: Center(
                  child: _uploading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: theme.secondary),
                        )
                      : Icon(Icons.add_a_photo_outlined,
                          color: theme.secondaryText, size: 22),
                ),
              ),
            );
          }

          return Stack(
            children: [
              GestureDetector(
                onTap: () => _editPhoto(i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _photos[i],
                    width: 92,
                    height: 92,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 92,
                      height: 92,
                      color: theme.alternate,
                      child: Icon(Icons.broken_image_outlined,
                          color: theme.secondaryText, size: 20),
                    ),
                  ),
                ),
              ),
              if (i == 0)
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Cover',
                        style: TextStyle(color: Colors.white, fontSize: 9)),
                  ),
                ),
              Positioned(
                right: 2,
                top: 2,
                child: InkWell(
                  onTap: () => _removePhoto(i),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _typeToggle(FlutterFlowTheme theme) {
    Widget chip(String value, String label, IconData icon) {
      final active = _type == value;
      return Expanded(
        child: InkWell(
          onTap: () => setState(() => _type = value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active
                  ? theme.secondary.withValues(alpha: 0.12)
                  : theme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active ? theme.secondary : theme.alternate,
                width: active ? 1.8 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 16,
                    color: active ? theme.secondary : theme.secondaryText),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: active ? theme.primaryText : theme.secondaryText,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('goods', 'Goods', Icons.inventory_2_outlined),
        const SizedBox(width: 10),
        chip('services', 'Services', Icons.handyman_outlined),
      ],
    );
  }

  /// Subcategory only — the category is inherited from the storefront and is
  /// shown read-only. Letting a vendor pick any category meant listings could
  /// land outside their own store's category entirely.
  /// One field per row, its shape driven by [d]['field_type']. Values for
  /// non-text types write straight into [_attrValues]; text/number types
  /// stay in their controller until save (see [_collectAttrValues]).
  Widget _specField(FlutterFlowTheme theme, Map<String, dynamic> d) {
    final key = '${d['field_key']}';
    final label = '${d['label'] ?? key}';
    final type = '${d['field_type']}';
    final required = d['required'] == true;
    final unit = d['unit'] as String?;
    final options = (d['options'] as List?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        const <Map<String, dynamic>>[];
    final fullLabel = required ? '$label *' : label;

    switch (type) {
      case 'text':
      case 'number':
        _attrTextControllers.putIfAbsent(key, () => TextEditingController());
        return _field(
          theme,
          _attrTextControllers[key]!,
          unit != null ? '$fullLabel ($unit)' : fullLabel,
          required: required,
          keyboardType:
              type == 'number' ? TextInputType.number : TextInputType.text,
        );
      case 'textarea':
        _attrTextControllers.putIfAbsent(key, () => TextEditingController());
        return _field(theme, _attrTextControllers[key]!, fullLabel,
            required: required, maxLines: 3);
      case 'switch':
        return SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _attrValues[key] == true,
          onChanged: (v) => setState(() => _attrValues[key] = v),
          activeThumbColor: theme.secondary,
          title: Text(label,
              style: TextStyle(color: theme.primaryText, fontSize: 13.5)),
        );
      case 'date':
        final current = DateTime.tryParse('${_attrValues[key] ?? ''}');
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: current ?? DateTime.now(),
                firstDate: DateTime(2015),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => _attrValues[key] =
                    picked.toIso8601String().split('T').first);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.alternate),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      current == null
                          ? fullLabel
                          : '$label: ${current.toIso8601String().split('T').first}',
                      style: TextStyle(
                          color: current == null
                              ? theme.secondaryText
                              : theme.primaryText,
                          fontSize: 13.5),
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: theme.secondaryText),
                ],
              ),
            ),
          ),
        );
      case 'choice_chip':
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullLabel,
                  style: TextStyle(color: theme.primaryText, fontSize: 13.5)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final o in options)
                    ChoiceChip(
                      label: Text('${o['label']}'),
                      selected: _attrValues[key] == o['value'],
                      selectedColor: theme.primary,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: _attrValues[key] == o['value']
                              ? Colors.white
                              : theme.primaryText,
                          fontSize: 12.5),
                      backgroundColor: theme.secondaryBackground,
                      side: BorderSide(color: theme.alternate),
                      onSelected: (sel) => setState(
                          () => _attrValues[key] = sel ? o['value'] : null),
                    ),
                ],
              ),
              if (_attrValues[key] == 'other') _otherSpecifyField(theme, key),
            ],
          ),
        );
      case 'choice_chip_multi':
        final selected =
            (_attrValues[key] as List?)?.map((e) => '$e').toSet() ?? <String>{};
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullLabel,
                  style: TextStyle(color: theme.primaryText, fontSize: 13.5)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final o in options)
                    FilterChip(
                      label: Text('${o['label']}'),
                      selected: selected.contains('${o['value']}'),
                      selectedColor: theme.primary,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: selected.contains('${o['value']}')
                              ? Colors.white
                              : theme.primaryText,
                          fontSize: 12.5),
                      backgroundColor: theme.secondaryBackground,
                      side: BorderSide(color: theme.alternate),
                      onSelected: (sel) => setState(() {
                        final next = {...selected};
                        sel
                            ? next.add('${o['value']}')
                            : next.remove('${o['value']}');
                        _attrValues[key] = next.toList();
                      }),
                    ),
                ],
              ),
            ],
          ),
        );
      case 'dropdown':
      default:
        final items = {
          for (final o in options) '${o['value']}': '${o['label']}'
        };
        final value = _attrValues[key] as String?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdown(
              theme,
              label: fullLabel,
              value: items.containsKey(value) ? value : null,
              items: items,
              onChanged: (v) => setState(() => _attrValues[key] = v),
            ),
            if (value == 'other') _otherSpecifyField(theme, key),
          ],
        );
    }
  }

  /// Shown under a dropdown/choice-chip field once the seller picks "Other"
  /// -- lets them say what it actually is instead of the answer dead-ending.
  Widget _otherSpecifyField(FlutterFlowTheme theme, String key) {
    final otherKey = '${key}_other';
    _attrTextControllers.putIfAbsent(otherKey, () => TextEditingController());
    if (_attrTextControllers[otherKey]!.text.isEmpty &&
        _attrValues[otherKey] != null) {
      _attrTextControllers[otherKey]!.text = '${_attrValues[otherKey]}';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: _field(theme, _attrTextControllers[otherKey]!, 'Please specify',
          required: true),
    );
  }

  /// "Specifications" -- the category's fields (once a category is known),
  /// then the subcategory's own fields (once one is picked). Empty when
  /// there is nothing to ask, so most categories add zero UI until seeded.
  Widget _specificationsSection(FlutterFlowTheme theme) {
    if (_categorySlug == null) return const SizedBox.shrink();
    if (_attrDefsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    final defs = _activeAttrDefs;
    if (defs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'Specifications',
              'Helps buyers know exactly what they are getting.'),
          const SizedBox(height: 8),
          for (final d in defs) _specField(theme, d),
        ],
      ),
    );
  }

  Widget _categoryPickers(FlutterFlowTheme theme) {
    final selected = _subcategories
        .where((s) => '${s['slug']}' == _subcategorySlug)
        .toList();
    final selectedName = selected.isEmpty ? null : '${selected.first['name']}';

    if (_categorySlug == null || _categorySlug!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _errorBanner(
          theme,
          'This store has no category set, so listings cannot be categorised. '
          'Set the store category in storefront settings first.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(Icons.storefront_outlined,
                  size: 14, color: theme.secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Category: ${_categoryName ?? _categorySlug} · set by your store',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: _subcategories.isEmpty ? null : () => _pickSubcategory(theme),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedName ??
                        (_subcategories.isEmpty
                            ? 'No subcategories for this store category'
                            : 'Choose a subcategory'),
                    style: TextStyle(
                      color: selectedName == null
                          ? theme.secondaryText
                          : theme.primaryText,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                Icon(Icons.expand_more, size: 20, color: theme.secondaryText),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Searchable A–Z list. Small today (3–12 per category) but the search box
  /// keeps it usable as the taxonomy grows.
  void _pickSubcategory(FlutterFlowTheme theme) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final query = controller.text.trim().toLowerCase();
            final results = _subcategories
                .where((s) =>
                    query.isEmpty ||
                    '${s['name']}'.toLowerCase().contains(query))
                .toList();

            return Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.alternate,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Choose a subcategory',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (_) => setSheetState(() {}),
                      style:
                          TextStyle(color: theme.primaryText, fontSize: 13.5),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle:
                            TextStyle(color: theme.secondaryText, fontSize: 13),
                        prefixIcon: Icon(Icons.search,
                            size: 18, color: theme.secondaryText),
                        filled: true,
                        fillColor: theme.secondaryBackground,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                          borderSide: BorderSide(color: theme.secondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                      ),
                      child: results.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                'Nothing matches “${controller.text.trim()}”.',
                                style: TextStyle(
                                    color: theme.secondaryText, fontSize: 12.5),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: results.length,
                              itemBuilder: (_, i) {
                                final s = results[i];
                                final slug = '${s['slug']}';
                                final active = slug == _subcategorySlug;
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${s['name']}',
                                    style: TextStyle(
                                      color: theme.primaryText,
                                      fontSize: 13.5,
                                      fontWeight: active
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  trailing: active
                                      ? Icon(Icons.check,
                                          size: 18, color: theme.secondary)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _subcategorySlug = slug;
                                      _subcategoryAttrDefs = [];
                                      _attrValues = {};
                                    });
                                    Navigator.of(ctx).pop();
                                    if (slug != null)
                                      _loadSubcategoryAttrDefs(slug);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(controller.dispose);
  }

  /// Goods only. Without a band (or an exact weight) `build_order_parcel`
  /// refuses to price courier delivery for any order containing this item,
  /// so the copy says that plainly rather than leaving it as a silent gap.
  Widget _deliverySection(FlutterFlowTheme theme) {
    final hasSize = _sizeBand != null || _exactWeight.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(theme, 'Delivery size',
            'Needed before buyers can have this delivered.'),
        const SizedBox(height: 8),
        ..._bands.map((b) {
          final code = '${b['code']}';
          final active = _sizeBand == code;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _sizeBand = active ? null : code),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active ? theme.secondary : theme.alternate,
                    width: active ? 1.8 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      active
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 20,
                      color: active ? theme.secondary : theme.secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${b['label']}  ·  ${b['weight_kg']} kg',
                            style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${b['example']}',
                            style: TextStyle(
                                color: theme.secondaryText,
                                fontSize: 11.5,
                                height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (!hasSize)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 15, color: theme.secondaryText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Without a size, this item can only be picked up — buyers '
                    'will not be offered delivery for it.',
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 11.5,
                        height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        // Wins over the band when set, matching listing_ship_weight_kg().
        _field(theme, _exactWeight, 'Exact weight in kg (optional)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            required: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ]),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _isFragile,
          onChanged: (v) => setState(() => _isFragile = v),
          activeThumbColor: theme.secondary,
          title: Text('Fragile',
              style: TextStyle(color: theme.primaryText, fontSize: 13.5)),
        ),
      ],
    );
  }

  Widget _dropdown(
    FlutterFlowTheme theme, {
    required String label,
    required String? value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // A stale value not present in items would make DropdownButton throw.
    final safeValue = items.containsKey(value) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: safeValue,
        isExpanded: true,
        dropdownColor: theme.secondaryBackground,
        style: TextStyle(color: theme.primaryText, fontSize: 13.5),
        decoration: _decoration(theme, label),
        items: items.entries
            .map((e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value, overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _field(
    FlutterFlowTheme theme,
    TextEditingController controller,
    String label, {
    bool required = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: TextStyle(color: theme.primaryText, fontSize: 13.5),
        decoration: _decoration(theme, label),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }

  InputDecoration _decoration(FlutterFlowTheme theme, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        borderSide: BorderSide(color: theme.secondary),
      ),
    );
  }
}
