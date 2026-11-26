// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExploreMarketStruct extends BaseStruct {
  ExploreMarketStruct({
    String? mode,
    bool? success,
    List<SectionsMarketStruct>? sections,
    String? userCity,
    List<CategoriesMarketStruct>? categories,
    String? userState,
    List<String>? interestCats,
    int? followedCount,
    List<ResultsStruct>? results,
    bool? isVendor,
  })  : _mode = mode,
        _success = success,
        _sections = sections,
        _userCity = userCity,
        _categories = categories,
        _userState = userState,
        _interestCats = interestCats,
        _followedCount = followedCount,
        _results = results,
        _isVendor = isVendor;

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
  List<SectionsMarketStruct>? _sections;
  List<SectionsMarketStruct> get sections => _sections ?? const [];
  set sections(List<SectionsMarketStruct>? val) => _sections = val;

  void updateSections(Function(List<SectionsMarketStruct>) updateFn) {
    updateFn(_sections ??= []);
  }

  bool hasSections() => _sections != null;

  // "user_city" field.
  String? _userCity;
  String get userCity => _userCity ?? '';
  set userCity(String? val) => _userCity = val;

  bool hasUserCity() => _userCity != null;

  // "categories" field.
  List<CategoriesMarketStruct>? _categories;
  List<CategoriesMarketStruct> get categories => _categories ?? const [];
  set categories(List<CategoriesMarketStruct>? val) => _categories = val;

  void updateCategories(Function(List<CategoriesMarketStruct>) updateFn) {
    updateFn(_categories ??= []);
  }

  bool hasCategories() => _categories != null;

  // "user_state" field.
  String? _userState;
  String get userState => _userState ?? '';
  set userState(String? val) => _userState = val;

  bool hasUserState() => _userState != null;

  // "interest_cats" field.
  List<String>? _interestCats;
  List<String> get interestCats => _interestCats ?? const [];
  set interestCats(List<String>? val) => _interestCats = val;

  void updateInterestCats(Function(List<String>) updateFn) {
    updateFn(_interestCats ??= []);
  }

  bool hasInterestCats() => _interestCats != null;

  // "followed_count" field.
  int? _followedCount;
  int get followedCount => _followedCount ?? 0;
  set followedCount(int? val) => _followedCount = val;

  void incrementFollowedCount(int amount) =>
      followedCount = followedCount + amount;

  bool hasFollowedCount() => _followedCount != null;

  // "results" field.
  List<ResultsStruct>? _results;
  List<ResultsStruct> get results => _results ?? const [];
  set results(List<ResultsStruct>? val) => _results = val;

  void updateResults(Function(List<ResultsStruct>) updateFn) {
    updateFn(_results ??= []);
  }

  bool hasResults() => _results != null;

  // "is_vendor" field.
  bool? _isVendor;
  bool get isVendor => _isVendor ?? false;
  set isVendor(bool? val) => _isVendor = val;

  bool hasIsVendor() => _isVendor != null;

  static ExploreMarketStruct fromMap(Map<String, dynamic> data) =>
      ExploreMarketStruct(
        mode: data['mode'] as String?,
        success: data['success'] as bool?,
        sections: getStructList(
          data['sections'],
          SectionsMarketStruct.fromMap,
        ),
        userCity: data['user_city'] as String?,
        categories: getStructList(
          data['categories'],
          CategoriesMarketStruct.fromMap,
        ),
        userState: data['user_state'] as String?,
        interestCats: getDataList(data['interest_cats']),
        followedCount: castToType<int>(data['followed_count']),
        results: getStructList(
          data['results'],
          ResultsStruct.fromMap,
        ),
        isVendor: data['is_vendor'] as bool?,
      );

  static ExploreMarketStruct? maybeFromMap(dynamic data) => data is Map
      ? ExploreMarketStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mode': _mode,
        'success': _success,
        'sections': _sections?.map((e) => e.toMap()).toList(),
        'user_city': _userCity,
        'categories': _categories?.map((e) => e.toMap()).toList(),
        'user_state': _userState,
        'interest_cats': _interestCats,
        'followed_count': _followedCount,
        'results': _results?.map((e) => e.toMap()).toList(),
        'is_vendor': _isVendor,
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
        'user_city': serializeParam(
          _userCity,
          ParamType.String,
        ),
        'categories': serializeParam(
          _categories,
          ParamType.DataStruct,
          isList: true,
        ),
        'user_state': serializeParam(
          _userState,
          ParamType.String,
        ),
        'interest_cats': serializeParam(
          _interestCats,
          ParamType.String,
          isList: true,
        ),
        'followed_count': serializeParam(
          _followedCount,
          ParamType.int,
        ),
        'results': serializeParam(
          _results,
          ParamType.DataStruct,
          isList: true,
        ),
        'is_vendor': serializeParam(
          _isVendor,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ExploreMarketStruct fromSerializableMap(Map<String, dynamic> data) =>
      ExploreMarketStruct(
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
        sections: deserializeStructParam<SectionsMarketStruct>(
          data['sections'],
          ParamType.DataStruct,
          true,
          structBuilder: SectionsMarketStruct.fromSerializableMap,
        ),
        userCity: deserializeParam(
          data['user_city'],
          ParamType.String,
          false,
        ),
        categories: deserializeStructParam<CategoriesMarketStruct>(
          data['categories'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoriesMarketStruct.fromSerializableMap,
        ),
        userState: deserializeParam(
          data['user_state'],
          ParamType.String,
          false,
        ),
        interestCats: deserializeParam<String>(
          data['interest_cats'],
          ParamType.String,
          true,
        ),
        followedCount: deserializeParam(
          data['followed_count'],
          ParamType.int,
          false,
        ),
        results: deserializeStructParam<ResultsStruct>(
          data['results'],
          ParamType.DataStruct,
          true,
          structBuilder: ResultsStruct.fromSerializableMap,
        ),
        isVendor: deserializeParam(
          data['is_vendor'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ExploreMarketStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ExploreMarketStruct &&
        mode == other.mode &&
        success == other.success &&
        listEquality.equals(sections, other.sections) &&
        userCity == other.userCity &&
        listEquality.equals(categories, other.categories) &&
        userState == other.userState &&
        listEquality.equals(interestCats, other.interestCats) &&
        followedCount == other.followedCount &&
        listEquality.equals(results, other.results) &&
        isVendor == other.isVendor;
  }

  @override
  int get hashCode => const ListEquality().hash([
        mode,
        success,
        const ListEquality().hash(sections),
        userCity,
        const ListEquality().hash(categories),
        userState,
        const ListEquality().hash(interestCats),
        followedCount,
        const ListEquality().hash(results),
        isVendor
      ]);
}

ExploreMarketStruct createExploreMarketStruct({
  String? mode,
  bool? success,
  String? userCity,
  String? userState,
  int? followedCount,
  bool? isVendor,
}) =>
    ExploreMarketStruct(
      mode: mode,
      success: success,
      userCity: userCity,
      userState: userState,
      followedCount: followedCount,
      isVendor: isVendor,
    );
