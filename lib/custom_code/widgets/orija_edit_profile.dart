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

import 'package:flutter/services.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_location_picker.dart';
import '/custom_code/widgets/orija_media_field.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Edit the signed-in user's own profile: photo, name, phone, date of birth,
/// where they live and what they are interested in.
///
/// Loads the row itself, so it needs no parameters (the page's old `profile`
/// parameter is no longer used). The photo goes straight to Cloudinary and
/// replaces the previous one: it is saved to `users.avatar_url` as soon as it
/// uploads and the old picture is deleted afterwards.
///
/// Name, date of birth and at least one interest are what onboarding counts
/// as a finished profile, so they are required here too. Email is shown but
/// can't be edited: it is the sign-in identity.
class OrijaEditProfile extends StatefulWidget {
  const OrijaEditProfile({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaEditProfile> createState() => _OrijaEditProfileState();
}

class _OrijaEditProfileState extends State<OrijaEditProfile> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _loadError;
  Map<String, dynamic> _user = {};

  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  OrijaLocationValue _loc = const OrijaLocationValue();

  List<Map<String, String>> _cats = [];
  final Set<String> _interests = {};
  List<Map<String, dynamic>> _interestRows = [];

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final row = await _client
          .from('users')
          .select(
              'first_name, last_name, phone, email, avatar_url, state, city')
          .eq('id', currentUserUid)
          .maybeSingle();
      final cats = await _client
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      final mine = await _client
          .from('user_interests')
          .select('id, category')
          .eq('user_id', currentUserUid);

      if (!mounted) return;
      if (row == null) {
        setState(() {
          _loadError = 'Your profile could not be found.';
          _loading = false;
        });
        return;
      }

      final categories = [
        for (final c in cats)
          {'slug': c['slug'] as String, 'name': c['name'] as String},
      ];
      // Older rows stored the category NAME; map those to its slug.
      String? slugOf(String v) {
        for (final c in categories) {
          if (c['slug'] == v || c['name'] == v) return c['slug'];
        }
        return null;
      }

      _user = Map<String, dynamic>.from(row);
      _first.text = '${row['first_name'] ?? ''}';
      _last.text = '${row['last_name'] ?? ''}';
      _phone.text = ngPhoneDigitsFromAny('${row['phone'] ?? ''}');
      _loc = OrijaLocationValue(
        stateName: row['state'] as String?,
        city: row['city'] as String?,
      );
      _interestRows = [for (final m in mine) Map<String, dynamic>.from(m)];
      for (final m in _interestRows) {
        final s = slugOf('${m['category']}');
        if (s != null) _interests.add(s);
      }
      setState(() {
        _cats = categories;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Could not load your profile. Check your connection.';
        _loading = false;
      });
    }
  }

  Future<bool> _saveAvatar(String url) async {
    try {
      await _client
          .from('users')
          .update({'avatar_url': url}).eq('id', currentUserUid);
      _user['avatar_url'] = url;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _save() async {
    final digits = _phone.text.trim();
    if (digits.isNotEmpty && digits.length != 10) {
      setState(() => _error = 'Enter a 10-digit number.');
      return;
    }
    if (_interests.isEmpty) {
      setState(() => _error = 'Pick at least one interest.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final update = <String, dynamic>{
        'phone':
            _phone.text.trim().isEmpty ? null : '+234${_phone.text.trim()}',
        if (_loc.hasStateAndCity) 'state': _loc.stateName,
        if (_loc.hasStateAndCity) 'city': _loc.city,
      };
      await _client.from('users').update(update).eq('id', currentUserUid);

      // Interests: drop rows that are no longer chosen (including old rows
      // that stored a category name), add the new ones.
      final have = {for (final r in _interestRows) '${r['category']}'};
      final removeIds = [
        for (final r in _interestRows)
          if (!_interests.contains('${r['category']}')) r['id'],
      ];
      if (removeIds.isNotEmpty) {
        await _client.from('user_interests').delete().inFilter('id', removeIds);
      }
      final add = _interests.where((s) => !have.contains(s)).toList();
      if (add.isNotEmpty) {
        await _client.from('user_interests').insert([
          for (final s in add) {'user_id': currentUserUid, 'category': s},
        ]);
      }

      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Profile updated.'),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ));
      if (context.canPop()) context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save your profile. Try again.';
      });
    }
  }

  // ------------------------------------------------------------------- UI

  Widget _lockedField(FlutterFlowTheme t, String label, String value) {
    return InputDecorator(
      decoration: _dec(t, label).copyWith(
        suffixIcon: Icon(Icons.lock_outline, size: 16, color: t.secondaryText),
      ),
      child: Text(
        value.isEmpty ? '—' : value,
        style: TextStyle(color: t.secondaryText, fontSize: 14),
      ),
    );
  }

  InputDecoration _dec(FlutterFlowTheme t, String label) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: t.secondaryText, fontSize: 13),
      filled: true,
      fillColor: t.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(t.alternate),
      focusedBorder: b(t.secondary),
      border: b(t.alternate),
    );
  }

  Widget _section(FlutterFlowTheme t, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(title,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    if (_loading) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }
    if (_loadError != null) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_loadError!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 14.5)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.goNamed('HomePage'),
            child: const Text('Go back'),
          ),
        ]),
      );
    }

    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
            child: Row(children: [
              IconButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.goNamed('HomePage'),
                icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
              ),
              Text('Edit profile',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(children: [
                      OrijaMediaField(
                        uploadContext: 'avatar',
                        shape: 'circle',
                        width: 110,
                        height: 110,
                        label: 'Add a photo',
                        imageUrl: _user['avatar_url'] as String?,
                        onSave: _saveAvatar,
                      ),
                      const SizedBox(height: 8),
                      Text('Your photo saves as soon as you pick it.',
                          style: TextStyle(
                              color: t.secondaryText, fontSize: 11.5)),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  _section(t, 'About you', [
                    Text(
                        'Your name is set once and cannot be changed here. Contact support if something needs correcting.',
                        style: TextStyle(
                            color: t.secondaryText,
                            fontSize: 11.5,
                            height: 1.35)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                          child: _lockedField(t, 'First name', _first.text)),
                      const SizedBox(width: 10),
                      Expanded(child: _lockedField(t, 'Last name', _last.text)),
                    ]),
                  ]),
                  _section(t, 'Contact', [
                    ngPhoneField(t, _phone),
                    const SizedBox(height: 12),
                    InputDecorator(
                      decoration: _dec(t, 'Email'),
                      child: Text('${_user['email'] ?? currentUserEmail}',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 14)),
                    ),
                  ]),
                  _section(t, 'Where you live', [
                    OrijaLocationPicker(
                      showStreet: false,
                      initialState: _loc.stateName,
                      initialCity: _loc.city,
                      onChanged: (v) => _loc = v,
                    ),
                  ]),
                  _section(t, 'Interests', [
                    Text(
                        'We use these to shape your feed. Pick as many as you like.',
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 12.5)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final c in _cats)
                        FilterChip(
                          label: Text(c['name']!),
                          selected: _interests.contains(c['slug']),
                          showCheckmark: false,
                          selectedColor: t.secondary,
                          backgroundColor: t.secondaryBackground,
                          side: BorderSide(
                              color: _interests.contains(c['slug'])
                                  ? t.secondary
                                  : t.alternate),
                          labelStyle: TextStyle(
                              fontSize: 12.5,
                              color: _interests.contains(c['slug'])
                                  ? Colors.white
                                  : t.primaryText),
                          onSelected: (on) => setState(() {
                            on
                                ? _interests.add(c['slug']!)
                                : _interests.remove(c['slug']);
                          }),
                        ),
                    ]),
                  ]),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              border: Border(top: BorderSide(color: t.alternate)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!,
                      style: TextStyle(color: t.error, fontSize: 12.5)),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save changes',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14.5)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// A phone field fixed to +234 (Nigeria): the prefix is shown, not typed,
/// and only the 10 digits after it are collected. Terminal Africa expects
/// this exact shape for pickup/delivery contacts, so every phone number this
/// app collects is stored the same way rather than however each seller or
/// buyer happens to type theirs. Duplicated from orija_storefront_setup.dart
/// (each custom widget is an independent compilation unit).
String ngPhoneDigitsFromAny(String raw) {
  var d = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (d.startsWith('234')) d = d.substring(3);
  if (d.startsWith('0')) d = d.substring(1);
  if (d.length > 10) d = d.substring(d.length - 10);
  return d;
}

Widget ngPhoneField(
  FlutterFlowTheme theme,
  TextEditingController controller, {
  bool validateForm = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.phone,
    maxLength: 10,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ],
    style: TextStyle(color: theme.primaryText, fontSize: 13.5),
    validator: validateForm
        ? (v) => (v == null || v.trim().length != 10)
            ? 'Enter a 10-digit number'
            : null
        : null,
    decoration: InputDecoration(
      labelText: 'Phone number',
      prefixText: '+234  ',
      prefixStyle: TextStyle(
          color: theme.primaryText,
          fontSize: 13.5,
          fontWeight: FontWeight.w600),
      counterText: '',
      labelStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
  );
}
