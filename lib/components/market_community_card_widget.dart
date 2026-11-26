import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'market_community_card_model.dart';
export 'market_community_card_model.dart';

/// Create a reusable Market Community Card component for the Orija app.
///
/// The component represents a physical market/community hub in Nigeria and
/// should feel modern, trusted, social, and location-aware.
///
/// COMPONENT NAME:
/// OrijaMarketCard
///
/// DESIGN STYLE:
/// - Modern marketplace UI
/// - Clean spacing
/// - Soft shadow
/// - Rounded corners (20px)
/// - Mobile-first design
/// - Inspired by Airbnb + Facebook Communities + local Nigerian commerce
/// - Elegant but simple
/// - Supports light and dark mode
///
/// CARD STRUCTURE:
///
/// 1. COVER IMAGE
/// - Large top cover image
/// - Height around 150–180px
/// - Rounded top corners
/// - Use network image
/// - Dark gradient overlay at bottom for readability
///
/// 2. VERIFIED BADGE
/// - Show verified badge if is_verified = true
/// - Positioned beside market name
///
/// 3. MARKET NAME
/// Example:
/// "The Arena Market, Oshodi"
///
/// - Bold text
/// - Max 2 lines
/// - High emphasis
///
/// 4. LOCATION
/// Display:
/// "Oshodi, Lagos"
///
/// Use location icon beside text.
///
/// 5. DESCRIPTION
/// - Max 3 lines
/// - Soft gray text
/// - Should truncate with ellipsis
///
/// 6. MARKET STATS ROW
/// Display:
/// - Member count
/// - Vendor count
///
/// Example:
/// "2.4K Members"
/// "320 Vendors"
///
/// Use small icons beside each stat.
///
/// 7. MARKET HEAD
/// Display:
/// "Managed by Feyisayo Adebayo"
///
/// Use smaller muted text.
///
/// 8. NEAR YOU TAG
/// If is_near_you = true:
/// - Show orange pill badge
/// - Text:
/// "Near You"
///
/// 9. TOP STOREFRONTS PREVIEW
/// If top_storefronts contains items:
/// - Show overlapping storefront avatars/logos
/// - Show "+12 vendors"
///
/// 10. ACTION BUTTON
/// Primary button:
/// "View Market"
///
/// Rounded pill style.
/// Use Orija orange color.
///
/// INTERACTIONS:
/// - Entire card clickable
/// - Smooth tap animation
/// - Slight scale-down on press
/// - Hover state support
/// - Lazy image loading
///
/// COMPONENT INPUT PARAMETERS:
///
/// - id
/// - lat
/// - lng
/// - city
/// - name
/// - slug
/// - state
/// - address
/// - cover_url
/// - head_name
/// - created_at
/// - description
/// - is_near_you
/// - is_verified
/// - member_count
/// - vendor_count
/// - top_storefronts
///
/// EXAMPLE DATA:
///
/// {
///   "id": "df2986c9-ed9c-4acd-afd2-15d6fa96a7b4",
///   "lat": 6.4531,
///   "lng": 3.3958,
///   "city": "Oshodi",
///   "name": "The Arena Market, Oshodi",
///   "slug": "arena-oshodi-market",
///   "state": "Lagos",
///   "address": "Agege Motor Road, Bolade Bus Stop, Oshodi, Lagos",
///   "cover_url":
/// "https://dgwvnxdxushgfvuzrvdr.supabase.co/storage/v1/object/public/default%20Images/communityDefault.jpg",
///   "head_name": "Feyisayo Adebayo",
///   "created_at": "2026-05-23T17:30:25.528215+00:00",
///   "description": "One of Lagos' most iconic one-stop shopping
/// destinations.",
///   "is_near_you": true,
///   "is_verified": true,
///   "member_count": 2400,
///   "vendor_count": 320,
///   "top_storefronts": []
/// }
///
/// FLUTTERFLOW REQUIREMENTS:
/// - Reusable component
/// - Optimized for ListView
/// - Dynamic Supabase data support
/// - Cached network images
/// - Responsive width
/// - Support loading states
/// - Use Stack for overlays
/// - Avoid overflow issues
/// - Fully mobile responsive
class MarketCommunityCardWidget extends StatefulWidget {
  const MarketCommunityCardWidget({
    super.key,
    String? coverUrl,
    String? name,
    String? city,
    String? state,
    String? memberCount,
    this.slug,
    this.communityID,
    required this.isNearYou,
    this.isVerified,
  })  : this.coverUrl = coverUrl ?? '',
        this.name = name ?? '',
        this.city = city ?? '',
        this.state = state ?? '',
        this.memberCount = memberCount ?? '';

  final String coverUrl;
  final String name;
  final String city;
  final String state;
  final String memberCount;
  final String? slug;
  final String? communityID;
  final bool? isNearYou;
  final bool? isVerified;

  @override
  State<MarketCommunityCardWidget> createState() =>
      _MarketCommunityCardWidgetState();
}

class _MarketCommunityCardWidgetState extends State<MarketCommunityCardWidget> {
  late MarketCommunityCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketCommunityCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(
          CommunityWidget.routeName,
          queryParameters: {
            'communitySlug': serializeParam(
              widget.slug,
              ParamType.String,
            ),
            'communityID': serializeParam(
              widget.communityID,
              ParamType.String,
            ),
          }.withoutNulls,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 300.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(20.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondary,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 120.0,
                child: Stack(
                  alignment: AlignmentDirectional(-1.0, -1.0),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        imageUrl: valueOrDefault<String>(
                          widget.coverUrl,
                          'https://picsum.photos/seed/15/600',
                        ),
                        width: double.infinity,
                        height: 120.0,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ),
                    Container(
                      height: 120.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          stops: [0.4, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    if (widget.isNearYou ?? true)
                      Align(
                        alignment: AlignmentDirectional(-1.0, -1.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondary,
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 4.0, 8.0, 4.0),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.white,
                                        size: 12.0,
                                      ),
                                      Text(
                                        'Near You',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmallFamily,
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              lineHeight: 1.27,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelSmallIsCustom,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 4.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (widget.isVerified ?? true)
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            alignment: AlignmentDirectional(1.0, -1.0),
                            child: Container(
                              width: 28.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.verified_rounded,
                                color: FlutterFlowTheme.of(context).secondary,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.name,
                              maxLines: 2,
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.35,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleMediumIsCustom,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 14.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${widget.city}, ${widget.state}',
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.38,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodySmallIsCustom,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_outlined,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 16.0,
                                ),
                                Text(
                                  '${widget.memberCount} Members',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.38,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
