// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FaqsStruct extends BaseStruct {
  FaqsStruct({
    List<ItemsFAQStruct>? items,
    String? category,
  })  : _items = items,
        _category = category;

  // "items" field.
  List<ItemsFAQStruct>? _items;
  List<ItemsFAQStruct> get items => _items ?? const [];
  set items(List<ItemsFAQStruct>? val) => _items = val;

  void updateItems(Function(List<ItemsFAQStruct>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  static FaqsStruct fromMap(Map<String, dynamic> data) => FaqsStruct(
        items: getStructList(
          data['items'],
          ItemsFAQStruct.fromMap,
        ),
        category: data['category'] as String?,
      );

  static FaqsStruct? maybeFromMap(dynamic data) =>
      data is Map ? FaqsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'items': _items?.map((e) => e.toMap()).toList(),
        'category': _category,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'items': serializeParam(
          _items,
          ParamType.DataStruct,
          isList: true,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
      }.withoutNulls;

  static FaqsStruct fromSerializableMap(Map<String, dynamic> data) =>
      FaqsStruct(
        items: deserializeStructParam<ItemsFAQStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: ItemsFAQStruct.fromSerializableMap,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FaqsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is FaqsStruct &&
        listEquality.equals(items, other.items) &&
        category == other.category;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([const ListEquality().hash(items), category]);
}

FaqsStruct createFaqsStruct({
  String? category,
}) =>
    FaqsStruct(
      category: category,
    );
