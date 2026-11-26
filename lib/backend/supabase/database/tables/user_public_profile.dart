import '../database.dart';

class UserPublicProfileTable extends SupabaseTable<UserPublicProfileRow> {
  @override
  String get tableName => 'user_public_profile';

  @override
  UserPublicProfileRow createRow(Map<String, dynamic> data) =>
      UserPublicProfileRow(data);
}

class UserPublicProfileRow extends SupabaseDataRow {
  UserPublicProfileRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserPublicProfileTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  bool? get isRider => getField<bool>('is_rider');
  set isRider(bool? value) => setField<bool>('is_rider', value);

  int? get ojaPoints => getField<int>('oja_points');
  set ojaPoints(int? value) => setField<int>('oja_points', value);

  int? get ojaTier => getField<int>('oja_tier');
  set ojaTier(int? value) => setField<int>('oja_tier', value);

  String? get ojaTierTitle => getField<String>('oja_tier_title');
  set ojaTierTitle(String? value) => setField<String>('oja_tier_title', value);

  String? get ojaTierNextTitle => getField<String>('oja_tier_next_title');
  set ojaTierNextTitle(String? value) =>
      setField<String>('oja_tier_next_title', value);

  int? get ojaTierPointsStart => getField<int>('oja_tier_points_start');
  set ojaTierPointsStart(int? value) =>
      setField<int>('oja_tier_points_start', value);

  int? get ojaTierPointsNext => getField<int>('oja_tier_points_next');
  set ojaTierPointsNext(int? value) =>
      setField<int>('oja_tier_points_next', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
