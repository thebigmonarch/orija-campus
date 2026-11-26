// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SlideDataStruct extends BaseStruct {
  SlideDataStruct({
    List<StorefrontsNoticeStruct>? storefronts,
    List<ListingsNoticeStruct>? listings,
    BillboardStruct? billboard,
  })  : _storefronts = storefronts,
        _listings = listings,
        _billboard = billboard;

  // "storefronts" field.
  List<StorefrontsNoticeStruct>? _storefronts;
  List<StorefrontsNoticeStruct> get storefronts => _storefronts ?? const [];
  set storefronts(List<StorefrontsNoticeStruct>? val) => _storefronts = val;

  void updateStorefronts(Function(List<StorefrontsNoticeStruct>) updateFn) {
    updateFn(_storefronts ??= []);
  }

  bool hasStorefronts() => _storefronts != null;

  // "listings" field.
  List<ListingsNoticeStruct>? _listings;
  List<ListingsNoticeStruct> get listings => _listings ?? const [];
  set listings(List<ListingsNoticeStruct>? val) => _listings = val;

  void updateListings(Function(List<ListingsNoticeStruct>) updateFn) {
    updateFn(_listings ??= []);
  }

  bool hasListings() => _listings != null;

  // "billboard" field.
  BillboardStruct? _billboard;
  BillboardStruct get billboard => _billboard ?? BillboardStruct();
  set billboard(BillboardStruct? val) => _billboard = val;

  void updateBillboard(Function(BillboardStruct) updateFn) {
    updateFn(_billboard ??= BillboardStruct());
  }

  bool hasBillboard() => _billboard != null;

  static SlideDataStruct fromMap(Map<String, dynamic> data) => SlideDataStruct(
        storefronts: getStructList(
          data['storefronts'],
          StorefrontsNoticeStruct.fromMap,
        ),
        listings: getStructList(
          data['listings'],
          ListingsNoticeStruct.fromMap,
        ),
        billboard: data['billboard'] is BillboardStruct
            ? data['billboard']
            : BillboardStruct.maybeFromMap(data['billboard']),
      );

  static SlideDataStruct? maybeFromMap(dynamic data) => data is Map
      ? SlideDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'storefronts': _storefronts?.map((e) => e.toMap()).toList(),
        'listings': _listings?.map((e) => e.toMap()).toList(),
        'billboard': _billboard?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storefronts': serializeParam(
          _storefronts,
          ParamType.DataStruct,
          isList: true,
        ),
        'listings': serializeParam(
          _listings,
          ParamType.DataStruct,
          isList: true,
        ),
        'billboard': serializeParam(
          _billboard,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static SlideDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      SlideDataStruct(
        storefronts: deserializeStructParam<StorefrontsNoticeStruct>(
          data['storefronts'],
          ParamType.DataStruct,
          true,
          structBuilder: StorefrontsNoticeStruct.fromSerializableMap,
        ),
        listings: deserializeStructParam<ListingsNoticeStruct>(
          data['listings'],
          ParamType.DataStruct,
          true,
          structBuilder: ListingsNoticeStruct.fromSerializableMap,
        ),
        billboard: deserializeStructParam(
          data['billboard'],
          ParamType.DataStruct,
          false,
          structBuilder: BillboardStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SlideDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SlideDataStruct &&
        listEquality.equals(storefronts, other.storefronts) &&
        listEquality.equals(listings, other.listings) &&
        billboard == other.billboard;
  }

  @override
  int get hashCode => const ListEquality().hash([
        const ListEquality().hash(storefronts),
        const ListEquality().hash(listings),
        billboard
      ]);
}

SlideDataStruct createSlideDataStruct({
  BillboardStruct? billboard,
}) =>
    SlideDataStruct(
      billboard: billboard ?? BillboardStruct(),
    );
