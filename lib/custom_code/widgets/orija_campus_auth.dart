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

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/component/reset_password_component/reset_password_component_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';

/// The banner is always brown with light text, in light and dark mode, so its
/// text and drawing use fixed light colours instead of theme colours that turn
/// dark in dark mode.
const Color _kHeroCream = Color(0xFFFFF5EE);

/// A school students can pick when they sign up: a row in `institutions`.
/// `domain` is its first email domain (e.g. uniosun.edu.ng), used for the
/// email hint.
class _CampusSchool {
  const _CampusSchool(this.id, this.name, this.domain);
  final String id;
  final String name;
  final String? domain;
}

/// Orija Campus sign up and log in on one page, with tabs.
///
/// Sign up has two steps: pick your school, then email, password, confirm
/// password and an optional referral code. Picking a school moves to step 2.
class OrijaCampusAuth extends StatefulWidget {
  const OrijaCampusAuth({
    super.key,
    this.width,
    this.height,
    this.isSignUp,
    this.referralCode,
  });

  final double? width;
  final double? height;
  final bool? isSignUp;
  final String? referralCode;

  @override
  State<OrijaCampusAuth> createState() => _OrijaCampusAuthState();
}

class _OrijaCampusAuthState extends State<OrijaCampusAuth> {
  final _formKeyUp = GlobalKey<FormState>();
  final _formKeyIn = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _referral = TextEditingController();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();

  bool _signUp = true;
  _CampusSchool? _school;
  // Answer to "Are you a student here?": 'student', 'nearby' or '' (not yet).
  String _role = '';
  // Step 1 (school + question) is done and the details step is showing.
  bool _schoolDone = false;
  List<_CampusSchool> _schools = [];
  bool _loadingSchools = true;
  bool _showPw = false;
  bool _showConfirm = false;
  bool _showLoginPw = false;
  bool _busy = false;
  bool _showReferral = false;
  bool? _referralValid; // null = unchecked / empty
  bool _checkingReferral = false;

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  @override
  void initState() {
    super.initState();
    _signUp = widget.isSignUp ?? true;
    _loadSchools();
    // Read ?ref= straight off the route so a direct link such as
    // orija.app/signuppage?ref=CODE (from Share Profile) works.
    var ref = (widget.referralCode ?? '').trim();
    if (ref.isEmpty) {
      ref = (GoRouterState.of(context).uri.queryParameters['ref'] ?? '').trim();
    }
    if (ref.isNotEmpty) {
      _referral.text = ref.toUpperCase();
      _showReferral = true;
      _checkReferral();
    } else {
      _loadSavedReferral();
    }
  }

  // A code saved from a shared storefront link (see OrijaStorefront).
  Future<void> _loadSavedReferral() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('orija_pending_ref') ?? '';
      if (saved.isNotEmpty && mounted && _referral.text.isEmpty) {
        setState(() {
          _referral.text = saved;
          _showReferral = true;
        });
        _checkReferral();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _referral.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    super.dispose();
  }

  // Password rules shown as a checklist.
  bool get _hasLen => _password.text.length >= 8;
  bool get _hasUpper => RegExp(r'[A-Z]').hasMatch(_password.text);
  bool get _hasLower => RegExp(r'[a-z]').hasMatch(_password.text);
  bool get _hasDigit => RegExp(r'\d').hasMatch(_password.text);
  bool get _pwOk => _hasLen && _hasUpper && _hasLower && _hasDigit;
  int get _score =>
      [_hasLen, _hasUpper, _hasLower, _hasDigit].where((b) => b).length;

  // Brand brown reads well on light backgrounds; on dark ones the lighter tan
  // is used for text and icons so they stay readable.
  Color _accent(FlutterFlowTheme t) =>
      Theme.of(context).brightness == Brightness.dark ? t.tertiary : t.primary;

