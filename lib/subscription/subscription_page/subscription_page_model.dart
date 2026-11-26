import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'subscription_page_widget.dart' show SubscriptionPageWidget;
import 'package:flutter/material.dart';

class SubscriptionPageModel extends FlutterFlowModel<SubscriptionPageWidget> {
  ///  Local state fields for this page.

  bool? startermontly = false;

  bool? tradermonthly = false;

  bool? marketbossMonthly = false;

  bool? starterYearly = false;

  bool? traderYearly1 = false;

  bool? marketbossYearly = false;

  bool? planExist = false;

  bool? isTrial = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in subscriptionPage widget.
  List<SubscriptionsRow>? subscriptionOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
