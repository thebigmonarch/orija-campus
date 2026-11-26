import 'dart:convert';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, DateTimeRange;
// Redundant when the data-type schema export already re-exports it.
// ignore: unnecessary_import
import 'package:from_css_color/from_css_color.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class ExplorecommunitiesCall {
  static Future<ApiCallResponse> call({
    int? pLimit,
    int? pOffset,
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_limit": ${pLimit == null ? 'null' : '"${pLimit}"'},
  "p_offset": ${pOffset == null ? 'null' : '"${pOffset}"'},
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'explorecommunities',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/explore_communities',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$[:].category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? coverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? membercount(dynamic response) => (getJsonField(
        response,
        r'''$[:].member_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? vendorcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].vendor_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<bool>? isseed(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_seed''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class GetCommunityPageCall {
  static Future<ApiCallResponse> call({
    String? communityID = '',
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "input_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "viewer_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Community Page',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_community_page_v2',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdmingetdashboardstatsCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'admingetdashboardstats',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/admin_get_dashboard_stats',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      bodyType: BodyType.NONE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdmingetdashboardstatsCopyCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'admingetdashboardstats Copy',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/admin_get_revenue_analytics',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      bodyType: BodyType.NONE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetojaleaderboardCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getojaleaderboard',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_oja_leaderboard',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatenotificationpreferencesCall {
  static Future<ApiCallResponse> call({
    bool? pBidActivityEnabled,
    bool? pCommunityEnabled,
    bool? pDispatchEnabled,
    bool? pLiveTradeEnabled,
    bool? pOrdersPaymentsEnabled,
    bool? pPlatformEnabled,
    String? pQuietEndTime = '',
    bool? pQuietHoursEnabled,
    String? pQuietStartTime = '',
    bool? pSocialEnabled,
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bid_activity_enabled": ${pBidActivityEnabled == null ? 'null' : '"${pBidActivityEnabled}"'},
  "p_community_enabled": ${pCommunityEnabled == null ? 'null' : '"${pCommunityEnabled}"'},
  "p_dispatch_enabled": ${pDispatchEnabled == null ? 'null' : '"${pDispatchEnabled}"'},
  "p_live_trade_enabled": ${pLiveTradeEnabled == null ? 'null' : '"${pLiveTradeEnabled}"'},
  "p_orders_payments_enabled": ${pOrdersPaymentsEnabled == null ? 'null' : '"${pOrdersPaymentsEnabled}"'},
  "p_platform_enabled": "v${pPlatformEnabled}",
  "p_quiet_end_time": ${pQuietEndTime == null ? 'null' : '"${escapeStringForJson(pQuietEndTime)}"'},
  "p_quiet_hours_enabled": ${pQuietHoursEnabled == null ? 'null' : '"${pQuietHoursEnabled}"'},
  "p_quiet_start_time": ${pQuietStartTime == null ? 'null' : '"${escapeStringForJson(pQuietStartTime)}"'},
  "p_social_enabled": ${pSocialEnabled == null ? 'null' : '"${pSocialEnabled}"'},
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updatenotificationpreferences',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/update_notification_preferences',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdmingetrevenueanalyticsCall {
  static Future<ApiCallResponse> call({
    String? period = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_period": ${period == null ? 'null' : '"${escapeStringForJson(period)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'admingetrevenueanalytics',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/admin_get_revenue_analytics',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetsettingspageCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsettingspage',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_settings_page',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarketHeadDashboardPageCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? communityID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "p_head_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Market Head Dashboard Page',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/market_head_get_dashboard',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitDeclutterItemCall {
  static Future<ApiCallResponse> call({
    double? pAskingPrice,
    String? pCategory = '',
    String? pCondition = '',
    String? pDeclutterSfId = '',
    String? pDescription = '',
    bool? pIsBroadcast,
    String? pOwnerId = '',
    String? pOwnerPhone = '',
    List<String>? pPhotosList,
    String? pPickupAddressLine = '',
    String? pPickupCity = '',
    String? pPickupLandmark = '',
    String? pPickupState = '',
    String? pSubcategory = '',
    String? pTitle = '',
  }) async {
    final pPhotos = _serializeList(pPhotosList);

    final ffApiRequestBody = '''
{
  "p_asking_price": ${pAskingPrice == null ? 'null' : '"${pAskingPrice}"'},
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_condition": ${pCondition == null ? 'null' : '"${escapeStringForJson(pCondition)}"'},
  "p_declutter_sf_id": ${pDeclutterSfId == null ? 'null' : '"${escapeStringForJson(pDeclutterSfId)}"'},
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_is_broadcast": ${pIsBroadcast == null ? 'null' : '"${pIsBroadcast}"'},
  "p_owner_id": ${pOwnerId == null ? 'null' : '"${escapeStringForJson(pOwnerId)}"'},
  "p_owner_phone": ${pOwnerPhone == null ? 'null' : '"${escapeStringForJson(pOwnerPhone)}"'},
  "p_photos": "${pPhotos}",
  "p_pickup_address_line": ${pPickupAddressLine == null ? 'null' : '"${escapeStringForJson(pPickupAddressLine)}"'},
  "p_pickup_city": ${pPickupCity == null ? 'null' : '"${escapeStringForJson(pPickupCity)}"'},
  "p_pickup_landmark": ${pPickupLandmark == null ? 'null' : '"${escapeStringForJson(pPickupLandmark)}"'},
  "p_pickup_state": ${pPickupState == null ? 'null' : '"${escapeStringForJson(pPickupState)}"'},
  "p_subcategory": ${pSubcategory == null ? 'null' : '"${escapeStringForJson(pSubcategory)}"'},
  "p_title": ${pTitle == null ? 'null' : '"${escapeStringForJson(pTitle)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Submit Declutter Item',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/submit_declutter_item',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetCategoryPageCall {
  static Future<ApiCallResponse> call({
    String? communityID = '',
    String? filterSubtype = '',
    String? inputCategorySlug = '',
    int? pageLimit,
    int? pageOffset,
  }) async {
    final ffApiRequestBody = '''
{
  "filter_subtype": ${filterSubtype == null ? 'null' : '"${escapeStringForJson(filterSubtype)}"'},
  "input_category_slug": ${inputCategorySlug == null ? 'null' : '"${escapeStringForJson(inputCategorySlug)}"'},
  "input_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "page_limit": ${pageLimit == null ? 'null' : '"${pageLimit}"'},
  "page_offset": ${pageOffset == null ? 'null' : '"${pageOffset}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Category Page',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_category_page',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetSubcategoryListingCall {
  static Future<ApiCallResponse> call({
    int? pageLimit,
    int? pageOffset,
    String? filterCondition = '',
    double? filterMaxPrice,
    double? filterMinPrice,
    String? filterState = '',
    String? inputSubcategorySlug = '',
    String? searchQuery = '',
    String? sortBy = '',
    String? communityID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "filter_condition": ${filterCondition == null ? 'null' : '"${escapeStringForJson(filterCondition)}"'},
  "filter_max_price": ${filterMaxPrice == null ? 'null' : '"${filterMaxPrice}"'},
  "filter_min_price": ${filterMinPrice == null ? 'null' : '"${filterMinPrice}"'},
  "filter_state": ${filterState == null ? 'null' : '"${escapeStringForJson(filterState)}"'},
  "input_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "input_subcategory_slug": ${inputSubcategorySlug == null ? 'null' : '"${escapeStringForJson(inputSubcategorySlug)}"'},
  "page_limit": ${pageLimit == null ? 'null' : '"${pageLimit}"'},
  "page_offset": ${pageOffset == null ? 'null' : '"${pageOffset}"'},
  "search_query": ${searchQuery == null ? 'null' : '"${escapeStringForJson(searchQuery)}"'},
  "sort_by": ${sortBy == null ? 'null' : '"${escapeStringForJson(sortBy)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Subcategory listing',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_subcategory_listings',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ExploremarketplaceCall {
  static Future<ApiCallResponse> call({
    int? pLimit,
    int? pOffset,
    String? pUserId = '',
    String? pCategory = '',
    String? pCondition = '',
    String? pSearch = '',
    String? pType = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_condition": ${pCondition == null ? 'null' : '"${escapeStringForJson(pCondition)}"'},
  "p_limit": ${pLimit == null ? 'null' : '"${pLimit}"'},
  "p_offset": ${pOffset == null ? 'null' : '"${pOffset}"'},
  "p_search": ${pSearch == null ? 'null' : '"${escapeStringForJson(pSearch)}"'},
  "p_type": ${pType == null ? 'null' : '"${escapeStringForJson(pType)}"'},
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'exploremarketplace',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/explore_marketplace',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$[:].category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? coverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? membercount(dynamic response) => (getJsonField(
        response,
        r'''$[:].member_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? vendorcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].vendor_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<bool>? isseed(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_seed''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class CreatestorefrontCall {
  static Future<ApiCallResponse> call({
    String? pAddressLine = '',
    String? pCategory = '',
    String? pCity = '',
    String? pCountry = '',
    String? pDescription = '',
    double? pLat,
    double? pLng,
    String? pLogoUrl = '',
    String? pName = '',
    String? pOwnerId = '',
    String? pPhone = '',
    String? pState = '',
    List<String>? pSubCategoriesList,
    String? coverUrl = '',
    bool? pAcceptsSubmissions,
    String? pDeclutterBio = '',
    double? pCommissionRate,
    String? pStorefrontType = '',
  }) async {
    final pSubCategories = _serializeList(pSubCategoriesList);

    final ffApiRequestBody = '''
{
  "p_accepts_submissions": ${pAcceptsSubmissions == null ? 'null' : '"${pAcceptsSubmissions}"'},
  "p_address_line": ${pAddressLine == null ? 'null' : '"${escapeStringForJson(pAddressLine)}"'},
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_city": ${pCity == null ? 'null' : '"${escapeStringForJson(pCity)}"'},
  "p_commission_rate": ${pCommissionRate == null ? 'null' : '"${pCommissionRate}"'},
  "p_country": ${pCountry == null ? 'null' : '"${escapeStringForJson(pCountry)}"'},
  "p_cover_url": ${coverUrl == null ? 'null' : '"${escapeStringForJson(coverUrl)}"'},
  "p_declutter_bio": ${pDeclutterBio == null ? 'null' : '"${escapeStringForJson(pDeclutterBio)}"'},
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_lat": ${pLat == null ? 'null' : '"${pLat}"'},
  "p_lng": ${pLng == null ? 'null' : '"${pLng}"'},
  "p_logo_url": ${pLogoUrl == null ? 'null' : '"${escapeStringForJson(pLogoUrl)}"'},
  "p_name": ${pName == null ? 'null' : '"${escapeStringForJson(pName)}"'},
  "p_owner_id": ${pOwnerId == null ? 'null' : '"${escapeStringForJson(pOwnerId)}"'},
  "p_phone": ${pPhone == null ? 'null' : '"${escapeStringForJson(pPhone)}"'},
  "p_state": ${pState == null ? 'null' : '"${escapeStringForJson(pState)}"'},
  "p_storefront_type": ${pStorefrontType == null ? 'null' : '"${escapeStringForJson(pStorefrontType)}"'},
  "p_sub_categories": "${pSubCategories}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createstorefront',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/create_storefront',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic success(dynamic response) => getJsonField(
        response,
        r'''$[:].success''',
      );
  static dynamic storefrontID(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_id''',
      );
  static dynamic needsSubscription(dynamic response) => getJsonField(
        response,
        r'''$[:].needs_subscription''',
      );
  static dynamic message(dynamic response) => getJsonField(
        response,
        r'''$[:].message''',
      );
}

class CreatestorefrontCopyCall {
  static Future<ApiCallResponse> call({
    String? pAddressLine = '',
    String? pCategory = '',
    String? pCity = '',
    String? pCountry = '',
    String? pDescription = '',
    double? pLat,
    double? pLng,
    String? pLogoUrl = '',
    String? pName = '',
    String? pOwnerId = '',
    String? pPhone = '',
    String? pState = '',
    List<String>? pSubCategoriesList,
    String? coverUrl = '',
    bool? pAcceptsSubmissions,
    String? pDeclutterBio = '',
    double? pCommissionRate,
    String? pStorefrontType = '',
  }) async {
    final pSubCategories = _serializeList(pSubCategoriesList);

    final ffApiRequestBody = '''
{
  "p_accepts_submissions": ${pAcceptsSubmissions == null ? 'null' : '"${pAcceptsSubmissions}"'},
  "p_address_line": ${pAddressLine == null ? 'null' : '"${escapeStringForJson(pAddressLine)}"'},
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_city": ${pCity == null ? 'null' : '"${escapeStringForJson(pCity)}"'},
  "p_commission_rate": ${pCommissionRate == null ? 'null' : '"${pCommissionRate}"'},
  "p_country": ${pCountry == null ? 'null' : '"${escapeStringForJson(pCountry)}"'},
  "p_cover_url": ${coverUrl == null ? 'null' : '"${escapeStringForJson(coverUrl)}"'},
  "p_declutter_bio": ${pDeclutterBio == null ? 'null' : '"${escapeStringForJson(pDeclutterBio)}"'},
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_lat": ${pLat == null ? 'null' : '"${pLat}"'},
  "p_lng": ${pLng == null ? 'null' : '"${pLng}"'},
  "p_logo_url": ${pLogoUrl == null ? 'null' : '"${escapeStringForJson(pLogoUrl)}"'},
  "p_name": ${pName == null ? 'null' : '"${escapeStringForJson(pName)}"'},
  "p_owner_id": ${pOwnerId == null ? 'null' : '"${escapeStringForJson(pOwnerId)}"'},
  "p_phone": ${pPhone == null ? 'null' : '"${escapeStringForJson(pPhone)}"'},
  "p_state": ${pState == null ? 'null' : '"${escapeStringForJson(pState)}"'},
  "p_storefront_type": ${pStorefrontType == null ? 'null' : '"${escapeStringForJson(pStorefrontType)}"'},
  "p_sub_categories": "${pSubCategories}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createstorefront Copy',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/create_storefront',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic success(dynamic response) => getJsonField(
        response,
        r'''$[:].success''',
      );
  static dynamic storefrontID(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_id''',
      );
  static dynamic needsSubscription(dynamic response) => getJsonField(
        response,
        r'''$[:].needs_subscription''',
      );
  static dynamic message(dynamic response) => getJsonField(
        response,
        r'''$[:].message''',
      );
}

class SendCommentCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? content = '',
    String? parentId = '',
    String? postId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_author_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "p_content": ${content == null ? 'null' : '"${escapeStringForJson(content)}"'},
  "p_parent_id": ${parentId == null ? 'null' : '"${escapeStringForJson(parentId)}"'},
  "p_post_id": ${postId == null ? 'null' : '"${escapeStringForJson(postId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Send Comment',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/send_comment',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? postid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.post_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static bool? isreply(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.is_reply''',
      ));
  static String? commentid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.comment_id''',
      ));
  static dynamic parentid(dynamic response) => getJsonField(
        response,
        r'''$.parent_id''',
      );
}

class MarkNotificationUnreadCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? notificationID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_notification_id": ${notificationID == null ? 'null' : '"${escapeStringForJson(notificationID)}"'},
  "p_user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Mark notification unread',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/mark_notification_unread',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetNewChatVendorsCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_search": ${search == null ? 'null' : '"${escapeStringForJson(search)}"'},
  "p_user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get new chat vendors',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_new_chat_vendors',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitFeedbackCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? pAppVersion = '',
    String? pBody = '',
    String? pDeviceInfo = '',
    List<String>? pMediaUrlsList,
    String? pScreenName = '',
    String? pSubject = '',
    String? pType = '',
  }) async {
    final pMediaUrls = _serializeList(pMediaUrlsList);

    final ffApiRequestBody = '''
{
  "p_app_version": ${pAppVersion == null ? 'null' : '"${escapeStringForJson(pAppVersion)}"'},
  "p_body": ${pBody == null ? 'null' : '"${escapeStringForJson(pBody)}"'},
  "p_device_info": ${pDeviceInfo == null ? 'null' : '"${escapeStringForJson(pDeviceInfo)}"'},
  "p_media_urls": "${pMediaUrls}",
  "p_screen_name": ${pScreenName == null ? 'null' : '"${escapeStringForJson(pScreenName)}"'},
  "p_subject": ${pSubject == null ? 'null' : '"${escapeStringForJson(pSubject)}"'},
  "p_type": ${pType == null ? 'null' : '"${escapeStringForJson(pType)}"'},
  "p_user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Submit Feedback',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/submit_feedback',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? feedbackid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.feedback_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class SubmitReportCall {
  static Future<ApiCallResponse> call({
    String? pDescription = '',
    String? pReason = '',
    String? pReporterId = '',
    String? pTargetId = '',
    String? pTargetType = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_reason": ${pReason == null ? 'null' : '"${escapeStringForJson(pReason)}"'},
  "p_reporter_id": ${pReporterId == null ? 'null' : '"${escapeStringForJson(pReporterId)}"'},
  "p_target_id": ${pTargetId == null ? 'null' : '"${escapeStringForJson(pTargetId)}"'},
  "p_target_type": ${pTargetType == null ? 'null' : '"${escapeStringForJson(pTargetType)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Submit Report',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/submit_report',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? reportid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.report_id''',
      ));
}

class CreatepostCall {
  static Future<ApiCallResponse> call({
    bool? pAskBroadcast,
    double? pAskBudgetMax,
    double? pAskBudgetMin,
    String? pAuthorId = '',
    String? pCategory = '',
    List<String>? pCommunityIdsList,
    String? pContent = '',
    String? pListingId = '',
    List<String>? pMediaUrlsList,
    String? pStorefrontId = '',
    String? pSubcategory = '',
    String? pType = '',
  }) async {
    final pCommunityIds = _serializeList(pCommunityIdsList);
    final pMediaUrls = _serializeList(pMediaUrlsList);

    final ffApiRequestBody = '''
{
  "p_author_id": ${pAuthorId == null ? 'null' : '"${escapeStringForJson(pAuthorId)}"'},
  "p_type": ${pType == null ? 'null' : '"${escapeStringForJson(pType)}"'},
  "p_content": ${pContent == null ? 'null' : '"${escapeStringForJson(pContent)}"'},
  "p_media_urls": "${pMediaUrls}",
  "p_storefront_id": ${pStorefrontId == null ? 'null' : '"${escapeStringForJson(pStorefrontId)}"'},
  "p_listing_id": ${pListingId == null ? 'null' : '"${escapeStringForJson(pListingId)}"'},
  "p_community_ids": "${pCommunityIds}",
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_subcategory": ${pSubcategory == null ? 'null' : '"${escapeStringForJson(pSubcategory)}"'},
  "p_ask_budget_min": ${pAskBudgetMin == null ? 'null' : '"${pAskBudgetMin}"'},
  "p_ask_budget_max": ${pAskBudgetMax == null ? 'null' : '"${pAskBudgetMax}"'},
  "p_ask_broadcast": ${pAskBroadcast == null ? 'null' : '"${pAskBroadcast}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createpost',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/create-post',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? type(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.type''',
      ));
  static String? postid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.post_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static bool? isvendor(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.is_vendor''',
      ));
  static bool? broadcast(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.broadcast''',
      ));
}

class CreateListingCall {
  static Future<ApiCallResponse> call({
    List<String>? photoUrlsList,
    String? pStorefrontId = '',
    String? pTitle = '',
    String? pDescription = '',
    String? pCategory = '',
    String? pSubcategory = '',
    String? pPricingType = '',
    double? pPrice,
    String? pCondition = '',
    String? pCurrency = '',
    int? pStockQuantity,
    bool? pIsNegotiable,
    String? pPrimaryImageUrl = '',
    int? pWeightKg,
    bool? pIsFragile,
    String? pDeliveryMethod = '',
    String? pType = '',
  }) async {
    final photoUrls = _serializeList(photoUrlsList);

    final ffApiRequestBody = '''
{
  "p_storefront_id": ${pStorefrontId == null ? 'null' : '"${escapeStringForJson(pStorefrontId)}"'},
  "p_title": ${pTitle == null ? 'null' : '"${escapeStringForJson(pTitle)}"'},
  "p_type": ${pType == null ? 'null' : '"${escapeStringForJson(pType)}"'},
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_subcategory": ${pSubcategory == null ? 'null' : '"${escapeStringForJson(pSubcategory)}"'},
  "p_price": ${pPrice == null ? 'null' : '"${pPrice}"'},
  "p_pricing_type": ${pPricingType == null ? 'null' : '"${escapeStringForJson(pPricingType)}"'},
  "p_condition": ${pCondition == null ? 'null' : '"${escapeStringForJson(pCondition)}"'},
  "p_currency": ${pCurrency == null ? 'null' : '"${escapeStringForJson(pCurrency)}"'},
  "p_stock_quantity": ${pStockQuantity == null ? 'null' : '"${pStockQuantity}"'},
  "p_is_negotiable": ${pIsNegotiable == null ? 'null' : '"${pIsNegotiable}"'},
  "p_primary_image_url": ${pPrimaryImageUrl == null ? 'null' : '"${escapeStringForJson(pPrimaryImageUrl)}"'},
  "p_photos": "${photoUrls}",
  "p_weight_kg": ${pWeightKg == null ? 'null' : '"${pWeightKg}"'},
  "p_is_fragile": ${pIsFragile == null ? 'null' : '"${pIsFragile}"'},
  "p_delivery_method": ${pDeliveryMethod == null ? 'null' : '"${escapeStringForJson(pDeliveryMethod)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'create listing',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/create-listing',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  static List<String>? migrationwarnings(dynamic response) => (getJsonField(
        response,
        r'''$.migration_warnings''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static String? listingid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.listing_id''',
      ));
}

class CreatecommunityCall {
  static Future<ApiCallResponse> call({
    String? pCategory = '',
    String? pCoverUrl = '',
    String? pDescription = '',
    String? pName = '',
    String? pRule1 = '',
    String? pRule2 = '',
    String? pRule3 = '',
    List<String>? pSubCategoriesList,
    String? userID = '',
  }) async {
    final pSubCategories = _serializeList(pSubCategoriesList);

    final ffApiRequestBody = '''
{
  "p_category": ${pCategory == null ? 'null' : '"${escapeStringForJson(pCategory)}"'},
  "p_cover_url": ${pCoverUrl == null ? 'null' : '"${escapeStringForJson(pCoverUrl)}"'},
  "p_description": ${pDescription == null ? 'null' : '"${escapeStringForJson(pDescription)}"'},
  "p_name": ${pName == null ? 'null' : '"${escapeStringForJson(pName)}"'},
  "p_rule1": ${pRule1 == null ? 'null' : '"${escapeStringForJson(pRule1)}"'},
  "p_rule2": ${pRule2 == null ? 'null' : '"${escapeStringForJson(pRule2)}"'},
  "p_rule3": ${pRule3 == null ? 'null' : '"${escapeStringForJson(pRule3)}"'},
  "p_sub_categories": "${pSubCategories}",
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createcommunity',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/create_community',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic success(dynamic response) => getJsonField(
        response,
        r'''$[:].success''',
      );
  static dynamic message(dynamic response) => getJsonField(
        response,
        r'''$[:].message''',
      );
}

class OrijasearchCall {
  static Future<ApiCallResponse> call({
    int? pLimit,
    int? pOffset,
    String? pSearch = '',
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_limit": ${pLimit == null ? 'null' : '"${pLimit}"'},
  "p_offset": ${pOffset == null ? 'null' : '"${pOffset}"'},
  "p_search": ${pSearch == null ? 'null' : '"${escapeStringForJson(pSearch)}"'},
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'orijasearch',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/orija_search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListofAcctCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "action": "listBanks"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'listofAcct',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-orija',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List<String>? code(dynamic response) => (getJsonField(
        response,
        r'''$.banks[:].code''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.banks[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$.banks[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class InitializePaymentCall {
  static Future<ApiCallResponse> call({
    String? orderID = '',
    String? callBackUrl = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "initializePayment",
  "order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'},
  "callback_url": ${callBackUrl == null ? 'null' : '"${escapeStringForJson(callBackUrl)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initializePayment',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-orija',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? authorizationurl(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.authorization_url''',
      ));
  static String? accesscode(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.access_code''',
      ));
  static String? reference1(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.reference''',
      ));
  static int? subtotal(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.subtotal''',
      ));
  static double? shippingfee(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.shipping_fee''',
      ));
  static double? total(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.total''',
      ));
  static double? orijafeenaira(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.debug.orija_fee_naira''',
      ));
  static int? vendorreceivesapprox(dynamic response) =>
      castToType<int>(getJsonField(
        response,
        r'''$.debug.vendor_receives_approx''',
      ));
  static String? vendorsubaccount(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.debug.vendor_subaccount''',
      ));
}

class ResolveAccountCall {
  static Future<ApiCallResponse> call({
    String? accountNumber = '',
    String? bankCode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "resolveAccount",
  "account_number": ${accountNumber == null ? 'null' : '"${escapeStringForJson(accountNumber)}"'},
  "bank_code": ${bankCode == null ? 'null' : '"${escapeStringForJson(bankCode)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'resolveAccount',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-orija',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? accountnumber(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.account_number''',
      ));
  static String? accountname(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.account_name''',
      ));
  static String? bankcode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bank_code''',
      ));
}

