import '/components/decorative_particle_widget.dart';
import '/components/floating_market_icon_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'storefront_empty_state_widget.dart' show StorefrontEmptyStateWidget;
import 'package:flutter/material.dart';

class StorefrontEmptyStateModel
    extends FlutterFlowModel<StorefrontEmptyStateWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for DecorativeParticle.
  late DecorativeParticleModel decorativeParticleModel1;
  // Model for DecorativeParticle.
  late DecorativeParticleModel decorativeParticleModel2;
  // Model for DecorativeParticle.
  late DecorativeParticleModel decorativeParticleModel3;
  // Model for FloatingMarketIcon.
  late FloatingMarketIconModel floatingMarketIconModel1;
  // Model for FloatingMarketIcon.
  late FloatingMarketIconModel floatingMarketIconModel2;
  // Model for FloatingMarketIcon.
  late FloatingMarketIconModel floatingMarketIconModel3;

  @override
  void initState(BuildContext context) {
    decorativeParticleModel1 =
        createModel(context, () => DecorativeParticleModel());
    decorativeParticleModel2 =
        createModel(context, () => DecorativeParticleModel());
    decorativeParticleModel3 =
        createModel(context, () => DecorativeParticleModel());
    floatingMarketIconModel1 =
        createModel(context, () => FloatingMarketIconModel());
    floatingMarketIconModel2 =
        createModel(context, () => FloatingMarketIconModel());
    floatingMarketIconModel3 =
        createModel(context, () => FloatingMarketIconModel());
  }

  @override
  void dispose() {
    decorativeParticleModel1.dispose();
    decorativeParticleModel2.dispose();
    decorativeParticleModel3.dispose();
    floatingMarketIconModel1.dispose();
    floatingMarketIconModel2.dispose();
    floatingMarketIconModel3.dispose();
  }
}
