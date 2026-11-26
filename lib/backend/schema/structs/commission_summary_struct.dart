// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommissionSummaryStruct extends BaseStruct {
  CommissionSummaryStruct({
    int? lastMonth,
    int? totalPaid,
    int? entryCount,
    int? totalEarned,
    int? currentMonth,
    int? pendingPayout,
  })  : _lastMonth = lastMonth,
        _totalPaid = totalPaid,
        _entryCount = entryCount,
        _totalEarned = totalEarned,
        _currentMonth = currentMonth,
        _pendingPayout = pendingPayout;

  // "last_month" field.
  int? _lastMonth;
  int get lastMonth => _lastMonth ?? 0;
  set lastMonth(int? val) => _lastMonth = val;

  void incrementLastMonth(int amount) => lastMonth = lastMonth + amount;

  bool hasLastMonth() => _lastMonth != null;

  // "total_paid" field.
  int? _totalPaid;
  int get totalPaid => _totalPaid ?? 0;
  set totalPaid(int? val) => _totalPaid = val;

  void incrementTotalPaid(int amount) => totalPaid = totalPaid + amount;

  bool hasTotalPaid() => _totalPaid != null;

  // "entry_count" field.
  int? _entryCount;
  int get entryCount => _entryCount ?? 0;
  set entryCount(int? val) => _entryCount = val;

  void incrementEntryCount(int amount) => entryCount = entryCount + amount;

  bool hasEntryCount() => _entryCount != null;

  // "total_earned" field.
  int? _totalEarned;
  int get totalEarned => _totalEarned ?? 0;
  set totalEarned(int? val) => _totalEarned = val;

  void incrementTotalEarned(int amount) => totalEarned = totalEarned + amount;

  bool hasTotalEarned() => _totalEarned != null;

  // "current_month" field.
  int? _currentMonth;
  int get currentMonth => _currentMonth ?? 0;
  set currentMonth(int? val) => _currentMonth = val;

  void incrementCurrentMonth(int amount) =>
      currentMonth = currentMonth + amount;

  bool hasCurrentMonth() => _currentMonth != null;

  // "pending_payout" field.
  int? _pendingPayout;
  int get pendingPayout => _pendingPayout ?? 0;
  set pendingPayout(int? val) => _pendingPayout = val;

  void incrementPendingPayout(int amount) =>
      pendingPayout = pendingPayout + amount;

  bool hasPendingPayout() => _pendingPayout != null;

  static CommissionSummaryStruct fromMap(Map<String, dynamic> data) =>
      CommissionSummaryStruct(
        lastMonth: castToType<int>(data['last_month']),
        totalPaid: castToType<int>(data['total_paid']),
        entryCount: castToType<int>(data['entry_count']),
        totalEarned: castToType<int>(data['total_earned']),
        currentMonth: castToType<int>(data['current_month']),
        pendingPayout: castToType<int>(data['pending_payout']),
      );

  static CommissionSummaryStruct? maybeFromMap(dynamic data) => data is Map
      ? CommissionSummaryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'last_month': _lastMonth,
        'total_paid': _totalPaid,
        'entry_count': _entryCount,
        'total_earned': _totalEarned,
        'current_month': _currentMonth,
        'pending_payout': _pendingPayout,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'last_month': serializeParam(
          _lastMonth,
          ParamType.int,
        ),
        'total_paid': serializeParam(
          _totalPaid,
          ParamType.int,
        ),
        'entry_count': serializeParam(
          _entryCount,
          ParamType.int,
        ),
        'total_earned': serializeParam(
          _totalEarned,
          ParamType.int,
        ),
        'current_month': serializeParam(
          _currentMonth,
          ParamType.int,
        ),
        'pending_payout': serializeParam(
          _pendingPayout,
          ParamType.int,
        ),
      }.withoutNulls;

  static CommissionSummaryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CommissionSummaryStruct(
        lastMonth: deserializeParam(
          data['last_month'],
          ParamType.int,
          false,
        ),
        totalPaid: deserializeParam(
          data['total_paid'],
          ParamType.int,
          false,
        ),
        entryCount: deserializeParam(
          data['entry_count'],
          ParamType.int,
          false,
        ),
        totalEarned: deserializeParam(
          data['total_earned'],
          ParamType.int,
          false,
        ),
        currentMonth: deserializeParam(
          data['current_month'],
          ParamType.int,
          false,
        ),
        pendingPayout: deserializeParam(
          data['pending_payout'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CommissionSummaryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommissionSummaryStruct &&
        lastMonth == other.lastMonth &&
        totalPaid == other.totalPaid &&
        entryCount == other.entryCount &&
        totalEarned == other.totalEarned &&
        currentMonth == other.currentMonth &&
        pendingPayout == other.pendingPayout;
  }

  @override
  int get hashCode => const ListEquality().hash([
        lastMonth,
        totalPaid,
        entryCount,
        totalEarned,
        currentMonth,
        pendingPayout
      ]);
}

CommissionSummaryStruct createCommissionSummaryStruct({
  int? lastMonth,
  int? totalPaid,
  int? entryCount,
  int? totalEarned,
  int? currentMonth,
  int? pendingPayout,
}) =>
    CommissionSummaryStruct(
      lastMonth: lastMonth,
      totalPaid: totalPaid,
      entryCount: entryCount,
      totalEarned: totalEarned,
      currentMonth: currentMonth,
      pendingPayout: pendingPayout,
    );
