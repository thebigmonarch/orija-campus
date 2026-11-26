import '/backend/schema/structs/index.dart';
import '/components/storefront_component2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'stores_market_place_model.dart';
export 'stores_market_place_model.dart';

class StoresMarketPlaceWidget extends StatefulWidget {
  const StoresMarketPlaceWidget({
    super.key,
    required this.storeSection,
  });

  final SectionsMarketStruct? storeSection;

  @override
  State<StoresMarketPlaceWidget> createState() =>
      _StoresMarketPlaceWidgetState();
}

class _StoresMarketPlaceWidgetState extends State<StoresMarketPlaceWidget> {
  late StoresMarketPlaceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoresMarketPlaceModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.storeSection?.title,
                        'null',
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.storeSection?.subtitle,
                    'null',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
          Builder(
            builder: (context) {
              final storeIDs = widget.storeSection?.items
                      .map((e) => e.storefront)
                      .toList()
                      .toList() ??
                  [];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(storeIDs.length, (storeIDsIndex) {
                    final storeIDsItem = storeIDs[storeIDsIndex];
                    return wrapWithModel(
                      model: _model.storefrontComponent2Models.getModel(
                        storeIDsItem.id,
                        storeIDsIndex,
                      ),
                      updateCallback: () => safeSetState(() {}),
                      child: StorefrontComponent2Widget(
                        key: Key(
                          'Key84n_${storeIDsItem.id}',
                        ),
                        storeID: storeIDsItem.id,
                      ),
                    );
                  })
                      .divide(SizedBox(width: 10.0))
                      .addToStart(SizedBox(width: 16.0))
                      .addToEnd(SizedBox(width: 16.0)),
                ),
              );
            },
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
