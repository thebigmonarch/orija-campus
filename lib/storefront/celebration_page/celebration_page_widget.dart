import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'celebration_page_model.dart';
export 'celebration_page_model.dart';

/// Orija mobile app (Flutter).
///
/// Design system: background Surface #FFF5EE, Primary #86370E, Secondary/CTA
/// #FE6601, Tertiary #ED9E66, Ink text #2A1005, Muted #8B6553, Card white.
/// Font: Arial. Nav bar 56 px, top app bar 56 px. Radius tokens: sm 4 px, md
/// 8 px, lg 12 px, xl 16 px, 2xl 24 px, full 999 px. Brand feel: warm,
/// vibrant, trusted Nigerian market. Storefront Celebration screen. Full
/// screen. Background: deep gradient Primary #86370E to Mid #4A1E08. No nav
/// bar. Animated confetti particles in Secondary #FE6601 and Tertiary #ED9E66
/// falling from top. Centre: white circle 80 px with store logo inside.
/// Below: 'Adaeze Luxury Fabrics is live!' Arial Black 28 pt white. 'Your
/// store is now visible to buyers.' body white 15 pt. Three horizontal chips
/// below: 'Add products', 'Join a community', 'Share your store' — white
/// outlined pill chips. Bottom: 'Go to my store' white outlined 48 px button.
/// Celebration energy, premium.
class CelebrationPageWidget extends StatefulWidget {
  const CelebrationPageWidget({
    super.key,
    required this.storefrontID,
    required this.storename,
  });

  final String? storefrontID;
  final String? storename;

  static String routeName = 'celebrationPage';
  static String routePath = 'celebrationPage';

  @override
  State<CelebrationPageWidget> createState() => _CelebrationPageWidgetState();
}

class _CelebrationPageWidgetState extends State<CelebrationPageWidget> {
  late CelebrationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CelebrationPageModel());

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
            backgroundColor: Color(0xFF86370E),
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
        List<StorefrontsRow> celebrationPageStorefrontsRowList = snapshot.data!;

        final celebrationPageStorefrontsRow =
            celebrationPageStorefrontsRowList.isNotEmpty
                ? celebrationPageStorefrontsRowList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFF86370E),
            body: Container(
              child: custom_widgets.OrijaCelebration(
                storefrontId: widget.storefrontID,
                storename: widget.storename,
              ),
            ),
          ),
        );
      },
    );
  }
}
