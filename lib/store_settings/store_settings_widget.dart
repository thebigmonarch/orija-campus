import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/storefront/storefront_component/storefront_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'store_settings_model.dart';
export 'store_settings_model.dart';

class StoreSettingsWidget extends StatefulWidget {
  const StoreSettingsWidget({super.key});

  static String routeName = 'storeSettings';
  static String routePath = 'storeSettings';

  @override
  State<StoreSettingsWidget> createState() => _StoreSettingsWidgetState();
}

class _StoreSettingsWidgetState extends State<StoreSettingsWidget> {
  late StoreSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoreSettingsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StorefrontsWithReviewSummaryRow>>(
      future: StorefrontsWithReviewSummaryTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'owner_id',
          currentUserUid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitChasingDots(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<StorefrontsWithReviewSummaryRow>
            storeSettingsStorefrontsWithReviewSummaryRowList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 54.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                'Edit Stores',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.plusJakartaSans(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Builder(
                      builder: (context) {
                        final storeOwner =
                            storeSettingsStorefrontsWithReviewSummaryRowList
                                .toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: storeOwner.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.0),
                          itemBuilder: (context, storeOwnerIndex) {
                            final storeOwnerItem = storeOwner[storeOwnerIndex];
                            return wrapWithModel(
                              model: _model.storefrontComponentModels.getModel(
                                storeOwnerItem.id!,
                                storeOwnerIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: StorefrontComponentWidget(
                                key: Key(
                                  'Keycv4_${storeOwnerItem.id!}',
                                ),
                                storefrontID: storeOwnerItem.id!,
                                logo: storeOwnerItem.logoUrl!,
                                name: storeOwnerItem.name!,
                                isVerified: storeOwnerItem.isVerified!,
                                discription: storeOwnerItem.description!,
                                rating: storeOwnerItem.avgRating!.toString(),
                                slug: storeOwnerItem.slug!,
                                isEdit: true,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ].addToStart(SizedBox(height: 20.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
