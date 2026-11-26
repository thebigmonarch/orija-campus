import '../database.dart';

class UserOjaProgressTable extends SupabaseTable<UserOjaProgressRow> {
  @override
  String get tableName => 'user_oja_progress';

  @override
  UserOjaProgressRow createRow(Map<String, dynamic> data) =>
      UserOjaProgressRow(data);
}

class UserOjaProgressRow extends SupabaseDataRow {
  UserOjaProgressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserOjaProgressTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int? get ojaPoints => getField<int>('oja_points');
  set ojaPoints(int? value) => setField<int>('oja_points', value);

  int? get ojaTier => getField<int>('oja_tier');
  set ojaTier(int? value) => setField<int>('oja_tier', value);

  String? get ojaTierTitle => getField<String>('oja_tier_title');
  set ojaTierTitle(String? value) => setField<String>('oja_tier_title', value);

  int? get ojaTierPointsStart => getField<int>('oja_tier_points_start');
  set ojaTierPointsStart(int? value) =>
      setField<int>('oja_tier_points_start', value);

  int? get ojaTierPointsNext => getField<int>('oja_tier_points_next');
  set ojaTierPointsNext(int? value) =>
      setField<int>('oja_tier_points_next', value);

  String? get ojaTierNextTitle => getField<String>('oja_tier_next_title');
  set ojaTierNextTitle(String? value) =>
      setField<String>('oja_tier_next_title', value);

  double? get progressPct => getField<double>('progress_pct');
  set progressPct(double? value) => setField<double>('progress_pct', value);

  int? get pointsToNextTier => getField<int>('points_to_next_tier');
  set pointsToNextTier(int? value) =>
      setField<int>('points_to_next_tier', value);
}
