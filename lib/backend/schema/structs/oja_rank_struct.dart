// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OjaRankStruct extends BaseStruct {
  OjaRankStruct({
    int? tier,
    String? title,
    int? points,
    String? nextTitle,
    int? pointsNext,
    int? pointsStart,
    double? progressPct,
  })  : _tier = tier,
        _title = title,
        _points = points,
        _nextTitle = nextTitle,
        _pointsNext = pointsNext,
        _pointsStart = pointsStart,
        _progressPct = progressPct;

  // "tier" field.
  int? _tier;
  int get tier => _tier ?? 0;
  set tier(int? val) => _tier = val;

  void incrementTier(int amount) => tier = tier + amount;

  bool hasTier() => _tier != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "points" field.
  int? _points;
  int get points => _points ?? 0;
  set points(int? val) => _points = val;

  void incrementPoints(int amount) => points = points + amount;

  bool hasPoints() => _points != null;

  // "next_title" field.
  String? _nextTitle;
  String get nextTitle => _nextTitle ?? '';
  set nextTitle(String? val) => _nextTitle = val;

  bool hasNextTitle() => _nextTitle != null;

  // "points_next" field.
  int? _pointsNext;
  int get pointsNext => _pointsNext ?? 0;
  set pointsNext(int? val) => _pointsNext = val;

  void incrementPointsNext(int amount) => pointsNext = pointsNext + amount;

  bool hasPointsNext() => _pointsNext != null;

  // "points_start" field.
  int? _pointsStart;
  int get pointsStart => _pointsStart ?? 0;
  set pointsStart(int? val) => _pointsStart = val;

  void incrementPointsStart(int amount) => pointsStart = pointsStart + amount;

  bool hasPointsStart() => _pointsStart != null;

  // "progress_pct" field.
  double? _progressPct;
  double get progressPct => _progressPct ?? 0.0;
  set progressPct(double? val) => _progressPct = val;

  void incrementProgressPct(double amount) =>
      progressPct = progressPct + amount;

  bool hasProgressPct() => _progressPct != null;

  static OjaRankStruct fromMap(Map<String, dynamic> data) => OjaRankStruct(
        tier: castToType<int>(data['tier']),
        title: data['title'] as String?,
        points: castToType<int>(data['points']),
        nextTitle: data['next_title'] as String?,
        pointsNext: castToType<int>(data['points_next']),
        pointsStart: castToType<int>(data['points_start']),
        progressPct: castToType<double>(data['progress_pct']),
      );

  static OjaRankStruct? maybeFromMap(dynamic data) =>
      data is Map ? OjaRankStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'tier': _tier,
        'title': _title,
        'points': _points,
        'next_title': _nextTitle,
        'points_next': _pointsNext,
        'points_start': _pointsStart,
        'progress_pct': _progressPct,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tier': serializeParam(
          _tier,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'points': serializeParam(
          _points,
          ParamType.int,
        ),
        'next_title': serializeParam(
          _nextTitle,
          ParamType.String,
        ),
        'points_next': serializeParam(
          _pointsNext,
          ParamType.int,
        ),
        'points_start': serializeParam(
          _pointsStart,
          ParamType.int,
        ),
        'progress_pct': serializeParam(
          _progressPct,
          ParamType.double,
        ),
      }.withoutNulls;

  static OjaRankStruct fromSerializableMap(Map<String, dynamic> data) =>
      OjaRankStruct(
        tier: deserializeParam(
          data['tier'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        points: deserializeParam(
          data['points'],
          ParamType.int,
          false,
        ),
        nextTitle: deserializeParam(
          data['next_title'],
          ParamType.String,
          false,
        ),
        pointsNext: deserializeParam(
          data['points_next'],
          ParamType.int,
          false,
        ),
        pointsStart: deserializeParam(
          data['points_start'],
          ParamType.int,
          false,
        ),
        progressPct: deserializeParam(
          data['progress_pct'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'OjaRankStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OjaRankStruct &&
        tier == other.tier &&
        title == other.title &&
        points == other.points &&
        nextTitle == other.nextTitle &&
        pointsNext == other.pointsNext &&
        pointsStart == other.pointsStart &&
        progressPct == other.progressPct;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [tier, title, points, nextTitle, pointsNext, pointsStart, progressPct]);
}

OjaRankStruct createOjaRankStruct({
  int? tier,
  String? title,
  int? points,
  String? nextTitle,
  int? pointsNext,
  int? pointsStart,
  double? progressPct,
}) =>
    OjaRankStruct(
      tier: tier,
      title: title,
      points: points,
      nextTitle: nextTitle,
      pointsNext: pointsNext,
      pointsStart: pointsStart,
      progressPct: progressPct,
    );
