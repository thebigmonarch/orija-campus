// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsStruct extends BaseStruct {
  NotificationsStruct({
    bool? isDefault,
    String? quietEndTime,
    bool? socialEnabled,
    bool? dispatchEnabled,
    bool? platformEnabled,
    String? quietStartTime,
    bool? communityEnabled,
    bool? liveTradeEnabled,
    bool? quietHoursEnabled,
    bool? bidActivityEnabled,
    bool? ordersPaymentsEnabled,
  })  : _isDefault = isDefault,
        _quietEndTime = quietEndTime,
        _socialEnabled = socialEnabled,
        _dispatchEnabled = dispatchEnabled,
        _platformEnabled = platformEnabled,
        _quietStartTime = quietStartTime,
        _communityEnabled = communityEnabled,
        _liveTradeEnabled = liveTradeEnabled,
        _quietHoursEnabled = quietHoursEnabled,
        _bidActivityEnabled = bidActivityEnabled,
        _ordersPaymentsEnabled = ordersPaymentsEnabled;

  // "is_default" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  set isDefault(bool? val) => _isDefault = val;

  bool hasIsDefault() => _isDefault != null;

  // "quiet_end_time" field.
  String? _quietEndTime;
  String get quietEndTime => _quietEndTime ?? '';
  set quietEndTime(String? val) => _quietEndTime = val;

  bool hasQuietEndTime() => _quietEndTime != null;

  // "social_enabled" field.
  bool? _socialEnabled;
  bool get socialEnabled => _socialEnabled ?? false;
  set socialEnabled(bool? val) => _socialEnabled = val;

  bool hasSocialEnabled() => _socialEnabled != null;

  // "dispatch_enabled" field.
  bool? _dispatchEnabled;
  bool get dispatchEnabled => _dispatchEnabled ?? false;
  set dispatchEnabled(bool? val) => _dispatchEnabled = val;

  bool hasDispatchEnabled() => _dispatchEnabled != null;

  // "platform_enabled" field.
  bool? _platformEnabled;
  bool get platformEnabled => _platformEnabled ?? false;
  set platformEnabled(bool? val) => _platformEnabled = val;

  bool hasPlatformEnabled() => _platformEnabled != null;

  // "quiet_start_time" field.
  String? _quietStartTime;
  String get quietStartTime => _quietStartTime ?? '';
  set quietStartTime(String? val) => _quietStartTime = val;

  bool hasQuietStartTime() => _quietStartTime != null;

  // "community_enabled" field.
  bool? _communityEnabled;
  bool get communityEnabled => _communityEnabled ?? false;
  set communityEnabled(bool? val) => _communityEnabled = val;

  bool hasCommunityEnabled() => _communityEnabled != null;

  // "live_trade_enabled" field.
  bool? _liveTradeEnabled;
  bool get liveTradeEnabled => _liveTradeEnabled ?? false;
  set liveTradeEnabled(bool? val) => _liveTradeEnabled = val;

  bool hasLiveTradeEnabled() => _liveTradeEnabled != null;

  // "quiet_hours_enabled" field.
  bool? _quietHoursEnabled;
  bool get quietHoursEnabled => _quietHoursEnabled ?? false;
  set quietHoursEnabled(bool? val) => _quietHoursEnabled = val;

  bool hasQuietHoursEnabled() => _quietHoursEnabled != null;

  // "bid_activity_enabled" field.
  bool? _bidActivityEnabled;
  bool get bidActivityEnabled => _bidActivityEnabled ?? false;
  set bidActivityEnabled(bool? val) => _bidActivityEnabled = val;

  bool hasBidActivityEnabled() => _bidActivityEnabled != null;

  // "orders_payments_enabled" field.
  bool? _ordersPaymentsEnabled;
  bool get ordersPaymentsEnabled => _ordersPaymentsEnabled ?? false;
  set ordersPaymentsEnabled(bool? val) => _ordersPaymentsEnabled = val;

  bool hasOrdersPaymentsEnabled() => _ordersPaymentsEnabled != null;

  static NotificationsStruct fromMap(Map<String, dynamic> data) =>
      NotificationsStruct(
        isDefault: data['is_default'] as bool?,
        quietEndTime: data['quiet_end_time'] as String?,
        socialEnabled: data['social_enabled'] as bool?,
        dispatchEnabled: data['dispatch_enabled'] as bool?,
        platformEnabled: data['platform_enabled'] as bool?,
        quietStartTime: data['quiet_start_time'] as String?,
        communityEnabled: data['community_enabled'] as bool?,
        liveTradeEnabled: data['live_trade_enabled'] as bool?,
        quietHoursEnabled: data['quiet_hours_enabled'] as bool?,
        bidActivityEnabled: data['bid_activity_enabled'] as bool?,
        ordersPaymentsEnabled: data['orders_payments_enabled'] as bool?,
      );

  static NotificationsStruct? maybeFromMap(dynamic data) => data is Map
      ? NotificationsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'is_default': _isDefault,
        'quiet_end_time': _quietEndTime,
        'social_enabled': _socialEnabled,
        'dispatch_enabled': _dispatchEnabled,
        'platform_enabled': _platformEnabled,
        'quiet_start_time': _quietStartTime,
        'community_enabled': _communityEnabled,
        'live_trade_enabled': _liveTradeEnabled,
        'quiet_hours_enabled': _quietHoursEnabled,
        'bid_activity_enabled': _bidActivityEnabled,
        'orders_payments_enabled': _ordersPaymentsEnabled,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'is_default': serializeParam(
          _isDefault,
          ParamType.bool,
        ),
        'quiet_end_time': serializeParam(
          _quietEndTime,
          ParamType.String,
        ),
        'social_enabled': serializeParam(
          _socialEnabled,
          ParamType.bool,
        ),
        'dispatch_enabled': serializeParam(
          _dispatchEnabled,
          ParamType.bool,
        ),
        'platform_enabled': serializeParam(
          _platformEnabled,
          ParamType.bool,
        ),
        'quiet_start_time': serializeParam(
          _quietStartTime,
          ParamType.String,
        ),
        'community_enabled': serializeParam(
          _communityEnabled,
          ParamType.bool,
        ),
        'live_trade_enabled': serializeParam(
          _liveTradeEnabled,
          ParamType.bool,
        ),
        'quiet_hours_enabled': serializeParam(
          _quietHoursEnabled,
          ParamType.bool,
        ),
        'bid_activity_enabled': serializeParam(
          _bidActivityEnabled,
          ParamType.bool,
        ),
        'orders_payments_enabled': serializeParam(
          _ordersPaymentsEnabled,
          ParamType.bool,
        ),
      }.withoutNulls;

  static NotificationsStruct fromSerializableMap(Map<String, dynamic> data) =>
      NotificationsStruct(
        isDefault: deserializeParam(
          data['is_default'],
          ParamType.bool,
          false,
        ),
        quietEndTime: deserializeParam(
          data['quiet_end_time'],
          ParamType.String,
          false,
        ),
        socialEnabled: deserializeParam(
          data['social_enabled'],
          ParamType.bool,
          false,
        ),
        dispatchEnabled: deserializeParam(
          data['dispatch_enabled'],
          ParamType.bool,
          false,
        ),
        platformEnabled: deserializeParam(
          data['platform_enabled'],
          ParamType.bool,
          false,
        ),
        quietStartTime: deserializeParam(
          data['quiet_start_time'],
          ParamType.String,
          false,
        ),
        communityEnabled: deserializeParam(
          data['community_enabled'],
          ParamType.bool,
          false,
        ),
        liveTradeEnabled: deserializeParam(
          data['live_trade_enabled'],
          ParamType.bool,
          false,
        ),
        quietHoursEnabled: deserializeParam(
          data['quiet_hours_enabled'],
          ParamType.bool,
          false,
        ),
        bidActivityEnabled: deserializeParam(
          data['bid_activity_enabled'],
          ParamType.bool,
          false,
        ),
        ordersPaymentsEnabled: deserializeParam(
          data['orders_payments_enabled'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'NotificationsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NotificationsStruct &&
        isDefault == other.isDefault &&
        quietEndTime == other.quietEndTime &&
        socialEnabled == other.socialEnabled &&
        dispatchEnabled == other.dispatchEnabled &&
        platformEnabled == other.platformEnabled &&
        quietStartTime == other.quietStartTime &&
        communityEnabled == other.communityEnabled &&
        liveTradeEnabled == other.liveTradeEnabled &&
        quietHoursEnabled == other.quietHoursEnabled &&
        bidActivityEnabled == other.bidActivityEnabled &&
        ordersPaymentsEnabled == other.ordersPaymentsEnabled;
  }

  @override
  int get hashCode => const ListEquality().hash([
        isDefault,
        quietEndTime,
        socialEnabled,
        dispatchEnabled,
        platformEnabled,
        quietStartTime,
        communityEnabled,
        liveTradeEnabled,
        quietHoursEnabled,
        bidActivityEnabled,
        ordersPaymentsEnabled
      ]);
}

NotificationsStruct createNotificationsStruct({
  bool? isDefault,
  String? quietEndTime,
  bool? socialEnabled,
  bool? dispatchEnabled,
  bool? platformEnabled,
  String? quietStartTime,
  bool? communityEnabled,
  bool? liveTradeEnabled,
  bool? quietHoursEnabled,
  bool? bidActivityEnabled,
  bool? ordersPaymentsEnabled,
}) =>
    NotificationsStruct(
      isDefault: isDefault,
      quietEndTime: quietEndTime,
      socialEnabled: socialEnabled,
      dispatchEnabled: dispatchEnabled,
      platformEnabled: platformEnabled,
      quietStartTime: quietStartTime,
      communityEnabled: communityEnabled,
      liveTradeEnabled: liveTradeEnabled,
      quietHoursEnabled: quietHoursEnabled,
      bidActivityEnabled: bidActivityEnabled,
      ordersPaymentsEnabled: ordersPaymentsEnabled,
    );
