// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccountStruct extends BaseStruct {
  AccountStruct({
    String? status,
    bool? isRider,
    bool? isVendor,
    String? referredBy,
    String? memberSince,
    bool? fcmTokenSet,
    String? referralCode,
    bool? hasStorefront,
    String? lastActiveAt,
    int? totalReferrals,
    bool? riderModeActive,
    bool? hasUsedFreeTrial,
  })  : _status = status,
        _isRider = isRider,
        _isVendor = isVendor,
        _referredBy = referredBy,
        _memberSince = memberSince,
        _fcmTokenSet = fcmTokenSet,
        _referralCode = referralCode,
        _hasStorefront = hasStorefront,
        _lastActiveAt = lastActiveAt,
        _totalReferrals = totalReferrals,
        _riderModeActive = riderModeActive,
        _hasUsedFreeTrial = hasUsedFreeTrial;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "is_rider" field.
  bool? _isRider;
  bool get isRider => _isRider ?? false;
  set isRider(bool? val) => _isRider = val;

  bool hasIsRider() => _isRider != null;

  // "is_vendor" field.
  bool? _isVendor;
  bool get isVendor => _isVendor ?? false;
  set isVendor(bool? val) => _isVendor = val;

  bool hasIsVendor() => _isVendor != null;

  // "referred_by" field.
  String? _referredBy;
  String get referredBy => _referredBy ?? '';
  set referredBy(String? val) => _referredBy = val;

  bool hasReferredBy() => _referredBy != null;

  // "member_since" field.
  String? _memberSince;
  String get memberSince => _memberSince ?? '';
  set memberSince(String? val) => _memberSince = val;

  bool hasMemberSince() => _memberSince != null;

  // "fcm_token_set" field.
  bool? _fcmTokenSet;
  bool get fcmTokenSet => _fcmTokenSet ?? false;
  set fcmTokenSet(bool? val) => _fcmTokenSet = val;

  bool hasFcmTokenSet() => _fcmTokenSet != null;

  // "referral_code" field.
  String? _referralCode;
  String get referralCode => _referralCode ?? '';
  set referralCode(String? val) => _referralCode = val;

  bool hasReferralCode() => _referralCode != null;

  // "has_storefront" field.
  bool? _hasStorefront;
  bool get hasStorefront => _hasStorefront ?? false;
  set hasStorefront(bool? val) => _hasStorefront = val;

  bool hasHasStorefront() => _hasStorefront != null;

  // "last_active_at" field.
  String? _lastActiveAt;
  String get lastActiveAt => _lastActiveAt ?? '';
  set lastActiveAt(String? val) => _lastActiveAt = val;

  bool hasLastActiveAt() => _lastActiveAt != null;

  // "total_referrals" field.
  int? _totalReferrals;
  int get totalReferrals => _totalReferrals ?? 0;
  set totalReferrals(int? val) => _totalReferrals = val;

  void incrementTotalReferrals(int amount) =>
      totalReferrals = totalReferrals + amount;

  bool hasTotalReferrals() => _totalReferrals != null;

  // "rider_mode_active" field.
  bool? _riderModeActive;
  bool get riderModeActive => _riderModeActive ?? false;
  set riderModeActive(bool? val) => _riderModeActive = val;

  bool hasRiderModeActive() => _riderModeActive != null;

  // "has_used_free_trial" field.
  bool? _hasUsedFreeTrial;
  bool get hasUsedFreeTrial => _hasUsedFreeTrial ?? false;
  set hasUsedFreeTrial(bool? val) => _hasUsedFreeTrial = val;

  bool hasHasUsedFreeTrial() => _hasUsedFreeTrial != null;

  static AccountStruct fromMap(Map<String, dynamic> data) => AccountStruct(
        status: data['status'] as String?,
        isRider: data['is_rider'] as bool?,
        isVendor: data['is_vendor'] as bool?,
        referredBy: data['referred_by'] as String?,
        memberSince: data['member_since'] as String?,
        fcmTokenSet: data['fcm_token_set'] as bool?,
        referralCode: data['referral_code'] as String?,
        hasStorefront: data['has_storefront'] as bool?,
        lastActiveAt: data['last_active_at'] as String?,
        totalReferrals: castToType<int>(data['total_referrals']),
        riderModeActive: data['rider_mode_active'] as bool?,
        hasUsedFreeTrial: data['has_used_free_trial'] as bool?,
      );

  static AccountStruct? maybeFromMap(dynamic data) =>
      data is Map ? AccountStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
        'is_rider': _isRider,
        'is_vendor': _isVendor,
        'referred_by': _referredBy,
        'member_since': _memberSince,
        'fcm_token_set': _fcmTokenSet,
        'referral_code': _referralCode,
        'has_storefront': _hasStorefront,
        'last_active_at': _lastActiveAt,
        'total_referrals': _totalReferrals,
        'rider_mode_active': _riderModeActive,
        'has_used_free_trial': _hasUsedFreeTrial,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'is_rider': serializeParam(
          _isRider,
          ParamType.bool,
        ),
        'is_vendor': serializeParam(
          _isVendor,
          ParamType.bool,
        ),
        'referred_by': serializeParam(
          _referredBy,
          ParamType.String,
        ),
        'member_since': serializeParam(
          _memberSince,
          ParamType.String,
        ),
        'fcm_token_set': serializeParam(
          _fcmTokenSet,
          ParamType.bool,
        ),
        'referral_code': serializeParam(
          _referralCode,
          ParamType.String,
        ),
        'has_storefront': serializeParam(
          _hasStorefront,
          ParamType.bool,
        ),
        'last_active_at': serializeParam(
          _lastActiveAt,
          ParamType.String,
        ),
        'total_referrals': serializeParam(
          _totalReferrals,
          ParamType.int,
        ),
        'rider_mode_active': serializeParam(
          _riderModeActive,
          ParamType.bool,
        ),
        'has_used_free_trial': serializeParam(
          _hasUsedFreeTrial,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AccountStruct fromSerializableMap(Map<String, dynamic> data) =>
      AccountStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        isRider: deserializeParam(
          data['is_rider'],
          ParamType.bool,
          false,
        ),
        isVendor: deserializeParam(
          data['is_vendor'],
          ParamType.bool,
          false,
        ),
        referredBy: deserializeParam(
          data['referred_by'],
          ParamType.String,
          false,
        ),
        memberSince: deserializeParam(
          data['member_since'],
          ParamType.String,
          false,
        ),
        fcmTokenSet: deserializeParam(
          data['fcm_token_set'],
          ParamType.bool,
          false,
        ),
        referralCode: deserializeParam(
          data['referral_code'],
          ParamType.String,
          false,
        ),
        hasStorefront: deserializeParam(
          data['has_storefront'],
          ParamType.bool,
          false,
        ),
        lastActiveAt: deserializeParam(
          data['last_active_at'],
          ParamType.String,
          false,
        ),
        totalReferrals: deserializeParam(
          data['total_referrals'],
          ParamType.int,
          false,
        ),
        riderModeActive: deserializeParam(
          data['rider_mode_active'],
          ParamType.bool,
          false,
        ),
        hasUsedFreeTrial: deserializeParam(
          data['has_used_free_trial'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AccountStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccountStruct &&
        status == other.status &&
        isRider == other.isRider &&
        isVendor == other.isVendor &&
        referredBy == other.referredBy &&
        memberSince == other.memberSince &&
        fcmTokenSet == other.fcmTokenSet &&
        referralCode == other.referralCode &&
        hasStorefront == other.hasStorefront &&
        lastActiveAt == other.lastActiveAt &&
        totalReferrals == other.totalReferrals &&
        riderModeActive == other.riderModeActive &&
        hasUsedFreeTrial == other.hasUsedFreeTrial;
  }

  @override
  int get hashCode => const ListEquality().hash([
        status,
        isRider,
        isVendor,
        referredBy,
        memberSince,
        fcmTokenSet,
        referralCode,
        hasStorefront,
        lastActiveAt,
        totalReferrals,
        riderModeActive,
        hasUsedFreeTrial
      ]);
}

AccountStruct createAccountStruct({
  String? status,
  bool? isRider,
  bool? isVendor,
  String? referredBy,
  String? memberSince,
  bool? fcmTokenSet,
  String? referralCode,
  bool? hasStorefront,
  String? lastActiveAt,
  int? totalReferrals,
  bool? riderModeActive,
  bool? hasUsedFreeTrial,
}) =>
    AccountStruct(
      status: status,
      isRider: isRider,
      isVendor: isVendor,
      referredBy: referredBy,
      memberSince: memberSince,
      fcmTokenSet: fcmTokenSet,
      referralCode: referralCode,
      hasStorefront: hasStorefront,
      lastActiveAt: lastActiveAt,
      totalReferrals: totalReferrals,
      riderModeActive: riderModeActive,
      hasUsedFreeTrial: hasUsedFreeTrial,
    );