  Future<void> _checkReferral() async {
    final code = _referral.text.trim();
    if (code.isEmpty) {
      setState(() => _referralValid = null);
      return;
    }
    setState(() => _checkingReferral = true);
    try {
      final ok = await Supabase.instance.client
          .rpc('check_referral_code', params: {'p_code': code});
      if (!mounted) return;
      setState(() {
        _referralValid = ok == true;
        _checkingReferral = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _referralValid = null;
        _checkingReferral = false;
      });
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // The school list is every active row in `institutions`.
  Future<void> _loadSchools() async {
    setState(() => _loadingSchools = true);
    try {
      final rows = await Supabase.instance.client
          .from('institutions')
          .select('id,name,email_domains')
          .eq('status', 'active')
          .order('name');
      if (!mounted) return;
      setState(() {
        _schools = [
          for (final r in (rows as List))
            _CampusSchool(
              (r['id'] ?? '').toString(),
              (r['name'] ?? '').toString(),
              (r['email_domains'] is List &&
                      (r['email_domains'] as List).isNotEmpty)
                  ? (r['email_domains'] as List).first.toString()
                  : null,
            )
        ];
      });
    } catch (_) {
      if (mounted)
        _toast("We couldn't load the schools. Tap the field to try again.");
    } finally {
      if (mounted) setState(() => _loadingSchools = false);
    }
  }

  // The field was tapped while the list is empty.
  void _onNoSchools() {
    if (_loadingSchools) return;
    _toast('No schools are listed yet. Tap "Request it" to ask for yours.');
    _loadSchools();
  }

  void _onSchoolPicked(String name) {
    final match = _schools.where((s) => s.name == name);
    if (match.isNotEmpty && mounted) {
      setState(() => _school = match.first);
    }
  }

  void _requestSchool() =>
      context.pushNamed(RequestInstitutionWidget.routeName);

  Future<void> _submitSignUp() async {
    if (_busy) return;
    if (_school == null) {
      _toast('Pick your school first.');
      return;
    }
    if (_role.isEmpty) {
      setState(() => _schoolDone = false);
      _toast('Tell us if you are a student here.');
      return;
    }
    if (!(_formKeyUp.currentState?.validate() ?? false)) return;
    if (!_pwOk) {
      _toast('Choose a stronger password.');
      return;
    }
    if (_referral.text.trim().isNotEmpty && _referralValid == false) {
      _toast('That referral code was not found. Clear it or fix it.');
      return;
    }
    setState(() => _busy = true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final email = _email.text.trim();
      final user = await authManager.createAccountWithEmail(
          context, email, _password.text);
      if (user == null) return;
      // Remember the chosen school on this device until the backend has
      // somewhere to store it (never blocks sign-up).
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('orija_campus_school_id', _school!.id);
        await prefs.setString('orija_campus_school_name', _school!.name);
        await prefs.setString('orija_campus_role', _role);
      } catch (_) {}
      // Remember the referral for this account (never blocks sign-up).
      final code = _referral.text.trim();
      if (code.isNotEmpty && _referralValid != false) {
        try {
          await Supabase.instance.client.rpc('register_referral',
              params: {'p_email': email, 'p_code': code});
        } catch (_) {}
      }
      try {
        (await SharedPreferences.getInstance()).remove('orija_pending_ref');
      } catch (_) {}
      await actions.getOtp(email);
      if (!mounted) return;
      context.pushNamedAuth(
        ConfirmEmailWidget.routeName,
        context.mounted,
        queryParameters: {
          'email': serializeParam(email, ParamType.String),
        }.withoutNulls,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // A page the viewer was on before being sent here to sign in/up. Consuming
  // it routes them back to where they came from instead of the Home landing.
  Future<String?> _consumePendingRedirect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getString('orija_pending_redirect');
      if (v != null && v.isNotEmpty) {
        await prefs.remove('orija_pending_redirect');
        return v;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _submitLogin() async {
    if (_busy) return;
    if (!(_formKeyIn.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await authManager.signInWithEmail(
          context, _loginEmail.text.trim(), _loginPassword.text);
      if (user == null) return;
      if (!mounted) return;
      final pending = await _consumePendingRedirect();
      if (!mounted) return;
      if (pending != null) {
        context.go(pending);
      } else {
        context.goNamedAuth(HomePageWidget.routeName, context.mounted);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (ctx) => Padding(
        padding: MediaQuery.viewInsetsOf(ctx),
        child: ResetPasswordComponentWidget(email: _loginEmail.text.trim()),
      ),
    );
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    // Pre-auth page: centred on desktop, no desktop shell chrome.
    if (OrijaDesktopShell.isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _body(context),
        ),
      );
    }
    return _body(context);
  }

  Widget _body(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const heroBase = 168.0;
    const overlap = 24.0;
    final heroH = heroBase + topInset;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: t.primary,
        child: LayoutBuilder(
          builder: (context, c) {
            final viewport = c.maxHeight.isFinite ? c.maxHeight : 700.0;
            final sheetMin = math.max(0.0, viewport - (heroH - overlap));
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: heroH,
                    child: _hero(t, topInset),
                  ),
                  Column(
                    children: [
                      SizedBox(height: heroH - overlap),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: t.primaryBackground,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 8,
                                offset: const Offset(0, -2)),
                          ],
                        ),
                        padding:
                            EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight:
                                  math.max(0.0, sheetMin - 48 - bottomInset)),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _tabs(t),
                                const SizedBox(height: 16),
                                Expanded(
                                  child:
                                      _signUp ? _signUpForm(t) : _loginForm(t),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------------- hero
  Widget _hero(FlutterFlowTheme t, double topInset) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MarketStallPainter(
              cream: _kHeroCream,
              orange: t.secondary,
              tan: t.tertiary,
              brown: t.primary,
              topInset: topInset,
            ),
          ),
        ),
        Positioned(
          left: 24,
          top: 24 + topInset,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orija logo (transparent PNG: orange and white lettering that
              // reads on the brown banner). Falls back to the name as text.
              Semantics(
                label: 'Orija Campus',
                image: true,
                child: Image.network(
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/zwwd502l5bt6/OrijaLogo2.png',
                  height: 32,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (_, __, ___) => Text('Orija Campus',
                      style: t.titleSmall.copyWith(
                          color: _kHeroCream, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _signUp ? 'Your campus,\nyour market' : 'Welcome\nback',
                style: t.headlineMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------- tabs
  Widget _tabs(FlutterFlowTheme t) {
    final accent = _accent(t);
    Widget tab(String label, bool selected, VoidCallback onTap) => Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: selected ? accent : Colors.transparent, width: 3),
                ),
              ),
              child: Text(label,
                  style: (selected ? t.titleSmall : t.bodyLarge)
                      .copyWith(color: selected ? accent : t.secondaryText)),
            ),
          ),
        );
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.alternate, width: 1)),
      ),
      child: Row(
        children: [
          tab('Sign up', _signUp, () => setState(() => _signUp = true)),
          tab('Log in', !_signUp, () => setState(() => _signUp = false)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- helpers
  InputDecoration _dec(FlutterFlowTheme t, String hint, {Widget? suffix}) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c, width: w));
    return InputDecoration(
      hintText: hint,
      hintStyle: t.bodyMedium.copyWith(color: t.secondaryText),
      suffixIcon: suffix,
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

  Widget _labeled(FlutterFlowTheme t, String label, Widget field,
      {String? helper}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodyMedium),
        const SizedBox(height: 4),
        field,
        if (helper != null) ...[
          const SizedBox(height: 4),
          Text(helper, style: t.labelSmall),
        ],
      ],
    );
  }

  String? _emailValidator(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter your email address';
    if (!_emailRe.hasMatch(s)) return 'That email does not look right';
    return null;
  }

  Widget _eye(FlutterFlowTheme t, bool shown, VoidCallback onTap) => IconButton(
        icon: Icon(
            shown ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: t.secondaryText),
        onPressed: onTap,
      );

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

  Widget _linkButton(FlutterFlowTheme t, String label, VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: onTap,
        child: Text(label,
            style: t.titleSmall.copyWith(color: _accent(t), fontSize: 14)),
      ),
    );
  }

  // ---------------------------------------------------------------- sign up
  Widget _signUpForm(FlutterFlowTheme t) {
    return (_school == null || !_schoolDone) ? _schoolStep(t) : _detailsStep(t);
  }

  void _continueFromSchool() {
    if (_school == null) {
      _toast('Pick your school first.');
      return;
    }
    if (_role.isEmpty) {
      _toast('Tell us if you are a student here.');
      return;
    }
    setState(() => _schoolDone = true);
  }

  // One answer to "Are you a student here?".
  Widget _roleOption(FlutterFlowTheme t, String value, IconData icon,
      String title, String subtitle) {
    final on = _role == value;
    final accent = _accent(t);
    return Semantics(
      button: true,
      selected: on,
      child: Material(
        color: on ? t.secondaryBackground : t.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: on ? accent : t.alternate, width: on ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _role = value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: accent, size: 24),
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
                Icon(
                    on
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: on ? accent : t.secondaryText,
                    size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 1: pick a school, then answer "Are you a student here?".
  Widget _schoolStep(FlutterFlowTheme t) {
    return Column(
      key: const ValueKey('school'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeled(
          t,
          'Your school',
          _SearchDropdown(
            options: [for (final s in _schools) s.name],
            value: _school?.name,
            placeholder: 'Select your school',
            searchHint: 'Search schools',
            loading: _loadingSchools,
            onEmptyTap: _onNoSchools,
            leading: Icon(Icons.school_outlined, color: _accent(t), size: 24),
            onChanged: _onSchoolPicked,
          ),
        ),
        Text(
            'Not a student? Pick the school you live, work or run a business near.',
            style: t.labelSmall),
        _linkButton(t, "Can't find your school? Request it", _requestSchool),
        if (_school != null) ...[
          const SizedBox(height: 8),
          Text('Are you a student here?',
              style: t.bodyMedium.copyWith(color: t.primaryText)),
          const SizedBox(height: 8),
          _roleOption(t, 'student', Icons.school_outlined, 'Yes, I study here',
              "You'll verify your student ID after sign-up"),
          const SizedBox(height: 8),
          _roleOption(
              t,
              'nearby',
              Icons.storefront_outlined,
              "No, I'm near the school",
              'I live, work or run a business around it'),
          const Spacer(),
          const SizedBox(height: 16),
          _button(t, 'Continue', _continueFromSchool),
        ],
      ],
    );
  }

  // Step 2: email, password, confirm password and referral.
  Widget _detailsStep(FlutterFlowTheme t) {
    final school = _school!;
    final accent = _accent(t);
    final confirmText = _confirm.text;
    final matches = confirmText.isNotEmpty && confirmText == _password.text;
    final mismatch = confirmText.isNotEmpty && confirmText != _password.text;
    return Form(
      key: _formKeyUp,
      child: AutofillGroup(
        child: Column(
          key: const ValueKey('details'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, color: accent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(school.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelSmall.copyWith(
                          color: t.primaryText, fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () => setState(() => _schoolDone = false),
                  child: Text('Change',
                      style: t.labelSmall.copyWith(
                          color: accent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _labeled(
              t,
              'Email',
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                validator: _emailValidator,
                style: t.bodyMedium,
                decoration: _dec(
                    t,
                    school.domain != null
                        ? 'you@${school.domain}'
                        : 'you@school.edu.ng'),
              ),
              helper: _role == 'nearby'
                  ? 'Any email you use works.'
                  : (school.domain != null
                      ? 'Use your @${school.domain} email to be verified instantly.'
                      : 'Use your school email to be verified instantly.'),
            ),
            const SizedBox(height: 16),
            _labeled(
              t,
              'Password',
              TextFormField(
                controller: _password,
                obscureText: !_showPw,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                onChanged: (_) => setState(() {}),
                validator: (v) =>
                    (v ?? '').isEmpty ? 'Create a password' : null,
                style: t.bodyMedium,
                decoration: _dec(t, 'Create a password',
                    suffix: _eye(
                        t, _showPw, () => setState(() => _showPw = !_showPw))),
              ),
            ),
            if (_password.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _strength(t),
            ],
            const SizedBox(height: 16),
            _labeled(
              t,
              'Confirm password',
              TextFormField(
                controller: _confirm,
                obscureText: !_showConfirm,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Confirm your password';
                  if (v != _password.text) return 'Passwords do not match';
                  return null;
                },
                style: t.bodyMedium,
                decoration: _dec(t, 'Enter your password again',
                    suffix: _eye(t, _showConfirm,
                        () => setState(() => _showConfirm = !_showConfirm))),
              ),
            ),
            if (matches || mismatch) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(matches ? Icons.check_rounded : Icons.error_outline,
                      size: 16, color: matches ? t.success : t.error),
                  const SizedBox(width: 4),
                  Text(
                      matches
                          ? 'Passwords match'
                          : "Passwords don't match. Check both fields.",
                      style: t.labelSmall
                          .copyWith(color: matches ? t.primaryText : t.error)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            _referralField(t),
            const Spacer(),
            const SizedBox(height: 16),
            _button(t, 'Create account', _submitSignUp),
            const SizedBox(height: 8),
            Center(
              child: Text.rich(
                TextSpan(
                  style: t.labelSmall,
                  children: [
                    const TextSpan(text: 'By continuing you agree to our '),
                    TextSpan(
                      text: 'Terms and Privacy Policy',
                      style: t.labelSmall
                          .copyWith(color: accent, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () =>
                    context.pushNamed(LegalPrivacyWidget.routeName),
                child: Text('Read them',
                    style: t.labelSmall.copyWith(color: accent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _strength(FlutterFlowTheme t) {
    final colors = [t.error, t.error, t.warning, t.success, t.success];
    Widget rule(String text, bool ok) => Padding(
          padding: const EdgeInsets.only(right: 12, top: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ok ? Icons.check_circle : Icons.circle_outlined,
                  size: 14, color: ok ? t.success : t.secondaryText),
              const SizedBox(width: 4),
              Text(text,
                  style: t.labelSmall
                      .copyWith(color: ok ? t.primaryText : t.secondaryText)),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 4; i++)
              Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i == 3 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: i < _score ? colors[_score] : t.alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          children: [
            rule('8+ characters', _hasLen),
            rule('Uppercase', _hasUpper),
            rule('Lowercase', _hasLower),
            rule('Number', _hasDigit),
          ],
        ),
      ],
    );
  }

  Widget _referralField(FlutterFlowTheme t) {
    if (!_showReferral) {
      return _linkButton(t, 'Have a referral code?',
          () => setState(() => _showReferral = true));
    }
    Widget? status;
    if (_checkingReferral) {
      status = const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (_referralValid == true) {
      status = Icon(Icons.check_circle, color: t.success);
    } else if (_referralValid == false) {
      status = Icon(Icons.error_outline, color: t.error);
    }
    return _labeled(
      t,
      'Referral code (optional)',
      TextFormField(
        controller: _referral,
        textCapitalization: TextCapitalization.characters,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        ],
        onChanged: (_) => setState(() => _referralValid = null),
        onEditingComplete: _checkReferral,
        style: t.bodyMedium,
        decoration: _dec(t, "Enter a friend's code", suffix: status),
      ),
      helper: _referralValid == false
          ? 'We could not find that code.'
          : (_referralValid == true
              ? 'Code applied to your new account.'
              : null),
    );
  }

  // ---------------------------------------------------------------- log in
  Widget _loginForm(FlutterFlowTheme t) {
    return Form(
      key: _formKeyIn,
      child: AutofillGroup(
        child: Column(
          key: const ValueKey('login'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labeled(
              t,
              'Email',
              TextFormField(
                controller: _loginEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                validator: _emailValidator,
                style: t.bodyMedium,
                decoration: _dec(t, 'you@example.com'),
              ),
            ),
            const SizedBox(height: 16),
            _labeled(
              t,
              'Password',
              TextFormField(
                controller: _loginPassword,
                obscureText: !_showLoginPw,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submitLogin(),
                validator: (v) =>
                    (v ?? '').isEmpty ? 'Enter your password' : null,
                style: t.bodyMedium,
                decoration: _dec(t, 'Enter your password',
                    suffix: _eye(t, _showLoginPw,
                        () => setState(() => _showLoginPw = !_showLoginPw))),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: _forgot,
                child: Text('Forgot password?',
                    style:
                        t.titleSmall.copyWith(color: _accent(t), fontSize: 14)),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            _button(t, 'Log in', _submitLogin),
          ],
        ),
      ),
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

/// Brown hero art: notebook dots and a campus market stall with a school
/// pennant, a hanging price tag, goods on the counter and a shopping bag.
class _MarketStallPainter extends CustomPainter {
  _MarketStallPainter({
    required this.cream,
    required this.orange,
    required this.tan,
    required this.brown,
    required this.topInset,
  });

  final Color cream;
  final Color orange;
  final Color tan;
  final Color brown;
  final double topInset;

  @override
  void paint(Canvas canvas, Size size) {
    Paint fill(Color c) => Paint()..color = c;
    Paint line(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;

    // Notebook dots.
    final dots = fill(cream.withValues(alpha: 0.18));
    for (double x = 2; x < size.width; x += 16) {
      for (double y = 2; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 1.2, dots);
      }
    }

    // The art is drawn on a 390 x 168 board, pinned to the right.
    final s = size.width < 390 ? size.width / 390 : 1.0;
    canvas.save();
    canvas.translate(size.width - 390 * s, topInset);
    canvas.scale(s);

    canvas.drawCircle(
        const Offset(304, 72), 66, fill(orange.withValues(alpha: 0.35)));

    // Poles and school pennant.
    canvas.drawLine(
        const Offset(246, 62), const Offset(246, 130), line(tan, 4));
    canvas.drawLine(
        const Offset(346, 62), const Offset(346, 130), line(tan, 4));
    canvas.drawLine(const Offset(246, 40), const Offset(246, 20), line(tan, 3));
    canvas.drawPath(
      Path()
        ..moveTo(246, 20)
        ..lineTo(278, 28)
        ..lineTo(246, 36)
        ..close(),
      fill(cream),
    );

    // Striped awning with a scalloped edge.
    for (var i = 0; i < 6; i++) {
      final c = i.isEven ? cream : orange;
      canvas.drawRect(Rect.fromLTWH(240 + i * 18.7, 40, 18.7, 22), fill(c));
      canvas.drawCircle(Offset(249.3 + i * 18.7, 62), 9.3, fill(c));
    }

    // Hanging price tag.
    canvas.drawLine(
        const Offset(300, 72), const Offset(300, 82), line(cream, 1.5));
    canvas.drawPath(
      Path()
        ..moveTo(292, 82)
        ..lineTo(308, 82)
        ..lineTo(312, 90)
        ..lineTo(308, 98)
        ..lineTo(292, 98)
        ..close(),
      fill(cream),
    );
    canvas.drawCircle(const Offset(296, 87), 1.8, fill(brown));

    // Counter and goods.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(238, 110, 120, 20), const Radius.circular(4)),
      fill(cream),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(256, 94, 24, 16), const Radius.circular(3)),
      fill(tan),
    );
    canvas.drawCircle(const Offset(326, 100), 10, fill(orange));

    // Shopping bag with a handle.
    canvas.drawPath(
      Path()
        ..moveTo(338, 90)
        ..lineTo(374, 90)
        ..lineTo(371, 128)
        ..lineTo(341, 128)
        ..close(),
      fill(tan),
    );
    canvas.drawPath(
      Path()
        ..moveTo(347, 90)
        ..lineTo(347, 84)
        ..arcTo(Rect.fromCircle(center: const Offset(356, 84), radius: 9),
            math.pi, math.pi, false)
        ..lineTo(365, 90),
      line(cream, 3),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MarketStallPainter old) =>
      old.cream != cream ||
      old.orange != orange ||
      old.tan != tan ||
      old.brown != brown ||
      old.topInset != topInset;
}
