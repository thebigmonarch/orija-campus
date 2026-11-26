// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SettingsPageStruct extends BaseStruct {
  SettingsPageStruct({
    AccountStruct? account,
    ProfileStruct? profile,
    bool? success,
    OjaRankStruct? ojaRank,
    SecurityStruct? security,
    List<InterestsStruct>? interests,
    StorefrontSettingsStruct? storefront,
    NotificationsStruct? notifications,
    List<FaqsStruct>? faqs,
  })  : _account = account,
        _profile = profile,
        _success = success,
        _ojaRank = ojaRank,
        _security = security,
        _interests = interests,
        _storefront = storefront,
        _notifications = notifications,
        _faqs = faqs;

  // "account" field.
  AccountStruct? _account;
  AccountStruct get account => _account ?? AccountStruct();
  set account(AccountStruct? val) => _account = val;

  void updateAccount(Function(AccountStruct) updateFn) {
    updateFn(_account ??= AccountStruct());
  }

  bool hasAccount() => _account != null;

  // "profile" field.
  ProfileStruct? _profile;
  ProfileStruct get profile => _profile ?? ProfileStruct();
  set profile(ProfileStruct? val) => _profile = val;

  void updateProfile(Function(ProfileStruct) updateFn) {
    updateFn(_profile ??= ProfileStruct());
  }

  bool hasProfile() => _profile != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "oja_rank" field.
  OjaRankStruct? _ojaRank;
  OjaRankStruct get ojaRank => _ojaRank ?? OjaRankStruct();
  set ojaRank(OjaRankStruct? val) => _ojaRank = val;

  void updateOjaRank(Function(OjaRankStruct) updateFn) {
    updateFn(_ojaRank ??= OjaRankStruct());
  }

  bool hasOjaRank() => _ojaRank != null;

  // "security" field.
  SecurityStruct? _security;
  SecurityStruct get security => _security ?? SecurityStruct();
  set security(SecurityStruct? val) => _security = val;

  void updateSecurity(Function(SecurityStruct) updateFn) {
    updateFn(_security ??= SecurityStruct());
  }

  bool hasSecurity() => _security != null;

  // "interests" field.
  List<InterestsStruct>? _interests;
  List<InterestsStruct> get interests => _interests ?? const [];
  set interests(List<InterestsStruct>? val) => _interests = val;

  void updateInterests(Function(List<InterestsStruct>) updateFn) {
    updateFn(_interests ??= []);
  }

  bool hasInterests() => _interests != null;

  // "storefront" field.
  StorefrontSettingsStruct? _storefront;
  StorefrontSettingsStruct get storefront =>
      _storefront ?? StorefrontSettingsStruct();
  set storefront(StorefrontSettingsStruct? val) => _storefront = val;

  void updateStorefront(Function(StorefrontSettingsStruct) updateFn) {
    updateFn(_storefront ??= StorefrontSettingsStruct());
  }

  bool hasStorefront() => _storefront != null;

  // "notifications" field.
  NotificationsStruct? _notifications;
  NotificationsStruct get notifications =>
      _notifications ?? NotificationsStruct();
  set notifications(NotificationsStruct? val) => _notifications = val;

  void updateNotifications(Function(NotificationsStruct) updateFn) {
    updateFn(_notifications ??= NotificationsStruct());
  }

  bool hasNotifications() => _notifications != null;

  // "faqs" field.
  List<FaqsStruct>? _faqs;
  List<FaqsStruct> get faqs => _faqs ?? const [];
  set faqs(List<FaqsStruct>? val) => _faqs = val;

  void updateFaqs(Function(List<FaqsStruct>) updateFn) {
    updateFn(_faqs ??= []);
  }

  bool hasFaqs() => _faqs != null;

  static SettingsPageStruct fromMap(Map<String, dynamic> data) =>
      SettingsPageStruct(
        account: data['account'] is AccountStruct
            ? data['account']
            : AccountStruct.maybeFromMap(data['account']),
        profile: data['profile'] is ProfileStruct
            ? data['profile']
            : ProfileStruct.maybeFromMap(data['profile']),
        success: data['success'] as bool?,
        ojaRank: data['oja_rank'] is OjaRankStruct
            ? data['oja_rank']
            : OjaRankStruct.maybeFromMap(data['oja_rank']),
        security: data['security'] is SecurityStruct
            ? data['security']
            : SecurityStruct.maybeFromMap(data['security']),
        interests: getStructList(
          data['interests'],
          InterestsStruct.fromMap,
        ),
        storefront: data['storefront'] is StorefrontSettingsStruct
            ? data['storefront']
            : StorefrontSettingsStruct.maybeFromMap(data['storefront']),
        notifications: data['notifications'] is NotificationsStruct
            ? data['notifications']
            : NotificationsStruct.maybeFromMap(data['notifications']),
        faqs: getStructList(
          data['faqs'],
          FaqsStruct.fromMap,
        ),
      );

  static SettingsPageStruct? maybeFromMap(dynamic data) => data is Map
      ? SettingsPageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'account': _account?.toMap(),
        'profile': _profile?.toMap(),
        'success': _success,
        'oja_rank': _ojaRank?.toMap(),
        'security': _security?.toMap(),
        'interests': _interests?.map((e) => e.toMap()).toList(),
        'storefront': _storefront?.toMap(),
        'notifications': _notifications?.toMap(),
        'faqs': _faqs?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'account': serializeParam(
          _account,
          ParamType.DataStruct,
        ),
        'profile': serializeParam(
          _profile,
          ParamType.DataStruct,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'oja_rank': serializeParam(
          _ojaRank,
          ParamType.DataStruct,
        ),
        'security': serializeParam(
          _security,
          ParamType.DataStruct,
        ),
        'interests': serializeParam(
          _interests,
          ParamType.DataStruct,
          isList: true,
        ),
        'storefront': serializeParam(
          _storefront,
          ParamType.DataStruct,
        ),
        'notifications': serializeParam(
          _notifications,
          ParamType.DataStruct,
        ),
        'faqs': serializeParam(
          _faqs,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static SettingsPageStruct fromSerializableMap(Map<String, dynamic> data) =>
      SettingsPageStruct(
        account: deserializeStructParam(
          data['account'],
          ParamType.DataStruct,
          false,
          structBuilder: AccountStruct.fromSerializableMap,
        ),
        profile: deserializeStructParam(
          data['profile'],
          ParamType.DataStruct,
          false,
          structBuilder: ProfileStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        ojaRank: deserializeStructParam(
          data['oja_rank'],
          ParamType.DataStruct,
          false,
          structBuilder: OjaRankStruct.fromSerializableMap,
        ),
        security: deserializeStructParam(
          data['security'],
          ParamType.DataStruct,
          false,
          structBuilder: SecurityStruct.fromSerializableMap,
        ),
        interests: deserializeStructParam<InterestsStruct>(
          data['interests'],
          ParamType.DataStruct,
          true,
          structBuilder: InterestsStruct.fromSerializableMap,
        ),
        storefront: deserializeStructParam(
          data['storefront'],
          ParamType.DataStruct,
          false,
          structBuilder: StorefrontSettingsStruct.fromSerializableMap,
        ),
        notifications: deserializeStructParam(
          data['notifications'],
          ParamType.DataStruct,
          false,
          structBuilder: NotificationsStruct.fromSerializableMap,
        ),
        faqs: deserializeStructParam<FaqsStruct>(
          data['faqs'],
          ParamType.DataStruct,
          true,
          structBuilder: FaqsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SettingsPageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SettingsPageStruct &&
        account == other.account &&
        profile == other.profile &&
        success == other.success &&
        ojaRank == other.ojaRank &&
        security == other.security &&
        listEquality.equals(interests, other.interests) &&
        storefront == other.storefront &&
        notifications == other.notifications &&
        listEquality.equals(faqs, other.faqs);
  }

  @override
  int get hashCode => const ListEquality().hash([
        account,
        profile,
        success,
        ojaRank,
        security,
        const ListEquality().hash(interests),
        storefront,
        notifications,
        const ListEquality().hash(faqs)
      ]);
}

SettingsPageStruct createSettingsPageStruct({
  AccountStruct? account,
  ProfileStruct? profile,
  bool? success,
  OjaRankStruct? ojaRank,
  SecurityStruct? security,
  StorefrontSettingsStruct? storefront,
  NotificationsStruct? notifications,
}) =>
    SettingsPageStruct(
      account: account ?? AccountStruct(),
      profile: profile ?? ProfileStruct(),
      success: success,
      ojaRank: ojaRank ?? OjaRankStruct(),
      security: security ?? SecurityStruct(),
      storefront: storefront ?? StorefrontSettingsStruct(),
      notifications: notifications ?? NotificationsStruct(),
    );
