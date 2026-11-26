// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SectionsMarketStruct extends BaseStruct {
  SectionsMarketStruct({
    String? id,
    String? note,
    bool? show,
    List<ItemsMarketStruct>? items,
    String? title,
    String? layout,
    String? subtitle,
  })  : _id = id,
        _note = note,
        _show = show,
        _items = items,
        _title = title,
        _layout = layout,
        _subtitle = subtitle;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  // "show" field.
  bool? _show;
  bool get show => _show ?? false;
  set show(bool? val) => _show = val;

  bool hasShow() => _show != null;

  // "items" field.
  List<ItemsMarketStruct>? _items;
  List<ItemsMarketStruct> get items => _items ?? const [];
  set items(List<ItemsMarketStruct>? val) => _items = val;

  void updateItems(Function(List<ItemsMarketStruct>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "layout" field.
  String? _layout;
  String get layout => _layout ?? '';
  set layout(String? val) => _layout = val;

  bool hasLayout() => _layout != null;

  // "subtitle" field.
  String? _subtitle;
  String get subtitle => _subtitle ?? '';
  set subtitle(String? val) => _subtitle = val;

  bool hasSubtitle() => _subtitle != null;

  static SectionsMarketStruct fromMap(Map<String, dynamic> data) =>
      SectionsMarketStruct(
        id: data['id'] as String?,
        note: data['note'] as String?,
        show: data['show'] as bool?,
        items: getStructList(
          data['items'],
          ItemsMarketStruct.fromMap,
        ),
        title: data['title'] as String?,
        layout: data['layout'] as String?,
        subtitle: data['subtitle'] as String?,
      );

  static SectionsMarketStruct? maybeFromMap(dynamic data) => data is Map
      ? SectionsMarketStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'note': _note,
        'show': _show,
        'items': _items?.map((e) => e.toMap()).toList(),
        'title': _title,
        'layout': _layout,
        'subtitle': _subtitle,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
        'show': serializeParam(
          _show,
          ParamType.bool,
        ),
        'items': serializeParam(
          _items,
          ParamType.DataStruct,
          isList: true,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'layout': serializeParam(
          _layout,
          ParamType.String,
        ),
        'subtitle': serializeParam(
          _subtitle,
          ParamType.String,
        ),
      }.withoutNulls;

  static SectionsMarketStruct fromSerializableMap(Map<String, dynamic> data) =>
      SectionsMarketStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
        show: deserializeParam(
          data['show'],
          ParamType.bool,
          false,
        ),
        items: deserializeStructParam<ItemsMarketStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: ItemsMarketStruct.fromSerializableMap,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        layout: deserializeParam(
          data['layout'],
          ParamType.String,
          false,
        ),
        subtitle: deserializeParam(
          data['subtitle'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SectionsMarketStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SectionsMarketStruct &&
        id == other.id &&
        note == other.note &&
        show == other.show &&
        listEquality.equals(items, other.items) &&
        title == other.title &&
        layout == other.layout &&
        subtitle == other.subtitle;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        note,
        show,
        const ListEquality().hash(items),
        title,
        layout,
        subtitle
      ]);
}

SectionsMarketStruct createSectionsMarketStruct({
  String? id,
  String? note,
  bool? show,
  String? title,
  String? layout,
  String? subtitle,
}) =>
    SectionsMarketStruct(
      id: id,
      note: note,
      show: show,
      title: title,
      layout: layout,
      subtitle: subtitle,
    );
