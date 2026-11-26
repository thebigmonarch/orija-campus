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
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
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

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/component/reset_password_component/reset_password_component_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';

final String _kOrijaLogoDark =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/zwwd502l5bt6/OrijaLogo2.png';
final String _kOrijaLogoLight =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/jllbgd2olh64/OrijaLogoLightMode.png';

@override
Widget build(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final String logoUrl = isDarkMode ? _kOrijaLogoDark : _kOrijaLogoLight;

  return Image.network(logoUrl);
}

/// Log in and sign up with inline validation, password checklist, referral
/// code and forgot-password.
class OrijaAuth extends StatefulWidget {
  const OrijaAuth({
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
  State<OrijaAuth> createState() => _OrijaAuthState();
}

class _OrijaAuthState extends State<OrijaAuth> {
  final _formKeyUp = GlobalKey<FormState>();
  final _formKeyIn = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _referral = TextEditingController();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();

  bool _signUp = true;
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
    // The generated signup page wrapper always passes referralCode: '' --
    // it never actually forwards its own route's query params. Read ?ref=
    // straight off the route instead, so a direct link like
    // orija.app/signuppage?ref=CODE (e.g. from Share Profile) works.
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

  Future<void> _submitSignUp() async {
    if (_busy) return;
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

  // A page the viewer was on before being sent here to sign in/up (see
  // OrijaListingDetail/OrijaStorefront's _requireAuth). Consuming it routes
  // them back to where they came from instead of the default Home landing.
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

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8: pre-auth page, so centered only --
    // no OrijaDesktopShell chrome, since there's no account yet. Mobile
    // body below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _mobileBody(context),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: t.primaryBackground,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  _brand(t),
                  const SizedBox(height: 22),
                  _tabs(t),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _signUp ? _signUpForm(t) : _loginForm(t),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brand(FlutterFlowTheme t) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 48,
          child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/OrijaLogo2.png'
                  : 'assets/images/OrijaLogoLightMode.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.network(
                  Theme.of(context).brightness == Brightness.dark
                      ? _kOrijaLogoDark
                      : _kOrijaLogoLight,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text('orija.',
                      style: TextStyle(
                          color: t.primary,
                          fontSize: 34,
                          fontWeight: FontWeight.w800)))),
        ),
        const SizedBox(height: 8),
        Text('The Market Head',
            style: TextStyle(
                color: t.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _tabs(FlutterFlowTheme t) {
    Widget tab(String label, bool selected, VoidCallback onTap) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: selected ? t.primaryBackground : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: selected
                    ? [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2))
                      ]
                    : null,
              ),
              child: Center(
                child: Text(label,
                    style: TextStyle(
                        color: selected ? t.primary : t.secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ),
          ),
        );
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(13)),
      child: Row(
        children: [
          tab('Log In', !_signUp, () => setState(() => _signUp = false)),
          tab('Sign Up', _signUp, () => setState(() => _signUp = true)),
        ],
      ),
    );
  }

  InputDecoration _dec(FlutterFlowTheme t, String label,
      {IconData? icon, Widget? suffix, String? helper}) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: w));
    return InputDecoration(
      labelText: label,
      helperText: helper,
      helperMaxLines: 2,
      prefixIcon: icon == null ? null : Icon(icon, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: t.secondaryBackground,
      enabledBorder: b(t.alternate),
      focusedBorder: b(t.primary, 1.6),
      errorBorder: b(t.error),
      focusedErrorBorder: b(t.error, 1.6),
    );
  }

  String? _emailValidator(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter your email address';
    if (!_emailRe.hasMatch(s)) return 'That email does not look right';
    return null;
  }

  Widget _eye(bool shown, VoidCallback onTap) => IconButton(
        icon: Icon(
            shown ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20),
        onPressed: onTap,
      );

  Widget _button(FlutterFlowTheme t, String label, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: t.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: _busy ? null : onTap,
        child: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: Colors.white))
            : Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15.5)),
      ),
    );
  }

  // ---------------------------------------------------------------- sign up
  Widget _signUpForm(FlutterFlowTheme t) {
    return Form(
      key: _formKeyUp,
      child: AutofillGroup(
        child: Column(
          key: const ValueKey('signup'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get started',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Join the social market. Post. Sell. Earn trust.',
                style: TextStyle(color: t.secondaryText, fontSize: 14)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              validator: _emailValidator,
              decoration: _dec(t, 'Email', icon: Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _password,
              obscureText: !_showPw,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (_) => setState(() {}),
              validator: (v) => (v ?? '').isEmpty ? 'Create a password' : null,
              decoration: _dec(t, 'Password',
                  icon: Icons.lock_outline_rounded,
                  suffix:
                      _eye(_showPw, () => setState(() => _showPw = !_showPw))),
            ),
            if (_password.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _strength(t),
            ],
            const SizedBox(height: 14),
            TextFormField(
              controller: _confirm,
              obscureText: !_showConfirm,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if ((v ?? '').isEmpty) return 'Confirm your password';
                if (v != _password.text) return 'Passwords do not match';
                return null;
              },
              decoration: _dec(t, 'Confirm password',
                  icon: Icons.lock_reset_rounded,
                  suffix: _eye(_showConfirm,
                      () => setState(() => _showConfirm = !_showConfirm))),
            ),
            const SizedBox(height: 12),
            _referralField(t),
            const SizedBox(height: 20),
            _button(t, 'Create account', _submitSignUp),
            const SizedBox(height: 14),
            Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: t.secondaryText, fontSize: 12),
                  children: [
                    const TextSpan(text: 'By continuing you agree to our '),
                    TextSpan(
                      text: 'Terms and Privacy Policy',
                      style: TextStyle(
                          color: t.primary, fontWeight: FontWeight.w700),
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
                    style: TextStyle(color: t.primary, fontSize: 12.5)),
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
                  style: TextStyle(
                      color: ok ? t.primaryText : t.secondaryText,
                      fontSize: 12)),
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
        const SizedBox(height: 6),
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
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => setState(() => _showReferral = true),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('Have a referral code?',
                style: TextStyle(
                    color: t.primary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      );
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
    return TextFormField(
      controller: _referral,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
      ],
      onChanged: (_) => setState(() => _referralValid = null),
      onEditingComplete: _checkReferral,
      decoration: _dec(t, 'Referral code (optional)',
          icon: Icons.card_giftcard_rounded,
          suffix: status,
          helper: _referralValid == false
              ? 'We could not find that code.'
              : (_referralValid == true
                  ? 'Code applied to your new account.'
                  : null)),
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
            Text('Welcome back',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Pick up where you left and keep hustling.',
                style: TextStyle(color: t.secondaryText, fontSize: 14)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _loginEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              validator: _emailValidator,
              decoration: _dec(t, 'Email', icon: Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _loginPassword,
              obscureText: !_showLoginPw,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submitLogin(),
              validator: (v) =>
                  (v ?? '').isEmpty ? 'Enter your password' : null,
              decoration: _dec(t, 'Password',
                  icon: Icons.lock_outline_rounded,
                  suffix: _eye(_showLoginPw,
                      () => setState(() => _showLoginPw = !_showLoginPw))),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgot,
                child: Text('Forgot password?',
                    style: TextStyle(
                        color: t.primary, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 6),
            _button(t, 'Log In', _submitLogin),
          ],
        ),
      ),
    );
  }
}