class CreateSubaccountCall {
  static Future<ApiCallResponse> call({
    String? accountNumber = '',
    String? bankCode = '',
    String? storeID = '',
    String? vendorID = '',
    String? email = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "createSubaccount",
  "storefront_id": ${storeID == null ? 'null' : '"${escapeStringForJson(storeID)}"'},
  "account_number": ${accountNumber == null ? 'null' : '"${escapeStringForJson(accountNumber)}"'},
  "bank_code": ${bankCode == null ? 'null' : '"${escapeStringForJson(bankCode)}"'},
  "vendor_id": ${vendorID == null ? 'null' : '"${escapeStringForJson(vendorID)}"'},
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createSubaccount',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-orija',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
  static String? subaccountcode(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.subaccount_code''',
      ));
  static String? accountname(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.account_name''',
      ));
  static String? accountnumber(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.account_number''',
      ));
  static String? bankname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bank_name''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static double? percentagecharge(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.percentage_charge''',
      ));
}

class GetorderpagestateCall {
  static Future<ApiCallResponse> call({
    String? bagId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagId == null ? 'null' : '"${escapeStringForJson(bagId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getorderpagestate',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_order_page_state',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static int? pageindex(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.page_index''',
      ));
  static int? message(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class SendbagtovendorCall {
  static Future<ApiCallResponse> call({
    String? bagId = '',
    String? buyerId = '',
    String? buyerNote = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagId == null ? 'null' : '"${escapeStringForJson(bagId)}"'},
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_buyer_note": ${buyerNote == null ? 'null' : '"${escapeStringForJson(buyerNote)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendbagtovendor',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/send_bag_to_vendor',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static int? itemcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.item_count''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? bagid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_id''',
      ));
}

class ProceedtocheckoutpickupCall {
  static Future<ApiCallResponse> call({
    String? bagId = '',
    String? buyerId = '',
    String? buyerNote = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagId == null ? 'null' : '"${escapeStringForJson(bagId)}"'},
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_buyer_note": ${buyerNote == null ? 'null' : '"${escapeStringForJson(buyerNote)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'proceedtocheckoutpickup',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/proceed_to_checkout_pickup',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static int? itemcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.item_count''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? bagid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_id''',
      ));
}

class ProceedtocheckoutCall {
  static Future<ApiCallResponse> call({
    String? bagId = '',
    String? buyerId = '',
    String? buyerNote = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagId == null ? 'null' : '"${escapeStringForJson(bagId)}"'},
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_buyer_note": ${buyerNote == null ? 'null' : '"${escapeStringForJson(buyerNote)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'proceedtocheckout',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/proceed_to_checkout',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? bagid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_id''',
      ));
  static String? orderid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.order_id''',
      ));
  static double? subtotal(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.subtotal''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static double? ordertotal(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.order_total''',
      ));
  static double? buyerfeeamt(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.buyer_fee_amt''',
      ));
  static double? buyerfeepct(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.buyer_fee_pct''',
      ));
  static double? vendorfeeamt(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.vendor_fee_amt''',
      ));
  static double? vendorfeepct(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.vendor_fee_pct''',
      ));
  static int? availableitems(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.available_items''',
      ));
  static String? deliverymethod(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery_method''',
      ));
  static String? nextstep(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.next_step''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? bagstatus(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_status''',
      ));
  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
}

class SetorderdeliverypreferenceCall {
  static Future<ApiCallResponse> call({
    String? buyerId = '',
    String? deliveryAddress = '',
    String? dCity = '',
    String? dState = '',
    String? dMethod = '',
    String? dPhone = '',
    String? dCountry = '',
    String? orderID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_delivery_address": ${deliveryAddress == null ? 'null' : '"${escapeStringForJson(deliveryAddress)}"'},
  "p_delivery_city": ${dCity == null ? 'null' : '"${escapeStringForJson(dCity)}"'},
  "p_delivery_country": ${dCountry == null ? 'null' : '"${escapeStringForJson(dCountry)}"'},
  "p_delivery_phone": ${dPhone == null ? 'null' : '"${escapeStringForJson(dPhone)}"'},
  "p_delivery_state": ${dState == null ? 'null' : '"${escapeStringForJson(dState)}"'},
  "p_method": ${dMethod == null ? 'null' : '"${escapeStringForJson(dMethod)}"'},
  "p_order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'setorderdeliverypreference',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/set_order_delivery_preference',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? orderid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.order_id''',
      ));
  static String? pickupaddressCity(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.pickup_address.city''',
      ));
  static dynamic pickupaddress(dynamic response) => getJsonField(
        response,
        r'''$.pickup_address''',
      );
  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static String? pickupaddressline1(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.pickup_address.line1''',
      ));
  static String? pickupaddressphone(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.pickup_address.phone''',
      ));
  static String? pickupaddressstate(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.pickup_address.state''',
      ));
}

