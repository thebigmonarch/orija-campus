import '../database.dart';

class UserInterestsTable extends SupabaseTable<UserInterestsRow> {
  @override
  String get tableName => 'user_interests';

  @override
  UserInterestsRow createRow(Map<String, dynamic> data) =>
      UserInterestsRow(data);
}

class UserInterestsRow extends SupabaseDataRow {
  UserInterestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserInterestsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String? get subCategory => getField<String>('sub_category');
  set subCategory(String? value) => setField<String>('sub_category', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
