// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StatsStruct extends BaseStruct {
  StatsStruct({
    double? totalEarned,
    int? pendingCount,
    int? totalVendors,
    int? rejectedCount,
    int? pendingCacDocs,
    int? verifiedVendors,
    double? monthlyCommission,
    int? unverifiedVendors,
    double? totalPendingPayout,
  })  : _totalEarned = totalEarned,
        _pendingCount = pendingCount,
        _totalVendors = totalVendors,
        _rejectedCount = rejectedCount,
        _pendingCacDocs = pendingCacDocs,
        _verifiedVendors = verifiedVendors,
        _monthlyCommission = monthlyCommission,
        _unverifiedVendors = unverifiedVendors,
        _totalPendingPayout = totalPendingPayout;

  // "total_earned" field.
  double? _totalEarned;
  double get totalEarned => _totalEarned ?? 0.0;
  set totalEarned(double? val) => _totalEarned = val;

  void incrementTotalEarned(double amount) =>
      totalEarned = totalEarned + amount;

  bool hasTotalEarned() => _totalEarned != null;

  // "pending_count" field.
  int? _pendingCount;
  int get pendingCount => _pendingCount ?? 0;
  set pendingCount(int? val) => _pendingCount = val;

  void incrementPendingCount(int amount) =>
      pendingCount = pendingCount + amount;

  bool hasPendingCount() => _pendingCount != null;

  // "total_vendors" field.
  int? _totalVendors;
  int get totalVendors => _totalVendors ?? 0;
  set totalVendors(int? val) => _totalVendors = val;

  void incrementTotalVendors(int amount) =>
      totalVendors = totalVendors + amount;

  bool hasTotalVendors() => _totalVendors != null;

  // "rejected_count" field.
  int? _rejectedCount;
  int get rejectedCount => _rejectedCount ?? 0;
  set rejectedCount(int? val) => _rejectedCount = val;

  void incrementRejectedCount(int amount) =>
      rejectedCount = rejectedCount + amount;

  bool hasRejectedCount() => _rejectedCount != null;

  // "pending_cac_docs" field.
  int? _pendingCacDocs;
  int get pendingCacDocs => _pendingCacDocs ?? 0;
  set pendingCacDocs(int? val) => _pendingCacDocs = val;

  void incrementPendingCacDocs(int amount) =>
      pendingCacDocs = pendingCacDocs + amount;

  bool hasPendingCacDocs() => _pendingCacDocs != null;

  // "verified_vendors" field.
  int? _verifiedVendors;
  int get verifiedVendors => _verifiedVendors ?? 0;
  set verifiedVendors(int? val) => _verifiedVendors = val;

  void incrementVerifiedVendors(int amount) =>
      verifiedVendors = verifiedVendors + amount;

  bool hasVerifiedVendors() => _verifiedVendors != null;

  // "monthly_commission" field.
  double? _monthlyCommission;
  double get monthlyCommission => _monthlyCommission ?? 0.0;
  set monthlyCommission(double? val) => _monthlyCommission = val;

  void incrementMonthlyCommission(double amount) =>
      monthlyCommission = monthlyCommission + amount;

  bool hasMonthlyCommission() => _monthlyCommission != null;

  // "unverified_vendors" field.
  int? _unverifiedVendors;
  int get unverifiedVendors => _unverifiedVendors ?? 0;
  set unverifiedVendors(int? val) => _unverifiedVendors = val;

  void incrementUnverifiedVendors(int amount) =>
      unverifiedVendors = unverifiedVendors + amount;

  bool hasUnverifiedVendors() => _unverifiedVendors != null;

  // "total_pending_payout" field.
  double? _totalPendingPayout;
  double get totalPendingPayout => _totalPendingPayout ?? 0.0;
  set totalPendingPayout(double? val) => _totalPendingPayout = val;

  void incrementTotalPendingPayout(double amount) =>
      totalPendingPayout = totalPendingPayout + amount;

  bool hasTotalPendingPayout() => _totalPendingPayout != null;

  static StatsStruct fromMap(Map<String, dynamic> data) => StatsStruct(
        totalEarned: castToType<double>(data['total_earned']),
        pendingCount: castToType<int>(data['pending_count']),
        totalVendors: castToType<int>(data['total_vendors']),
        rejectedCount: castToType<int>(data['rejected_count']),
        pendingCacDocs: castToType<int>(data['pending_cac_docs']),
        verifiedVendors: castToType<int>(data['verified_vendors']),
        monthlyCommission: castToType<double>(data['monthly_commission']),
        unverifiedVendors: castToType<int>(data['unverified_vendors']),
        totalPendingPayout: castToType<double>(data['total_pending_payout']),
      );

  static StatsStruct? maybeFromMap(dynamic data) =>
      data is Map ? StatsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'total_earned': _totalEarned,
        'pending_count': _pendingCount,
        'total_vendors': _totalVendors,
        'rejected_count': _rejectedCount,
        'pending_cac_docs': _pendingCacDocs,
        'verified_vendors': _verifiedVendors,
        'monthly_commission': _monthlyCommission,
        'unverified_vendors': _unverifiedVendors,
        'total_pending_payout': _totalPendingPayout,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'total_earned': serializeParam(
          _totalEarned,
          ParamType.double,
        ),
        'pending_count': serializeParam(
          _pendingCount,
          ParamType.int,
        ),
        'total_vendors': serializeParam(
          _totalVendors,
          ParamType.int,
        ),
        'rejected_count': serializeParam(
          _rejectedCount,
          ParamType.int,
        ),
        'pending_cac_docs': serializeParam(
          _pendingCacDocs,
          ParamType.int,
        ),
        'verified_vendors': serializeParam(
          _verifiedVendors,
          ParamType.int,
        ),
        'monthly_commission': serializeParam(
          _monthlyCommission,
          ParamType.double,
        ),
        'unverified_vendors': serializeParam(
          _unverifiedVendors,
          ParamType.int,
        ),
        'total_pending_payout': serializeParam(
          _totalPendingPayout,
          ParamType.double,
        ),
      }.withoutNulls;

  static StatsStruct fromSerializableMap(Map<String, dynamic> data) =>
      StatsStruct(
        totalEarned: deserializeParam(
          data['total_earned'],
          ParamType.double,
          false,
        ),
        pendingCount: deserializeParam(
          data['pending_count'],
          ParamType.int,
          false,
        ),
        totalVendors: deserializeParam(
          data['total_vendors'],
          ParamType.int,
          false,
        ),
        rejectedCount: deserializeParam(
          data['rejected_count'],
          ParamType.int,
          false,
        ),
        pendingCacDocs: deserializeParam(
          data['pending_cac_docs'],
          ParamType.int,
          false,
        ),
        verifiedVendors: deserializeParam(
          data['verified_vendors'],
          ParamType.int,
          false,
        ),
        monthlyCommission: deserializeParam(
          data['monthly_commission'],
          ParamType.double,
          false,
        ),
        unverifiedVendors: deserializeParam(
          data['unverified_vendors'],
          ParamType.int,
          false,
        ),
        totalPendingPayout: deserializeParam(
          data['total_pending_payout'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'StatsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StatsStruct &&
        totalEarned == other.totalEarned &&
        pendingCount == other.pendingCount &&
        totalVendors == other.totalVendors &&
        rejectedCount == other.rejectedCount &&
        pendingCacDocs == other.pendingCacDocs &&
        verifiedVendors == other.verifiedVendors &&
        monthlyCommission == other.monthlyCommission &&
        unverifiedVendors == other.unverifiedVendors &&
        totalPendingPayout == other.totalPendingPayout;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalEarned,
        pendingCount,
        totalVendors,
        rejectedCount,
        pendingCacDocs,
        verifiedVendors,
        monthlyCommission,
        unverifiedVendors,
        totalPendingPayout
      ]);
}

StatsStruct createStatsStruct({
  double? totalEarned,
  int? pendingCount,
  int? totalVendors,
  int? rejectedCount,
  int? pendingCacDocs,
  int? verifiedVendors,
  double? monthlyCommission,
  int? unverifiedVendors,
  double? totalPendingPayout,
}) =>
    StatsStruct(
      totalEarned: totalEarned,
      pendingCount: pendingCount,
      totalVendors: totalVendors,
      rejectedCount: rejectedCount,
      pendingCacDocs: pendingCacDocs,
      verifiedVendors: verifiedVendors,
      monthlyCommission: monthlyCommission,
      unverifiedVendors: unverifiedVendors,
      totalPendingPayout: totalPendingPayout,
    );