class TerminalselectrateCall {
  static Future<ApiCallResponse> call({
    String? buyerId = '',
    String? carrierLogo = '',
    String? carrierName = '',
    String? estDay = '',
    String? orderID = '',
    String? rateID = '',
    String? shippingFee = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_carrier_logo": ${carrierLogo == null ? 'null' : '"${escapeStringForJson(carrierLogo)}"'},
  "p_carrier_name": ${carrierName == null ? 'null' : '"${escapeStringForJson(carrierName)}"'},
  "p_est_days": ${estDay == null ? 'null' : '"${escapeStringForJson(estDay)}"'},
  "p_order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'},
  "p_rate_id": ${rateID == null ? 'null' : '"${escapeStringForJson(rateID)}"'},
  "p_shipping_fee": ${shippingFee == null ? 'null' : '"${escapeStringForJson(shippingFee)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'terminalselectrate',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/terminal_select_rate',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class TerminalorchestrateCall {
  static Future<ApiCallResponse> call({
    String? orderID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "orchestrateDelivery",
  "order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'terminalorchestrate',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/terminal-orchestrate',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? orderid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.order_id''',
      ));
  static List<double>? amount(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].amount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
  static List<String>? carrierlogo(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].carrier_logo''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? carriername(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].carrier_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? deliverytime(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].delivery_time''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? pickuptime(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].pickup_time''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? rateid(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].rate_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? type(dynamic response) => (getJsonField(
        response,
        r'''$.steps.rates.rates[:].type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ConfirmorderpaidCall {
  static Future<ApiCallResponse> call({
    String? orderID = '',
    String? paystackRef = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'},
  "p_paystack_ref": ${paystackRef == null ? 'null' : '"${escapeStringForJson(paystackRef)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'confirmorderpaid',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/confirm_order_paid',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? orderid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.order_id''',
      ));
  static double? vendorpayout(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.vendor_payout''',
      ));
}

class TerminalupdatestatusCall {
  static Future<ApiCallResponse> call({
    String? orderID = '',
    dynamic eventJson,
  }) async {
    final event = _serializeJson(eventJson);
    final ffApiRequestBody = '''
{
  "p_event": "${event}",
  "p_order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'},
  "p_status": "paid"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'terminalupdatestatus',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/terminal_update_status',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? orderid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.order_id''',
      ));
  static double? vendorpayout(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.vendor_payout''',
      ));
}

class TerminalstartdeliveryCall {
  static Future<ApiCallResponse> call({
    String? orderID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_order_id": ${orderID == null ? 'null' : '"${escapeStringForJson(orderID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'terminalstartdelivery',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/terminal_start_delivery',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class VendorconfirmbagCall {
  static Future<ApiCallResponse> call({
    String? bagId = '',
    String? vendorId = '',
    String? vendorNote = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagId == null ? 'null' : '"${escapeStringForJson(bagId)}"'},
  "p_vendor_id": ${vendorId == null ? 'null' : '"${escapeStringForJson(vendorId)}"'},
  "p_vendor_note": ${vendorNote == null ? 'null' : '"${escapeStringForJson(vendorNote)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'vendorconfirmbag',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/vendor_confirm_bag',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static int? itemcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.item_count''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? bagid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_id''',
      ));
}

class UpdatebagitemCall {
  static Future<ApiCallResponse> call({
    String? buyerId = '',
    String? buyerNote = '',
    String? itemID = '',
    double? offerPrice,
    int? quantity,
  }) async {
    final ffApiRequestBody = '''
{
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_item_id": ${itemID == null ? 'null' : '"${escapeStringForJson(itemID)}"'},
  "p_note": ${buyerNote == null ? 'null' : '"${escapeStringForJson(buyerNote)}"'},
  "p_offer_price": ${offerPrice == null ? 'null' : '"${offerPrice}"'},
  "p_quantity": ${quantity == null ? 'null' : '"${quantity}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updatebagitem',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/update_bag_item',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class VendorconfirmitemCall {
  static Future<ApiCallResponse> call({
    String? itemID = '',
    bool? isAvailable,
    double? vConfrimedPrice,
    String? vendorId = '',
    String? vendorNote = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_is_available": ${isAvailable == null ? 'null' : '"${isAvailable}"'},
  "p_item_id": ${itemID == null ? 'null' : '"${escapeStringForJson(itemID)}"'},
  "p_vendor_confirmed_price": ${vConfrimedPrice == null ? 'null' : '"${vConfrimedPrice}"'},
  "p_vendor_id": ${vendorId == null ? 'null' : '"${escapeStringForJson(vendorId)}"'},
  "p_vendor_note": ${vendorNote == null ? 'null' : '"${escapeStringForJson(vendorNote)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'vendorconfirmitem',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/vendor_confirm_item',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class RemovebagitemCall {
  static Future<ApiCallResponse> call({
    String? buyerId = '',
    String? itemID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_item_id": ${itemID == null ? 'null' : '"${escapeStringForJson(itemID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'removebagitem',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/remove_bag_item',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class ClearthreadunreadCall {
  static Future<ApiCallResponse> call({
    String? treadID = '',
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_thread_id": ${treadID == null ? 'null' : '"${escapeStringForJson(treadID)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'clearthreadunread',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/clear_thread_unread',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$[:].category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? coverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? membercount(dynamic response) => (getJsonField(
        response,
        r'''$[:].member_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? vendorcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].vendor_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<bool>? isseed(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_seed''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class SenddmmessageCall {
  static Future<ApiCallResponse> call({
    String? treadID = '',
    String? userID = '',
    String? listingID = '',
    String? mediaUrl = '',
    String? messageType = '',
    double? offerPrice,
    String? content = '',
    String? replyid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_content": ${content == null ? 'null' : '"${escapeStringForJson(content)}"'},
  "p_listing_id": ${listingID == null ? 'null' : '"${escapeStringForJson(listingID)}"'},
  "p_media_url": ${mediaUrl == null ? 'null' : '"${escapeStringForJson(mediaUrl)}"'},
  "p_message_type": ${messageType == null ? 'null' : '"${escapeStringForJson(messageType)}"'},
  "p_metadata": "",
  "p_offer_price": ${offerPrice == null ? 'null' : '"${offerPrice}"'},
  "p_reply_to_id": ${replyid == null ? 'null' : '"${escapeStringForJson(replyid)}"'},
  "p_sender_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'},
  "p_thread_id": ${treadID == null ? 'null' : '"${escapeStringForJson(treadID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'senddmmessage',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/send_dm_message',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$[:].category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? coverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? membercount(dynamic response) => (getJsonField(
        response,
        r'''$[:].member_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? vendorcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].vendor_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<bool>? isseed(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_seed''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class OpenChatAskCall {
  static Future<ApiCallResponse> call({
    String? postID = '',
    String? storeID = '',
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_ask_author_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'},
  "p_ask_post_id": ${postID == null ? 'null' : '"${escapeStringForJson(postID)}"'},
  "p_storefront_id": ${storeID == null ? 'null' : '"${escapeStringForJson(storeID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Open Chat Ask',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/openchat_ask',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.name''',
      ));
  static String? storelogo(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.store_logo''',
      ));
  static String? tiertitle(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.tier_title''',
      ));
  static String? image(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.image''',
      ));
  static String? askpostid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.ask_post_id''',
      ));
  static bool? isbuyer(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.is_buyer''',
      ));
  static String? storeslug(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.store_slug''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class OpenChatStorefrontCall {
  static Future<ApiCallResponse> call({
    String? storeID = '',
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_storefront_id": ${storeID == null ? 'null' : '"${escapeStringForJson(storeID)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Open Chat Storefront',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/openchat_storefront',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static String? storefrontid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.storefront_id''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.name''',
      ));
  static String? storelogo(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.store_logo''',
      ));
  static String? tiertitle(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.tier_title''',
      ));
  static String? image(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.opposite.image''',
      ));
  static String? askpostid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.ask_post_id''',
      ));
  static bool? isbuyer(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.is_buyer''',
      ));
  static String? storeslug(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.store_slug''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetmycommunitiesCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": ${pUserId == null ? 'null' : '"${escapeStringForJson(pUserId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getmycommunities',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_my_communities',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? isseed(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_seed''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? joinedat(dynamic response) => (getJsonField(
        response,
        r'''$[:].joined_at''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? role(dynamic response) => (getJsonField(
        response,
        r'''$[:].role''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? vendorcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].vendor_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? membercount(dynamic response) => (getJsonField(
        response,
        r'''$[:].member_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? coverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$[:].category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? slug(dynamic response) => (getJsonField(
        response,
        r'''$[:].slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class PaystacksubscribeCall {
  static Future<ApiCallResponse> call({
    String? storefrontId = '',
    String? userId = '',
    String? email = '',
    String? tier = '',
    String? billingCycle = '',
    String? callbackUrl = '',
  }) async {
    final ffApiRequestBody = '''
{
  "storefront_id": ${storefrontId == null ? 'null' : '"${escapeStringForJson(storefrontId)}"'},
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
  "tier": ${tier == null ? 'null' : '"${escapeStringForJson(tier)}"'},
  "billing_cycle": ${billingCycle == null ? 'null' : '"${escapeStringForJson(billingCycle)}"'},
  "callback_url": ${callbackUrl == null ? 'null' : '"${escapeStringForJson(callbackUrl)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'paystacksubscribe',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-subscribe',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.ok''',
      ));
  static String? authorizationUrl(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.authorization_url''',
      ));
  static String? reference1(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.reference''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? tier(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.tier''',
      ));
  static String? billingcycle(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.billing_cycle''',
      ));
  static int? amountnaira(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.amount_naira''',
      ));
  static String? subscriptionid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.subscription_id''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
  static String? currentstatus(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.detail.current_status''',
      ));
}

class GetCountryterminalafricaCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{ "action": "getCountries" }''';
    return ApiManager.instance.makeApiCall(
      callName: 'getCountryterminalafrica',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/terminal-africa',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? isoCode(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].isoCode''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? latitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].latitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? longitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].longitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? countryid(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].country_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? currency(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].currency''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? phonecode(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].phonecode''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetCityterminalafricaCall {
  static Future<ApiCallResponse> call({
    String? countryCode = '',
    String? stateCode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "getCities",
  "country_code": ${countryCode == null ? 'null' : '"${escapeStringForJson(countryCode)}"'},
  "state_code": ${stateCode == null ? 'null' : '"${escapeStringForJson(stateCode)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getCityterminalafrica',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/terminal-africa',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? latitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].latitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? longitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].longitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetStateterminalafricaCall {
  static Future<ApiCallResponse> call({
    String? countryCode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "action": "getStates",
  "country_code": ${countryCode == null ? 'null' : '"${escapeStringForJson(countryCode)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getStateterminalafrica',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/terminal-africa',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? isoCode(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].isoCode''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? latitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].latitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? longitude(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].longitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class PaystackcancelsubscriptionCall {
  static Future<ApiCallResponse> call({
    String? storefrontId = '',
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "storefront_id": "13074717-88f9-44bf-9428-18e31fd724b2",
  "user_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'paystackcancelsubscription',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/paystack-cancel-subscription',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.ok''',
      ));
  static bool? cancelledlocally(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.cancelled_locally''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class AddToBagCall {
  static Future<ApiCallResponse> call({
    String? buyerId = '',
    String? listingId = '',
    int? quantity,
    String? storefrontId = '',
    double? unitPrice,
  }) async {
    final ffApiRequestBody = '''
{
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_listing_id": ${listingId == null ? 'null' : '"${escapeStringForJson(listingId)}"'},
  "p_note": "",
  "p_offer_price": ${unitPrice == null ? 'null' : '"${unitPrice}"'},
  "p_quantity": ${quantity == null ? 'null' : '"${quantity}"'},
  "p_storefront_id": ${storefrontId == null ? 'null' : '"${escapeStringForJson(storefrontId)}"'},
  "p_variant": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Add to bag',
      apiUrl: 'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/add_to_bag',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? bagid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_id''',
      ));
  static String? threadid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.thread_id''',
      ));
  static String? bagitemid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bag_item_id''',
      ));
}

class RemoveFromBagCall {
  static Future<ApiCallResponse> call({
    String? bagitemid = '',
    String? buyerId = '',
    String? bagID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_bag_id": ${bagID == null ? 'null' : '"${escapeStringForJson(bagID)}"'},
  "p_buyer_id": ${buyerId == null ? 'null' : '"${escapeStringForJson(buyerId)}"'},
  "p_item_id": ${bagitemid == null ? 'null' : '"${escapeStringForJson(bagitemid)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Remove from Bag',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/remove_from_bag',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetpostuserstateCall {
  static Future<ApiCallResponse> call({
    String? postID = '',
    String? storeID = '',
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_post_id": ${postID == null ? 'null' : '"${escapeStringForJson(postID)}"'},
  "p_storefront_id": ${storeID == null ? 'null' : '"${escapeStringForJson(storeID)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getpostuserstate',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_post_user_state',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? hasLiked(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].has_liked''',
      ));
  static bool? hasFollowed(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].has_followed''',
      ));
  static bool? hasSaved(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].has_saved''',
      ));
  static bool? hasRecommend(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].has_recommended''',
      ));
  static bool? hasCommented(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].has_commented''',
      ));
}

class GetsmartfeedCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_limit": "40",
  "p_offset": "0",
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsmartfeed',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_smart_feed',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? postID(dynamic response) => (getJsonField(
        response,
        r'''$[:].post_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? authorID(dynamic response) => (getJsonField(
        response,
        r'''$[:].author_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? storeID(dynamic response) => (getJsonField(
        response,
        r'''$[:].storefront_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? postType(dynamic response) => (getJsonField(
        response,
        r'''$[:].post_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? rowtype(dynamic response) => (getJsonField(
        response,
        r'''$[:].row_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetReelFeedCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_limit": "100",
  "p_page": "0",
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get reel feed',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_reel_feed',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? postID(dynamic response) => (getJsonField(
        response,
        r'''$[:].post_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? authorID(dynamic response) => (getJsonField(
        response,
        r'''$[:].author_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? storeID(dynamic response) => (getJsonField(
        response,
        r'''$[:].storefront_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? postType(dynamic response) => (getJsonField(
        response,
        r'''$[:].post_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? rowtype(dynamic response) => (getJsonField(
        response,
        r'''$[:].row_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class JoinstorefronttocommunityCall {
  static Future<ApiCallResponse> call({
    String? storefrontID = '',
    String? userID = '',
    String? communityID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "p_storefront_id": ${storefrontID == null ? 'null' : '"${escapeStringForJson(storefrontID)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'joinstorefronttocommunity',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/join_storefront_to_community',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? code(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.code''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static int? slotsmax(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.slots_max''',
      ));
  static int? slotsused(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.slots_used''',
      ));
}

class MarketHeadReviewStorefrontCall {
  static Future<ApiCallResponse> call({
    String? storefrontID = '',
    String? marketHeaduserID = '',
    String? reason = '',
    String? action = '',
    String? pCommunityId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_action": ${action == null ? 'null' : '"${escapeStringForJson(action)}"'},
  "p_head_user_id": ${marketHeaduserID == null ? 'null' : '"${escapeStringForJson(marketHeaduserID)}"'},
  "p_reason": ${reason == null ? 'null' : '"${escapeStringForJson(reason)}"'},
  "p_storefront_id": ${storefrontID == null ? 'null' : '"${escapeStringForJson(storefrontID)}"'},
"p_community_id": ${pCommunityId == null ? 'null' : '"${escapeStringForJson(pCommunityId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'market head review storefront',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/market_head_review_storefront',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static dynamic error(dynamic response) => getJsonField(
        response,
        r'''$.error''',
      );
}

class LeavecommunityCall {
  static Future<ApiCallResponse> call({
    String? storefrontID = '',
    String? userID = '',
    String? communityID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_community_id": ${communityID == null ? 'null' : '"${escapeStringForJson(communityID)}"'},
  "p_storefront_id": ${storefrontID == null ? 'null' : '"${escapeStringForJson(storefrontID)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'leavecommunity',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/leave_community',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class GetmythreadsCall {
  static Future<ApiCallResponse> call({
    String? limit = '',
    String? offset = '',
    String? search = '',
    String? type = '',
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_limit": ${limit == null ? 'null' : '"${escapeStringForJson(limit)}"'},
  "p_offset": ${offset == null ? 'null' : '"${escapeStringForJson(offset)}"'},
  "p_search": ${search == null ? 'null' : '"${escapeStringForJson(search)}"'},
  "p_type": ${type == null ? 'null' : '"${escapeStringForJson(type)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getmythreads',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/get_my_threads',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? threadid(dynamic response) => (getJsonField(
        response,
        r'''$[:].thread_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? threadtype(dynamic response) => (getJsonField(
        response,
        r'''$[:].thread_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? createdat(dynamic response) => (getJsonField(
        response,
        r'''$[:].created_at''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? lastmessageat(dynamic response) => (getJsonField(
        response,
        r'''$[:].last_message_at''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? buyerid(dynamic response) => getJsonField(
        response,
        r'''$[:].buyer_id''',
        true,
      ) as List?;
  static List? storefrontslug(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_slug''',
        true,
      ) as List?;
  static List? storefrontlogourl(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_logo_url''',
        true,
      ) as List?;
  static List? storefrontname(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_name''',
        true,
      ) as List?;
  static List<String>? lastmessagesenderid(dynamic response) => (getJsonField(
        response,
        r'''$[:].last_message_sender_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? lastmessagetype(dynamic response) => (getJsonField(
        response,
        r'''$[:].last_message_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? lastmessagecontent(dynamic response) => getJsonField(
        response,
        r'''$[:].last_message_content''',
        true,
      ) as List?;
  static List? vendorunread(dynamic response) => getJsonField(
        response,
        r'''$[:].vendor_unread''',
        true,
      ) as List?;
  static List<String>? communityname(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? communityslug(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_slug''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? communitycoverurl(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_cover_url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? hasactivebag(dynamic response) => (getJsonField(
        response,
        r'''$[:].has_active_bag''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List? activebagid(dynamic response) => getJsonField(
        response,
        r'''$[:].active_bag_id''',
        true,
      ) as List?;
  static List? activebagstatus(dynamic response) => getJsonField(
        response,
        r'''$[:].active_bag_status''',
        true,
      ) as List?;
  static List? activebagitemcount(dynamic response) => getJsonField(
        response,
        r'''$[:].active_bag_item_count''',
        true,
      ) as List?;
  static List? activeorderid(dynamic response) => getJsonField(
        response,
        r'''$[:].active_order_id''',
        true,
      ) as List?;
  static List<String>? communitythreadid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_thread_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? unreadcount(dynamic response) => (getJsonField(
        response,
        r'''$[:].unread_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List? buyerunread(dynamic response) => getJsonField(
        response,
        r'''$[:].buyer_unread''',
        true,
      ) as List?;
  static List? storefrontid(dynamic response) => getJsonField(
        response,
        r'''$[:].storefront_id''',
        true,
      ) as List?;
  static List<String>? communityid(dynamic response) => (getJsonField(
        response,
        r'''$[:].community_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? vendorid(dynamic response) => getJsonField(
        response,
        r'''$[:].vendor_id''',
        true,
      ) as List?;
  static List? partnername(dynamic response) => getJsonField(
        response,
        r'''$[:].partner_name''',
        true,
      ) as List?;
  static List? partneravatar(dynamic response) => getJsonField(
        response,
        r'''$[:].partner_avatar''',
        true,
      ) as List?;
  static List<bool>? hasactiveask(dynamic response) => (getJsonField(
        response,
        r'''$[:].has_active_ask''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class DiscoverCommunitiesCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
    String? category = '',
    int? offset,
    int? limit,
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_category": ${category == null ? 'null' : '"${escapeStringForJson(category)}"'},
  "p_limit": ${limit == null ? 'null' : '"${limit}"'},
  "p_offset": ${offset == null ? 'null' : '"${offset}"'},
  "p_search": ${search == null ? 'null' : '"${escapeStringForJson(search)}"'},
  "p_type": ${type == null ? 'null' : '"${escapeStringForJson(type)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Discover Communities',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/discover_communities',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? sections(dynamic response) => getJsonField(
        response,
        r'''$.sections''',
        true,
      ) as List?;
}

class DiscoverCommunitiesSearchCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
    String? category = '',
    int? offset,
    int? limit,
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_category": ${category == null ? 'null' : '"${escapeStringForJson(category)}"'},
  "p_limit": ${limit == null ? 'null' : '"${limit}"'},
  "p_offset": ${offset == null ? 'null' : '"${offset}"'},
  "p_search": ${search == null ? 'null' : '"${escapeStringForJson(search)}"'},
  "p_type": ${type == null ? 'null' : '"${escapeStringForJson(type)}"'},
  "p_user_id": ${userID == null ? 'null' : '"${escapeStringForJson(userID)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Discover Communities Search',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/rest/v1/rpc/discover_communities',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? sections(dynamic response) => getJsonField(
        response,
        r'''$.sections''',
        true,
      ) as List?;
}

class GetCloudinarySignatureCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "context": "post_media"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getCloudinarySignature',
      apiUrl:
          'https://dgwvnxdxushgfvuzrvdr.supabase.co/functions/v1/cloudinary-sign',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  if (item is Color) {
    return item.toCssString();
  }
  if (item is LatLng) {
    return item.serialize();
  }
  if (item is DateTimeRange) {
    String millis(DateTime d) =>
        '${d.isUtc ? 'u' : 'l'}${d.millisecondsSinceEpoch}';
    return '${millis(item.start)}|${millis(item.end)}';
  }
  if (item is FFPlace) {
    return jsonEncode({
      'latLng': item.latLng.serialize(),
      'name': item.name,
      'address': item.address,
      'city': item.city,
      'state': item.state,
      'country': item.country,
      'zipCode': item.zipCode,
    });
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}
