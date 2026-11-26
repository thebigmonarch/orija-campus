import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'storefront_row2_model.dart';
export 'storefront_row2_model.dart';

class StorefrontRow2Widget extends StatefulWidget {
  const StorefrontRow2Widget({
    super.key,
    String? category,
    String? city,
    String? logoDesc,
    String? name,
    String? orders,
    String? ownerName,
    String? rating,
    String? tier,
    bool? isVerified,
  })  : this.category = category ?? 'Gadgets',
        this.city = city ?? 'Oshodi',
        this.logoDesc = logoDesc ??
            'https://dimg.dreamflow.cloud/v1/image/electronics%20store%20logo',
        this.name = name ?? 'Olu\'s Electronics',
        this.orders = orders ?? '1.2k',
        this.ownerName = ownerName ?? 'Oluwaseun John',
        this.rating = rating ?? '4.8',
        this.tier = tier ?? 'Gold Tier',
        this.isVerified = isVerified ?? true;

  final String category;
  final String city;
  final String logoDesc;
  final String name;
  final String orders;
  final String ownerName;
  final String rating;
  final String tier;
  final bool isVerified;

  @override
  State<StorefrontRow2Widget> createState() => _StorefrontRow2WidgetState();
}

class _StorefrontRow2WidgetState extends State<StorefrontRow2Widget> {
  late StorefrontRow2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontRow2Model());

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
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 0),
                            fadeOutDuration: Duration(milliseconds: 0),
                            imageUrl: valueOrDefault<String>(
                              widget.logoDesc,
                              'https://dimg.dreamflow.cloud/v1/image/electronics%20store%20logo',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    valueOrDefault<String>(
                                      widget.name,
                                      'Olu\'s Electronics',
                                    ),
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleMediumFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          lineHeight: 1.4,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleMediumIsCustom,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: valueOrDefault<Color>(
                                      valueOrDefault<bool>(
                                        widget.isVerified,
                                        true,
                                      )
                                          ? Color(0x2610B981)
                                          : Color(0xFFE0E3E7),
                                      Color(0x2610B981),
                                    ),
                                    borderRadius: BorderRadius.circular(9999.0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 14.0,
                                            height: 14.0,
                                            child: Stack(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  color: valueOrDefault<Color>(
                                                    valueOrDefault<bool>(
                                                      widget.isVerified,
                                                      true,
                                                    )
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .success
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                  ),
                                                  size: 14.0,
                                                ),
                                                Icon(
                                                  Icons.report_problem_rounded,
                                                  color: valueOrDefault<Color>(
                                                    valueOrDefault<bool>(
                                                      widget.isVerified,
                                                      true,
                                                    )
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .success
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                  ),
                                                  size: 14.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              valueOrDefault<bool>(
                                                widget.isVerified,
                                                true,
                                              )
                                                  ? 'Verified'
                                                  : 'Unverified',
                                              'Verified',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmallFamily,
                                                  color: valueOrDefault<Color>(
                                                    valueOrDefault<bool>(
                                                      widget.isVerified,
                                                      true,
                                                    )
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .success
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  lineHeight: 1.2,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmallIsCustom,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.category,
                                    'Gadgets',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.4,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                                Text(
                                  '•',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.4,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    widget.city,
                                    'Oshodi',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.4,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: Colors.transparent,
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 22.0,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              widget.ownerName,
                              'Oluwaseun John',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.2,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0x1A86370E),
                              borderRadius: BorderRadius.circular(4.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  6.0, 2.0, 6.0, 2.0),
                              child: Container(
                                child: Text(
                                  valueOrDefault<String>(
                                    widget.tier,
                                    'Gold Tier',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelSmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        lineHeight: 1.2,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelSmallIsCustom,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 2.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: FlutterFlowTheme.of(context).warning,
                                size: 16.0,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  widget.rating,
                                  '4.8',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.2,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 16.0,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  '${widget.orders} orders',
                                  '1.2k orders',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.2,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ].divide(SizedBox(width: 16.0)),
                      ),
                    ],
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
