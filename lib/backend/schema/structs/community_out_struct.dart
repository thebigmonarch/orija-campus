// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityOutStruct extends BaseStruct {
  CommunityOutStruct({
    String? mode,
    bool? success,
    List<SectionsStruct>? sections,
    List<CategoriesStruct>? categories,
    List<String>? joinedIds,
  })  : _mode = mode,
        _success = success,
        _sections = sections,
        _categories = categories,
        _joinedIds = joinedIds;

  // "mode" field.
  String? _mode;
  String get mode => _mode ?? '';
  set mode(String? val) => _mode = val;

  bool hasMode() => _mode != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "sections" field.
  List<SectionsStruct>? _sections;
  List<SectionsStruct> get sections => _sections ?? const [];
  set sections(List<SectionsStruct>? val) => _sections = val;

  void updateSections(Function(List<SectionsStruct>) updateFn) {
    updateFn(_sections ??= []);
  }

  bool hasSections() => _sections != null;

  // "categories" field.
  List<CategoriesStruct>? _categories;
  List<CategoriesStruct> get categories => _categories ?? const [];
  set categories(List<CategoriesStruct>? val) => _categories = val;

  void updateCategories(Function(List<CategoriesStruct>) updateFn) {
    updateFn(_categories ??= []);
  }

  bool hasCategories() => _categories != null;

  // "joined_ids" field.
  List<String>? _joinedIds;
  List<String> get joinedIds => _joinedIds ?? const [];
  set joinedIds(List<String>? val) => _joinedIds = val;

  void updateJoinedIds(Function(List<String>) updateFn) {
    updateFn(_joinedIds ??= []);
  }

  bool hasJoinedIds() => _joinedIds != null;

  static CommunityOutStruct fromMap(Map<String, dynamic> data) =>
      CommunityOutStruct(
        mode: data['mode'] as String?,
        success: data['success'] as bool?,
        sections: getStructList(
          data['sections'],
          SectionsStruct.fromMap,
        ),
        categories: getStructList(
          data['categories'],
          CategoriesStruct.fromMap,
        ),
        joinedIds: getDataList(data['joined_ids']),
      );

  static CommunityOutStruct? maybeFromMap(dynamic data) => data is Map
      ? CommunityOutStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mode': _mode,
        'success': _success,
        'sections': _sections?.map((e) => e.toMap()).toList(),
        'categories': _categories?.map((e) => e.toMap()).toList(),
        'joined_ids': _joinedIds,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mode': serializeParam(
          _mode,
          ParamType.String,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'sections': serializeParam(
          _sections,
          ParamType.DataStruct,
          isList: true,
        ),
        'categories': serializeParam(
          _categories,
          ParamType.DataStruct,
          isList: true,
        ),
        'joined_ids': serializeParam(
          _joinedIds,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static CommunityOutStruct fromSerializableMap(Map<String, dynamic> data) =>
      CommunityOutStruct(
        mode: deserializeParam(
          data['mode'],
          ParamType.String,
          false,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        sections: deserializeStructParam<SectionsStruct>(
          data['sections'],
          ParamType.DataStruct,
          true,
          structBuilder: SectionsStruct.fromSerializableMap,
        ),
        categories: deserializeStructParam<CategoriesStruct>(
          data['categories'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoriesStruct.fromSerializableMap,
        ),
        joinedIds: deserializeParam<String>(
          data['joined_ids'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'CommunityOutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CommunityOutStruct &&
        mode == other.mode &&
        success == other.success &&
        listEquality.equals(sections, other.sections) &&
        listEquality.equals(categories, other.categories) &&
        listEquality.equals(joinedIds, other.joinedIds);
  }

  @override
  int get hashCode => const ListEquality().hash([
        mode,
        success,
        const ListEquality().hash(sections),
        const ListEquality().hash(categories),
        const ListEquality().hash(joinedIds)
      ]);
}

CommunityOutStruct createCommunityOutStruct({
  String? mode,
  bool? success,
}) =>
    CommunityOutStruct(
      mode: mode,
      success: success,
    );
