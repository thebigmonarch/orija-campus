import 'dart:convert';

import 'package:flutter/material.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeToString(DateTime dateTime) =>
    '${dateTime.isUtc ? 'u' : 'l'}${dateTime.millisecondsSinceEpoch}';

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final start = dateTimeRange.start;
  final end = dateTimeRange.end;
  final startStr = '${start.isUtc ? 'u' : 'l'}${start.millisecondsSinceEpoch}';
  final endStr = '${end.isUtc ? 'u' : 'l'}${end.millisecondsSinceEpoch}';
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = dateTimeToString(param as DateTime);
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTime? dateTimeFromString(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) {
    return null;
  }
  final hasPrefix = dateTimeStr.startsWith('u') || dateTimeStr.startsWith('l');
  final milliseconds = int.tryParse(
    hasPrefix ? dateTimeStr.substring(1) : dateTimeStr,
  );
  return milliseconds != null
      ? DateTime.fromMillisecondsSinceEpoch(
          milliseconds,
          isUtc: hasPrefix ? dateTimeStr.startsWith('u') : false,
        )
      : null;
}

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  DateTime? parseDateTime(String value) {
    final hasPrefix = value.startsWith('u') || value.startsWith('l');
    final milliseconds = int.tryParse(hasPrefix ? value.substring(1) : value);
    return milliseconds != null
        ? DateTime.fromMillisecondsSinceEpoch(
            milliseconds,
            isUtc: hasPrefix ? value.startsWith('u') : false,
          )
        : null;
  }

  final start = parseDateTime(pieces.first);
  final end = parseDateTime(pieces.last);
  if (start == null || end == null) {
    return null;
  }
  return DateTimeRange(
    start: start,
    end: end,
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  DataStruct,
  SupabaseRow,

  CustomClass,
  CustomEnum,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .where((p) => p is String)
          .map((p) => p as String)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        return dateTimeFromString(param);
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case BagMessagesBackup20260916Row:
            return BagMessagesBackup20260916Row(data);
          case AdminAuditLogRow:
            return AdminAuditLogRow(data);
          case AdminBroadcastMessagesRow:
            return AdminBroadcastMessagesRow(data);
          case AdminUsersRow:
            return AdminUsersRow(data);
          case AllThreadsViewRow:
            return AllThreadsViewRow(data);
          case AppVersionsRow:
            return AppVersionsRow(data);
          case AutoBidsRow:
            return AutoBidsRow(data);
          case BagItemOfferEventsRow:
            return BagItemOfferEventsRow(data);
          case BagItemsRow:
            return BagItemsRow(data);
          case BagsRow:
            return BagsRow(data);
          case BidsRow:
            return BidsRow(data);
          case BillboardAdsRow:
            return BillboardAdsRow(data);
          case BusinessVerificationsRow:
            return BusinessVerificationsRow(data);
          case BuyerAddressesRow:
            return BuyerAddressesRow(data);
          case CategoriesRow:
            return CategoriesRow(data);
          case CategoryAttributeDefsRow:
            return CategoryAttributeDefsRow(data);
          case CommentLikesRow:
            return CommentLikesRow(data);
          case CommentViewRow:
            return CommentViewRow(data);
          case CommunitiesRow:
            return CommunitiesRow(data);
          case CommunityAnalyticsRow:
            return CommunityAnalyticsRow(data);
          case CommunityChatAuditRow:
            return CommunityChatAuditRow(data);
          case CommunityChatRestrictionsRow:
            return CommunityChatRestrictionsRow(data);
          case CommunityMembersRow:
            return CommunityMembersRow(data);
          case CommunityMembersViewRow:
            return CommunityMembersViewRow(data);
          case CommunityMessageReactionsRow:
            return CommunityMessageReactionsRow(data);
          case CommunityMessageReportsRow:
            return CommunityMessageReportsRow(data);
          case CommunityMessagesRow:
            return CommunityMessagesRow(data);
          case CommunityStorefrontsRow:
            return CommunityStorefrontsRow(data);
          case CommunitySubscriptionsRow:
            return CommunitySubscriptionsRow(data);
          case CommunityThreadMembersRow:
            return CommunityThreadMembersRow(data);
          case CommunityThreadsRow:
            return CommunityThreadsRow(data);
          case DeclutterPayoutsRow:
            return DeclutterPayoutsRow(data);
          case DeclutterReviewsRow:
            return DeclutterReviewsRow(data);
          case DeclutterSubmissionInterestsRow:
            return DeclutterSubmissionInterestsRow(data);
          case DeclutterSubmissionsRow:
            return DeclutterSubmissionsRow(data);
          case DeliveryProvidersRow:
            return DeliveryProvidersRow(data);
          case DeliverySizeBandsRow:
            return DeliverySizeBandsRow(data);
          case DeviceSessionsRow:
            return DeviceSessionsRow(data);
          case DispatchJobsRow:
            return DispatchJobsRow(data);
          case DispatchJobsMaskedRow:
            return DispatchJobsMaskedRow(data);
          case DmInvoicesRow:
            return DmInvoicesRow(data);
          case DmMessagesRow:
            return DmMessagesRow(data);
          case DmThreadAsksRow:
            return DmThreadAsksRow(data);
          case DmThreadSettingsRow:
            return DmThreadSettingsRow(data);
          case DmThreadsRow:
            return DmThreadsRow(data);
          case FaqsRow:
            return FaqsRow(data);
          case FeedViewRow:
            return FeedViewRow(data);
          case FeedbackRow:
            return FeedbackRow(data);
          case FlagsRow:
            return FlagsRow(data);
          case FollowsRow:
            return FollowsRow(data);
          case FrontStallsRow:
            return FrontStallsRow(data);
          case FxRatesRow:
            return FxRatesRow(data);
          case IdentityVerificationLogRow:
            return IdentityVerificationLogRow(data);
          case InstantPayoutRequestsRow:
            return InstantPayoutRequestsRow(data);
          case JobCounterOffersRow:
            return JobCounterOffersRow(data);
          case ListingHidesRow:
            return ListingHidesRow(data);
          case ListingSavesRow:
            return ListingSavesRow(data);
          case ListingSummaryRow:
            return ListingSummaryRow(data);
          case ListingViewsRow:
            return ListingViewsRow(data);
          case ListingsRow:
            return ListingsRow(data);
          case LiveBidConfigRow:
            return LiveBidConfigRow(data);
          case LiveSessionsRow:
            return LiveSessionsRow(data);
          case LocalGovernmentsRow:
            return LocalGovernmentsRow(data);
          case MarketCommissionLedgerRow:
            return MarketCommissionLedgerRow(data);
          case MarketStallCodesRow:
            return MarketStallCodesRow(data);
          case NotificationPreferencesRow:
            return NotificationPreferencesRow(data);
          case NotificationsRow:
            return NotificationsRow(data);
          case OjaRankEventsRow:
            return OjaRankEventsRow(data);
          case OjaRankHistoryRow:
            return OjaRankHistoryRow(data);
          case OjaTiersRow:
            return OjaTiersRow(data);
          case OnboardingSlidesRow:
            return OnboardingSlidesRow(data);
          case OrderDeliveryQuotesRow:
            return OrderDeliveryQuotesRow(data);
          case OrderItemsRow:
            return OrderItemsRow(data);
          case OrderReviewNudgesRow:
            return OrderReviewNudgesRow(data);
          case OrderTerminalRatesRow:
            return OrderTerminalRatesRow(data);
          case OrdersRow:
            return OrdersRow(data);
          case PayoutChangeLogRow:
            return PayoutChangeLogRow(data);
          case PendingReferralsRow:
            return PendingReferralsRow(data);
          case PlatformConfigRow:
            return PlatformConfigRow(data);
          case PostCommentsRow:
            return PostCommentsRow(data);
          case PostCommunityTagsRow:
            return PostCommunityTagsRow(data);
          case PostCommunityTagsViewRow:
            return PostCommunityTagsViewRow(data);
          case PostHidesRow:
            return PostHidesRow(data);
          case PostLikesRow:
            return PostLikesRow(data);
          case PostRecommendsRow:
            return PostRecommendsRow(data);
          case PostSavesRow:
            return PostSavesRow(data);
          case PostsRow:
            return PostsRow(data);
          case PromotedSlotsRow:
            return PromotedSlotsRow(data);
          case PushDebugLogRow:
            return PushDebugLogRow(data);
          case QrScanLogRow:
            return QrScanLogRow(data);
          case ReplayProductMomentsRow:
            return ReplayProductMomentsRow(data);
          case ReportsRow:
            return ReportsRow(data);
          case ReservedSlugsRow:
            return ReservedSlugsRow(data);
          case ReviewLikesRow:
            return ReviewLikesRow(data);
          case ReviewRepliesRow:
            return ReviewRepliesRow(data);
          case ReviewReplyLikesRow:
            return ReviewReplyLikesRow(data);
          case ReviewsRow:
            return ReviewsRow(data);
          case RiderEarningsRow:
            return RiderEarningsRow(data);
          case RiderPayoutBatchesRow:
            return RiderPayoutBatchesRow(data);
          case RiderProfilesRow:
            return RiderProfilesRow(data);
          case SessionCommunityTagsRow:
            return SessionCommunityTagsRow(data);
          case SessionRemindersRow:
            return SessionRemindersRow(data);
          case SessionReplaysRow:
            return SessionReplaysRow(data);
          case SessionSaleItemsRow:
            return SessionSaleItemsRow(data);
          case SessionViewersRow:
            return SessionViewersRow(data);
          case ShareEventsRow:
            return ShareEventsRow(data);
          case StatesRow:
            return StatesRow(data);
          case StorefrontAnalyticsRow:
            return StorefrontAnalyticsRow(data);
          case StorefrontCustomisationRow:
            return StorefrontCustomisationRow(data);
          case StorefrontQrCodesRow:
            return StorefrontQrCodesRow(data);
          case StorefrontsRow:
            return StorefrontsRow(data);
          case StorefrontsWithReviewSummaryRow:
            return StorefrontsWithReviewSummaryRow(data);
          case SubcategoriesRow:
            return SubcategoriesRow(data);
          case SubscriptionPlansRow:
            return SubscriptionPlansRow(data);
          case SubscriptionsRow:
            return SubscriptionsRow(data);
          case SupportEventsRow:
            return SupportEventsRow(data);
          case SupportFaqsRow:
            return SupportFaqsRow(data);
          case SupportPostsRow:
            return SupportPostsRow(data);
          case SupportReadsRow:
            return SupportReadsRow(data);
          case SupportTrackProgressRow:
            return SupportTrackProgressRow(data);
          case UserActivityDaysRow:
            return UserActivityDaysRow(data);
          case UserBadgeCountsRow:
            return UserBadgeCountsRow(data);
          case UserBlocksRow:
            return UserBlocksRow(data);
          case UserHidesRow:
            return UserHidesRow(data);
          case UserInterestsRow:
            return UserInterestsRow(data);
          case UserOjaProgressRow:
            return UserOjaProgressRow(data);
          case UserPublicProfileRow:
            return UserPublicProfileRow(data);
          case UsersRow:
            return UsersRow(data);
          case UsersWithSubscriptionRow:
            return UsersWithSubscriptionRow(data);
          case VBagItemsRow:
            return VBagItemsRow(data);
          case VDmMessagesFullRow:
            return VDmMessagesFullRow(data);
          case VGroupchatReportsRow:
            return VGroupchatReportsRow(data);
          case VOrderFullRow:
            return VOrderFullRow(data);
          case VUserInboxCountsRow:
            return VUserInboxCountsRow(data);
          case WaitlistRow:
            return WaitlistRow(data);
          default:
            return null;
        }

      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}
