// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SectionsStruct extends BaseStruct {
  SectionsStruct({
    String? id,
    bool? show,
    List<ItemsStruct>? items,
    String? title,
    String? layout,
    String? subtitle,
  })  : _id = id,
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

  // "show" field.
  bool? _show;
  bool get show => _show ?? false;
  set show(bool? val) => _show = val;

  bool hasShow() => _show != null;

  // "items" field.
  List<ItemsStruct>? _items;
  List<ItemsStruct> get items => _items ?? const [];
  set items(List<ItemsStruct>? val) => _items = val;

  void updateItems(Function(List<ItemsStruct>) updateFn) {
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

  static SectionsStruct fromMap(Map<String, dynamic> data) => SectionsStruct(
        id: data['id'] as String?,
        show: data['show'] as bool?,
        items: getStructList(
          data['items'],
          ItemsStruct.fromMap,
        ),
        title: data['title'] as String?,
        layout: data['layout'] as String?,
        subtitle: data['subtitle'] as String?,
      );

  static SectionsStruct? maybeFromMap(dynamic data) =>
      data is Map ? SectionsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
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

  static SectionsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SectionsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        show: deserializeParam(
          data['show'],
          ParamType.bool,
          false,
        ),
        items: deserializeStructParam<ItemsStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: ItemsStruct.fromSerializableMap,
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
  String toString() => 'SectionsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SectionsStruct &&
        id == other.id &&
        show == other.show &&
        listEquality.equals(items, other.items) &&
        title == other.title &&
        layout == other.layout &&
        subtitle == other.subtitle;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [id, show, const ListEquality().hash(items), title, layout, subtitle]);
}

SectionsStruct createSectionsStruct({
  String? id,
  bool? show,
  String? title,
  String? layout,
  String? subtitle,
}) =>
    SectionsStruct(
      id: id,
      show: show,
      title: title,
      layout: layout,
      subtitle: subtitle,
    );
