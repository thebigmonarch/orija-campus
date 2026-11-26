// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MarketheadDashboardStruct extends BaseStruct {
  MarketheadDashboardStruct({
    HeadDashboardStruct? head,
    StatsStruct? stats,
    MarketStruct? market,
    bool? success,
    List<PendingApprovalsStruct>? pendingApprovals,
    List<RecentlyApprovedStruct>? recentlyApproved,
    CommissionSummaryStruct? commissionSummary,
    List<CommissionBreakdownStruct>? commissionBreakdown,
  })  : _head = head,
        _stats = stats,
        _market = market,
        _success = success,
        _pendingApprovals = pendingApprovals,
        _recentlyApproved = recentlyApproved,
        _commissionSummary = commissionSummary,
        _commissionBreakdown = commissionBreakdown;

  // "head" field.
  HeadDashboardStruct? _head;
  HeadDashboardStruct get head => _head ?? HeadDashboardStruct();
  set head(HeadDashboardStruct? val) => _head = val;

  void updateHead(Function(HeadDashboardStruct) updateFn) {
    updateFn(_head ??= HeadDashboardStruct());
  }

  bool hasHead() => _head != null;

  // "stats" field.
  StatsStruct? _stats;
  StatsStruct get stats => _stats ?? StatsStruct();
  set stats(StatsStruct? val) => _stats = val;

  void updateStats(Function(StatsStruct) updateFn) {
    updateFn(_stats ??= StatsStruct());
  }

  bool hasStats() => _stats != null;

  // "market" field.
  MarketStruct? _market;
  MarketStruct get market => _market ?? MarketStruct();
  set market(MarketStruct? val) => _market = val;

  void updateMarket(Function(MarketStruct) updateFn) {
    updateFn(_market ??= MarketStruct());
  }

  bool hasMarket() => _market != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "pending_approvals" field.
  List<PendingApprovalsStruct>? _pendingApprovals;
  List<PendingApprovalsStruct> get pendingApprovals =>
      _pendingApprovals ?? const [];
  set pendingApprovals(List<PendingApprovalsStruct>? val) =>
      _pendingApprovals = val;

  void updatePendingApprovals(Function(List<PendingApprovalsStruct>) updateFn) {
    updateFn(_pendingApprovals ??= []);
  }

  bool hasPendingApprovals() => _pendingApprovals != null;

  // "recently_approved" field.
  List<RecentlyApprovedStruct>? _recentlyApproved;
  List<RecentlyApprovedStruct> get recentlyApproved =>
      _recentlyApproved ?? const [];
  set recentlyApproved(List<RecentlyApprovedStruct>? val) =>
      _recentlyApproved = val;

  void updateRecentlyApproved(Function(List<RecentlyApprovedStruct>) updateFn) {
    updateFn(_recentlyApproved ??= []);
  }

  bool hasRecentlyApproved() => _recentlyApproved != null;

  // "commission_summary" field.
  CommissionSummaryStruct? _commissionSummary;
  CommissionSummaryStruct get commissionSummary =>
      _commissionSummary ?? CommissionSummaryStruct();
  set commissionSummary(CommissionSummaryStruct? val) =>
      _commissionSummary = val;

  void updateCommissionSummary(Function(CommissionSummaryStruct) updateFn) {
    updateFn(_commissionSummary ??= CommissionSummaryStruct());
  }

  bool hasCommissionSummary() => _commissionSummary != null;

  // "commission_breakdown" field.
  List<CommissionBreakdownStruct>? _commissionBreakdown;
  List<CommissionBreakdownStruct> get commissionBreakdown =>
      _commissionBreakdown ?? const [];
  set commissionBreakdown(List<CommissionBreakdownStruct>? val) =>
      _commissionBreakdown = val;

  void updateCommissionBreakdown(
      Function(List<CommissionBreakdownStruct>) updateFn) {
    updateFn(_commissionBreakdown ??= []);
  }

  bool hasCommissionBreakdown() => _commissionBreakdown != null;

  static MarketheadDashboardStruct fromMap(Map<String, dynamic> data) =>
      MarketheadDashboardStruct(
        head: data['head'] is HeadDashboardStruct
            ? data['head']
            : HeadDashboardStruct.maybeFromMap(data['head']),
        stats: data['stats'] is StatsStruct
            ? data['stats']
            : StatsStruct.maybeFromMap(data['stats']),
        market: data['market'] is MarketStruct
            ? data['market']
            : MarketStruct.maybeFromMap(data['market']),
        success: data['success'] as bool?,
        pendingApprovals: getStructList(
          data['pending_approvals'],
          PendingApprovalsStruct.fromMap,
        ),
        recentlyApproved: getStructList(
          data['recently_approved'],
          RecentlyApprovedStruct.fromMap,
        ),
        commissionSummary: data['commission_summary'] is CommissionSummaryStruct
            ? data['commission_summary']
            : CommissionSummaryStruct.maybeFromMap(data['commission_summary']),
        commissionBreakdown: getStructList(
          data['commission_breakdown'],
          CommissionBreakdownStruct.fromMap,
        ),
      );

  static MarketheadDashboardStruct? maybeFromMap(dynamic data) => data is Map
      ? MarketheadDashboardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'head': _head?.toMap(),
        'stats': _stats?.toMap(),
        'market': _market?.toMap(),
        'success': _success,
        'pending_approvals': _pendingApprovals?.map((e) => e.toMap()).toList(),
        'recently_approved': _recentlyApproved?.map((e) => e.toMap()).toList(),
        'commission_summary': _commissionSummary?.toMap(),
        'commission_breakdown':
            _commissionBreakdown?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'head': serializeParam(
          _head,
          ParamType.DataStruct,
        ),
        'stats': serializeParam(
          _stats,
          ParamType.DataStruct,
        ),
        'market': serializeParam(
          _market,
          ParamType.DataStruct,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'pending_approvals': serializeParam(
          _pendingApprovals,
          ParamType.DataStruct,
          isList: true,
        ),
        'recently_approved': serializeParam(
          _recentlyApproved,
          ParamType.DataStruct,
          isList: true,
        ),
        'commission_summary': serializeParam(
          _commissionSummary,
          ParamType.DataStruct,
        ),
        'commission_breakdown': serializeParam(
          _commissionBreakdown,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static MarketheadDashboardStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MarketheadDashboardStruct(
        head: deserializeStructParam(
          data['head'],
          ParamType.DataStruct,
          false,
          structBuilder: HeadDashboardStruct.fromSerializableMap,
        ),
        stats: deserializeStructParam(
          data['stats'],
          ParamType.DataStruct,
          false,
          structBuilder: StatsStruct.fromSerializableMap,
        ),
        market: deserializeStructParam(
          data['market'],
          ParamType.DataStruct,
          false,
          structBuilder: MarketStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        pendingApprovals: deserializeStructParam<PendingApprovalsStruct>(
          data['pending_approvals'],
          ParamType.DataStruct,
          true,
          structBuilder: PendingApprovalsStruct.fromSerializableMap,
        ),
        recentlyApproved: deserializeStructParam<RecentlyApprovedStruct>(
          data['recently_approved'],
          ParamType.DataStruct,
          true,
          structBuilder: RecentlyApprovedStruct.fromSerializableMap,
        ),
        commissionSummary: deserializeStructParam(
          data['commission_summary'],
          ParamType.DataStruct,
          false,
          structBuilder: CommissionSummaryStruct.fromSerializableMap,
        ),
        commissionBreakdown: deserializeStructParam<CommissionBreakdownStruct>(
          data['commission_breakdown'],
          ParamType.DataStruct,
          true,
          structBuilder: CommissionBreakdownStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MarketheadDashboardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MarketheadDashboardStruct &&
        head == other.head &&
        stats == other.stats &&
        market == other.market &&
        success == other.success &&
        listEquality.equals(pendingApprovals, other.pendingApprovals) &&
        listEquality.equals(recentlyApproved, other.recentlyApproved) &&
        commissionSummary == other.commissionSummary &&
        listEquality.equals(commissionBreakdown, other.commissionBreakdown);
  }

  @override
  int get hashCode => const ListEquality().hash([
        head,
        stats,
        market,
        success,
        const ListEquality().hash(pendingApprovals),
        const ListEquality().hash(recentlyApproved),
        commissionSummary,
        const ListEquality().hash(commissionBreakdown)
      ]);
}

MarketheadDashboardStruct createMarketheadDashboardStruct({
  HeadDashboardStruct? head,
  StatsStruct? stats,
  MarketStruct? market,
  bool? success,
  CommissionSummaryStruct? commissionSummary,
}) =>
    MarketheadDashboardStruct(
      head: head ?? HeadDashboardStruct(),
      stats: stats ?? StatsStruct(),
      market: market ?? MarketStruct(),
      success: success,
      commissionSummary: commissionSummary ?? CommissionSummaryStruct(),
    );
