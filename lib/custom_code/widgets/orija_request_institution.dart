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

import 'dart:math' as math;

import 'package:go_router/go_router.dart';

/// Orija Campus: a student asks for their school to be added.
///
/// State and Local government are dropdowns with search, sorted A to Z;
/// picking a state filters the local governments. The request goes to the
/// submit_institution_request database function (see
/// backend/campus_institutions.sql).
class OrijaRequestInstitution extends StatefulWidget {
  const OrijaRequestInstitution({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OrijaRequestInstitution> createState() =>
      _OrijaRequestInstitutionState();
}

class _OrijaRequestInstitutionState extends State<OrijaRequestInstitution> {
  final _formKey = GlobalKey<FormState>();
  final _school = TextEditingController();
  final _union = TextEditingController();
  final _email = TextEditingController();

  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _lgas = [];
  Map<String, dynamic>? _state;
  String? _lga;

  bool _loadingStates = true;
  bool _loadingLgas = false;
  bool _busy = false;
  bool _sent = false;

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  @override
  void dispose() {
    _school.dispose();
    _union.dispose();
    _email.dispose();
    super.dispose();
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _loadStates() async {
    setState(() => _loadingStates = true);
    try {
      final rows = await Supabase.instance.client
          .from('states')
          .select('id,name')
          .order('name');
      if (!mounted) return;
      setState(() => _states = List<Map<String, dynamic>>.from(rows as List));
    } catch (_) {
      if (mounted)
        _toast("We couldn't load the states. Tap State to try again.");
    } finally {
      if (mounted) setState(() => _loadingStates = false);
    }
  }

  Future<void> _loadLgas(String stateId) async {
    setState(() => _loadingLgas = true);
    try {
      final rows = await Supabase.instance.client
          .from('local_governments')
          .select('id,name')
          .eq('state_id', stateId)
          .order('name');
      if (!mounted) return;
      // Ignore a late answer for a state that is no longer selected.
      if (_state == null || _state!['id'].toString() != stateId) return;
      setState(() => _lgas = List<Map<String, dynamic>>.from(rows as List));
    } catch (_) {
      if (mounted) {
        _toast("We couldn't load the local governments. Tap it to try again.");
      }
    } finally {
      if (mounted) setState(() => _loadingLgas = false);
    }
  }

  void _onStatePicked(String name) {
    final match = _states.where((s) => (s['name'] ?? '').toString() == name);
    if (match.isEmpty) return;
    final picked = match.first;
    if (_state != null && _state!['id'] == picked['id']) return;
    setState(() {
      _state = picked;
      _lga = null; // a new state clears the local government
      _lgas = [];
    });
    _loadLgas(picked['id'].toString());
  }

  void _reloadLgas() {
    if (_state != null && !_loadingLgas) {
      _loadLgas(_state!['id'].toString());
    }
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_state == null || _lga == null) {
      _toast('Choose the state and local government.');
      return;
    }
    setState(() => _busy = true);
    try {
      final res = await Supabase.instance.client
          .rpc('submit_institution_request', params: {
        'p_school_name': _school.text.trim(),
        'p_state_name': (_state!['name'] ?? '').toString(),
        'p_city_name': _lga,
        'p_union_contact': _union.text.trim(),
        'p_email': _email.text.trim(),
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _sent = true);
      } else {
        final msg = res is Map ? res['message'] as String? : null;
        _toast(msg ?? "We couldn't send your request. Please try again.");
      }
    } catch (_) {
      if (mounted) {
        _toast(
            "We couldn't send your request. Check your connection and try again.");
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: t.primaryBackground,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final h = c.maxHeight.isFinite ? c.maxHeight : 700.0;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: math.max(0.0, h - 48)),
                  child: IntrinsicHeight(
                    child: _sent ? _sentView(t) : _form(t),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(FlutterFlowTheme t, String hint) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c, width: w));
    return InputDecoration(
      hintText: hint,
      hintStyle: t.bodyMedium.copyWith(color: t.secondaryText),
      isDense: true,
      filled: true,
      fillColor: t.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: b(t.alternate),
      focusedBorder: b(t.secondary, 1.5),
      errorBorder: b(t.error),
      focusedErrorBorder: b(t.error, 1.5),
    );
  }

  Widget _labeled(FlutterFlowTheme t, String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodyMedium),
        const SizedBox(height: 4),
        field,
      ],
    );
  }

  Widget _button(FlutterFlowTheme t, String label, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: t.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24))),
        onPressed: _busy ? null : onTap,
        child: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: Colors.white))
            : Text(label, style: t.titleSmall.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _form(FlutterFlowTheme t) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Tell us where you study and we'll review it. It usually takes a few days.",
              style: t.labelMedium),
          const SizedBox(height: 16),
          _labeled(
            t,
            'School name',
            TextFormField(
              controller: _school,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v ?? '').trim().length < 3 ? 'Enter your school name' : null,
              style: t.bodyMedium,
              decoration:
                  _dec(t, 'e.g. Federal University of Technology, Akure'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _labeled(
                  t,
                  'State',
                  _SearchDropdown(
                    options: [
                      for (final s in _states) (s['name'] ?? '').toString()
                    ],
                    value: _state == null
                        ? null
                        : (_state!['name'] ?? '').toString(),
                    placeholder: 'Select state',
                    searchHint: 'Search states',
                    loading: _loadingStates,
                    onEmptyTap: _loadStates,
                    onChanged: _onStatePicked,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _labeled(
                  t,
                  'Local government',
                  _SearchDropdown(
                    options: [
                      for (final l in _lgas) (l['name'] ?? '').toString()
                    ],
                    value: _lga,
                    placeholder:
                        _state == null ? 'Select state first' : 'Select',
                    searchHint: 'Search local governments',
                    loading: _loadingLgas,
                    enabled: _state != null,
                    onEmptyTap: _reloadLgas,
                    onChanged: (name) => setState(() => _lga = name),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _labeled(
            t,
            'Student union contact (optional)',
            TextFormField(
              controller: _union,
              textInputAction: TextInputAction.next,
              style: t.bodyMedium,
              decoration: _dec(t, 'Name or phone number'),
            ),
          ),
          const SizedBox(height: 16),
          _labeled(
            t,
            'Your email',
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              validator: (v) {
                final s = (v ?? '').trim();
                if (s.isEmpty) return 'Enter your email address';
                if (!_emailRe.hasMatch(s))
                  return 'That email does not look right';
                return null;
              },
              style: t.bodyMedium,
              decoration: _dec(t, 'you@example.com'),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: t.secondaryText, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You can keep using Orija with a general account while we review. We'll email you when your school is added.",
                    style: t.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),
          _button(t, 'Send request', _submit),
        ],
      ),
    );
  }

  Widget _sentView(FlutterFlowTheme t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
              color: t.secondaryBackground, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, color: t.success, size: 36),
        ),
        const SizedBox(height: 16),
        Text('Request sent', style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          "We'll review ${_school.text.trim()} and email ${_email.text.trim()} when it's added. You can keep using Orija with a general account meanwhile.",
          style: t.labelMedium,
        ),
        const Spacer(),
        const SizedBox(height: 16),
        _button(t, 'Back to sign up', () {
          if (context.canPop()) context.pop();
        }),
      ],
    );
  }
}

