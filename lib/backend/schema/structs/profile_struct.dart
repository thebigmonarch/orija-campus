// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProfileStruct extends BaseStruct {
  ProfileStruct({
    String? city,
    String? email,
    String? phone,
    String? state,
    String? country,
    String? userId,
    String? lastName,
    String? avatarUrl,
    String? firstName,
    String? dateOfBirth,
    bool? identityVerified,
    String? identityVerifiedAt,
  })  : _city = city,
        _email = email,
        _phone = phone,
        _state = state,
        _country = country,
        _userId = userId,
        _lastName = lastName,
        _avatarUrl = avatarUrl,
        _firstName = firstName,
        _dateOfBirth = dateOfBirth,
        _identityVerified = identityVerified,
        _identityVerifiedAt = identityVerifiedAt;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "avatar_url" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "first_name" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  // "date_of_birth" field.
  String? _dateOfBirth;
  String get dateOfBirth => _dateOfBirth ?? '';
  set dateOfBirth(String? val) => _dateOfBirth = val;

  bool hasDateOfBirth() => _dateOfBirth != null;

  // "identity_verified" field.
  bool? _identityVerified;
  bool get identityVerified => _identityVerified ?? false;
  set identityVerified(bool? val) => _identityVerified = val;

  bool hasIdentityVerified() => _identityVerified != null;

  // "identity_verified_at" field.
  String? _identityVerifiedAt;
  String get identityVerifiedAt => _identityVerifiedAt ?? '';
  set identityVerifiedAt(String? val) => _identityVerifiedAt = val;

  bool hasIdentityVerifiedAt() => _identityVerifiedAt != null;

  static ProfileStruct fromMap(Map<String, dynamic> data) => ProfileStruct(
        city: data['city'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        state: data['state'] as String?,
        country: data['country'] as String?,
        userId: data['user_id'] as String?,
        lastName: data['last_name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        firstName: data['first_name'] as String?,
        dateOfBirth: data['date_of_birth'] as String?,
        identityVerified: data['identity_verified'] as bool?,
        identityVerifiedAt: data['identity_verified_at'] as String?,
      );

  static ProfileStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProfileStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'city': _city,
        'email': _email,
        'phone': _phone,
        'state': _state,
        'country': _country,
        'user_id': _userId,
        'last_name': _lastName,
        'avatar_url': _avatarUrl,
        'first_name': _firstName,
        'date_of_birth': _dateOfBirth,
        'identity_verified': _identityVerified,
        'identity_verified_at': _identityVerifiedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'last_name': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'avatar_url': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'first_name': serializeParam(
          _firstName,
          ParamType.String,
        ),
        'date_of_birth': serializeParam(
          _dateOfBirth,
          ParamType.String,
        ),
        'identity_verified': serializeParam(
          _identityVerified,
          ParamType.bool,
        ),
        'identity_verified_at': serializeParam(
          _identityVerifiedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProfileStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProfileStruct(
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['last_name'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatar_url'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['first_name'],
          ParamType.String,
          false,
        ),
        dateOfBirth: deserializeParam(
          data['date_of_birth'],
          ParamType.String,
          false,
        ),
        identityVerified: deserializeParam(
          data['identity_verified'],
          ParamType.bool,
          false,
        ),
        identityVerifiedAt: deserializeParam(
          data['identity_verified_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProfileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProfileStruct &&
        city == other.city &&
        email == other.email &&
        phone == other.phone &&
        state == other.state &&
        country == other.country &&
        userId == other.userId &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl &&
        firstName == other.firstName &&
        dateOfBirth == other.dateOfBirth &&
        identityVerified == other.identityVerified &&
        identityVerifiedAt == other.identityVerifiedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        city,
        email,
        phone,
        state,
        country,
        userId,
        lastName,
        avatarUrl,
        firstName,
        dateOfBirth,
        identityVerified,
        identityVerifiedAt
      ]);
}

ProfileStruct createProfileStruct({
  String? city,
  String? email,
  String? phone,
  String? state,
  String? country,
  String? userId,
  String? lastName,
  String? avatarUrl,
  String? firstName,
  String? dateOfBirth,
  bool? identityVerified,
  String? identityVerifiedAt,
}) =>
    ProfileStruct(
      city: city,
      email: email,
      phone: phone,
      state: state,
      country: country,
      userId: userId,
      lastName: lastName,
      avatarUrl: avatarUrl,
      firstName: firstName,
      dateOfBirth: dateOfBirth,
      identityVerified: identityVerified,
      identityVerifiedAt: identityVerifiedAt,
    );
