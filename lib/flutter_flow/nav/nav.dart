import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';


import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? NavBarPage() : Onboarding06Widget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? NavBarPage() : Onboarding06Widget(),
          routes: [
            FFRoute(
              name: SignuppageWidget.routeName,
              path: SignuppageWidget.routePath,
              builder: (context, params) => SignuppageWidget(
                isSignUp: params.getParam(
                  'isSignUp',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: VerifyOtpPageWidget.routeName,
              path: VerifyOtpPageWidget.routePath,
              builder: (context, params) => VerifyOtpPageWidget(
                email: params.getParam(
                  'email',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ChangePasswordWidget.routeName,
              path: ChangePasswordWidget.routePath,
              builder: (context, params) => ChangePasswordWidget(),
            ),
            FFRoute(
              name: ProfileSetupWidget.routeName,
              path: ProfileSetupWidget.routePath,
              builder: (context, params) => ProfileSetupWidget(),
            ),
            FFRoute(
                name: ChatPageWidget.routeName,
                path: ChatPageWidget.routePath,
                builder: (context, params) => params.isEmpty
                    ? NavBarPage(initialPage: 'chatPage')
                    : NavBarPage(
                        initialPage: 'chatPage',
                        page: ChatPageWidget(),
                      )),
            FFRoute(
                name: NotificationsPageWidget.routeName,
                path: NotificationsPageWidget.routePath,
                builder: (context, params) => params.isEmpty
                    ? NavBarPage(initialPage: 'notificationsPage')
                    : NavBarPage(
                        initialPage: 'notificationsPage',
                        page: NotificationsPageWidget(),
                      )),
            FFRoute(
                name: HomePageWidget.routeName,
                path: HomePageWidget.routePath,
                builder: (context, params) => params.isEmpty
                    ? NavBarPage(initialPage: 'HomePage')
                    : NavBarPage(
                        initialPage: 'HomePage',
                        page: HomePageWidget(),
                      )),
            FFRoute(
              name: CreateCommunityWidget.routeName,
              path: CreateCommunityWidget.routePath,
              builder: (context, params) => CreateCommunityWidget(),
            ),
            FFRoute(
              name: StorefrontSetupWidget.routeName,
              path: StorefrontSetupWidget.routePath,
              builder: (context, params) => StorefrontSetupWidget(
                storeType: params.getParam(
                  'storeType',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: BlankWidget.routeName,
              path: BlankWidget.routePath,
              builder: (context, params) => BlankWidget(),
            ),
            FFRoute(
              name: CelebrationPageWidget.routeName,
              path: CelebrationPageWidget.routePath,
              builder: (context, params) => CelebrationPageWidget(
                storefrontID: params.getParam(
                  'storefrontID',
                  ParamType.String,
                ),
                storename: params.getParam(
                  'storename',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: StorefrontPageWidget.routeName,
              path: StorefrontPageWidget.routePath,
              builder: (context, params) => StorefrontPageWidget(
                storefontslug: params.getParam(
                  'storefontslug',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: CreatelistingPageWidget.routeName,
              path: CreatelistingPageWidget.routePath,
              builder: (context, params) => CreatelistingPageWidget(
                storeforntId: params.getParam(
                  'storeforntId',
                  ParamType.String,
                ),
                listingId: params.getParam(
                  'listingId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: SubscriptionPageWidget.routeName,
              path: SubscriptionPageWidget.routePath,
              builder: (context, params) => SubscriptionPageWidget(
                storefrontid: params.getParam(
                  'storefrontid',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: PaystackSubscribeWidget.routeName,
              path: PaystackSubscribeWidget.routePath,
              builder: (context, params) => PaystackSubscribeWidget(
                authorizationUrl: params.getParam(
                  'authorizationUrl',
                  ParamType.String,
                ),
                referencee: params.getParam(
                  'referencee',
                  ParamType.String,
                ),
                callbackUrl: params.getParam(
                  'callbackUrl',
                  ParamType.String,
                ),
                storefrontId: params.getParam(
                  'storefrontId',
                  ParamType.String,
                ),
                expectedTier: params.getParam(
                  'expectedTier',
                  ParamType.String,
                ),
                expectedBillingCycle: params.getParam(
                  'expectedBillingCycle',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: SuccessPageWidget.routeName,
              path: SuccessPageWidget.routePath,
              builder: (context, params) => SuccessPageWidget(),
            ),
            FFRoute(
              name: SubdscriptionfailedWidget.routeName,
              path: SubdscriptionfailedWidget.routePath,
              builder: (context, params) => SubdscriptionfailedWidget(),
            ),
            FFRoute(
              name: IdentificationVerificationPageWidget.routeName,
              path: IdentificationVerificationPageWidget.routePath,
              builder: (context, params) =>
                  IdentificationVerificationPageWidget(),
            ),
            FFRoute(
              name: Blank2Widget.routeName,
              path: Blank2Widget.routePath,
              builder: (context, params) => Blank2Widget(),
            ),
            FFRoute(
                name: ProfilePageWidget.routeName,
                path: ProfilePageWidget.routePath,
                builder: (context, params) => params.isEmpty
                    ? NavBarPage(initialPage: 'profilePage')
                    : NavBarPage(
                        initialPage: 'profilePage',
                        page: ProfilePageWidget(),
                      )),
            FFRoute(
              name: EditProfileWidget.routeName,
              path: EditProfileWidget.routePath,
              builder: (context, params) => EditProfileWidget(),
            ),
            FFRoute(
              name: EditStorefrontWidget.routeName,
              path: EditStorefrontWidget.routePath,
              builder: (context, params) => EditStorefrontWidget(
                storefrontID: params.getParam(
                  'storefrontID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ListingdetailPageWidget.routeName,
              path: ListingdetailPageWidget.routePath,
              builder: (context, params) => ListingdetailPageWidget(
                listingId: params.getParam(
                  'listingId',
                  ParamType.String,
                ),
                storefrontId: params.getParam(
                  'storefrontId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ImageViewerWidget.routeName,
              path: ImageViewerWidget.routePath,
              builder: (context, params) => ImageViewerWidget(
                imageUrl: params.getParam<String>(
                  'imageUrl',
                  ParamType.String,
                  isList: true,
                ),
                no: params.getParam(
                  'no',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: AskCommunityWidget.routeName,
              path: AskCommunityWidget.routePath,
              builder: (context, params) => AskCommunityWidget(),
            ),
            FFRoute(
              name: MyStorefrontWidget.routeName,
              path: MyStorefrontWidget.routePath,
              builder: (context, params) => MyStorefrontWidget(),
            ),
            FFRoute(
              name: CreatePostWidget.routeName,
              path: CreatePostWidget.routePath,
              builder: (context, params) => CreatePostWidget(
                storeID: params.getParam(
                  'storeID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MyPostWidget.routeName,
              path: MyPostWidget.routePath,
              builder: (context, params) => MyPostWidget(),
            ),
            FFRoute(
              name: CommunityWidget.routeName,
              path: CommunityWidget.routePath,
              builder: (context, params) => CommunityWidget(
                communitySlug: params.getParam(
                  'communitySlug',
                  ParamType.String,
                ),
                communityID: params.getParam(
                  'communityID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ConnectStorefrontWidget.routeName,
              path: ConnectStorefrontWidget.routePath,
              builder: (context, params) => ConnectStorefrontWidget(
                storeID: params.getParam(
                  'storeID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: GroupChatWidget.routeName,
              path: GroupChatWidget.routePath,
              builder: (context, params) => GroupChatWidget(),
            ),
            FFRoute(
              name: SelectWidget.routeName,
              path: SelectWidget.routePath,
              builder: (context, params) => SelectWidget(),
            ),
            FFRoute(
              name: OrderDetailsPageWidget.routeName,
              path: OrderDetailsPageWidget.routePath,
              builder: (context, params) => OrderDetailsPageWidget(
                orderId: params.getParam(
                  'orderId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: PaystackPaymenentWidget.routeName,
              path: PaystackPaymenentWidget.routePath,
              builder: (context, params) => PaystackPaymenentWidget(
                authorizationUrl: params.getParam(
                  'authorizationUrl',
                  ParamType.String,
                ),
                orderID: params.getParam(
                  'orderID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrderPaymentSuccessWidget.routeName,
              path: OrderPaymentSuccessWidget.routePath,
              builder: (context, params) => OrderPaymentSuccessWidget(
                orderID: params.getParam(
                  'orderID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrderPaymentFailureWidget.routeName,
              path: OrderPaymentFailureWidget.routePath,
              builder: (context, params) => OrderPaymentFailureWidget(
                orderID: params.getParam(
                  'orderID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ConfirmEmailWidget.routeName,
              path: ConfirmEmailWidget.routePath,
              builder: (context, params) => ConfirmEmailWidget(
                email: params.getParam(
                  'email',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: SearchPageWidget.routeName,
              path: SearchPageWidget.routePath,
              builder: (context, params) => SearchPageWidget(),
            ),
            FFRoute(
              name: ViewPostWidget.routeName,
              path: ViewPostWidget.routePath,
              builder: (context, params) => ViewPostWidget(
                postID: params.getParam(
                  'postID',
                  ParamType.String,
                ),
                postType: params.getParam(
                  'postType',
                  ParamType.String,
                ),
                storeID: params.getParam(
                  'storeID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: CommunitiesByInterestWidget.routeName,
              path: CommunitiesByInterestWidget.routePath,
              builder: (context, params) => CommunitiesByInterestWidget(
                category: params.getParam(
                  'category',
                  ParamType.String,
                ),
                typeFilter: params.getParam(
                  'typeFilter',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: SubListWidget.routeName,
              path: SubListWidget.routePath,
              builder: (context, params) => SubListWidget(
                name: params.getParam(
                  'name',
                  ParamType.String,
                ),
                categorySlug: params.getParam(
                  'categorySlug',
                  ParamType.String,
                ),
                communitySlug: params.getParam(
                  'communitySlug',
                  ParamType.String,
                ),
                communityID: params.getParam(
                  'communityID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ListlngPageWidget.routeName,
              path: ListlngPageWidget.routePath,
              builder: (context, params) => ListlngPageWidget(
                suvcategorySlug: params.getParam(
                  'suvcategorySlug',
                  ParamType.String,
                ),
                communityID: params.getParam(
                  'communityID',
                  ParamType.String,
                ),
                name: params.getParam(
                  'name',
                  ParamType.String,
                ),
                type: params.getParam(
                  'type',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: NewChatWidget.routeName,
              path: NewChatWidget.routePath,
              builder: (context, params) => NewChatWidget(),
            ),
            FFRoute(
              name: SellPageWidget.routeName,
              path: SellPageWidget.routePath,
              builder: (context, params) => SellPageWidget(),
            ),
            FFRoute(
              name: SubmissionListingDeclutterWidget.routeName,
              path: SubmissionListingDeclutterWidget.routePath,
              builder: (context, params) => SubmissionListingDeclutterWidget(),
            ),
            FFRoute(
              name: OjaStreetPageWidget.routeName,
              path: OjaStreetPageWidget.routePath,
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'ojaStreetPage')
                  : OjaStreetPageWidget(),
            ),
            FFRoute(
              name: MarketHeadDashboardPageWidget.routeName,
              path: MarketHeadDashboardPageWidget.routePath,
              builder: (context, params) => MarketHeadDashboardPageWidget(
                communityID: params.getParam(
                  'communityID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MediaTestWidget.routeName,
              path: MediaTestWidget.routePath,
              builder: (context, params) => MediaTestWidget(),
            ),
            FFRoute(
              name: MediaTest2Widget.routeName,
              path: MediaTest2Widget.routePath,
              builder: (context, params) => MediaTest2Widget(
                imageOut: params.getParam<String>(
                  'imageOut',
                  ParamType.String,
                  isList: true,
                ),
              ),
            ),
            FFRoute(
              name: SettingsMainWidget.routeName,
              path: SettingsMainWidget.routePath,
              builder: (context, params) => SettingsMainWidget(),
            ),
            FFRoute(
              name: PrivacySecurityWidget.routeName,
              path: PrivacySecurityWidget.routePath,
              builder: (context, params) => PrivacySecurityWidget(
                security: params.getParam(
                  'security',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SecurityStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: StorefrontPayOutWidget.routeName,
              path: StorefrontPayOutWidget.routePath,
              builder: (context, params) => StorefrontPayOutWidget(),
            ),
            FFRoute(
              name: StoreSettingsWidget.routeName,
              path: StoreSettingsWidget.routePath,
              builder: (context, params) => StoreSettingsWidget(),
            ),
            FFRoute(
              name: HelpFeedbackWidget.routeName,
              path: HelpFeedbackWidget.routePath,
              builder: (context, params) => HelpFeedbackWidget(
                faq: params.getParam<FaqsStruct>(
                  'faq',
                  ParamType.DataStruct,
                  isList: true,
                  structBuilder: FaqsStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: NotificationsSettingsWidget.routeName,
              path: NotificationsSettingsWidget.routePath,
              builder: (context, params) => NotificationsSettingsWidget(
                notification: params.getParam(
                  'notification',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: NotificationsStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: UpdateuserInterestPageWidget.routeName,
              path: UpdateuserInterestPageWidget.routePath,
              builder: (context, params) => UpdateuserInterestPageWidget(
                interests: params.getParam<InterestsStruct>(
                  'interests',
                  ParamType.DataStruct,
                  isList: true,
                  structBuilder: InterestsStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: OjaRankTierWidget.routeName,
              path: OjaRankTierWidget.routePath,
              builder: (context, params) => OjaRankTierWidget(),
            ),
            FFRoute(
              name: AppearanceWidget.routeName,
              path: AppearanceWidget.routePath,
              builder: (context, params) => AppearanceWidget(),
            ),
            FFRoute(
              name: Onboarding06Widget.routeName,
              path: Onboarding06Widget.routePath,
              builder: (context, params) => Onboarding06Widget(),
            ),
            FFRoute(
              name: OrijaMessageThreadPageWidget.routeName,
              path: OrijaMessageThreadPageWidget.routePath,
              builder: (context, params) => OrijaMessageThreadPageWidget(
                threadId: params.getParam(
                  'threadId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrijaBuyerBagPageWidget.routeName,
              path: OrijaBuyerBagPageWidget.routePath,
              builder: (context, params) => OrijaBuyerBagPageWidget(
                bagId: params.getParam(
                  'bagId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrijaVendorBagPageWidget.routeName,
              path: OrijaVendorBagPageWidget.routePath,
              builder: (context, params) => OrijaVendorBagPageWidget(
                bagId: params.getParam(
                  'bagId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrijaMyOrdersPageWidget.routeName,
              path: OrijaMyOrdersPageWidget.routePath,
              builder: (context, params) => OrijaMyOrdersPageWidget(),
            ),
            FFRoute(
              name: OrijaCheckoutPageWidget.routeName,
              path: OrijaCheckoutPageWidget.routePath,
              builder: (context, params) => OrijaCheckoutPageWidget(
                orderId: params.getParam(
                  'orderId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrijaListingEditorPageWidget.routeName,
              path: OrijaListingEditorPageWidget.routePath,
              builder: (context, params) => OrijaListingEditorPageWidget(
                listingId: params.getParam(
                  'listingId',
                  ParamType.String,
                ),
                storefrontId: params.getParam(
                  'storefrontId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: BlockedUsersWidget.routeName,
              path: BlockedUsersWidget.routePath,
              builder: (context, params) => BlockedUsersWidget(),
            ),
            FFRoute(
              name: LegalPrivacyWidget.routeName,
              path: LegalPrivacyWidget.routePath,
              builder: (context, params) => LegalPrivacyWidget(),
            ),
            FFRoute(
              name: ExploreSeeMoreWidget.routeName,
              path: ExploreSeeMoreWidget.routePath,
              builder: (context, params) => ExploreSeeMoreWidget(
                section: params.getParam(
                  'section',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MyCommunitiesWidget.routeName,
              path: MyCommunitiesWidget.routePath,
              builder: (context, params) => MyCommunitiesWidget(),
            ),
            FFRoute(
              name: SavedItemsWidget.routeName,
              path: SavedItemsWidget.routePath,
              builder: (context, params) => SavedItemsWidget(),
            ),
            FFRoute(
              name: ListingFiltersWidget.routeName,
              path: ListingFiltersWidget.routePath,
              builder: (context, params) => ListingFiltersWidget(
                filters: params.getParam(
                  'filters',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: OrijaSupportPageWidget.routeName,
              path: OrijaSupportPageWidget.routePath,
              builder: (context, params) => OrijaSupportPageWidget(),
            ),
            FFRoute(
              name: OrijaPracticePageWidget.routeName,
              path: OrijaPracticePageWidget.routePath,
              builder: (context, params) => OrijaPracticePageWidget(
                track: params.getParam(
                  'track',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: StorefrontVerificationPageWidget.routeName,
              path: StorefrontVerificationPageWidget.routePath,
              builder: (context, params) => StorefrontVerificationPageWidget(
                storefrontID: params.getParam(
                  'storefrontID',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: EditCommunityPageWidget.routeName,
              path: EditCommunityPageWidget.routePath,
              builder: (context, params) => EditCommunityPageWidget(
                communityId: params.getParam(
                  'communityId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: CreateBidListingWidget.routeName,
              path: CreateBidListingWidget.routePath,
              builder: (context, params) => CreateBidListingWidget(),
            ),
            FFRoute(
              name: BidDetailPageWidget.routeName,
              path: BidDetailPageWidget.routePath,
              builder: (context, params) => BidDetailPageWidget(
                sessionId: params.getParam(
                  'sessionId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: LiveBiddingListWidget.routeName,
              path: LiveBiddingListWidget.routePath,
              builder: (context, params) => LiveBiddingListWidget(),
            ),
            FFRoute(
              name: WalletPageWidget.routeName,
              path: WalletPageWidget.routePath,
              builder: (context, params) => WalletPageWidget(),
            ),
            FFRoute(
              name: MyBidsWidget.routeName,
              path: MyBidsWidget.routePath,
              builder: (context, params) => MyBidsWidget(),
            ),
            FFRoute(
              name: AddFundsWidget.routeName,
              path: AddFundsWidget.routePath,
              builder: (context, params) => AddFundsWidget(),
            ),
            FFRoute(
              name: ProfileDesktopPageWidget.routeName,
              path: ProfileDesktopPageWidget.routePath,
              builder: (context, params) => ProfileDesktopPageWidget(),
            ),
            FFRoute(
              name: OjaStreetDesktopPageWidget.routeName,
              path: OjaStreetDesktopPageWidget.routePath,
              builder: (context, params) => OjaStreetDesktopPageWidget(),
            ),
            FFRoute(
              name: RequestInstitutionWidget.routeName,
              path: RequestInstitutionWidget.routePath,
              builder: (context, params) => RequestInstitutionWidget(),
            ),
            FFRoute(
              name: TradeFairPageWidget.routeName,
              path: TradeFairPageWidget.routePath,
              builder: (context, params) => TradeFairPageWidget(
                fairId: params.getParam(
                  'fairId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: StallPassPageWidget.routeName,
              path: StallPassPageWidget.routePath,
              builder: (context, params) => StallPassPageWidget(
                bookingRef: params.getParam(
                  'bookingRef',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MyHostelsWidget.routeName,
              path: MyHostelsWidget.routePath,
              builder: (context, params) => MyHostelsWidget(
                storefrontId: params.getParam(
                  'storefrontId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: HostelPageWidget.routeName,
              path: HostelPageWidget.routePath,
              builder: (context, params) => HostelPageWidget(
                hostelId: params.getParam(
                  'hostelId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MyRoomRequestPageWidget.routeName,
              path: MyRoomRequestPageWidget.routePath,
              builder: (context, params) => MyRoomRequestPageWidget(
                requestId: params.getParam(
                  'requestId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: RoomRequestPageWidget.routeName,
              path: RoomRequestPageWidget.routePath,
              builder: (context, params) => RoomRequestPageWidget(
                prefill: params.getParam(
                  'prefill',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: RoomRequestAgentPageWidget.routeName,
              path: RoomRequestAgentPageWidget.routePath,
              builder: (context, params) => RoomRequestAgentPageWidget(
                requestId: params.getParam(
                  'requestId',
                  ParamType.String,
                ),
                storefrontId: params.getParam(
                  'storefrontId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: AccommodationPageWidget.routeName,
              path: AccommodationPageWidget.routePath,
              builder: (context, params) => AccommodationPageWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: ffNavigatorObservers,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/onboarding06';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? isWeb
                  ? Container()
                  : Container(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      child: Center(
                        child: Image.asset(
                          'assets/images/Annotation_2025-02-20_070257-removebg-preview_1.png',
                          width: 50.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    curve: transitionInfo.transitionType ==
                            PageTransitionType.scale
                        ? const Interval(0.0, 0.5)
                        : Curves.linear,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
