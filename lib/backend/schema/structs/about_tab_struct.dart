// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AboutTabStruct extends BaseStruct {
  AboutTabStruct({
    String? type,
    String? rule2,
    String? rule3,
    String? rules,
    String? category,
    bool? isPublic,
    String? createdAt,
    String? description,
    bool? isVerified,
    String? addressLine,
    int? memberCount,
    int? vendorCount,
  })  : _type = type,
        _rule2 = rule2,
        _rule3 = rule3,
        _rules = rules,
        _category = category,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _description = description,
        _isVerified = isVerified,
        _addressLine = addressLine,
        _memberCount = memberCount,
        _vendorCount = vendorCount;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "Rule2" field.
  String? _rule2;
  String get rule2 => _rule2 ?? '';
  set rule2(String? val) => _rule2 = val;

  bool hasRule2() => _rule2 != null;

  // "Rule3" field.
  String? _rule3;
  String get rule3 => _rule3 ?? '';
  set rule3(String? val) => _rule3 = val;

  bool hasRule3() => _rule3 != null;

  // "rules" field.
  String? _rules;
  String get rules => _rules ?? '';
  set rules(String? val) => _rules = val;

  bool hasRules() => _rules != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "is_public" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? false;
  set isPublic(bool? val) => _isPublic = val;

  bool hasIsPublic() => _isPublic != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "is_verified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

  // "address_line" field.
  String? _addressLine;
  String get addressLine => _addressLine ?? '';
  set addressLine(String? val) => _addressLine = val;

  bool hasAddressLine() => _addressLine != null;

  // "member_count" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  // "vendor_count" field.
  int? _vendorCount;
  int get vendorCount => _vendorCount ?? 0;
  set vendorCount(int? val) => _vendorCount = val;

  void incrementVendorCount(int amount) => vendorCount = vendorCount + amount;

  bool hasVendorCount() => _vendorCount != null;

  static AboutTabStruct fromMap(Map<String, dynamic> data) => AboutTabStruct(
        type: data['type'] as String?,
        rule2: data['Rule2'] as String?,
        rule3: data['Rule3'] as String?,
        rules: data['rules'] as String?,
        category: data['category'] as String?,
        isPublic: data['is_public'] as bool?,
        createdAt: data['created_at'] as String?,
        description: data['description'] as String?,
        isVerified: data['is_verified'] as bool?,
        addressLine: data['address_line'] as String?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
      );

  static AboutTabStruct? maybeFromMap(dynamic data) =>
      data is Map ? AboutTabStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
        'Rule2': _rule2,
        'Rule3': _rule3,
        'rules': _rules,
        'category': _category,
        'is_public': _isPublic,
        'created_at': _createdAt,
        'description': _description,
        'is_verified': _isVerified,
        'address_line': _addressLine,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'Rule2': serializeParam(
          _rule2,
          ParamType.String,
        ),
        'Rule3': serializeParam(
          _rule3,
          ParamType.String,
        ),
        'rules': serializeParam(
          _rules,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'is_public': serializeParam(
          _isPublic,
          ParamType.bool,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
        'address_line': serializeParam(
          _addressLine,
          ParamType.String,
        ),
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'vendor_count': serializeParam(
          _vendorCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static AboutTabStruct fromSerializableMap(Map<String, dynamic> data) =>
      AboutTabStruct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        rule2: deserializeParam(
          data['Rule2'],
          ParamType.String,
          false,
        ),
        rule3: deserializeParam(
          data['Rule3'],
          ParamType.String,
          false,
        ),
        rules: deserializeParam(
          data['rules'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        isPublic: deserializeParam(
          data['is_public'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        isVerified: deserializeParam(
          data['is_verified'],
          ParamType.bool,
          false,
        ),
        addressLine: deserializeParam(
          data['address_line'],
          ParamType.String,
          false,
        ),
        memberCount: deserializeParam(
          data['member_count'],
          ParamType.int,
          false,
        ),
        vendorCount: deserializeParam(
          data['vendor_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'AboutTabStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AboutTabStruct &&
        type == other.type &&
        rule2 == other.rule2 &&
        rule3 == other.rule3 &&
        rules == other.rules &&
        category == other.category &&
        isPublic == other.isPublic &&
        createdAt == other.createdAt &&
        description == other.description &&
        isVerified == other.isVerified &&
        addressLine == other.addressLine &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        type,
        rule2,
        rule3,
        rules,
        category,
        isPublic,
        createdAt,
        description,
        isVerified,
        addressLine,
        memberCount,
        vendorCount
      ]);
}

AboutTabStruct createAboutTabStruct({
  String? type,
  String? rule2,
  String? rule3,
  String? rules,
  String? category,
  bool? isPublic,
  String? createdAt,
  String? description,
  bool? isVerified,
  String? addressLine,
  int? memberCount,
  int? vendorCount,
}) =>
    AboutTabStruct(
      type: type,
      rule2: rule2,
      rule3: rule3,
      rules: rules,
      category: category,
      isPublic: isPublic,
      createdAt: createdAt,
      description: description,
      isVerified: isVerified,
      addressLine: addressLine,
      memberCount: memberCount,
      vendorCount: vendorCount,
    );
