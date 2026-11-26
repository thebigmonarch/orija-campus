import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _storefrontID = '';
  String get storefrontID => _storefrontID;
  set storefrontID(String value) {
    _storefrontID = value;
  }

  String _isProfileExist = '';
  String get isProfileExist => _isProfileExist;
  set isProfileExist(String value) {
    _isProfileExist = value;
  }

  bool _isProfileSet2 = false;
  bool get isProfileSet2 => _isProfileSet2;
  set isProfileSet2(bool value) {
    _isProfileSet2 = value;
  }

  String _commentID = '';
  String get commentID => _commentID;
  set commentID(String value) {
    _commentID = value;
  }

  String _commentorName = '';
  String get commentorName => _commentorName;
  set commentorName(String value) {
    _commentorName = value;
  }

  String _avatarID = '';
  String get avatarID => _avatarID;
  set avatarID(String value) {
    _avatarID = value;
  }

  String _countryName = '';
  String get countryName => _countryName;
  set countryName(String value) {
    _countryName = value;
  }

  String _countryCode = '';
  String get countryCode => _countryCode;
  set countryCode(String value) {
    _countryCode = value;
  }

  String _stateName = '';
  String get stateName => _stateName;
  set stateName(String value) {
    _stateName = value;
  }

  String _stateCode = '';
  String get stateCode => _stateCode;
  set stateCode(String value) {
    _stateCode = value;
  }

  String _cityName = '';
  String get cityName => _cityName;
  set cityName(String value) {
    _cityName = value;
  }

  int _chatRefreshKey = 0;
  int get chatRefreshKey => _chatRefreshKey;
  set chatRefreshKey(int value) {
    _chatRefreshKey = value;
  }

  int _notificationsRefreshKey = 0;
  int get notificationsRefreshKey => _notificationsRefreshKey;
  set notificationsRefreshKey(int value) {
    _notificationsRefreshKey = value;
  }

  int _mySquareRefreshKey = 0;
  int get mySquareRefreshKey => _mySquareRefreshKey;
  set mySquareRefreshKey(int value) {
    _mySquareRefreshKey = value;
  }

  int _profileRefreshKey = 0;
  int get profileRefreshKey => _profileRefreshKey;
  set profileRefreshKey(int value) {
    _profileRefreshKey = value;
  }

  int _homeRefreshKey = 0;
  int get homeRefreshKey => _homeRefreshKey;
  set homeRefreshKey(int value) {
    _homeRefreshKey = value;
  }

  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;
  set activeTabIndex(int value) {
    _activeTabIndex = value;
  }

  int _appResumedTrigger = 0;
  int get appResumedTrigger => _appResumedTrigger;
  set appResumedTrigger(int value) {
    _appResumedTrigger = value;
  }

  String _fcmToken = '';
  String get fcmToken => _fcmToken;
  set fcmToken(String value) {
    _fcmToken = value;
  }

  String _notifNavType = '';
  String get notifNavType => _notifNavType;
  set notifNavType(String value) {
    _notifNavType = value;
  }

  String _notifNavThreadId = '';
  String get notifNavThreadId => _notifNavThreadId;
  set notifNavThreadId(String value) {
    _notifNavThreadId = value;
  }

  String _notifNavOrderId = '';
  String get notifNavOrderId => _notifNavOrderId;
  set notifNavOrderId(String value) {
    _notifNavOrderId = value;
  }

  String _notifNavPostId = '';
  String get notifNavPostId => _notifNavPostId;
  set notifNavPostId(String value) {
    _notifNavPostId = value;
  }

  String _notifNavSessionId = '';
  String get notifNavSessionId => _notifNavSessionId;
  set notifNavSessionId(String value) {
    _notifNavSessionId = value;
  }

  String _notifNavBagId = '';
  String get notifNavBagId => _notifNavBagId;
  set notifNavBagId(String value) {
    _notifNavBagId = value;
  }

  String _notifNavCommunityId = '';
  String get notifNavCommunityId => _notifNavCommunityId;
  set notifNavCommunityId(String value) {
    _notifNavCommunityId = value;
  }

  String _notifNavStorefrontId = '';
  String get notifNavStorefrontId => _notifNavStorefrontId;
  set notifNavStorefrontId(String value) {
    _notifNavStorefrontId = value;
  }

  int _chatCount = 0;
  int get chatCount => _chatCount;
  set chatCount(int value) {
    _chatCount = value;
  }

  int _notificationCount = 0;
  int get notificationCount => _notificationCount;
  set notificationCount(int value) {
    _notificationCount = value;
  }
}
