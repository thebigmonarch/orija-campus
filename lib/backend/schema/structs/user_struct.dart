// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    int? ojaTier,
    String? lastName,
    String? avatarUrl,
    String? firstName,
    int? ojaPoints,
    double? progressPct,
    String? ojaTierTitle,
    String? ojaTierNextTitle,
    int? pointsToNextTier,
    int? ojaTierPointsNext,
    int? ojaTierPointsStart,
  })  : _ojaTier = ojaTier,
        _lastName = lastName,
        _avatarUrl = avatarUrl,
        _firstName = firstName,
        _ojaPoints = ojaPoints,
        _progressPct = progressPct,
        _ojaTierTitle = ojaTierTitle,
        _ojaTierNextTitle = ojaTierNextTitle,
        _pointsToNextTier = pointsToNextTier,
        _ojaTierPointsNext = ojaTierPointsNext,
        _ojaTierPointsStart = ojaTierPointsStart;

  // "oja_tier" field.
  int? _ojaTier;
  int get ojaTier => _ojaTier ?? 0;
  set ojaTier(int? val) => _ojaTier = val;

  void incrementOjaTier(int amount) => ojaTier = ojaTier + amount;

  bool hasOjaTier() => _ojaTier != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "avatar_url" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "first_name" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  // "oja_points" field.
  int? _ojaPoints;
  int get ojaPoints => _ojaPoints ?? 0;
  set ojaPoints(int? val) => _ojaPoints = val;

  void incrementOjaPoints(int amount) => ojaPoints = ojaPoints + amount;

  bool hasOjaPoints() => _ojaPoints != null;

  // "progress_pct" field.
  double? _progressPct;
  double get progressPct => _progressPct ?? 0.0;
  set progressPct(double? val) => _progressPct = val;

  void incrementProgressPct(double amount) =>
      progressPct = progressPct + amount;

  bool hasProgressPct() => _progressPct != null;

  // "oja_tier_title" field.
  String? _ojaTierTitle;
  String get ojaTierTitle => _ojaTierTitle ?? '';
  set ojaTierTitle(String? val) => _ojaTierTitle = val;

  bool hasOjaTierTitle() => _ojaTierTitle != null;

  // "oja_tier_next_title" field.
  String? _ojaTierNextTitle;
  String get ojaTierNextTitle => _ojaTierNextTitle ?? '';
  set ojaTierNextTitle(String? val) => _ojaTierNextTitle = val;

  bool hasOjaTierNextTitle() => _ojaTierNextTitle != null;

  // "points_to_next_tier" field.
  int? _pointsToNextTier;
  int get pointsToNextTier => _pointsToNextTier ?? 0;
  set pointsToNextTier(int? val) => _pointsToNextTier = val;

  void incrementPointsToNextTier(int amount) =>
      pointsToNextTier = pointsToNextTier + amount;

  bool hasPointsToNextTier() => _pointsToNextTier != null;

  // "oja_tier_points_next" field.
  int? _ojaTierPointsNext;
  int get ojaTierPointsNext => _ojaTierPointsNext ?? 0;
  set ojaTierPointsNext(int? val) => _ojaTierPointsNext = val;

  void incrementOjaTierPointsNext(int amount) =>
      ojaTierPointsNext = ojaTierPointsNext + amount;

  bool hasOjaTierPointsNext() => _ojaTierPointsNext != null;

  // "oja_tier_points_start" field.
  int? _ojaTierPointsStart;
  int get ojaTierPointsStart => _ojaTierPointsStart ?? 0;
  set ojaTierPointsStart(int? val) => _ojaTierPointsStart = val;

  void incrementOjaTierPointsStart(int amount) =>
      ojaTierPointsStart = ojaTierPointsStart + amount;

  bool hasOjaTierPointsStart() => _ojaTierPointsStart != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        ojaTier: castToType<int>(data['oja_tier']),
        lastName: data['last_name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        firstName: data['first_name'] as String?,
        ojaPoints: castToType<int>(data['oja_points']),
        progressPct: castToType<double>(data['progress_pct']),
        ojaTierTitle: data['oja_tier_title'] as String?,
        ojaTierNextTitle: data['oja_tier_next_title'] as String?,
        pointsToNextTier: castToType<int>(data['points_to_next_tier']),
        ojaTierPointsNext: castToType<int>(data['oja_tier_points_next']),
        ojaTierPointsStart: castToType<int>(data['oja_tier_points_start']),
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'oja_tier': _ojaTier,
        'last_name': _lastName,
        'avatar_url': _avatarUrl,
        'first_name': _firstName,
        'oja_points': _ojaPoints,
        'progress_pct': _progressPct,
        'oja_tier_title': _ojaTierTitle,
        'oja_tier_next_title': _ojaTierNextTitle,
        'points_to_next_tier': _pointsToNextTier,
        'oja_tier_points_next': _ojaTierPointsNext,
        'oja_tier_points_start': _ojaTierPointsStart,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'oja_tier': serializeParam(
          _ojaTier,
          ParamType.int,
        ),
        'last_name': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'avatar_url': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'first_name': serializeParam(
          _firstName,
          ParamType.String,
        ),
        'oja_points': serializeParam(
          _ojaPoints,
          ParamType.int,
        ),
        'progress_pct': serializeParam(
          _progressPct,
          ParamType.double,
        ),
        'oja_tier_title': serializeParam(
          _ojaTierTitle,
          ParamType.String,
        ),
        'oja_tier_next_title': serializeParam(
          _ojaTierNextTitle,
          ParamType.String,
        ),
        'points_to_next_tier': serializeParam(
          _pointsToNextTier,
          ParamType.int,
        ),
        'oja_tier_points_next': serializeParam(
          _ojaTierPointsNext,
          ParamType.int,
        ),
        'oja_tier_points_start': serializeParam(
          _ojaTierPointsStart,
          ParamType.int,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        ojaTier: deserializeParam(
          data['oja_tier'],
          ParamType.int,
          false,
        ),
        lastName: deserializeParam(
          data['last_name'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatar_url'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['first_name'],
          ParamType.String,
          false,
        ),
        ojaPoints: deserializeParam(
          data['oja_points'],
          ParamType.int,
          false,
        ),
        progressPct: deserializeParam(
          data['progress_pct'],
          ParamType.double,
          false,
        ),
        ojaTierTitle: deserializeParam(
          data['oja_tier_title'],
          ParamType.String,
          false,
        ),
        ojaTierNextTitle: deserializeParam(
          data['oja_tier_next_title'],
          ParamType.String,
          false,
        ),
        pointsToNextTier: deserializeParam(
          data['points_to_next_tier'],
          ParamType.int,
          false,
        ),
        ojaTierPointsNext: deserializeParam(
          data['oja_tier_points_next'],
          ParamType.int,
          false,
        ),
        ojaTierPointsStart: deserializeParam(
          data['oja_tier_points_start'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        ojaTier == other.ojaTier &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl &&
        firstName == other.firstName &&
        ojaPoints == other.ojaPoints &&
        progressPct == other.progressPct &&
        ojaTierTitle == other.ojaTierTitle &&
        ojaTierNextTitle == other.ojaTierNextTitle &&
        pointsToNextTier == other.pointsToNextTier &&
        ojaTierPointsNext == other.ojaTierPointsNext &&
        ojaTierPointsStart == other.ojaTierPointsStart;
  }

  @override
  int get hashCode => const ListEquality().hash([
        ojaTier,
        lastName,
        avatarUrl,
        firstName,
        ojaPoints,
        progressPct,
        ojaTierTitle,
        ojaTierNextTitle,
        pointsToNextTier,
        ojaTierPointsNext,
        ojaTierPointsStart
      ]);
}

UserStruct createUserStruct({
  int? ojaTier,
  String? lastName,
  String? avatarUrl,
  String? firstName,
  int? ojaPoints,
  double? progressPct,
  String? ojaTierTitle,
  String? ojaTierNextTitle,
  int? pointsToNextTier,
  int? ojaTierPointsNext,
  int? ojaTierPointsStart,
}) =>
    UserStruct(
      ojaTier: ojaTier,
      lastName: lastName,
      avatarUrl: avatarUrl,
      firstName: firstName,
      ojaPoints: ojaPoints,
      progressPct: progressPct,
      ojaTierTitle: ojaTierTitle,
      ojaTierNextTitle: ojaTierNextTitle,
      pointsToNextTier: pointsToNextTier,
      ojaTierPointsNext: ojaTierPointsNext,
      ojaTierPointsStart: ojaTierPointsStart,
    );
