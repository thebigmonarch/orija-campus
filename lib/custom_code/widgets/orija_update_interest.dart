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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces the native updateuserInterestPage, which crashed on every open:
/// its 'Update Interest' button's onPressed ternary read
/// `_model.choiceChipsValues!.length` -- a force-unwrap on a field that is
/// null until the user taps a chip, evaluated unconditionally on every
/// build (not gated behind a tap), so it threw a null-check exception
/// immediately on page load. This rebuild uses a plain nullable-free
/// Set<String> for selection state instead.
class OrijaUpdateInterest extends StatefulWidget {
  const OrijaUpdateInterest({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaUpdateInterest> createState() => _OrijaUpdateInterestState();
}

class _OrijaUpdateInterestState extends State<OrijaUpdateInterest> {
  bool _loading = true;
  bool _saving = false;
  List<Map<String, dynamic>> _categories = [];
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supabase = Supabase.instance.client;
    try {
      final categories = await supabase
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .order('name');
      final mine = await supabase
          .from('user_interests')
          .select('category')
          .eq('user_id', currentUserUid);
      if (!mounted) return;
      setState(() {
        _categories = List<Map<String, dynamic>>.from(categories as List);
        _selected
          ..clear()
          ..addAll(List<Map<String, dynamic>>.from(mine as List)
              .map((r) => r['category'] as String?)
              .whereType<String>());
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_selected.length < 3 || _saving) return;
    setState(() => _saving = true);
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('user_interests')
          .delete()
          .eq('user_id', currentUserUid);
      for (final category in _selected) {
        await supabase
            .from('user_interests')
            .insert({'user_id': currentUserUid, 'category': category});
      }
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
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
    final theme = FlutterFlowTheme.of(context);
    final canSave = _selected.length >= 3;
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text('Update Interest',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What interests you?',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("We'll personalize your market experience.",
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 14)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((c) {
                            final slug = c['slug'] as String;
                            final selected = _selected.contains(slug);
                            return InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => setState(() {
                                if (selected) {
                                  _selected.remove(slug);
                                } else {
                                  _selected.add(slug);
                                }
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.secondaryBackground
                                      : theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: selected
                                          ? theme.secondary
                                          : theme.alternate,
                                      width: selected ? 2 : 1),
                                ),
                                child: Text(c['name'] as String? ?? slug,
                                    style: TextStyle(
                                        color: selected
                                            ? theme.primaryText
                                            : theme.secondaryText,
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.normal)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              color: const Color(0x33000000),
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outlined,
                              color: theme.primary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                'Select at least 3 interests to personalize your experience.',
                                style: TextStyle(
                                    color: theme.secondaryText, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: canSave && !_saving ? _save : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: theme.secondaryText,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text('Update Interest',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
