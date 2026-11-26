import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'paystack_paymenent_model.dart';
export 'paystack_paymenent_model.dart';

class PaystackPaymenentWidget extends StatefulWidget {
  const PaystackPaymenentWidget({
    super.key,
    required this.authorizationUrl,
    required this.orderID,
  });

  final String? authorizationUrl;
  final String? orderID;

  static String routeName = 'paystackPaymenent';
  static String routePath = 'paystack';

  @override
  State<PaystackPaymenentWidget> createState() =>
      _PaystackPaymenentWidgetState();
}

class _PaystackPaymenentWidgetState extends State<PaystackPaymenentWidget> {
  late PaystackPaymenentModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaystackPaymenentModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          await actions.subscribeToOrderPayment(
            widget.orderID!,
            () async {
              context.pushNamed(
                OrderPaymentSuccessWidget.routeName,
                queryParameters: {
                  'orderID': serializeParam(
                    widget.orderID,
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            },
            () async {
              context.pushNamed(OrderPaymentFailureWidget.routeName);
            },
          );
        }),
        Future(() async {
          await actions.pollOrderPaymentStatus(
            widget.orderID!,
            () async {},
            4,
          );
        }),
      ]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      await actions.unsubscribeFromOrder();
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Payment\n',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
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
          child: Container(
            child: custom_widgets.PaystackCheckoutWidget(
              checkoutUrl: widget.authorizationUrl,
            ),
          ),
        ),
      ),
    );
  }
}
