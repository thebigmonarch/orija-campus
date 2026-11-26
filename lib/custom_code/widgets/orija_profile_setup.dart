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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';

/// Onboarding "tell us about you" + "what interests you" step. Two pages:
/// name/state/LGA, then interest chips. No date of birth -- it isn't
/// collected anywhere in this flow (or anywhere else in the app) anymore.
class OrijaProfileSetup extends StatefulWidget {
  const OrijaProfileSetup({super.key});

  static String routeName = 'profileSetup';
  static String routePath = 'profileSetup';

  @override
  State<OrijaProfileSetup> createState() => _OrijaProfileSetupState();
}

class _OrijaProfileSetupState extends State<OrijaProfileSetup> {
  final _client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _first = TextEditingController();
  final _last = TextEditingController();

  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _lgas = [];
  String? _stateName;
  String? _stateId;
  String? _lgaName;
  bool _loadingLgas = false;
  // Persistent controllers: FlutterFlowDropDown subscribes to its
  // controller's listener exactly once, in initState. Rebuilding a fresh
  // FormFieldController on every build() (as the dropdowns below used to)
  // orphans that listener after the first rebuild, so no further selection
  // ever reaches onChanged -- the dropdown looks unselectable.
  final _stateCtrl = FormFieldController<String>(null);
  final _lgaCtrl = FormFieldController<String>(null);
  // Same reason: FlutterFlowChoiceChips reads its selection straight from
  // this controller every build, so a fresh `[]` literal here would make
  // a tapped chip appear to un-select itself on the very next frame.
  final _interestsCtrl = FormFieldController<List<String>>([]);

  List<Map<String, dynamic>> _categories = [];
  final _selectedInterests = <String>{};
  bool _loadingCategories = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
    _loadCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _first.dispose();
    _last.dispose();
    _stateCtrl.dispose();
    _lgaCtrl.dispose();
    _interestsCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStates() async {
    final rows = await _client.from('states').select('id, name').order('name');
    if (!mounted) return;
    setState(() => _states = List<Map<String, dynamic>>.from(rows));
    await _applySchoolLocation();
  }

  // Orija Campus: state and local government start from the school picked at
  // sign-up (institutions.state_id / local_government_id). Still editable.
  bool _fromSchool = false;
  Future<void>? _lgaLoad;

  Future<void> _applySchoolLocation() async {
    if (_stateName != null) return;
    try {
      var schoolId = '';
      try {
        final prefs = await SharedPreferences.getInstance();
        schoolId = prefs.getString('orija_campus_school_id') ?? '';
      } catch (_) {}
      if (schoolId.isEmpty) {
        final me = await _client
            .from('users')
            .select('institution_id')
            .eq('id', currentUserUid)
            .maybeSingle();
        schoolId = (me?['institution_id'] as String?) ?? '';
      }
      if (schoolId.isEmpty) return;
      final inst = await _client
          .from('institutions')
          .select('state_id, local_government_id')
          .eq('id', schoolId)
          .maybeSingle();
      final stateId = inst?['state_id'] as String?;
      final lgaId = inst?['local_government_id'] as String?;
      final state =
          _states.firstWhere((e) => e['id'] == stateId, orElse: () => const {});
      final stateName = state['name'] as String?;
      if (stateName == null || !mounted || _stateName != null) return;
      // The state dropdown's onChanged clears the local government, so it is
      // told to skip while these defaults are applied.
      _applyingDefaults = true;
      setState(() {
        _stateName = stateName;
        _stateId = stateId;
      });
      _stateCtrl.value = stateName;
      await _loadLgas(stateId!);
      if (!mounted) return;
      final lga =
          _lgas.firstWhere((e) => e['id'] == lgaId, orElse: () => const {});
      final lgaName = lga['name'] as String?;
      if (lgaName != null) {
        _lgaCtrl.value = lgaName;
        setState(() => _lgaName = lgaName);
      }
      setState(() => _fromSchool = true);
      await Future<void>.delayed(Duration.zero);
    } catch (_) {
      // Leave the fields empty; the user picks them as before.
    } finally {
      _applyingDefaults = false;
    }
  }

