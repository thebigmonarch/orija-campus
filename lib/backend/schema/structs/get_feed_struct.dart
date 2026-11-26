// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GetFeedStruct extends BaseStruct {
  GetFeedStruct({
    String? postId,
    String? storefrontId,
    String? postType,
    String? rowType,
    List<FeedRowDataStruct>? carouselData,
  })  : _postId = postId,
        _storefrontId = storefrontId,
        _postType = postType,
        _rowType = rowType,
        _carouselData = carouselData;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;

  bool hasPostId() => _postId != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "post_type" field.
  String? _postType;
  String get postType => _postType ?? '';
  set postType(String? val) => _postType = val;

  bool hasPostType() => _postType != null;

  // "row_type" field.
  String? _rowType;
  String get rowType => _rowType ?? '';
  set rowType(String? val) => _rowType = val;

  bool hasRowType() => _rowType != null;

  // "carousel_data" field.
  List<FeedRowDataStruct>? _carouselData;
  List<FeedRowDataStruct> get carouselData => _carouselData ?? const [];
  set carouselData(List<FeedRowDataStruct>? val) => _carouselData = val;

  void updateCarouselData(Function(List<FeedRowDataStruct>) updateFn) {
    updateFn(_carouselData ??= []);
  }

  bool hasCarouselData() => _carouselData != null;

  static GetFeedStruct fromMap(Map<String, dynamic> data) => GetFeedStruct(
        postId: data['post_id'] as String?,
        storefrontId: data['storefront_id'] as String?,
        postType: data['post_type'] as String?,
        rowType: data['row_type'] as String?,
        carouselData: getStructList(
          data['carousel_data'],
          FeedRowDataStruct.fromMap,
        ),
      );

  static GetFeedStruct? maybeFromMap(dynamic data) =>
      data is Map ? GetFeedStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'post_id': _postId,
        'storefront_id': _storefrontId,
        'post_type': _postType,
        'row_type': _rowType,
        'carousel_data': _carouselData?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'post_id': serializeParam(
          _postId,
          ParamType.String,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'post_type': serializeParam(
          _postType,
          ParamType.String,
        ),
        'row_type': serializeParam(
          _rowType,
          ParamType.String,
        ),
        'carousel_data': serializeParam(
          _carouselData,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static GetFeedStruct fromSerializableMap(Map<String, dynamic> data) =>
      GetFeedStruct(
        postId: deserializeParam(
          data['post_id'],
          ParamType.String,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        postType: deserializeParam(
          data['post_type'],
          ParamType.String,
          false,
        ),
        rowType: deserializeParam(
          data['row_type'],
          ParamType.String,
          false,
        ),
        carouselData: deserializeStructParam<FeedRowDataStruct>(
          data['carousel_data'],
          ParamType.DataStruct,
          true,
          structBuilder: FeedRowDataStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'GetFeedStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GetFeedStruct &&
        postId == other.postId &&
        storefrontId == other.storefrontId &&
        postType == other.postType &&
        rowType == other.rowType &&
        listEquality.equals(carouselData, other.carouselData);
  }

  @override
  int get hashCode => const ListEquality().hash([
        postId,
        storefrontId,
        postType,
        rowType,
        const ListEquality().hash(carouselData)
      ]);
}

GetFeedStruct createGetFeedStruct({
  String? postId,
  String? storefrontId,
  String? postType,
  String? rowType,
}) =>
    GetFeedStruct(
      postId: postId,
      storefrontId: storefrontId,
      postType: postType,
      rowType: rowType,
    );
