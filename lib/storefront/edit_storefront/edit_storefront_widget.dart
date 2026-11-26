import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'edit_storefront_model.dart';
export 'edit_storefront_model.dart';

class EditStorefrontWidget extends StatefulWidget {
  const EditStorefrontWidget({
    super.key,
    required this.storefrontID,
  });

  final String? storefrontID;

  static String routeName = 'editStorefront';
  static String routePath = 'editStorefront';

  @override
  State<EditStorefrontWidget> createState() => _EditStorefrontWidgetState();
}

class _EditStorefrontWidgetState extends State<EditStorefrontWidget> {
  late EditStorefrontModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditStorefrontModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StorefrontsRow>>(
      future: StorefrontsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.storefrontID,
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
        List<StorefrontsRow> editStorefrontStorefrontsRowList = snapshot.data!;

        final editStorefrontStorefrontsRow =
            editStorefrontStorefrontsRowList.isNotEmpty
                ? editStorefrontStorefrontsRowList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Container(
                child: custom_widgets.OrijaEditStorefront(
                  storefrontId: widget.storefrontID,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
