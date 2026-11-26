// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sends a signed-in user back to the onboarding step they haven't finished.
///
/// Sign-up signs the user in before the email code is checked, so being signed
/// in doesn't mean onboarding is done. The server (get_onboarding_status) says
/// where they should be:
///   confirm_email -> no profile row yet (created when the email code is
///                    verified): send a fresh code and open confirmEmail
///   profile       -> name / date of birth / interests missing: profileSetup
///   done          -> stay
/// Fails open: if the check itself fails (offline, server error) the user is
/// not trapped.
Future<void> guardOnboarding(BuildContext context) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;
  if (user == null) return;

  try {
    final res = await client.rpc('get_onboarding_status');
    final step = res is Map ? res['step'] as String? : null;
    if (!context.mounted) return;

    // Orija Campus: once the account has a profile row, save the school picked
    // at sign-up (this also joins the school's community).
    if (step != 'confirm_email') {
      await _saveCampusSchool(client);
      if (!context.mounted) return;
    }

    if (step == 'confirm_email') {
      final email = user.email;
      if (email == null || email.isEmpty) return;
      await getOtp(email);
      if (!context.mounted) return;
      context.goNamed('confirmEmail', queryParameters: {'email': email});
    } else if (step == 'profile') {
      context.goNamed('profileSetup');
    } else {
      await _askCampusRole(context, client);
    }
  } catch (_) {
    // Fail open.
  }
}

// Asked at most once per app session, so closing the sheet isn't nagged.
bool _campusRoleAsked = false;

/// Orija Campus: accounts made before sign-up asked "Are you a student here?"
/// (or whose answer couldn't be saved) have a school but no answer. Ask once.
Future<void> _askCampusRole(BuildContext context, SupabaseClient client) async {
  if (_campusRoleAsked) return;
  try {
    final res = await client.rpc('get_my_campus_status');
    if (res is! Map) return;
    if (res['institution_id'] == null || res['campus_role'] != null) return;
    if (!context.mounted) return;
    _campusRoleAsked = true;
    final school = (res['school_name'] as String?) ?? 'your school';
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CampusRoleSheet(school: school),
    );
    if (picked == null) return;
    final saved =
        await client.rpc('set_my_campus_role', params: {'p_role': picked});
    if (!context.mounted) return;
    final ok = saved is Map && saved['success'] == true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? 'Thanks, saved.'
            : "Couldn't save that. We'll ask again next time.")));
    if (!ok) _campusRoleAsked = false;
  } catch (_) {
    _campusRoleAsked = false;
  }
}

class _CampusRoleSheet extends StatefulWidget {
  const _CampusRoleSheet({required this.school});
  final String school;

  @override
  State<_CampusRoleSheet> createState() => _CampusRoleSheetState();
}

class _CampusRoleSheetState extends State<_CampusRoleSheet> {
  String _role = '';

  Widget _option(FlutterFlowTheme t, String value, IconData icon, String title,
      String subtitle) {
    final on = _role == value;
    return Material(
      color: on ? t.secondaryBackground : t.primaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            BorderSide(color: on ? t.primary : t.alternate, width: on ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _role = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            Icon(icon, color: t.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: t.titleSmall
                          .copyWith(color: t.primaryText, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: t.labelSmall),
                ],
              ),
            ),
            Icon(on ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: on ? t.primary : t.secondaryText, size: 22),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: t.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: t.alternate, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Are you a student at ${widget.school}?',
              style: t.titleMedium.copyWith(color: t.primaryText)),
          const SizedBox(height: 4),
          Text(
              'This decides the label on your store: ✓ Student once your ID is '
              'approved, or Nearby.',
              style: t.labelMedium),
          const SizedBox(height: 16),
          _option(t, 'student', Icons.school_outlined, 'Yes, I study here',
              'Verify your student ID from Profile'),
          const SizedBox(height: 8),
          _option(
              t,
              'nearby',
              Icons.storefront_outlined,
              "No, I'm near the school",
              'I live, work or run a business around it'),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24))),
              onPressed:
                  _role.isEmpty ? null : () => Navigator.of(context).pop(_role),
              child: Text('Save',
                  style: t.titleSmall.copyWith(color: Colors.white)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Not now', style: t.labelMedium),
          ),
        ],
      ),
    );
  }
}

/// Orija Campus: the school picked at sign-up is kept on the phone until the
/// account has a profile row, then saved to the account once (set_my_institution
/// also joins the school's community). Never blocks onboarding.
Future<void> _saveCampusSchool(SupabaseClient client) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('orija_campus_school_id') ?? '';
    if (id.isEmpty) return;
    final role = prefs.getString('orija_campus_role') ?? '';
    final res = await client.rpc('set_my_institution', params: {
      'p_institution_id': id,
      if (role == 'student' || role == 'nearby') 'p_campus_role': role,
    });
    final code = res is Map ? res['code'] as String? : null;
    final ok = res is Map && res['success'] == true;
    // Done: saved, or the account already has a school, or the school is gone.
    if (ok ||
        code == 'ALREADY_SET' ||
        code == 'NOT_FOUND' ||
        code == 'OTHER_SCHOOL_COMMUNITY') {
      await prefs.remove('orija_campus_school_id');
      await prefs.remove('orija_campus_school_name');
      await prefs.remove('orija_campus_role');
    }
  } catch (_) {
    // Try again next time onboarding runs.
  }
}
