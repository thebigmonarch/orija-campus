// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlanStruct extends BaseStruct {
  PlanStruct({
    int? trialDays,
    String? displayName,
    int? communitySlots,
    bool? customBranding,
    double? annualPriceNgn,
    int? liveBidCredits,
    bool? analyticsEnabled,
    int? liveSaleCredits,
    int? liveSaleMinutes,
    double? monthlyPriceNgn,
    int? annualMonthsFree,
    bool? promotedDiscovery,
    int? maxActiveListings,
  })  : _trialDays = trialDays,
        _displayName = displayName,
        _communitySlots = communitySlots,
        _customBranding = customBranding,
        _annualPriceNgn = annualPriceNgn,
        _liveBidCredits = liveBidCredits,
        _analyticsEnabled = analyticsEnabled,
        _liveSaleCredits = liveSaleCredits,
        _liveSaleMinutes = liveSaleMinutes,
        _monthlyPriceNgn = monthlyPriceNgn,
        _annualMonthsFree = annualMonthsFree,
        _promotedDiscovery = promotedDiscovery,
        _maxActiveListings = maxActiveListings;

  // "trial_days" field.
  int? _trialDays;
  int get trialDays => _trialDays ?? 0;
  set trialDays(int? val) => _trialDays = val;

  void incrementTrialDays(int amount) => trialDays = trialDays + amount;

  bool hasTrialDays() => _trialDays != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  set displayName(String? val) => _displayName = val;

  bool hasDisplayName() => _displayName != null;

  // "community_slots" field.
  int? _communitySlots;
  int get communitySlots => _communitySlots ?? 0;
  set communitySlots(int? val) => _communitySlots = val;

  void incrementCommunitySlots(int amount) =>
      communitySlots = communitySlots + amount;

  bool hasCommunitySlots() => _communitySlots != null;

  // "custom_branding" field.
  bool? _customBranding;
  bool get customBranding => _customBranding ?? false;
  set customBranding(bool? val) => _customBranding = val;

  bool hasCustomBranding() => _customBranding != null;

  // "annual_price_ngn" field.
  double? _annualPriceNgn;
  double get annualPriceNgn => _annualPriceNgn ?? 0.0;
  set annualPriceNgn(double? val) => _annualPriceNgn = val;

  void incrementAnnualPriceNgn(double amount) =>
      annualPriceNgn = annualPriceNgn + amount;

  bool hasAnnualPriceNgn() => _annualPriceNgn != null;

  // "live_bid_credits" field.
  int? _liveBidCredits;
  int get liveBidCredits => _liveBidCredits ?? 0;
  set liveBidCredits(int? val) => _liveBidCredits = val;

  void incrementLiveBidCredits(int amount) =>
      liveBidCredits = liveBidCredits + amount;

  bool hasLiveBidCredits() => _liveBidCredits != null;

  // "analytics_enabled" field.
  bool? _analyticsEnabled;
  bool get analyticsEnabled => _analyticsEnabled ?? false;
  set analyticsEnabled(bool? val) => _analyticsEnabled = val;

  bool hasAnalyticsEnabled() => _analyticsEnabled != null;

  // "live_sale_credits" field.
  int? _liveSaleCredits;
  int get liveSaleCredits => _liveSaleCredits ?? 0;
  set liveSaleCredits(int? val) => _liveSaleCredits = val;

  void incrementLiveSaleCredits(int amount) =>
      liveSaleCredits = liveSaleCredits + amount;

  bool hasLiveSaleCredits() => _liveSaleCredits != null;

  // "live_sale_minutes" field.
  int? _liveSaleMinutes;
  int get liveSaleMinutes => _liveSaleMinutes ?? 0;
  set liveSaleMinutes(int? val) => _liveSaleMinutes = val;

  void incrementLiveSaleMinutes(int amount) =>
      liveSaleMinutes = liveSaleMinutes + amount;

  bool hasLiveSaleMinutes() => _liveSaleMinutes != null;

  // "monthly_price_ngn" field.
  double? _monthlyPriceNgn;
  double get monthlyPriceNgn => _monthlyPriceNgn ?? 0.0;
  set monthlyPriceNgn(double? val) => _monthlyPriceNgn = val;

  void incrementMonthlyPriceNgn(double amount) =>
      monthlyPriceNgn = monthlyPriceNgn + amount;

  bool hasMonthlyPriceNgn() => _monthlyPriceNgn != null;

  // "annual_months_free" field.
  int? _annualMonthsFree;
  int get annualMonthsFree => _annualMonthsFree ?? 0;
  set annualMonthsFree(int? val) => _annualMonthsFree = val;

  void incrementAnnualMonthsFree(int amount) =>
      annualMonthsFree = annualMonthsFree + amount;

  bool hasAnnualMonthsFree() => _annualMonthsFree != null;

  // "promoted_discovery" field.
  bool? _promotedDiscovery;
  bool get promotedDiscovery => _promotedDiscovery ?? false;
  set promotedDiscovery(bool? val) => _promotedDiscovery = val;

  bool hasPromotedDiscovery() => _promotedDiscovery != null;

  // "max_active_listings" field.
  int? _maxActiveListings;
  int get maxActiveListings => _maxActiveListings ?? 0;
  set maxActiveListings(int? val) => _maxActiveListings = val;

  void incrementMaxActiveListings(int amount) =>
      maxActiveListings = maxActiveListings + amount;

  bool hasMaxActiveListings() => _maxActiveListings != null;

  static PlanStruct fromMap(Map<String, dynamic> data) => PlanStruct(
        trialDays: castToType<int>(data['trial_days']),
        displayName: data['display_name'] as String?,
        communitySlots: castToType<int>(data['community_slots']),
        customBranding: data['custom_branding'] as bool?,
        annualPriceNgn: castToType<double>(data['annual_price_ngn']),
        liveBidCredits: castToType<int>(data['live_bid_credits']),
        analyticsEnabled: data['analytics_enabled'] as bool?,
        liveSaleCredits: castToType<int>(data['live_sale_credits']),
        liveSaleMinutes: castToType<int>(data['live_sale_minutes']),
        monthlyPriceNgn: castToType<double>(data['monthly_price_ngn']),
        annualMonthsFree: castToType<int>(data['annual_months_free']),
        promotedDiscovery: data['promoted_discovery'] as bool?,
        maxActiveListings: castToType<int>(data['max_active_listings']),
      );

  static PlanStruct? maybeFromMap(dynamic data) =>
      data is Map ? PlanStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'trial_days': _trialDays,
        'display_name': _displayName,
        'community_slots': _communitySlots,
        'custom_branding': _customBranding,
        'annual_price_ngn': _annualPriceNgn,
        'live_bid_credits': _liveBidCredits,
        'analytics_enabled': _analyticsEnabled,
        'live_sale_credits': _liveSaleCredits,
        'live_sale_minutes': _liveSaleMinutes,
        'monthly_price_ngn': _monthlyPriceNgn,
        'annual_months_free': _annualMonthsFree,
        'promoted_discovery': _promotedDiscovery,
        'max_active_listings': _maxActiveListings,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'trial_days': serializeParam(
          _trialDays,
          ParamType.int,
        ),
        'display_name': serializeParam(
          _displayName,
          ParamType.String,
        ),
        'community_slots': serializeParam(
          _communitySlots,
          ParamType.int,
        ),
        'custom_branding': serializeParam(
          _customBranding,
          ParamType.bool,
        ),
        'annual_price_ngn': serializeParam(
          _annualPriceNgn,
          ParamType.double,
        ),
        'live_bid_credits': serializeParam(
          _liveBidCredits,
          ParamType.int,
        ),
        'analytics_enabled': serializeParam(
          _analyticsEnabled,
          ParamType.bool,
        ),
        'live_sale_credits': serializeParam(
          _liveSaleCredits,
          ParamType.int,
        ),
        'live_sale_minutes': serializeParam(
          _liveSaleMinutes,
          ParamType.int,
        ),
        'monthly_price_ngn': serializeParam(
          _monthlyPriceNgn,
          ParamType.double,
        ),
        'annual_months_free': serializeParam(
          _annualMonthsFree,
          ParamType.int,
        ),
        'promoted_discovery': serializeParam(
          _promotedDiscovery,
          ParamType.bool,
        ),
        'max_active_listings': serializeParam(
          _maxActiveListings,
          ParamType.int,
        ),
      }.withoutNulls;

  static PlanStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlanStruct(
        trialDays: deserializeParam(
          data['trial_days'],
          ParamType.int,
          false,
        ),
        displayName: deserializeParam(
          data['display_name'],
          ParamType.String,
          false,
        ),
        communitySlots: deserializeParam(
          data['community_slots'],
          ParamType.int,
          false,
        ),
        customBranding: deserializeParam(
          data['custom_branding'],
          ParamType.bool,
          false,
        ),
        annualPriceNgn: deserializeParam(
          data['annual_price_ngn'],
          ParamType.double,
          false,
        ),
        liveBidCredits: deserializeParam(
          data['live_bid_credits'],
          ParamType.int,
          false,
        ),
        analyticsEnabled: deserializeParam(
          data['analytics_enabled'],
          ParamType.bool,
          false,
        ),
        liveSaleCredits: deserializeParam(
          data['live_sale_credits'],
          ParamType.int,
          false,
        ),
        liveSaleMinutes: deserializeParam(
          data['live_sale_minutes'],
          ParamType.int,
          false,
        ),
        monthlyPriceNgn: deserializeParam(
          data['monthly_price_ngn'],
          ParamType.double,
          false,
        ),
        annualMonthsFree: deserializeParam(
          data['annual_months_free'],
          ParamType.int,
          false,
        ),
        promotedDiscovery: deserializeParam(
          data['promoted_discovery'],
          ParamType.bool,
          false,
        ),
        maxActiveListings: deserializeParam(
          data['max_active_listings'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PlanStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlanStruct &&
        trialDays == other.trialDays &&
        displayName == other.displayName &&
        communitySlots == other.communitySlots &&
        customBranding == other.customBranding &&
        annualPriceNgn == other.annualPriceNgn &&
        liveBidCredits == other.liveBidCredits &&
        analyticsEnabled == other.analyticsEnabled &&
        liveSaleCredits == other.liveSaleCredits &&
        liveSaleMinutes == other.liveSaleMinutes &&
        monthlyPriceNgn == other.monthlyPriceNgn &&
        annualMonthsFree == other.annualMonthsFree &&
        promotedDiscovery == other.promotedDiscovery &&
        maxActiveListings == other.maxActiveListings;
  }

  @override
  int get hashCode => const ListEquality().hash([
        trialDays,
        displayName,
        communitySlots,
        customBranding,
        annualPriceNgn,
        liveBidCredits,
        analyticsEnabled,
        liveSaleCredits,
        liveSaleMinutes,
        monthlyPriceNgn,
        annualMonthsFree,
        promotedDiscovery,
        maxActiveListings
      ]);
}

PlanStruct createPlanStruct({
  int? trialDays,
  String? displayName,
  int? communitySlots,
  bool? customBranding,
  double? annualPriceNgn,
  int? liveBidCredits,
  bool? analyticsEnabled,
  int? liveSaleCredits,
  int? liveSaleMinutes,
  double? monthlyPriceNgn,
  int? annualMonthsFree,
  bool? promotedDiscovery,
  int? maxActiveListings,
}) =>
    PlanStruct(
      trialDays: trialDays,
      displayName: displayName,
      communitySlots: communitySlots,
      customBranding: customBranding,
      annualPriceNgn: annualPriceNgn,
      liveBidCredits: liveBidCredits,
      analyticsEnabled: analyticsEnabled,
      liveSaleCredits: liveSaleCredits,
      liveSaleMinutes: liveSaleMinutes,
      monthlyPriceNgn: monthlyPriceNgn,
      annualMonthsFree: annualMonthsFree,
      promotedDiscovery: promotedDiscovery,
      maxActiveListings: maxActiveListings,
    );
