import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'storefront_component_model.dart';
export 'storefront_component_model.dart';

class StorefrontComponentWidget extends StatefulWidget {
  const StorefrontComponentWidget({
    super.key,
    required this.storefrontID,
    required this.logo,
    required this.name,
    required this.isVerified,
    required this.discription,
    required this.rating,
    required this.slug,
    this.isEdit,
  });

  final String? storefrontID;
  final String? logo;
  final String? name;
  final bool? isVerified;
  final String? discription;
  final String? rating;
  final String? slug;
  final bool? isEdit;

  @override
  State<StorefrontComponentWidget> createState() =>
      _StorefrontComponentWidgetState();
}

class _StorefrontComponentWidgetState extends State<StorefrontComponentWidget> {
  late StorefrontComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontComponentModel());

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
        if (widget.isEdit!) {
          context.pushNamed(
            EditStorefrontWidget.routeName,
            queryParameters: {
              'storefrontID': serializeParam(
                widget.storefrontID,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        } else {
          context.pushNamed(
            StorefrontPageWidget.routeName,
            queryParameters: {
              'storefontslug': serializeParam(
                widget.slug,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  valueOrDefault<String>(
                    widget.logo,
                    'https://picsum.photos/seed/735/600',
                  ),
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.isVerified ?? true)
                                Icon(
                                  Icons.verified,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              widget.rating,
                              '0',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              4.0, 0.0, 0.0, 0.0),
                          child: Icon(
                            Icons.star,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.discription,
                        'null',
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
