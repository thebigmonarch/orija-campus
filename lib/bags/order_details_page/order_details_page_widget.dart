import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'order_details_page_model.dart';
export 'order_details_page_model.dart';

/// Orija mobile app (Flutter) UI using a warm Nigerian market design system:
/// Surface #FFF5EE, Primary #86370E, CTA #FE6601, Ink #2A1005, Muted #8B6553,
/// white cards, Arial font, rounded radii.
///
/// Order Detail screen (buyer view) with 56px app bar (back, “Order
/// ORD2F3A9B”, share). Scrollable layout, 20px padding, 16px gaps.
///
/// Sections:
///
/// Status card with large status chip, 4-step delivery stepper, carrier +
/// tracking. If rates_ready, show CTA card: “Select your carrier” + button.
/// Items card: list of items (image, title, variant, qty, price).
/// Price card: subtotal, shipping, buyer fee, total (highlighted).
/// Delivery address: full address + phone.
/// Storefront: logo, name, “View storefront”, message icon.
class OrderDetailsPageWidget extends StatefulWidget {
  const OrderDetailsPageWidget({
    super.key,
    this.orderId,
  });

  final String? orderId;

  static String routeName = 'orderDetailsPage';
  static String routePath = 'orderDetailsPage';

  @override
  State<OrderDetailsPageWidget> createState() => _OrderDetailsPageWidgetState();
}

class _OrderDetailsPageWidgetState extends State<OrderDetailsPageWidget> {
  late OrderDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VOrderFullRow>>(
      future: VOrderFullTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'order_id',
          widget.orderId,
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
        List<VOrderFullRow> orderDetailsPageVOrderFullRowList = snapshot.data!;

        final orderDetailsPageVOrderFullRow =
            orderDetailsPageVOrderFullRowList.isNotEmpty
                ? orderDetailsPageVOrderFullRowList.first
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
                child: custom_widgets.OrijaOrderDetails(
                  orderId: widget.orderId,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
