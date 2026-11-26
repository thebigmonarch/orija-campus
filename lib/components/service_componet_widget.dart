import '/backend/supabase/supabase.dart';
import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'service_componet_model.dart';
export 'service_componet_model.dart';

class ServiceComponetWidget extends StatefulWidget {
  const ServiceComponetWidget({
    super.key,
    required this.listingID,
  });

  final String? listingID;

  @override
  State<ServiceComponetWidget> createState() => _ServiceComponetWidgetState();
}

class _ServiceComponetWidgetState extends State<ServiceComponetWidget> {
  late ServiceComponetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServiceComponetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListingsRow>>(
      future: ListingsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.listingID,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Container(
            height: 110.0,
            child: ShimmerWidget(),
          );
        }
        List<ListingsRow> containerListingsRowList = snapshot.data!;

        final containerListingsRow = containerListingsRowList.isNotEmpty
            ? containerListingsRowList.first
            : null;

        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        valueOrDefault<String>(
                          containerListingsRow?.photos.firstOrNull,
                          'https://picsum.photos/seed/346/600',
                        ),
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              containerListingsRow?.title,
                              'null',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                          Expanded(
                            child: Text(
                              valueOrDefault<String>(
                                containerListingsRow?.description,
                                'null',
                              ),
                              maxLines: 2,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: valueOrDefault<String>(
                          formatNumber(
                            containerListingsRow?.price,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.periodDecimal,
                            currency: '₦',
                          ),
                          '₦0.0',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(),
                      ),
                      TextSpan(
                        text: valueOrDefault<String>(
                          containerListingsRow?.pricingType,
                          'null',
                        ),
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).secondary,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        );
      },
    );
  }
}
