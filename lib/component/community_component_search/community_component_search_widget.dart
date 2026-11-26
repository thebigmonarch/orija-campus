import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'community_component_search_model.dart';
export 'community_component_search_model.dart';

class CommunityComponentSearchWidget extends StatefulWidget {
  const CommunityComponentSearchWidget({
    super.key,
    required this.communityId,
    bool? isLink,
    this.storeID,
    required this.imageUrl,
    this.name,
    required this.members,
    required this.discription,
    required this.communitySlug,
    bool? isJoined,
    this.memberView,
  })  : this.isLink = isLink ?? false,
        this.isJoined = isJoined ?? false;

  final String? communityId;
  final bool isLink;
  final String? storeID;
  final String? imageUrl;
  final String? name;
  final int? members;
  final String? discription;
  final String? communitySlug;
  final bool isJoined;
  final List<MemberPreview2Struct>? memberView;

  @override
  State<CommunityComponentSearchWidget> createState() =>
      _CommunityComponentSearchWidgetState();
}

class _CommunityComponentSearchWidgetState
    extends State<CommunityComponentSearchWidget> {
  late CommunityComponentSearchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityComponentSearchModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.storeID != null && widget.storeID != '') {
        _model.communityLinkOut = await CommunityMembersTable().queryRows(
          queryFn: (q) => q
              .eqOrNull(
                'community_id',
                widget.communityId,
              )
              .eqOrNull(
                'storefront_id',
                widget.storeID,
              )
              .eqOrNull(
                'is_vendor_active',
                true,
              ),
        );
        if (_model.communityLinkOut != null &&
            (_model.communityLinkOut)!.isNotEmpty) {
          _model.isLinked = true;
          safeSetState(() {});
        } else {
          _model.isLinked = false;
          safeSetState(() {});
        }
      } else {
        _model.isJoined = widget.isJoined;
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            CommunityWidget.routeName,
            queryParameters: {
              'communitySlug': serializeParam(
                widget.communitySlug,
                ParamType.String,
              ),
              'communityID': serializeParam(
                widget.communityId,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                        imageUrl: valueOrDefault<String>(
                          widget.imageUrl,
                          'https://picsum.photos/seed/132/600',
                        ),
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              widget.name,
                              'null',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.people_outline,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 16.0,
                              ),
                              RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: valueOrDefault<String>(
                                        formatNumber(
                                          widget.members,
                                          formatType: FormatType.compact,
                                        ),
                                        '0',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' members ',
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(width: 6.0)),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                    Container(
                      child: custom_widgets.OrijaCommunityAction(
                        communityId: widget.communityId,
                        isJoined: widget.isJoined,
                        isLink: widget.isLink,
                        storeId: widget.storeID,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.discription,
                      'null',
                    ),
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.memberView != null &&
                    (widget.memberView)!.isNotEmpty)
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Stack(
                      children: [
                        if ((widget.memberView?.elementAtOrNull(0)) != null)
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: valueOrDefault<String>(
                                  (widget.memberView?.elementAtOrNull(0))
                                      ?.logoUrl,
                                  'https://picsum.photos/seed/677/600',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if ((widget.memberView?.elementAtOrNull(1)) != null)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: valueOrDefault<String>(
                                    (widget.memberView?.elementAtOrNull(1))
                                        ?.logoUrl,
                                    'https://picsum.photos/seed/677/600',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        if ((widget.memberView?.elementAtOrNull(2)) != null)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                34.0, 0.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: valueOrDefault<String>(
                                    (widget.memberView?.elementAtOrNull(2))
                                        ?.logoUrl,
                                    'https://picsum.photos/seed/677/600',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        if ((widget.memberView?.elementAtOrNull(3)) != null)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                52.0, 0.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: valueOrDefault<String>(
                                    (widget.memberView?.elementAtOrNull(3))
                                        ?.logoUrl,
                                    'https://picsum.photos/seed/677/600',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ].divide(SizedBox(height: 6.0)),
            ),
          ),
        ),
      ),
    );
  }
}