  bool _applyingDefaults = false;

  Future<void> _loadLgas(String stateId) async {
    setState(() => _loadingLgas = true);
    final rows = await _client
        .from('local_governments')
        .select('id, name')
        .eq('state_id', stateId)
        .order('name');
    if (!mounted) return;
    setState(() {
      _lgas = List<Map<String, dynamic>>.from(rows);
      _loadingLgas = false;
    });
  }

  Future<void> _loadCategories() async {
    final rows = await _client
        .from('categories')
        .select('slug, name')
        .isFilter('parent_slug', null)
        .order('name');
    if (!mounted) return;
    setState(() {
      _categories = List<Map<String, dynamic>>.from(rows);
      _loadingCategories = false;
    });
  }

  void _snack(String message, FlutterFlowTheme theme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: theme.secondary,
      ),
    );
  }

  Future<void> _next(FlutterFlowTheme theme) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    if (_stateName == null) {
      _snack('Select State', theme);
      return;
    }
    if (_lgaName == null) {
      _snack('Select Local Government', theme);
      return;
    }
    await _client.from('users').update({
      'first_name': _first.text,
      'last_name': _last.text,
      'state': _stateName,
      'city': _lgaName,
    }).eq('id', currentUserUid);
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> _finish(FlutterFlowTheme theme) async {
    if (_selectedInterests.length < 3) {
      _snack('Select at least 3 interests to continue.', theme);
      return;
    }
    setState(() => _saving = true);
    for (final slug in _selectedInterests) {
      await _client
          .from('user_interests')
          .insert({'user_id': currentUserUid, 'category': slug});
    }
    FFAppState().isProfileSet2 = true;
    if (!mounted) return;
    final upload = await _studentIdStep(theme);
    if (!mounted) return;
    context.pushNamed(HomePageWidget.routeName);
    if (upload) context.pushNamed('identificationVerificationPage');
  }

  /// Orija Campus: students who answered "Yes, I study here" at sign-up are
  /// asked to verify their student ID before Home. Skippable ("Do it later").
  /// Returns true when they chose to upload now. Never blocks onboarding.
  /// Saves the school (and the sign-up answer) picked at sign-up to the
  /// account now, so a school email can verify the student before the ID
  /// step. Same call guardOnboarding makes later; it is a no-op once saved.
  Future<void> _saveCampusSchool() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('orija_campus_school_id') ?? '';
      if (id.isEmpty) return;
      final role = prefs.getString('orija_campus_role') ?? '';
      final res = await _client.rpc('set_my_institution', params: {
        'p_institution_id': id,
        if (role == 'student' || role == 'nearby') 'p_campus_role': role,
      });
      final code = res is Map ? res['code'] as String? : null;
      if ((res is Map && res['success'] == true) ||
          code == 'ALREADY_SET' ||
          code == 'NOT_FOUND' ||
          code == 'OTHER_SCHOOL_COMMUNITY') {
        await prefs.remove('orija_campus_school_id');
        await prefs.remove('orija_campus_school_name');
        await prefs.remove('orija_campus_role');
      }
    } catch (_) {}
  }

  Future<bool> _studentIdStep(FlutterFlowTheme theme) async {
    var role = '';
    var school = 'your school';
    var emailVerified = false;
    await _saveCampusSchool();
    try {
      final res = await _client.rpc('get_my_campus_status');
      if (res is! Map) return false;
      // The ID card completes verification, even after a school email.
      final idStatus = res['verification_status'] as String?;
      if (idStatus == 'pending' || idStatus == 'approved') return false;
      emailVerified = res['email_verified'] == true;
      role = (res['campus_role'] as String?) ?? '';
      school = (res['school_name'] as String?) ?? school;
    } catch (_) {}
    // The school (and answer) may not be on the account yet: fall back to
    // what sign-up kept on this phone.
    if (role.isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        role = prefs.getString('orija_campus_role') ?? '';
        final name = prefs.getString('orija_campus_school_name') ?? '';
        if (name.isNotEmpty) school = name;
      } catch (_) {}
    }
    if (role != 'student' || !mounted) return false;
    final choice = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _StudentIdStepSheet(school: school, emailVerified: emailVerified),
    );
    return choice == true;
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8: pre-auth/onboarding page, so
    // centered only -- no OrijaDesktopShell chrome yet. Mobile body below
    // is untouched; this gate is unreachable on a real phone.
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
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
            child: Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (_) => setState(() {}),
                  children: [
                    _namePage(theme),
                    _interestsPage(theme),
                  ],
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                    child: smooth_page_indicator.SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      onDotClicked: (i) => _pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      ),
                      effect: smooth_page_indicator.SlideEffect(
                        spacing: 8,
                        radius: 8,
                        dotWidth: 8,
                        dotHeight: 8,
                        dotColor: theme.tertiary,
                        activeDotColor: theme.secondary,
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namePage(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tell us about you',
              style: theme.bodyMedium.override(
                font: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _first,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(theme, 'First Name'),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'First Name is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _last,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: _fieldDecoration(theme, 'Last Name'),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Last Name is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  FlutterFlowDropDown<String>(
                    controller: _stateCtrl,
                    options: _states.map((e) => e['name'] as String).toList(),
                    onChanged: (val) {
                      if (_applyingDefaults) return;
                      setState(() {
                        _stateName = val;
                        _lgaName = null;
                        _lgas = [];
                        _fromSchool = false;
                      });
                      _lgaCtrl.value = null;
                      final match = _states.firstWhere((e) => e['name'] == val,
                          orElse: () => const {});
                      final id = match['id'] as String?;
                      setState(() => _stateId = id);
                      if (id != null) _lgaLoad = _loadLgas(id);
                    },
                    width: double.infinity,
                    height: 48,
                    textStyle: TextStyle(color: theme.primaryText),
                    hintText: 'Select State',
                    searchHintText: 'Search...',
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText, size: 24),
                    fillColor: theme.secondaryBackground,
                    elevation: 2,
                    borderColor: theme.alternate,
                    borderWidth: 0,
                    borderRadius: 8,
                    margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    hidesUnderline: true,
                    isSearchable: true,
                  ),
                  if (_stateId != null) ...[
                    const SizedBox(height: 20),
                    _loadingLgas
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator())),
                          )
                        : FlutterFlowDropDown<String>(
                            controller: _lgaCtrl,
                            options:
                                _lgas.map((e) => e['name'] as String).toList(),
                            onChanged: (val) => setState(() => _lgaName = val),
                            width: double.infinity,
                            height: 48,
                            textStyle: TextStyle(color: theme.primaryText),
                            hintText: 'Select Local Government',
                            searchHintText: 'Search...',
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: theme.secondaryText, size: 24),
                            fillColor: theme.secondaryBackground,
                            elevation: 2,
                            borderColor: theme.alternate,
                            borderWidth: 0,
                            borderRadius: 8,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 12, 0),
                            hidesUnderline: true,
                            isSearchable: true,
                          ),
                    if (_fromSchool) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.school_outlined,
                              size: 16, color: theme.secondaryText),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Filled in from your school. Not where you live? Change it above.',
                                style: TextStyle(
                                    color: theme.secondaryText,
                                    fontSize: 12,
                                    height: 1.35)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: FFButtonWidget(
              onPressed: () => _next(theme),
              text: 'Next',
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                color: theme.primary,
                textStyle: theme.titleSmall.override(
                  color: Colors.white,
                  fontSize: 14,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(FlutterFlowTheme theme, String hint) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        );
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(color: theme.secondaryText),
      enabledBorder: border(theme.alternate),
      focusedBorder: border(theme.secondary),
      errorBorder: border(theme.error),
      focusedErrorBorder: border(theme.error),
      filled: true,
      fillColor: theme.secondaryBackground,
    );
  }

  Widget _interestsPage(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What interests you?',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 10),
                  Text("We'll personalize your market experience.",
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.outfit(),
                        fontSize: 14,
                      )),
                  const SizedBox(height: 30),
                  _loadingCategories
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FlutterFlowChoiceChips(
                          options: _categories
                              .map((e) => ChipData(e['name'] as String))
                              .toList(),
                          onChanged: (val) => setState(() {
                            _selectedInterests
                              ..clear()
                              ..addAll((val ?? []).map((name) =>
                                  _categories.firstWhere(
                                          (c) => c['name'] == name)['slug']
                                      as String));
                          }),
                          selectedChipStyle: ChipStyle(
                            backgroundColor: theme.secondaryBackground,
                            textStyle: TextStyle(color: theme.primaryText),
                            iconColor: theme.info,
                            iconSize: 16,
                            elevation: 0,
                            borderColor: theme.secondary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: theme.secondaryBackground,
                            textStyle: TextStyle(color: theme.secondaryText),
                            iconColor: theme.secondaryText,
                            iconSize: 16,
                            elevation: 0,
                            borderColor: theme.alternate,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          chipSpacing: 8,
                          rowSpacing: 8,
                          multiselect: true,
                          alignment: WrapAlignment.start,
                          controller: _interestsCtrl,
                          wrapped: true,
                        ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2))
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outlined, color: theme.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        'Select at least 3 interests to personalize your experience.',
                        style: TextStyle(color: theme.secondaryText)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FFButtonWidget(
              onPressed: _saving ? null : () => _finish(theme),
              text: 'Finish Setup',
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                color: theme.primary,
                textStyle: theme.titleSmall.override(
                  color: Colors.white,
                  fontSize: 14,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Verify you're a student": shown once after profile setup to students.
class _StudentIdStepSheet extends StatelessWidget {
  const _StudentIdStepSheet({required this.school, this.emailVerified = false});
  final String school;
  // Already verified instantly by school email; the ID card completes it.
  final bool emailVerified;

  Widget _perk(FlutterFlowTheme t, IconData icon, String title, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: t.success, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: t.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(sub, style: t.labelSmall),
            ],
          ),
        ),
      ],
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
          24, 24, 24, 16 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                  emailVerified
                      ? '✓ Verified by your school email'
                      : 'Last step for students',
                  style: t.labelSmall.copyWith(
                      color: emailVerified ? t.success : t.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
              emailVerified
                  ? 'Complete your verification'
                  : "Verify you're a student",
              style: t.headlineSmall.copyWith(color: t.primaryText)),
          const SizedBox(height: 8),
          Text(
              emailVerified
                  ? 'Your ✓ Student badge is already on. Upload a photo of your '
                      '$school ID card to complete your verification. The Market '
                      'Head checks it, usually within a day or two.'
                  : 'Upload a photo of your $school ID card. The Market Head checks '
                      'it, usually within a day or two.',
              style: t.labelMedium),
          const SizedBox(height: 24),
          Text('What you get',
              style: t.titleSmall.copyWith(color: t.primaryText)),
          const SizedBox(height: 12),
          _perk(t, Icons.verified_user_outlined, '✓ Student label',
              'On your profile and on your store when you open one'),
          const SizedBox(height: 12),
          _perk(t, Icons.add_circle_outline, 'Trade fair spots',
              'Only verified students can book a table'),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24))),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Upload student ID',
                  style: t.titleSmall.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Do it later from Profile',
                style: t.titleSmall.copyWith(color: t.primary, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
