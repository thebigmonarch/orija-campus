import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'sell_page_model.dart';
export 'sell_page_model.dart';

/// Design a 2-step mobile Sell experience.
///
/// Step 1: Sell Page
/// Header: Sell on Orija
/// Subtitle: Choose how you want to sell
///
/// Options (2 cards only):
///
/// Create Storefront – “Set up your shop and sell regularly” (Best for
/// regular sellers)
/// Quick Sell – “Sell instantly without a shop” (Fast & simple)
///
/// Tap Create Storefront → Step 2
/// Tap Quick Sell → Instant post form
///
/// Step 2: Store Type Selection
/// Header: Choose Store Type
/// Subtitle: What kind of seller are you?
///
/// 3 selectable cards (one choice only):
///
/// Business – Full shop, products/services, order management
/// Personal – Casual selling, limited listings, personal brand
/// Declutter – Quick item clearing, simple setup (fastest)
///
/// Show “Continue” after selection.
class SellPageWidget extends StatefulWidget {
  const SellPageWidget({super.key});

  static String routeName = 'SellPage';
  static String routePath = 'sellPage';

  @override
  State<SellPageWidget> createState() => _SellPageWidgetState();
}

class _SellPageWidgetState extends State<SellPageWidget> {
  late SellPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SellPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.storeOut = await StorefrontsWithReviewSummaryTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'owner_id',
          currentUserUid,
        ),
      );
      _model.storefront =
          _model.storeOut!.toList().cast<StorefrontsWithReviewSummaryRow>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
        body: SafeArea(
          top: true,
          child: Container(
            child: custom_widgets.OrijaSellHub(),
          ),
        ),
      ),
    );
  }
}
