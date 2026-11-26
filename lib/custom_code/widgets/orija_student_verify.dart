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
import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Orija Campus: student verification with a photo of the student ID card.
///
/// One widget, four states read from get_my_student_verification:
///   - nothing sent yet, or the last one was rejected -> upload the ID
///   - pending  -> "We're reviewing your ID"
///   - verified -> confirmation
/// The photo goes to the PRIVATE `student-ids` bucket under <user id>/, then
/// submit_student_verification records the request (see
/// backend/campus_student_verification.sql). A reviewer approves it, which
/// sets users.identity_verified.
class OrijaStudentVerify extends StatefulWidget {
  const OrijaStudentVerify({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OrijaStudentVerify> createState() => _OrijaStudentVerifyState();
}

class _OrijaStudentVerifyState extends State<OrijaStudentVerify> {
  bool _loading = true;
  bool _loadFailed = false;
  bool _busy = false;

  bool _verified = false;
  // Verified instantly by school email; the ID card still completes it.
  bool _emailVerified = false;
  String? _status; // ID card: pending | approved | rejected | null
  String? _note;
  String? _school;

  Uint8List? _photo;
  String _photoExt = 'jpg';
  String _photoMime = 'image/jpeg';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final res =
          await Supabase.instance.client.rpc('get_my_student_verification');
      if (!mounted) return;
      final m =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      setState(() {
        _verified = m['verified'] == true;
        _emailVerified = m['email_verified'] == true;
        _status = m['status'] as String?;
        _note = m['review_note'] as String?;
        _school = m['school_name'] as String?;
      });
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final x = await ImagePicker()
          .pickImage(source: source, maxWidth: 1800, imageQuality: 85);
      if (x == null) return;
      final bytes = await x.readAsBytes();
      final name = x.name.toLowerCase();
      var ext = name.contains('.') ? name.split('.').last : 'jpg';
      if (!const ['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(ext)) {
        ext = 'jpg';
      }
      final mime = ext == 'png'
          ? 'image/png'
          : ext == 'webp'
              ? 'image/webp'
              : ext == 'heic'
                  ? 'image/heic'
                  : 'image/jpeg';
      if (!mounted) return;
      setState(() {
        _photo = bytes;
        _photoExt = ext;
        _photoMime = mime;
      });
    } catch (_) {
      if (mounted) {
        _toast(
            "We couldn't open the camera or gallery. Check the app's photo permission.");
      }
    }
  }

  void _chooseSource() {
    final t = FlutterFlowTheme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, color: t.primary),
              title: Text('Take a photo', style: t.bodyMedium),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: t.primary),
              title: Text('Choose from gallery', style: t.bodyMedium),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_busy) return;
    final photo = _photo;
    if (photo == null) {
      _toast('Add a photo of your student ID first.');
      return;
    }
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      _toast('Sign in to verify.');
      return;
    }
    setState(() => _busy = true);
    try {
      final path = '$uid/${DateTime.now().millisecondsSinceEpoch}.$_photoExt';
      await Supabase.instance.client.storage.from('student-ids').uploadBinary(
            path,
            photo,
            fileOptions: FileOptions(contentType: _photoMime, upsert: false),
          );
      final res = await Supabase.instance.client
          .rpc('submit_student_verification', params: {'p_photo_path': path});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _photo = null;
          _status = 'pending';
          _note = null;
        });
      } else {
        final code = res is Map ? res['code'] : null;
        final msg = res is Map ? res['message'] as String? : null;
        if (code == 'ALREADY_PENDING' || code == 'ALREADY_VERIFIED') {
          await _load();
        }
        if (mounted) {
          _toast(msg ?? "We couldn't send your ID. Please try again.");
        }
      }
    } catch (_) {
      if (mounted) {
        _toast(
            "We couldn't send your ID. Check your connection and try again.");
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: t.secondary))
            : _loadFailed
                ? _loadError(t)
                : LayoutBuilder(
                    builder: (context, c) {
                      final h = c.maxHeight.isFinite ? c.maxHeight : 700.0;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: math.max(0.0, h - 48)),
                          child: IntrinsicHeight(child: _view(t)),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _view(FlutterFlowTheme t) {
    if (_status == 'approved') return _verifiedView(t);
    if (_status == 'pending') return _pendingView(t);
    // Verified by school email but no ID card yet: still ask for the ID.
    if (_verified && !_emailVerified) return _verifiedView(t);
    return _uploadView(t, rejected: _status == 'rejected');
  }

  Widget _button(FlutterFlowTheme t, String label, VoidCallback? onTap,
      {bool busy = false}) {
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
        onPressed: busy ? null : onTap,
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: Colors.white))
            : Text(label, style: t.titleSmall.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _loadError(FlutterFlowTheme t) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("We couldn't load your verification", style: t.titleMedium),
          const SizedBox(height: 8),
          Text('Check your connection and try again.', style: t.labelMedium),
          const SizedBox(height: 24),
          _button(t, 'Try again', _load),
        ],
      ),
    );
  }

  Widget _checkRow(FlutterFlowTheme t, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 20, color: t.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: t.bodyMedium)),
        ],
      ),
    );
  }

  Widget _uploadView(FlutterFlowTheme t, {required bool rejected}) {
    final school = (_school ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_emailVerified) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.success.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mark_email_read_outlined,
                    color: t.success, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verified by your school email',
                          style: t.titleSmall
                              .copyWith(color: t.primaryText, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                          'Your ✓ Student badge is on. Upload your student ID card to complete your verification.',
                          style: t.bodySmall
                              .copyWith(color: t.secondaryText, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (rejected) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.error.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: t.error, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("We couldn't verify your ID",
                          style: t.titleMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Reason from the reviewer', style: t.labelSmall),
                const SizedBox(height: 4),
                Text(
                  (_note ?? '').trim().isEmpty
                      ? 'The photo could not be read.'
                      : _note!.trim(),
                  style: t.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          school.isEmpty
              ? 'Take a clear photo of the front of your student ID card.'
              : 'Take a clear photo of the front of your $school student ID card.',
          style: t.labelMedium,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _busy ? null : _chooseSource,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.primary, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: _photo != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(_photo!, fit: BoxFit.cover),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('Change photo',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera_outlined,
                          size: 40, color: t.primary),
                      const SizedBox(height: 8),
                      Text('Take a photo', style: t.titleSmall),
                      Text('or choose from your gallery', style: t.labelMedium),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('For a quick review', style: t.titleSmall),
              _checkRow(t, 'Your name and school are easy to read'),
              _checkRow(t, 'All four corners of the card are in the photo'),
              _checkRow(t, 'No glare, and the card is not expired'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Only your school's reviewers see this photo. We use it to confirm you're a student and nothing else.",
          style: t.labelSmall,
        ),
        const Spacer(),
        const SizedBox(height: 16),
        _button(
          t,
          rejected ? 'Submit new photo' : 'Submit for review',
          _submit,
          busy: _busy,
        ),
      ],
    );
  }

  Widget _stepRow(FlutterFlowTheme t,
      {required Widget icon,
      required String label,
      bool strong = false,
      bool dim = false,
      bool top = false}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      decoration: BoxDecoration(
        border: top ? Border(top: BorderSide(color: t.alternate)) : null,
      ),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: strong
                  ? t.titleSmall
                  : dim
                      ? t.labelMedium
                      : t.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingView(FlutterFlowTheme t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
              color: t.secondaryBackground, shape: BoxShape.circle),
          child: Icon(Icons.schedule_rounded, color: t.primary, size: 36),
        ),
        const SizedBox(height: 16),
        Text("We're reviewing your ID", style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          "This usually takes a day or two. We'll send a notification when it's done.",
          style: t.labelMedium,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _stepRow(t,
                  icon: Icon(Icons.check_circle_outline_rounded,
                      color: t.success, size: 24),
                  label: 'ID photo received'),
              _stepRow(t,
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: t.secondary, width: 3),
                    ),
                  ),
                  label: 'Review in progress',
                  strong: true,
                  top: true),
              _stepRow(t,
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: t.alternate, width: 2),
                    ),
                  ),
                  label: 'Verified student badge',
                  dim: true,
                  top: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "While you wait, you can browse, chat and buy as usual. Selling opens once you're verified.",
          style: t.labelMedium,
        ),
        const Spacer(),
        const SizedBox(height: 16),
        _button(t, 'Back to profile', () {
          if (context.canPop()) context.pop();
        }),
      ],
    );
  }

  Widget _verifiedView(FlutterFlowTheme t) {
    final school = (_school ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
              color: t.secondaryBackground, shape: BoxShape.circle),
          child: Icon(Icons.verified_rounded, color: t.success, size: 36),
        ),
        const SizedBox(height: 16),
        Text("You're a verified student", style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          school.isEmpty
              ? 'Your verified badge shows on your profile. You can open your storefront now.'
              : 'Your verified $school badge shows on your profile. You can open your storefront now.',
          style: t.labelMedium,
        ),
        const Spacer(),
        const SizedBox(height: 16),
        _button(t, 'Back to profile', () {
          if (context.canPop()) context.pop();
        }),
      ],
    );
  }
}
