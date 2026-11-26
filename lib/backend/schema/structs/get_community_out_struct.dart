// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GetCommunityOutStruct extends BaseStruct {
  GetCommunityOutStruct({
    HeadStruct? head,
    bool? success,
    AboutTabStruct? aboutTab,
    CommunityStruct? community,
    String? createdBy,
    StoresTabStruct? storesTab,
    StreetTabStruct? streetTab,
    LiveCountsStruct? liveCounts,
    ViewerMembershipStruct? viewerMembership,
  })  : _head = head,
        _success = success,
        _aboutTab = aboutTab,
        _community = community,
        _createdBy = createdBy,
        _storesTab = storesTab,
        _streetTab = streetTab,
        _liveCounts = liveCounts,
        _viewerMembership = viewerMembership;

  // "head" field.
  HeadStruct? _head;
  HeadStruct get head => _head ?? HeadStruct();
  set head(HeadStruct? val) => _head = val;

  void updateHead(Function(HeadStruct) updateFn) {
    updateFn(_head ??= HeadStruct());
  }

  bool hasHead() => _head != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "about_tab" field.
  AboutTabStruct? _aboutTab;
  AboutTabStruct get aboutTab => _aboutTab ?? AboutTabStruct();
  set aboutTab(AboutTabStruct? val) => _aboutTab = val;

  void updateAboutTab(Function(AboutTabStruct) updateFn) {
    updateFn(_aboutTab ??= AboutTabStruct());
  }

  bool hasAboutTab() => _aboutTab != null;

  // "community" field.
  CommunityStruct? _community;
  CommunityStruct get community => _community ?? CommunityStruct();
  set community(CommunityStruct? val) => _community = val;

  void updateCommunity(Function(CommunityStruct) updateFn) {
    updateFn(_community ??= CommunityStruct());
  }

  bool hasCommunity() => _community != null;

  // "created_by" field.
  String? _createdBy;
  String get createdBy => _createdBy ?? '';
  set createdBy(String? val) => _createdBy = val;

  bool hasCreatedBy() => _createdBy != null;

  // "stores_tab" field.
  StoresTabStruct? _storesTab;
  StoresTabStruct get storesTab => _storesTab ?? StoresTabStruct();
  set storesTab(StoresTabStruct? val) => _storesTab = val;

  void updateStoresTab(Function(StoresTabStruct) updateFn) {
    updateFn(_storesTab ??= StoresTabStruct());
  }

  bool hasStoresTab() => _storesTab != null;

  // "street_tab" field.
  StreetTabStruct? _streetTab;
  StreetTabStruct get streetTab => _streetTab ?? StreetTabStruct();
  set streetTab(StreetTabStruct? val) => _streetTab = val;

  void updateStreetTab(Function(StreetTabStruct) updateFn) {
    updateFn(_streetTab ??= StreetTabStruct());
  }

  bool hasStreetTab() => _streetTab != null;

  // "live_counts" field.
  LiveCountsStruct? _liveCounts;
  LiveCountsStruct get liveCounts => _liveCounts ?? LiveCountsStruct();
  set liveCounts(LiveCountsStruct? val) => _liveCounts = val;

  void updateLiveCounts(Function(LiveCountsStruct) updateFn) {
    updateFn(_liveCounts ??= LiveCountsStruct());
  }

  bool hasLiveCounts() => _liveCounts != null;

  // "viewer_membership" field.
  ViewerMembershipStruct? _viewerMembership;
  ViewerMembershipStruct get viewerMembership =>
      _viewerMembership ?? ViewerMembershipStruct();
  set viewerMembership(ViewerMembershipStruct? val) => _viewerMembership = val;

  void updateViewerMembership(Function(ViewerMembershipStruct) updateFn) {
    updateFn(_viewerMembership ??= ViewerMembershipStruct());
  }

  bool hasViewerMembership() => _viewerMembership != null;

  static GetCommunityOutStruct fromMap(Map<String, dynamic> data) =>
      GetCommunityOutStruct(
        head: data['head'] is HeadStruct
            ? data['head']
            : HeadStruct.maybeFromMap(data['head']),
        success: data['success'] as bool?,
        aboutTab: data['about_tab'] is AboutTabStruct
            ? data['about_tab']
            : AboutTabStruct.maybeFromMap(data['about_tab']),
        community: data['community'] is CommunityStruct
            ? data['community']
            : CommunityStruct.maybeFromMap(data['community']),
        createdBy: data['created_by'] as String?,
        storesTab: data['stores_tab'] is StoresTabStruct
            ? data['stores_tab']
            : StoresTabStruct.maybeFromMap(data['stores_tab']),
        streetTab: data['street_tab'] is StreetTabStruct
            ? data['street_tab']
            : StreetTabStruct.maybeFromMap(data['street_tab']),
        liveCounts: data['live_counts'] is LiveCountsStruct
            ? data['live_counts']
            : LiveCountsStruct.maybeFromMap(data['live_counts']),
        viewerMembership: data['viewer_membership'] is ViewerMembershipStruct
            ? data['viewer_membership']
            : ViewerMembershipStruct.maybeFromMap(data['viewer_membership']),
      );

  static GetCommunityOutStruct? maybeFromMap(dynamic data) => data is Map
      ? GetCommunityOutStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'head': _head?.toMap(),
        'success': _success,
        'about_tab': _aboutTab?.toMap(),
        'community': _community?.toMap(),
        'created_by': _createdBy,
        'stores_tab': _storesTab?.toMap(),
        'street_tab': _streetTab?.toMap(),
        'live_counts': _liveCounts?.toMap(),
        'viewer_membership': _viewerMembership?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'head': serializeParam(
          _head,
          ParamType.DataStruct,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'about_tab': serializeParam(
          _aboutTab,
          ParamType.DataStruct,
        ),
        'community': serializeParam(
          _community,
          ParamType.DataStruct,
        ),
        'created_by': serializeParam(
          _createdBy,
          ParamType.String,
        ),
        'stores_tab': serializeParam(
          _storesTab,
          ParamType.DataStruct,
        ),
        'street_tab': serializeParam(
          _streetTab,
          ParamType.DataStruct,
        ),
        'live_counts': serializeParam(
          _liveCounts,
          ParamType.DataStruct,
        ),
        'viewer_membership': serializeParam(
          _viewerMembership,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static GetCommunityOutStruct fromSerializableMap(Map<String, dynamic> data) =>
      GetCommunityOutStruct(
        head: deserializeStructParam(
          data['head'],
          ParamType.DataStruct,
          false,
          structBuilder: HeadStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        aboutTab: deserializeStructParam(
          data['about_tab'],
          ParamType.DataStruct,
          false,
          structBuilder: AboutTabStruct.fromSerializableMap,
        ),
        community: deserializeStructParam(
          data['community'],
          ParamType.DataStruct,
          false,
          structBuilder: CommunityStruct.fromSerializableMap,
        ),
        createdBy: deserializeParam(
          data['created_by'],
          ParamType.String,
          false,
        ),
        storesTab: deserializeStructParam(
          data['stores_tab'],
          ParamType.DataStruct,
          false,
          structBuilder: StoresTabStruct.fromSerializableMap,
        ),
        streetTab: deserializeStructParam(
          data['street_tab'],
          ParamType.DataStruct,
          false,
          structBuilder: StreetTabStruct.fromSerializableMap,
        ),
        liveCounts: deserializeStructParam(
          data['live_counts'],
          ParamType.DataStruct,
          false,
          structBuilder: LiveCountsStruct.fromSerializableMap,
        ),
        viewerMembership: deserializeStructParam(
          data['viewer_membership'],
          ParamType.DataStruct,
          false,
          structBuilder: ViewerMembershipStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'GetCommunityOutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GetCommunityOutStruct &&
        head == other.head &&
        success == other.success &&
        aboutTab == other.aboutTab &&
        community == other.community &&
        createdBy == other.createdBy &&
        storesTab == other.storesTab &&
        streetTab == other.streetTab &&
        liveCounts == other.liveCounts &&
        viewerMembership == other.viewerMembership;
  }

  @override
  int get hashCode => const ListEquality().hash([
        head,
        success,
        aboutTab,
        community,
        createdBy,
        storesTab,
        streetTab,
        liveCounts,
        viewerMembership
      ]);
}

GetCommunityOutStruct createGetCommunityOutStruct({
  HeadStruct? head,
  bool? success,
  AboutTabStruct? aboutTab,
  CommunityStruct? community,
  String? createdBy,
  StoresTabStruct? storesTab,
  StreetTabStruct? streetTab,
  LiveCountsStruct? liveCounts,
  ViewerMembershipStruct? viewerMembership,
}) =>
    GetCommunityOutStruct(
      head: head ?? HeadStruct(),
      success: success,
      aboutTab: aboutTab ?? AboutTabStruct(),
      community: community ?? CommunityStruct(),
      createdBy: createdBy,
      storesTab: storesTab ?? StoresTabStruct(),
      streetTab: streetTab ?? StreetTabStruct(),
      liveCounts: liveCounts ?? LiveCountsStruct(),
      viewerMembership: viewerMembership ?? ViewerMembershipStruct(),
    );