/// A real dropdown: the field opens a menu right under it, with a search box
/// and the options sorted A to Z.
class _SearchDropdown extends StatefulWidget {
  const _SearchDropdown({
    required this.options,
    required this.value,
    required this.placeholder,
    required this.onChanged,
    this.searchHint = 'Search',
    this.leading,
    this.enabled = true,
    this.loading = false,
    this.onEmptyTap,
  });

  final List<String> options;
  final String? value;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final String searchHint;
  final Widget? leading;
  final bool enabled;
  final bool loading;

  /// Called when the field is tapped while there is nothing to pick yet.
  final VoidCallback? onEmptyTap;

  @override
  State<_SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<_SearchDropdown> {
  final LayerLink _link = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _entry;

  bool get _isOpen => _entry != null;

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;
    super.dispose();
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  void _open() {
    if (!widget.enabled) return;
    if (widget.options.isEmpty) {
      widget.onEmptyTap?.call();
      return;
    }
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final size = box.size;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.of(context).size.height;
    final room = screenH - (top + size.height) - 16;
    final maxH = room.clamp(160.0, 300.0).toDouble();
    final t = FlutterFlowTheme.of(context);
    final sorted = [...widget.options]
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    var query = '';
    _entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: StatefulBuilder(
                builder: (ctx, setMenu) {
                  final q = query.trim().toLowerCase();
                  final shown = q.isEmpty
                      ? sorted
                      : sorted
                          .where((e) => e.toLowerCase().contains(q))
                          .toList();
                  return Material(
                    elevation: 6,
                    color: t.secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxH),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              onChanged: (v) => setMenu(() => query = v),
                              style: t.bodyMedium,
                              decoration: InputDecoration(
                                hintText: widget.searchHint,
                                hintStyle: t.bodyMedium
                                    .copyWith(color: t.secondaryText),
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: t.secondaryText, size: 20),
                                isDense: true,
                                filled: true,
                                fillColor: t.primaryBackground,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: t.alternate)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: t.secondary, width: 1.5)),
                              ),
                            ),
                          ),
                          Flexible(
                            child: shown.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(16),
                                    child:
                                        Text('No match', style: t.labelMedium),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: shown.length,
                                    itemBuilder: (c, i) {
                                      final e = shown[i];
                                      final selected = e == widget.value;
                                      return InkWell(
                                        onTap: () {
                                          _close();
                                          widget.onChanged(e);
                                        },
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              minHeight: 44),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  e,
                                                  style: selected
                                                      ? t.titleSmall.copyWith(
                                                          fontSize: 14)
                                                      : t.bodyMedium,
                                                ),
                                              ),
                                              if (selected)
                                                Icon(Icons.check_rounded,
                                                    size: 18, color: t.success),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return CompositedTransformTarget(
      link: _link,
      child: InkWell(
        key: _fieldKey,
        onTap: widget.enabled ? (_isOpen ? _close : _open) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding:
              EdgeInsets.only(left: widget.leading == null ? 16 : 12, right: 8),
          decoration: BoxDecoration(
            color: widget.enabled ? t.secondaryBackground : t.alternate,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: _isOpen ? t.secondary : t.alternate,
                width: _isOpen ? 1.5 : 1),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.value ?? widget.placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMedium.copyWith(
                      color: widget.value == null
                          ? t.secondaryText
                          : t.primaryText),
                ),
              ),
              if (widget.loading)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: t.secondaryText,
                    size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
