import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'orija_asset_anchor_model.dart';
export 'orija_asset_anchor_model.dart';

/// Not shown anywhere.
///
/// Lists images used by custom code so FlutterFlow bundles them into the app.
class OrijaAssetAnchorWidget extends StatefulWidget {
  const OrijaAssetAnchorWidget({super.key});

  @override
  State<OrijaAssetAnchorWidget> createState() => _OrijaAssetAnchorWidgetState();
}

class _OrijaAssetAnchorWidgetState extends State<OrijaAssetAnchorWidget> {
  late OrijaAssetAnchorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaAssetAnchorModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
      crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_bag_checkout.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_bag_lives_chat.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_bag_review.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_bag_sent_waiting.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_delivery_confirm.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_item_unavailable.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_offer_accepted.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_offer_declined.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_order_success.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_payment_received.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_price_offer.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_rate_order.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/orija_share_template.webp',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/OrijaLogo2.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/OrijaLogoLightMode.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/Orija_Logo3.png',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(
            'assets/images/aerial-view-of-a-vibrant-west-african-open-air-mar_(1).jpeg',
            width: 1.0,
            height: 1.0,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
