// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatListStruct extends BaseStruct {
  ChatListStruct({
    String? threadId,
    String? threadType,
    String? lastMessageContent,
    String? lastMessageType,
    DateTime? lastMessageAt,
    int? unreadCount,
    String? partnerName,
    String? partnerAvatar,
    String? storefrontName,
    String? storefrontLogoUrl,
    String? storefrontSlug,
    bool? hasActiveBag,
    bool? hasActiveAsk,
    String? activeBagId,
    String? activeBagStatus,
    String? activeBagItemCount,
    String? activeOrderId,
    String? buyerId,
    String? vendorId,
    String? storefrontId,
    String? communityId,
    String? communityName,
    String? communitySlug,
    String? communityCoverUrl,
    String? communityThreadId,
  })  : _threadId = threadId,
        _threadType = threadType,
        _lastMessageContent = lastMessageContent,
        _lastMessageType = lastMessageType,
        _lastMessageAt = lastMessageAt,
        _unreadCount = unreadCount,
        _partnerName = partnerName,
        _partnerAvatar = partnerAvatar,
        _storefrontName = storefrontName,
        _storefrontLogoUrl = storefrontLogoUrl,
        _storefrontSlug = storefrontSlug,
        _hasActiveBag = hasActiveBag,
        _hasActiveAsk = hasActiveAsk,
        _activeBagId = activeBagId,
        _activeBagStatus = activeBagStatus,
        _activeBagItemCount = activeBagItemCount,
        _activeOrderId = activeOrderId,
        _buyerId = buyerId,
        _vendorId = vendorId,
        _storefrontId = storefrontId,
        _communityId = communityId,
        _communityName = communityName,
        _communitySlug = communitySlug,
        _communityCoverUrl = communityCoverUrl,
        _communityThreadId = communityThreadId;

  // "thread_id" field.
  String? _threadId;
  String get threadId => _threadId ?? '';
  set threadId(String? val) => _threadId = val;

  bool hasThreadId() => _threadId != null;

  // "thread_type" field.
  String? _threadType;
  String get threadType => _threadType ?? '';
  set threadType(String? val) => _threadType = val;

  bool hasThreadType() => _threadType != null;

  // "last_message_content" field.
  String? _lastMessageContent;
  String get lastMessageContent => _lastMessageContent ?? '';
  set lastMessageContent(String? val) => _lastMessageContent = val;

  bool hasLastMessageContent() => _lastMessageContent != null;

  // "last_message_type" field.
  String? _lastMessageType;
  String get lastMessageType => _lastMessageType ?? '';
  set lastMessageType(String? val) => _lastMessageType = val;

  bool hasLastMessageType() => _lastMessageType != null;

  // "last_message_at" field.
  DateTime? _lastMessageAt;
  DateTime? get lastMessageAt => _lastMessageAt;
  set lastMessageAt(DateTime? val) => _lastMessageAt = val;

  bool hasLastMessageAt() => _lastMessageAt != null;

  // "unread_count" field.
  int? _unreadCount;
  int get unreadCount => _unreadCount ?? 0;
  set unreadCount(int? val) => _unreadCount = val;

  void incrementUnreadCount(int amount) => unreadCount = unreadCount + amount;

  bool hasUnreadCount() => _unreadCount != null;

  // "partner_name" field.
  String? _partnerName;
  String get partnerName => _partnerName ?? '';
  set partnerName(String? val) => _partnerName = val;

  bool hasPartnerName() => _partnerName != null;

  // "partner_avatar" field.
  String? _partnerAvatar;
  String get partnerAvatar => _partnerAvatar ?? '';
  set partnerAvatar(String? val) => _partnerAvatar = val;

  bool hasPartnerAvatar() => _partnerAvatar != null;

  // "storefront_name" field.
  String? _storefrontName;
  String get storefrontName => _storefrontName ?? '';
  set storefrontName(String? val) => _storefrontName = val;

  bool hasStorefrontName() => _storefrontName != null;

  // "storefront_logo_url" field.
  String? _storefrontLogoUrl;
  String get storefrontLogoUrl => _storefrontLogoUrl ?? '';
  set storefrontLogoUrl(String? val) => _storefrontLogoUrl = val;

  bool hasStorefrontLogoUrl() => _storefrontLogoUrl != null;

  // "storefront_slug" field.
  String? _storefrontSlug;
  String get storefrontSlug => _storefrontSlug ?? '';
  set storefrontSlug(String? val) => _storefrontSlug = val;

  bool hasStorefrontSlug() => _storefrontSlug != null;

  // "has_active_bag" field.
  bool? _hasActiveBag;
  bool get hasActiveBag => _hasActiveBag ?? false;
  set hasActiveBag(bool? val) => _hasActiveBag = val;

  bool hasHasActiveBag() => _hasActiveBag != null;

  // "has_active_ask" field.
  bool? _hasActiveAsk;
  bool get hasActiveAsk => _hasActiveAsk ?? false;
  set hasActiveAsk(bool? val) => _hasActiveAsk = val;

  bool hasHasActiveAsk() => _hasActiveAsk != null;

  // "active_bag_id" field.
  String? _activeBagId;
  String get activeBagId => _activeBagId ?? '';
  set activeBagId(String? val) => _activeBagId = val;

  bool hasActiveBagId() => _activeBagId != null;

  // "active_bag_status" field.
  String? _activeBagStatus;
  String get activeBagStatus => _activeBagStatus ?? '';
  set activeBagStatus(String? val) => _activeBagStatus = val;

  bool hasActiveBagStatus() => _activeBagStatus != null;

  // "active_bag_item_count" field.
  String? _activeBagItemCount;
  String get activeBagItemCount => _activeBagItemCount ?? '';
  set activeBagItemCount(String? val) => _activeBagItemCount = val;

  bool hasActiveBagItemCount() => _activeBagItemCount != null;

  // "active_order_id" field.
  String? _activeOrderId;
  String get activeOrderId => _activeOrderId ?? '';
  set activeOrderId(String? val) => _activeOrderId = val;

  bool hasActiveOrderId() => _activeOrderId != null;

  // "buyer_id" field.
  String? _buyerId;
  String get buyerId => _buyerId ?? '';
  set buyerId(String? val) => _buyerId = val;

  bool hasBuyerId() => _buyerId != null;

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  set vendorId(String? val) => _vendorId = val;

  bool hasVendorId() => _vendorId != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "community_id" field.
  String? _communityId;
  String get communityId => _communityId ?? '';
  set communityId(String? val) => _communityId = val;

  bool hasCommunityId() => _communityId != null;

  // "community_name" field.
  String? _communityName;
  String get communityName => _communityName ?? '';
  set communityName(String? val) => _communityName = val;

  bool hasCommunityName() => _communityName != null;

  // "community_slug" field.
  String? _communitySlug;
  String get communitySlug => _communitySlug ?? '';
  set communitySlug(String? val) => _communitySlug = val;

  bool hasCommunitySlug() => _communitySlug != null;

  // "community_cover_url" field.
  String? _communityCoverUrl;
  String get communityCoverUrl => _communityCoverUrl ?? '';
  set communityCoverUrl(String? val) => _communityCoverUrl = val;

  bool hasCommunityCoverUrl() => _communityCoverUrl != null;

  // "community_thread_id" field.
  String? _communityThreadId;
  String get communityThreadId => _communityThreadId ?? '';
  set communityThreadId(String? val) => _communityThreadId = val;

  bool hasCommunityThreadId() => _communityThreadId != null;

  static ChatListStruct fromMap(Map<String, dynamic> data) => ChatListStruct(
        threadId: data['thread_id'] as String?,
        threadType: data['thread_type'] as String?,
        lastMessageContent: data['last_message_content'] as String?,
        lastMessageType: data['last_message_type'] as String?,
        lastMessageAt: data['last_message_at'] as DateTime?,
        unreadCount: castToType<int>(data['unread_count']),
        partnerName: data['partner_name'] as String?,
        partnerAvatar: data['partner_avatar'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontLogoUrl: data['storefront_logo_url'] as String?,
        storefrontSlug: data['storefront_slug'] as String?,
        hasActiveBag: data['has_active_bag'] as bool?,
        hasActiveAsk: data['has_active_ask'] as bool?,
        activeBagId: data['active_bag_id'] as String?,
        activeBagStatus: data['active_bag_status'] as String?,
        activeBagItemCount: data['active_bag_item_count'] as String?,
        activeOrderId: data['active_order_id'] as String?,
        buyerId: data['buyer_id'] as String?,
        vendorId: data['vendor_id'] as String?,
        storefrontId: data['storefront_id'] as String?,
        communityId: data['community_id'] as String?,
        communityName: data['community_name'] as String?,
        communitySlug: data['community_slug'] as String?,
        communityCoverUrl: data['community_cover_url'] as String?,
        communityThreadId: data['community_thread_id'] as String?,
      );

  static ChatListStruct? maybeFromMap(dynamic data) =>
      data is Map ? ChatListStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'thread_id': _threadId,
        'thread_type': _threadType,
        'last_message_content': _lastMessageContent,
        'last_message_type': _lastMessageType,
        'last_message_at': _lastMessageAt,
        'unread_count': _unreadCount,
        'partner_name': _partnerName,
        'partner_avatar': _partnerAvatar,
        'storefront_name': _storefrontName,
        'storefront_logo_url': _storefrontLogoUrl,
        'storefront_slug': _storefrontSlug,
        'has_active_bag': _hasActiveBag,
        'has_active_ask': _hasActiveAsk,
        'active_bag_id': _activeBagId,
        'active_bag_status': _activeBagStatus,
        'active_bag_item_count': _activeBagItemCount,
        'active_order_id': _activeOrderId,
        'buyer_id': _buyerId,
        'vendor_id': _vendorId,
        'storefront_id': _storefrontId,
        'community_id': _communityId,
        'community_name': _communityName,
        'community_slug': _communitySlug,
        'community_cover_url': _communityCoverUrl,
        'community_thread_id': _communityThreadId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'thread_id': serializeParam(
          _threadId,
          ParamType.String,
        ),
        'thread_type': serializeParam(
          _threadType,
          ParamType.String,
        ),
        'last_message_content': serializeParam(
          _lastMessageContent,
          ParamType.String,
        ),
        'last_message_type': serializeParam(
          _lastMessageType,
          ParamType.String,
        ),
        'last_message_at': serializeParam(
          _lastMessageAt,
          ParamType.DateTime,
        ),
        'unread_count': serializeParam(
          _unreadCount,
          ParamType.int,
        ),
        'partner_name': serializeParam(
          _partnerName,
          ParamType.String,
        ),
        'partner_avatar': serializeParam(
          _partnerAvatar,
          ParamType.String,
        ),
        'storefront_name': serializeParam(
          _storefrontName,
          ParamType.String,
        ),
        'storefront_logo_url': serializeParam(
          _storefrontLogoUrl,
          ParamType.String,
        ),
        'storefront_slug': serializeParam(
          _storefrontSlug,
          ParamType.String,
        ),
        'has_active_bag': serializeParam(
          _hasActiveBag,
          ParamType.bool,
        ),
        'has_active_ask': serializeParam(
          _hasActiveAsk,
          ParamType.bool,
        ),
        'active_bag_id': serializeParam(
          _activeBagId,
          ParamType.String,
        ),
        'active_bag_status': serializeParam(
          _activeBagStatus,
          ParamType.String,
        ),
        'active_bag_item_count': serializeParam(
          _activeBagItemCount,
          ParamType.String,
        ),
        'active_order_id': serializeParam(
          _activeOrderId,
          ParamType.String,
        ),
        'buyer_id': serializeParam(
          _buyerId,
          ParamType.String,
        ),
        'vendor_id': serializeParam(
          _vendorId,
          ParamType.String,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'community_id': serializeParam(
          _communityId,
          ParamType.String,
        ),
        'community_name': serializeParam(
          _communityName,
          ParamType.String,
        ),
        'community_slug': serializeParam(
          _communitySlug,
          ParamType.String,
        ),
        'community_cover_url': serializeParam(
          _communityCoverUrl,
          ParamType.String,
        ),
        'community_thread_id': serializeParam(
          _communityThreadId,
          ParamType.String,
        ),
      }.withoutNulls;

  static ChatListStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChatListStruct(
        threadId: deserializeParam(
          data['thread_id'],
          ParamType.String,
          false,
        ),
        threadType: deserializeParam(
          data['thread_type'],
          ParamType.String,
          false,
        ),
        lastMessageContent: deserializeParam(
          data['last_message_content'],
          ParamType.String,
          false,
        ),
        lastMessageType: deserializeParam(
          data['last_message_type'],
          ParamType.String,
          false,
        ),
        lastMessageAt: deserializeParam(
          data['last_message_at'],
          ParamType.DateTime,
          false,
        ),
        unreadCount: deserializeParam(
          data['unread_count'],
          ParamType.int,
          false,
        ),
        partnerName: deserializeParam(
          data['partner_name'],
          ParamType.String,
          false,
        ),
        partnerAvatar: deserializeParam(
          data['partner_avatar'],
          ParamType.String,
          false,
        ),
        storefrontName: deserializeParam(
          data['storefront_name'],
          ParamType.String,
          false,
        ),
        storefrontLogoUrl: deserializeParam(
          data['storefront_logo_url'],
          ParamType.String,
          false,
        ),
        storefrontSlug: deserializeParam(
          data['storefront_slug'],
          ParamType.String,
          false,
        ),
        hasActiveBag: deserializeParam(
          data['has_active_bag'],
          ParamType.bool,
          false,
        ),
        hasActiveAsk: deserializeParam(
          data['has_active_ask'],
          ParamType.bool,
          false,
        ),
        activeBagId: deserializeParam(
          data['active_bag_id'],
          ParamType.String,
          false,
        ),
        activeBagStatus: deserializeParam(
          data['active_bag_status'],
          ParamType.String,
          false,
        ),
        activeBagItemCount: deserializeParam(
          data['active_bag_item_count'],
          ParamType.String,
          false,
        ),
        activeOrderId: deserializeParam(
          data['active_order_id'],
          ParamType.String,
          false,
        ),
        buyerId: deserializeParam(
          data['buyer_id'],
          ParamType.String,
          false,
        ),
        vendorId: deserializeParam(
          data['vendor_id'],
          ParamType.String,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        communityId: deserializeParam(
          data['community_id'],
          ParamType.String,
          false,
        ),
        communityName: deserializeParam(
          data['community_name'],
          ParamType.String,
          false,
        ),
        communitySlug: deserializeParam(
          data['community_slug'],
          ParamType.String,
          false,
        ),
        communityCoverUrl: deserializeParam(
          data['community_cover_url'],
          ParamType.String,
          false,
        ),
        communityThreadId: deserializeParam(
          data['community_thread_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ChatListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChatListStruct &&
        threadId == other.threadId &&
        threadType == other.threadType &&
        lastMessageContent == other.lastMessageContent &&
        lastMessageType == other.lastMessageType &&
        lastMessageAt == other.lastMessageAt &&
        unreadCount == other.unreadCount &&
        partnerName == other.partnerName &&
        partnerAvatar == other.partnerAvatar &&
        storefrontName == other.storefrontName &&
        storefrontLogoUrl == other.storefrontLogoUrl &&
        storefrontSlug == other.storefrontSlug &&
        hasActiveBag == other.hasActiveBag &&
        hasActiveAsk == other.hasActiveAsk &&
        activeBagId == other.activeBagId &&
        activeBagStatus == other.activeBagStatus &&
        activeBagItemCount == other.activeBagItemCount &&
        activeOrderId == other.activeOrderId &&
        buyerId == other.buyerId &&
        vendorId == other.vendorId &&
        storefrontId == other.storefrontId &&
        communityId == other.communityId &&
        communityName == other.communityName &&
        communitySlug == other.communitySlug &&
        communityCoverUrl == other.communityCoverUrl &&
        communityThreadId == other.communityThreadId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        threadId,
        threadType,
        lastMessageContent,
        lastMessageType,
        lastMessageAt,
        unreadCount,
        partnerName,
        partnerAvatar,
        storefrontName,
        storefrontLogoUrl,
        storefrontSlug,
        hasActiveBag,
        hasActiveAsk,
        activeBagId,
        activeBagStatus,
        activeBagItemCount,
        activeOrderId,
        buyerId,
        vendorId,
        storefrontId,
        communityId,
        communityName,
        communitySlug,
        communityCoverUrl,
        communityThreadId
      ]);
}

ChatListStruct createChatListStruct({
  String? threadId,
  String? threadType,
  String? lastMessageContent,
  String? lastMessageType,
  DateTime? lastMessageAt,
  int? unreadCount,
  String? partnerName,
  String? partnerAvatar,
  String? storefrontName,
  String? storefrontLogoUrl,
  String? storefrontSlug,
  bool? hasActiveBag,
  bool? hasActiveAsk,
  String? activeBagId,
  String? activeBagStatus,
  String? activeBagItemCount,
  String? activeOrderId,
  String? buyerId,
  String? vendorId,
  String? storefrontId,
  String? communityId,
  String? communityName,
  String? communitySlug,
  String? communityCoverUrl,
  String? communityThreadId,
}) =>
    ChatListStruct(
      threadId: threadId,
      threadType: threadType,
      lastMessageContent: lastMessageContent,
      lastMessageType: lastMessageType,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      partnerName: partnerName,
      partnerAvatar: partnerAvatar,
      storefrontName: storefrontName,
      storefrontLogoUrl: storefrontLogoUrl,
      storefrontSlug: storefrontSlug,
      hasActiveBag: hasActiveBag,
      hasActiveAsk: hasActiveAsk,
      activeBagId: activeBagId,
      activeBagStatus: activeBagStatus,
      activeBagItemCount: activeBagItemCount,
      activeOrderId: activeOrderId,
      buyerId: buyerId,
      vendorId: vendorId,
      storefrontId: storefrontId,
      communityId: communityId,
      communityName: communityName,
      communitySlug: communitySlug,
      communityCoverUrl: communityCoverUrl,
      communityThreadId: communityThreadId,
    );
