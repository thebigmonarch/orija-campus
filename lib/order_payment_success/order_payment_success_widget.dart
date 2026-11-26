import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'order_payment_success_model.dart';
export 'order_payment_success_model.dart';

class OrderPaymentSuccessWidget extends StatefulWidget {
  const OrderPaymentSuccessWidget({
    super.key,
    this.orderID,
  });

  final String? orderID;

  static String routeName = 'orderPaymentSuccess';
  static String routePath = 'orderPaymentSuccess';

  @override
  State<OrderPaymentSuccessWidget> createState() =>
      _OrderPaymentSuccessWidgetState();
}

class _OrderPaymentSuccessWidgetState extends State<OrderPaymentSuccessWidget> {
  late OrderPaymentSuccessModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderPaymentSuccessModel());

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
          widget.orderID,
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
        List<VOrderFullRow> orderPaymentSuccessVOrderFullRowList =
            snapshot.data!;

        final orderPaymentSuccessVOrderFullRow =
            orderPaymentSuccessVOrderFullRowList.isNotEmpty
                ? orderPaymentSuccessVOrderFullRowList.first
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
                child: custom_widgets.OrijaOrderPaymentSuccess(
                  orderId: widget.orderID,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
