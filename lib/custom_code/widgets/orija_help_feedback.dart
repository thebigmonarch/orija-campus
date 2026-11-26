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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';

const _kFeedbackTypes = <String, String>{
  'Bug Report': 'bug_report',
  'Feature Request': 'feature_request',
  'General': 'general',
  'Support': 'support',
  'Compliment': 'compliment',
  'Complaint': 'complaint',
};

/// Replaces the native helpFeedback page. FAQs previously came from a
/// caller-supplied `faq` param that was never actually passed at any call
/// site (confirmed via preflight: "Navigates to HelpFeedback but may be
/// missing param faq") -- this self-fetches from the real `faqs` table
/// instead, grouped by category, so the section reliably has content.
class OrijaHelpFeedback extends StatefulWidget {
  const OrijaHelpFeedback({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaHelpFeedback> createState() => _OrijaHelpFeedbackState();
}

class _OrijaHelpFeedbackState extends State<OrijaHelpFeedback> {
  final _messageController = TextEditingController();
  String? _selectedType;
  bool _submitting = false;
  bool _uploading = false;
  final List<String> _imageUrls = [];

  bool _faqLoading = true;
  final Map<String, List<Map<String, dynamic>>> _faqByCategory = {};
  final Set<String> _expandedCategories = {};

  String? _deviceInfo;
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
    _loadDiagnostics();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadDiagnostics() async {
    try {
      final raw = await actions.getDiagnostics();
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      _deviceInfo = jsonEncode(parsed['deviceInfo']);
      _appVersion = parsed['appVersion'] as String?;
    } catch (_) {}
  }

  Future<void> _loadFaqs() async {
    try {
      final rows = await Supabase.instance.client
          .from('faqs')
          .select('category, question, answer')
          .eq('is_active', true)
          .order('category')
          .order('sort_order');
      if (!mounted) return;
      final byCategory = <String, List<Map<String, dynamic>>>{};
      for (final r in List<Map<String, dynamic>>.from(rows as List)) {
        final cat = r['category'] as String? ?? 'General';
        byCategory.putIfAbsent(cat, () => []).add(r);
      }
      setState(() {
        _faqByCategory
          ..clear()
          ..addAll(byCategory);
        _faqLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _faqLoading = false);
    }
  }

  Future<void> _addScreenshots() async {
    final selected = await selectMedia(
      storageFolderPath: '',
      mediaSource: MediaSource.photoGallery,
      multiImage: true,
    );
    if (selected == null || selected.isEmpty) return;
    if (!selected.every((m) => validateFileFormat(m.storagePath, context)))
      return;
    setState(() => _uploading = true);
    try {
      showUploadMessage(context, 'Uploading file...', showLoading: true);
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'feedback',
        selectedFiles: selected,
      );
      if (!mounted) return;
      setState(() => _imageUrls.addAll(urls));
      showUploadMessage(context, 'Success!');
    } catch (_) {
      if (mounted) showUploadMessage(context, 'Failed to upload data');
    } finally {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final res = await SubmitFeedbackCall.call(
      userId: currentUserUid,
      pAppVersion: _appVersion ?? '',
      pBody: _messageController.text,
      pDeviceInfo: _deviceInfo ?? '',
      pMediaUrlsList: _imageUrls,
      pType:
          _selectedType == null ? '' : (_kFeedbackTypes[_selectedType] ?? ''),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    final ok =
        res.succeeded && (SubmitFeedbackCall.success(res.jsonBody) ?? false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (SubmitFeedbackCall.message(res.jsonBody) ??
                'Thanks for the feedback!')
            : (SubmitFeedbackCall.error(res.jsonBody) ??
                'Failed. Please try again in a few minutes.')),
      ),
    );
    if (ok) context.pop();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Help & Feedback',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Send us your feedback',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Your input helps us make Orija better for everyone.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 16),
                  Text('Feedback Type',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _kFeedbackTypes.keys.map((label) {
                      final selected = _selectedType == label;
                      return InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => setState(() => _selectedType = label),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? theme.primary
                                : theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color:
                                    selected ? theme.primary : theme.alternate),
                          ),
                          child: Text(label,
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : theme.secondaryText,
                                  fontSize: 12.5)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Message',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    minLines: 5,
                    maxLines: null,
                    style: TextStyle(color: theme.primaryText, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Tell us what's on your mind...",
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Please be as descriptive as possible',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 16),
                  if (_imageUrls.isEmpty)
                    InkWell(
                      onTap: _uploading ? null : _addScreenshots,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _uploading
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: theme.primary, strokeWidth: 2))
                                : Icon(Icons.add_photo_alternate_rounded,
                                    color: theme.primary, size: 24),
                            const SizedBox(width: 16),
                            Text('Add screenshots',
                                style: TextStyle(
                                    color: theme.primary, fontSize: 14)),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageUrls.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final url = _imageUrls[i];
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url,
                                    width: 90, height: 90, fit: BoxFit.cover),
                              ),
                              InkWell(
                                onTap: () =>
                                    setState(() => _imageUrls.removeAt(i)),
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: Color(0xBC000000),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close_sharp,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Feedback',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Divider(height: 16, thickness: 8, color: theme.alternate),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Frequently Asked Questions',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  if (_faqLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(color: theme.primary),
                    )
                  else if (_faqByCategory.isEmpty)
                    Text('No FAQs yet.',
                        style: TextStyle(color: theme.secondaryText))
                  else
                    Column(
                      children: _faqByCategory.entries.map((entry) {
                        final expanded =
                            _expandedCategories.contains(entry.key);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.alternate),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => setState(() {
                                  if (expanded) {
                                    _expandedCategories.remove(entry.key);
                                  } else {
                                    _expandedCategories.add(entry.key);
                                  }
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(entry.key,
                                            style: TextStyle(
                                                color: theme.primaryText,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Icon(
                                          expanded
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                  .keyboard_arrow_down_rounded,
                                          color: theme.secondaryText),
                                    ],
                                  ),
                                ),
                              ),
                              if (expanded)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: entry.value
                                        .map((f) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      f['question']
                                                              as String? ??
                                                          '',
                                                      style: TextStyle(
                                                          color:
                                                              theme.primaryText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                      f['answer'] as String? ??
                                                          '',
                                                      style: TextStyle(
                                                          color: theme
                                                              .secondaryText,
                                                          fontSize: 12.5,
                                                          height: 1.4)),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
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
