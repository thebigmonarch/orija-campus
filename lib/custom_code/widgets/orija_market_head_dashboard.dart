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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Hand-authored replacement for the generated MarketHeadDashboardPage.
/// Backend is untouched -- everything here already existed as real,
/// working RPCs (market_head_get_dashboard / _review_storefront /
/// _get_market_storefronts / _remove_storefront); this rebuilds the visual
/// layer: real stat tiles instead of a stacked-Container mess, a proper
/// 3-tab view, and live approve/reject/remove actions instead of static
/// placeholders. The 4th ("Market Info", editable profile) tab from the
/// original design doc is intentionally out of scope for this pass -- it
/// was documented there as read-only/future-phase even before this rebuild.
class OrijaMarketHeadDashboard extends StatefulWidget {
  const OrijaMarketHeadDashboard(
      {super.key, this.width, this.height, this.communityId});

  final double? width;
  final double? height;
  final String? communityId;

  @override
  State<OrijaMarketHeadDashboard> createState() =>
      _OrijaMarketHeadDashboardState();
}

class _OrijaMarketHeadDashboardState extends State<OrijaMarketHeadDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  // My Market tab
  List<Map<String, dynamic>> _storefronts = [];
  String _statusFilter = 'approved';
  final _searchController = TextEditingController();
  bool _loadingStorefronts = false;

  // Approvals multi-select
  final Set<String> _selectedApprovalIds = {};
  bool _batchApproving = false;

  // Stall Codes tab
  List<Map<String, dynamic>> _stallCodes = [];
  bool _loadingStallCodes = false;
  String _stallCodeStatusFilter = 'unused';
  final _codeCountController = TextEditingController(text: '10');
  final _codeLabelController = TextEditingController();
  bool _generatingCodes = false;

  // Students tab (school communities only): ID photos waiting for review.
  List<Map<String, dynamic>> _students = [];
  String _studentStatus = 'pending';
  bool _loadingStudents = false;
  bool _studentsLoaded = false;
  bool _studentsAreSchool = true;
  String? _studentsError;
  String? _reviewingId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      // Unconditional: the TabBar below no longer drives a TabBarView, so
      // nothing else rebuilds this widget when the selected tab changes --
      // this is what makes the newly selected tab's content actually show.
      if (mounted) setState(() {});
      if (!_tabController.indexIsChanging) return;
      if (_tabController.index == 1 && _storefronts.isEmpty) {
        _loadStorefronts();
      }
      if (_tabController.index == 3 && _stallCodes.isEmpty) {
        _loadStallCodes();
      }
      if (_tabController.index == 4 && !_studentsLoaded) {
        _loadStudents();
      }
      if (_tabController.index == 5 && !_reportsLoaded) {
        _loadReports();
      }
    });
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _codeCountController.dispose();
    _codeLabelController.dispose();
    super.dispose();
  }

  String get _communityId => widget.communityId ?? '';

  Future<void> _load() async {
    if (_communityId.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'No market selected.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_get_dashboard', params: {
        'p_head_user_id': currentUserUid,
        'p_community_id': _communityId,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _data = Map<String, dynamic>.from(res);
          _loading = false;
        });
        _loadAgentInfo();
      } else {
        setState(() {
          _loading = false;
          _error = res is Map && res['error'] == 'NOT_A_MARKET_HEAD'
              ? "You don't manage this market."
              : 'Could not load the dashboard.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No connection. Pull to refresh.';
      });
    }
  }

  // ------------------------------------------------ Reports (hostel inspections)
  // Problems students reported after an inspection. Refund = the agent didn't
  // show up (fee back to the student's wallet); Close = no refund. Suspend
  // hides an agent's hostels from students.

  bool _reportsLoaded = false;
  bool _reportsLoading = false;
  String? _reportsError;
  List<Map<String, dynamic>> _reports = [];
  final Set<String> _reportBusy = {};

  Future<void> _loadReports() async {
    setState(() {
      _reportsLoading = true;
      _reportsError = null;
    });
    try {
      final res = await Supabase.instance.client.rpc(
          'market_head_list_inspection_reports',
          params: {'p_community_id': _communityId});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _reports = [
            for (final r in (res['reports'] as List? ?? const []))
              Map<String, dynamic>.from(r as Map)
          ];
          _reportsLoaded = true;
          _reportsLoading = false;
        });
      } else {
        setState(() {
          _reportsLoading = false;
          _reportsError = 'Reports are only for school communities you head.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reportsLoading = false;
        _reportsError = 'Could not load reports. Check your connection.';
      });
    }
  }

  void _toastMsg(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<bool> _ask(String title, String body, String yes) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Back')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(yes)),
        ],
      ),
    );
    return r == true;
  }

  Future<void> _resolveReport(Map<String, dynamic> r, bool refund) async {
    final id = '${r['booking_id']}';
    final fee = '₦${r['fee']}';
    final ok = refund
        ? await _ask(
            'Refund the student?',
            'Use this when the agent didn’t show up. $fee goes back to the student’s wallet and comes out of the agent’s.',
            'Refund')
        : await _ask(
            'Close without a refund?',
            'Use this when the inspection did happen. The student is told the report was closed.',
            'Close report');
    if (!ok) return;
    setState(() => _reportBusy.add(id));
    try {
      final res = await Supabase.instance.client.rpc(
          'resolve_inspection_problem',
          params: {'p_booking_id': id, 'p_refund': refund});
      if (res is Map && res['success'] == true) {
        _toastMsg(refund ? 'Refunded to the student.' : 'Report closed.');
        await _loadReports();
      } else {
        _toastMsg(
            '${(res is Map ? res['message'] : null) ?? 'That didn’t work.'}');
      }
    } catch (_) {
      _toastMsg('Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _reportBusy.remove(id));
    }
  }

  Future<void> _setSuspended(Map<String, dynamic> r, bool suspend) async {
    final ok = await _ask(
        suspend ? 'Suspend ${r['agent']}?' : 'Restore ${r['agent']}?',
        suspend
            ? 'Their hostels are hidden and students can’t book them. Existing bookings stay. You can restore them later.'
            : 'Their hostels show to students again.',
        suspend ? 'Suspend' : 'Restore');
    if (!ok) return;
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_set_agent_suspended', params: {
        'p_storefront_id': r['storefront_id'],
        'p_community_id': _communityId,
        'p_suspend': suspend,
      });
      if (res is Map && res['success'] == true) {
        _toastMsg(suspend ? 'Agent suspended.' : 'Agent restored.');
        await _loadReports();
      } else {
        _toastMsg(
            '${(res is Map ? res['message'] : null) ?? 'That didn’t work.'}');
      }
    } catch (_) {
      _toastMsg('Check your connection and try again.');
    }
  }

  Widget _buildReports(FlutterFlowTheme theme) {
    if (_reportsLoading && !_reportsLoaded) {
      return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()));
    }
    if (_reportsError != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Text(_reportsError!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.secondaryText)),
          TextButton(onPressed: _loadReports, child: const Text('Try again')),
        ]),
      );
    }
    if (_reports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(children: [
          Icon(Icons.verified_user_outlined,
              size: 40, color: theme.secondaryText),
          const SizedBox(height: 8),
          Text('No inspection problems reported.',
              style: TextStyle(color: theme.secondaryText, fontSize: 13.5)),
        ]),
      );
    }
    return Column(children: [
      for (final r in _reports) _reportCard(theme, r),
    ]);
  }

  Widget _reportCard(FlutterFlowTheme theme, Map<String, dynamic> r) {
    final open = r['status'] == 'problem';
    final busy = _reportBusy.contains('${r['booking_id']}');
    final suspended = r['agent_status'] == 'rejected';
    final when = DateTime.tryParse('${r['slot_start'] ?? ''}')?.toLocal();
    final whenText = when == null
        ? ''
        : '${when.day}/${when.month} ${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}';
    final count = (r['agent_reports'] as num?)?.toInt() ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: open ? theme.error.withValues(alpha: 0.4) : theme.alternate),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text('${r['hostel']} · $whenText',
                style: TextStyle(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
          Text(open ? 'Open' : 'Resolved',
              style: TextStyle(
                  color: open ? theme.error : theme.secondaryText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Text('"${r['problem'] ?? ''}"',
            style: TextStyle(color: theme.primaryText, fontSize: 13)),
        const SizedBox(height: 6),
        Text(
            'Student: ${r['student']}${(r['student_phone'] ?? '').toString().isNotEmpty ? ' · ${r['student_phone']}' : ''}',
            style: TextStyle(color: theme.secondaryText, fontSize: 12)),
        Text(
            'Agent: ${r['agent']}${(r['agent_phone'] ?? '').toString().isNotEmpty ? ' · ${r['agent_phone']}' : ''}${count > 1 ? ' · $count reports' : ''}${suspended ? ' · Suspended' : ''}',
            style: TextStyle(
                color:
                    count > 1 || suspended ? theme.error : theme.secondaryText,
                fontSize: 12)),
        if (r['done_at'] == null && open)
          Text('The agent never marked it as done.',
              style: TextStyle(color: theme.secondaryText, fontSize: 12)),
        const SizedBox(height: 10),
        if (busy)
          const Center(child: CircularProgressIndicator())
        else
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (open)
              ElevatedButton(
                onPressed: () => _resolveReport(r, true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0),
                child: Text('Refund ₦${r['fee']}'),
              ),
            if (open)
              OutlinedButton(
                onPressed: () => _resolveReport(r, false),
                child: const Text('Close, no refund'),
              ),
            OutlinedButton(
              onPressed: () => _setSuspended(r, !suspended),
              style: OutlinedButton.styleFrom(
                  foregroundColor: suspended ? theme.primary : theme.error),
              child: Text(suspended ? 'Restore agent' : 'Suspend agent'),
            ),
          ]),
      ]),
    );
  }

  // Hostel agents among the pending approvals: areas, fees, association card.
  Map<String, Map<String, dynamic>> _agentInfo = {};

  Future<void> _loadAgentInfo() async {
    final ids = [
      for (final a in ((_data?['pending_approvals'] as List?) ?? const []))
        if (a is Map && a['storefront_id'] != null) '${a['storefront_id']}'
    ];
    if (ids.isEmpty) return;
    try {
      final res = await Supabase.instance.client.rpc(
          'market_head_get_agent_details',
          params: {'p_storefront_ids': ids});
      if (!mounted || res is! Map) return;
      setState(() => _agentInfo = {
            for (final e in res.entries)
              '${e.key}': Map<String, dynamic>.from(e.value as Map)
          });
    } catch (_) {}
  }

  Widget _agentBlock(FlutterFlowTheme theme, Map<String, dynamic> info) {
    final areas = ((info['areas'] as List?) ?? const []).join(', ');
    final fee = info['agent_fee_type'] == 'flat'
        ? '₦${info['agent_fee_value']}'
        : '${info['agent_fee_value']}% of rent';
    final card = (info['card_path'] as String?) ?? '';
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF4B39EF).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: const Color(0xFF4B39EF).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: const Color(0xFF4B39EF),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('Hostel agent',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('You approve the agent once, not each hostel.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 10.5)),
            ),
          ]),
          const SizedBox(height: 8),
          if ((info['office'] ?? '').toString().isNotEmpty)
            Text('Office: ${info['office']}',
                style: TextStyle(color: theme.primaryText, fontSize: 12)),
          if (areas.isNotEmpty)
            Text('Areas: $areas',
                style: TextStyle(color: theme.primaryText, fontSize: 12)),
          Text('Agent fee: $fee · Inspection: ₦${info['inspection_fee']}',
              style: TextStyle(color: theme.primaryText, fontSize: 12)),
          const SizedBox(height: 8),
          Text('Association card',
              style: TextStyle(
                  color: theme.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          if (card.isEmpty)
            Text('Not uploaded yet',
                style: TextStyle(color: theme.error, fontSize: 12))
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: _SignedIdImage(path: card, fit: BoxFit.contain),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadStorefronts() async {
    setState(() => _loadingStorefronts = true);
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_get_market_storefronts', params: {
        'p_head_user_id': currentUserUid,
        'p_status': _statusFilter,
        'p_search': _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _storefronts =
              List<Map<String, dynamic>>.from(res['items'] as List? ?? []);
          _loadingStorefronts = false;
        });
      } else {
        setState(() => _loadingStorefronts = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingStorefronts = false);
    }
  }

  Future<void> _review(String storefrontId, String action,
      {String? reason}) async {
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_review_storefront', params: {
        'p_head_user_id': currentUserUid,
        'p_community_id': _communityId,
        'p_storefront_id': storefrontId,
        'p_action': action,
        'p_reason': reason,
      });
      if (res is Map && res['success'] == true) {
        _load();
        _snack(action == 'approve'
            ? 'Storefront approved'
            : 'Storefront rejected');
      } else {
        _snack('Could not $action this storefront.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    }
  }

  Future<void> _remove(String storefrontId, String reason) async {
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_remove_storefront', params: {
        'p_head_user_id': currentUserUid,
        'p_storefront_id': storefrontId,
        'p_reason': reason,
      });
      if (res is Map && res['success'] == true) {
        _loadStorefronts();
        _snack('Removed from market');
      } else {
        _snack('Could not remove this storefront.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    }
  }

  Future<void> _batchApprove() async {
    if (_selectedApprovalIds.isEmpty) return;
    setState(() => _batchApproving = true);
    try {
      final res = await Supabase.instance.client
          .rpc('market_head_batch_approve', params: {
        'p_head_user_id': currentUserUid,
        'p_community_id': _communityId,
        'p_storefront_ids': _selectedApprovalIds.toList(),
      });
      if (res is Map && res['success'] == true) {
        final approved = res['approved_count'] ?? 0;
        final failed = res['failed_count'] ?? 0;
        _selectedApprovalIds.clear();
        _load();
        _snack(failed > 0
            ? '$approved approved, $failed failed'
            : '$approved storefront${approved == 1 ? '' : 's'} approved');
      } else {
        _snack('Could not approve the selected storefronts.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    } finally {
      if (mounted) setState(() => _batchApproving = false);
    }
  }

  Future<void> _loadStallCodes() async {
    setState(() => _loadingStallCodes = true);
    try {
      final res = await Supabase.instance.client
          .rpc('market_list_stall_codes', params: {
        'p_head_user_id': currentUserUid,
        'p_community_id': _communityId,
        'p_status':
            _stallCodeStatusFilter == 'all' ? null : _stallCodeStatusFilter,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _stallCodes =
              List<Map<String, dynamic>>.from(res['items'] as List? ?? []);
          _loadingStallCodes = false;
        });
      } else {
        setState(() => _loadingStallCodes = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingStallCodes = false);
    }
  }

  Future<void> _generateCodes() async {
    final count = int.tryParse(_codeCountController.text.trim()) ?? 0;
    if (count < 1 || count > 500) {
      _snack('Enter a count between 1 and 500.');
      return;
    }
    setState(() => _generatingCodes = true);
    try {
      final label = _codeLabelController.text.trim();
      final res = await Supabase.instance.client
          .rpc('market_generate_stall_codes', params: {
        'p_head_user_id': currentUserUid,
        'p_community_id': _communityId,
        'p_count': count,
        'p_label_prefix': label.isEmpty ? null : label,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        final codes =
            List<Map<String, dynamic>>.from(res['codes'] as List? ?? []);
        _loadStallCodes();
        await _showGeneratedCodesDialog(codes);
      } else {
        _snack('Could not generate codes.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    } finally {
      if (mounted) setState(() => _generatingCodes = false);
    }
  }

  Future<void> _showGeneratedCodesDialog(
      List<Map<String, dynamic>> codes) async {
    final theme = FlutterFlowTheme.of(context);
    final text = codes
        .map((c) => c['label'] != null
            ? '${c['code']}  (${c['label']})'
            : '${c['code']}')
        .join('\n');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text(
            '${codes.length} code${codes.length == 1 ? '' : 's'} generated',
            style: TextStyle(color: theme.primaryText)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(text,
                style: TextStyle(
                    color: theme.primaryText,
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.6)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              _snack('Copied to clipboard');
            },
            child: Text('Copy all', style: TextStyle(color: theme.secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Done', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _revokeCode(String id) async {
    try {
      final res = await Supabase.instance.client
          .rpc('market_revoke_stall_code', params: {
        'p_head_user_id': currentUserUid,
        'p_code_id': id,
      });
      if (res is Map && res['success'] == true) {
        _loadStallCodes();
        _snack('Code revoked');
      } else {
        _snack('Could not revoke this code.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _naira(num? v) {
    final n = (v ?? 0).round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  String _relativeTime(String? raw) {
    if (raw == null) return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'Just now';
  }

  Future<void> _confirmReject(String storefrontId) async {
    final controller = TextEditingController();
    final theme = FlutterFlowTheme.of(context);
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Reject storefront',
            style: TextStyle(color: theme.primaryText)),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          style: TextStyle(color: theme.primaryText),
          decoration: InputDecoration(
            hintText: 'Reason (required)',
            hintStyle: TextStyle(color: theme.secondaryText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: controller.text.trim().isEmpty
                ? null
                : () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Reject',
                style:
                    TextStyle(color: theme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (reason != null && reason.isNotEmpty)
      _review(storefrontId, 'reject', reason: reason);
  }

  Future<void> _confirmRemove(String storefrontId) async {
    final controller = TextEditingController();
    final theme = FlutterFlowTheme.of(context);
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Remove from market',
            style: TextStyle(color: theme.primaryText)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This storefront will lose its market badge and listing here.',
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: TextStyle(color: theme.secondaryText),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Remove',
                style:
                    TextStyle(color: theme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (reason != null) _remove(storefrontId, reason);
  }

  Widget _statTile(String label, String value, FlutterFlowTheme theme,
      {Color? accent}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: accent ?? theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 7 (Pattern E group, simple centered
    // treatment). Mobile body below is untouched; this gate is
    // unreachable on a real phone.
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
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Market Dashboard',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            tooltip: 'Edit community',
            icon: Icon(Icons.edit_outlined, color: theme.primaryText),
            onPressed: () async {
              final saved = await context.pushNamed('EditCommunityPage',
                  queryParameters: {
                    'communityId':
                        serializeParam(_communityId, ParamType.String),
                  }.withoutNulls);
              if (saved == true) _load();
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: theme.secondaryText)),
                          const SizedBox(height: 12),
                          TextButton(
                              onPressed: _load, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildHero(theme),
                              const SizedBox(height: 16),
                              _buildStats(theme),
                              const SizedBox(height: 16),
                              TabBar(
                                controller: _tabController,
                                labelColor: theme.primary,
                                unselectedLabelColor: theme.secondaryText,
                                indicatorColor: theme.primary,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                tabs: const [
                                  Tab(text: 'Approvals'),
                                  Tab(text: 'My Market'),
                                  Tab(text: 'Commission'),
                                  Tab(text: 'Stall Codes'),
                                  Tab(text: 'Students'),
                                  Tab(text: 'Reports'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // No TabBarView / fixed-size box: only the
                              // selected tab's content is built, sized to
                              // its own content, and scrolls as part of
                              // this same outer ListView -- not in its own
                              // nested scroll region, and never clipped
                              // regardless of how many rows it has.
                              switch (_tabController.index) {
                                0 => _buildApprovals(theme),
                                1 => _buildMyMarket(theme),
                                2 => _buildCommission(theme),
                                3 => _buildStallCodes(theme),
                                4 => _buildStudents(theme),
                                _ => _buildReports(theme),
                              },
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildHero(FlutterFlowTheme theme) {
    final market = (_data?['market'] as Map?) ?? {};
    final cover = market['cover_url'] as String?;
    final verified = market['is_verified'] == true;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 140,
        decoration: BoxDecoration(color: theme.alternate),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (cover != null && cover.isNotEmpty)
              Image.network(cover, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.45)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(market['name'] as String? ?? 'Your market',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ),
                      if (verified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded,
                            color: Colors.greenAccent, size: 18),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [market['city'], market['state']]
                        .where((e) => e != null && e != '')
                        .join(', '),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(FlutterFlowTheme theme) {
    final stats = (_data?['stats'] as Map?) ?? {};
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _statTile('Total Vendors', '${stats['total_vendors'] ?? 0}', theme),
        _statTile('Pending Approvals', '${stats['pending_count'] ?? 0}', theme,
            accent: (stats['pending_count'] ?? 0) > 0 ? theme.warning : null),
        _statTile(
            'Verified Vendors', '${stats['verified_vendors'] ?? 0}', theme),
        _statTile(
            'CAC Docs Pending', '${stats['pending_cac_docs'] ?? 0}', theme),
        _statTile(
            'This Month', _naira(stats['monthly_commission'] as num?), theme,
            accent: theme.primary),
        _statTile('Total Earned', _naira(stats['total_earned'] as num?), theme),
      ],
    );
  }

  Widget _buildApprovals(FlutterFlowTheme theme) {
    final approvals = List<Map<String, dynamic>>.from(
        (_data?['pending_approvals'] as List?) ?? []);
    if (approvals.isEmpty) {
      return Center(
        child: Text("No pending approvals — you're all caught up 🎉",
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.secondaryText)),
      );
    }
    return Column(
      children: [
        if (_selectedApprovalIds.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('${_selectedApprovalIds.length} selected',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedApprovalIds.clear()),
                  child: Text('Clear',
                      style: TextStyle(color: theme.secondaryText)),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: _batchApproving ? null : _batchApprove,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme.primary),
                  child: _batchApproving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text('Approve selected',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.5)),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              for (final a in approvals) ...[
                Builder(builder: (context) {
                  final owner = (a['owner'] as Map?) ?? {};
                  final cac = a['cac_document'] as Map?;
                  final id = a['storefront_id'] as String?;
                  final photo = a['application_photo_url'] as String?;
                  final stallCode = a['stall_code'] as Map?;
                  final referredBy = a['referred_by'] as Map?;
                  final selected =
                      id != null && _selectedApprovalIds.contains(id);
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selected ? theme.primary : theme.alternate,
                          width: selected ? 1.5 : 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: selected,
                              onChanged: id == null
                                  ? null
                                  : (v) => setState(() {
                                        if (v == true) {
                                          _selectedApprovalIds.add(id);
                                        } else {
                                          _selectedApprovalIds.remove(id);
                                        }
                                      }),
                              activeColor: theme.primary,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 4),
                            if (photo != null && photo.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(photo,
                                    width: 44, height: 44, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(a['name'] as String? ?? '',
                                            style: TextStyle(
                                                color: theme.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      ),
                                      if ((a['category'] as String? ?? '')
                                          .isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: theme.alternate,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(a['category'] as String,
                                              style: TextStyle(
                                                  color: theme.secondaryText,
                                                  fontSize: 10.5)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Owner: ${owner['name'] ?? '—'} · ${owner['phone'] ?? ''}',
                                      style: TextStyle(
                                          color: theme.secondaryText,
                                          fontSize: 12)),
                                  Text(
                                      'Joined ${_relativeTime(a['joined_at'] as String?)} · ${a['city'] ?? ''}',
                                      style: TextStyle(
                                          color: theme.secondaryText,
                                          fontSize: 12)),
                                  if (stallCode != null ||
                                      referredBy != null) ...[
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        if (stallCode != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: theme.secondary
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                'Code: ${stallCode['code'] ?? ''}${(stallCode['label'] as String? ?? '').isNotEmpty ? ' · ${stallCode['label']}' : ''}',
                                                style: TextStyle(
                                                    color: theme.secondary,
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        if (referredBy != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: theme.alternate,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                'Referred by ${referredBy['name'] ?? ''}',
                                                style: TextStyle(
                                                    color: theme.secondaryText,
                                                    fontSize: 10.5)),
                                          ),
                                      ],
                                    ),
                                  ],
                                  if (cac != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                        'CAC · Reg No: ${cac['reg_number'] ?? '—'}',
                                        style: TextStyle(
                                            color: theme.secondary,
                                            fontSize: 11.5)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (id != null && _agentInfo[id] != null)
                          _agentBlock(theme, _agentInfo[id]!),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: id == null
                                    ? null
                                    : () => _confirmReject(id),
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.error),
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: id == null
                                    ? null
                                    : () => _review(id, 'approve'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primary),
                                child: const Text('Approve',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyMarket(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onSubmitted: (_) => _loadStorefronts(),
          style: TextStyle(color: theme.primaryText),
          decoration: InputDecoration(
            hintText: 'Search vendors…',
            prefixIcon:
                Icon(Icons.search, color: theme.secondaryText, size: 18),
            isDense: true,
            filled: true,
            fillColor: theme.secondaryBackground,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.alternate)),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: [
            for (final s in ['approved', 'pending', 'rejected', 'all'])
              ChoiceChip(
                label: Text(s[0].toUpperCase() + s.substring(1)),
                selected: _statusFilter == s,
                onSelected: (_) {
                  setState(() => _statusFilter = s);
                  _loadStorefronts();
                },
                labelStyle: TextStyle(
                    fontSize: 11.5,
                    color:
                        _statusFilter == s ? theme.info : theme.secondaryText),
                backgroundColor: theme.secondaryBackground,
                selectedColor: theme.secondaryBackground,
                side: BorderSide(
                    color:
                        _statusFilter == s ? theme.primary : theme.alternate),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _loadingStorefronts
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _storefronts.isEmpty
                ? Center(
                    child: Text('No storefronts here yet.',
                        style: TextStyle(color: theme.secondaryText)))
                : Column(
                    children: [
                      for (final s in _storefronts) ...[
                        Builder(builder: (context) {
                          final owner = (s['owner'] as Map?) ?? {};
                          final id = s['storefront_id'] as String?;
                          final verified = s['badge_market'] == true;
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.alternate,
                                  backgroundImage: (s['logo_url'] as String? ??
                                              '')
                                          .isNotEmpty
                                      ? NetworkImage(s['logo_url'] as String)
                                      : null,
                                  child:
                                      (s['logo_url'] as String? ?? '').isEmpty
                                          ? Icon(Icons.storefront,
                                              color: theme.secondaryText,
                                              size: 16)
                                          : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                                s['name'] as String? ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: theme.primaryText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13)),
                                          ),
                                          if (verified) ...[
                                            const SizedBox(width: 4),
                                            Icon(Icons.verified_rounded,
                                                size: 14,
                                                color: theme.secondary),
                                          ],
                                        ],
                                      ),
                                      Text(
                                          '${owner['name'] ?? ''} · ${s['category'] ?? ''}',
                                          style: TextStyle(
                                              color: theme.secondaryText,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert,
                                      color: theme.secondaryText, size: 18),
                                  onSelected: (v) {
                                    if (v == 'remove' && id != null)
                                      _confirmRemove(id);
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                        value: 'remove',
                                        child: Text('Remove from Market')),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
      ],
    );
  }

  Widget _buildCommission(FlutterFlowTheme theme) {
    final summary = (_data?['commission_summary'] as Map?) ?? {};
    final breakdown = List<Map<String, dynamic>>.from(
        (_data?['commission_breakdown'] as List?) ?? []);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            _statTile(
                'This Month', _naira(summary['current_month'] as num?), theme,
                accent: theme.primary),
            _statTile(
                'Last Month', _naira(summary['last_month'] as num?), theme),
            _statTile('Pending Payout',
                _naira(summary['pending_payout'] as num?), theme,
                accent: theme.warning),
            _statTile(
                'All Time', _naira(summary['total_earned'] as num?), theme),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Orija pays out commissions monthly. Payouts are processed within the first 5 working days of the next month.',
            style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
          ),
        ),
        const SizedBox(height: 14),
        if (breakdown.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text('No commission records yet this month.',
                  style: TextStyle(color: theme.secondaryText)),
            ),
          )
        else
          for (final b in breakdown)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.alternate),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(b['storefront_name'] as String? ?? '',
                            style: TextStyle(
                                color: theme.primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        Text(b['subscription_tier'] as String? ?? '',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text(_naira(b['commission_amt'] as num?),
                      style: TextStyle(
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: b['status'] == 'paid'
                          ? theme.success.withValues(alpha: 0.15)
                          : theme.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      b['status'] == 'paid' ? 'Paid' : 'Pending',
                      style: TextStyle(
                          fontSize: 10.5,
                          color: b['status'] == 'paid'
                              ? theme.success
                              : theme.warning),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  // ------------------------------------------------------- Students (ID review)
  Future<void> _loadStudents() async {
    setState(() {
      _loadingStudents = true;
      _studentsError = null;
    });
    try {
      final res = await Supabase.instance.client
          .rpc('list_student_verifications', params: {
        'p_community_id': _communityId,
        'p_status': _studentStatus,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() {
          _studentsAreSchool = res['is_institution'] != false;
          _students = List<Map<String, dynamic>>.from(
              ((res['items'] as List?) ?? const [])
                  .map((e) => Map<String, dynamic>.from(e as Map)));
          _studentsLoaded = true;
        });
      } else {
        setState(() => _studentsError =
            (res is Map ? res['message'] as String? : null) ??
                "We couldn't load the student IDs.");
      }
    } catch (_) {
      if (mounted) {
        setState(() => _studentsError =
            "We couldn't load the student IDs. Check your connection.");
      }
    } finally {
      if (mounted) setState(() => _loadingStudents = false);
    }
  }

  Future<void> _reviewStudent(Map<String, dynamic> row,
      {required bool approve}) async {
    String? note;
    if (!approve) {
      final c = TextEditingController();
      note = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Why is this ID not accepted?'),
          content: TextField(
            controller: c,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'e.g. The photo is too blurry to read the name.',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: const Text('Reject ID'),
            ),
          ],
        ),
      );
      if (note == null) return;
      if (note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Add a reason so the student knows what to fix.')));
        return;
      }
    }
    setState(() => _reviewingId = row['id'].toString());
    try {
      final res = await Supabase.instance.client
          .rpc('review_student_verification', params: {
        'p_id': row['id'],
        'p_approve': approve,
        'p_note': note,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(approve ? 'Student verified.' : 'ID rejected.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((res is Map ? res['message'] as String? : null) ??
                "We couldn't save that. Please try again.")));
      }
      await _loadStudents();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("We couldn't save that. Check your connection.")));
      }
    } finally {
      if (mounted) setState(() => _reviewingId = null);
    }
  }

  void _openIdPhoto(String path) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                child: _SignedIdImage(path: path, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudents(FlutterFlowTheme theme) {
    final pending = _studentStatus == 'pending';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final s in const ['pending', 'approved', 'rejected'])
              ChoiceChip(
                label: Text(s == 'pending'
                    ? 'Waiting'
                    : s == 'approved'
                        ? 'Verified'
                        : 'Not accepted'),
                selected: _studentStatus == s,
                onSelected: (_) {
                  if (_studentStatus == s) return;
                  setState(() => _studentStatus = s);
                  _loadStudents();
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_loadingStudents)
          Padding(
            padding: const EdgeInsets.all(24),
            child:
                Center(child: CircularProgressIndicator(color: theme.primary)),
          )
        else if (_studentsError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_studentsError!,
                    style: TextStyle(color: theme.secondaryText)),
                TextButton(
                    onPressed: _loadStudents, child: const Text('Retry')),
              ],
            ),
          )
        else if (!_studentsAreSchool)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('Student ID review is only for school communities.',
                style: TextStyle(color: theme.secondaryText)),
          )
        else if (_students.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
                pending
                    ? 'No student IDs are waiting for review.'
                    : 'Nothing here yet.',
                style: TextStyle(color: theme.secondaryText)),
          )
        else
          for (final s in _students) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.alternate),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _openIdPhoto('${s['photo_path']}'),
                        borderRadius: BorderRadius.circular(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 96,
                            height: 64,
                            child: _SignedIdImage(
                                path: '${s['photo_path']}', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ('${s['name'] ?? ''}').trim().isEmpty
                                  ? 'Student'
                                  : '${s['name']}',
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text('${s['email'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.secondaryText, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              'Tap the photo to enlarge',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!pending &&
                      ('${s['review_note'] ?? ''}').trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Reason: ${s['review_note']}',
                        style: TextStyle(color: theme.secondaryText)),
                  ],
                  if (pending) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _reviewingId != null
                                ? null
                                : () => _reviewStudent(s, approve: false),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: theme.primary),
                            onPressed: _reviewingId != null
                                ? null
                                : () => _reviewStudent(s, approve: true),
                            child: _reviewingId == '${s['id']}'
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Verify student'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
      ],
    );
  }

  Widget _buildStallCodes(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.alternate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Print stall stickers',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
              const SizedBox(height: 2),
              Text(
                  'Generate short codes for a batch of stalls -- traders scan or type the code to apply instantly. You still approve every application.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _codeCountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: theme.primaryText),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Count',
                        filled: true,
                        fillColor: theme.primaryBackground,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _codeLabelController,
                      style: TextStyle(color: theme.primaryText),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Label prefix (optional)',
                        hintText: 'e.g. Row A',
                        filled: true,
                        fillColor: theme.primaryBackground,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generatingCodes ? null : _generateCodes,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme.primary),
                  child: _generatingCodes
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Generate codes',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          children: [
            for (final s in ['unused', 'used', 'revoked', 'all'])
              ChoiceChip(
                label: Text(s[0].toUpperCase() + s.substring(1)),
                selected: _stallCodeStatusFilter == s,
                onSelected: (_) {
                  setState(() => _stallCodeStatusFilter = s);
                  _loadStallCodes();
                },
                labelStyle: TextStyle(
                    fontSize: 11.5,
                    color: _stallCodeStatusFilter == s
                        ? theme.info
                        : theme.secondaryText),
                backgroundColor: theme.secondaryBackground,
                selectedColor: theme.secondaryBackground,
                side: BorderSide(
                    color: _stallCodeStatusFilter == s
                        ? theme.primary
                        : theme.alternate),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Plain, non-scrolling content -- this tab sits inside the
        // dashboard's own fixed-height TabBarView box, and an Expanded +
        // ListView here made the code list scroll independently within
        // that small box instead of flowing with the page's own scroll.
        _loadingStallCodes
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _stallCodes.isEmpty
                ? Center(
                    child: Text('No codes here yet.',
                        style: TextStyle(color: theme.secondaryText)))
                : Column(
                    children: [
                      for (final c in _stallCodes) ...[
                        Builder(builder: (context) {
                          final status = c['status'] as String? ?? 'unused';
                          final usedBy = c['used_by'] as Map?;
                          final code = c['code'] as String? ?? '';
                          final color = status == 'used'
                              ? theme.success
                              : status == 'revoked'
                                  ? theme.error
                                  : theme.secondary;
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(code,
                                              style: TextStyle(
                                                  color: theme.primaryText,
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1.5,
                                                  fontSize: 14)),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color:
                                                  color.withValues(alpha: 0.13),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                status[0].toUpperCase() +
                                                    status.substring(1),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: color)),
                                          ),
                                        ],
                                      ),
                                      if ((c['label'] as String? ?? '')
                                          .isNotEmpty)
                                        Text(c['label'] as String,
                                            style: TextStyle(
                                                color: theme.secondaryText,
                                                fontSize: 11)),
                                      if (usedBy != null)
                                        Text('Used by ${usedBy['name'] ?? ''}',
                                            style: TextStyle(
                                                color: theme.secondaryText,
                                                fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy_rounded,
                                      size: 16, color: theme.secondaryText),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: code));
                                    _snack('Copied');
                                  },
                                ),
                                if (status == 'unused')
                                  IconButton(
                                    icon: Icon(Icons.block_rounded,
                                        size: 16, color: theme.error),
                                    onPressed: () =>
                                        _revokeCode(c['id'] as String),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
      ],
    );
  }
}

/// A student ID photo from the private `student-ids` bucket, shown through a
/// short-lived signed link (the bucket is not public).
class _SignedIdImage extends StatefulWidget {
  const _SignedIdImage({required this.path, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  State<_SignedIdImage> createState() => _SignedIdImageState();
}

class _SignedIdImageState extends State<_SignedIdImage> {
  String? _url;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _sign();
  }

  Future<void> _sign() async {
    try {
      final u = await Supabase.instance.client.storage
          .from('student-ids')
          .createSignedUrl(widget.path, 600);
      if (mounted) setState(() => _url = u);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_failed) {
      return Container(
        color: t.alternate,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, color: t.secondaryText),
      );
    }
    if (_url == null) {
      return Container(
        color: t.alternate,
        alignment: Alignment.center,
        child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Image.network(
      _url!,
      fit: widget.fit,
      errorBuilder: (_, __, ___) => Container(
        color: t.alternate,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, color: t.secondaryText),
      ),
    );
  }
}
