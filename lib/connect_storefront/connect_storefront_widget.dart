import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'connect_storefront_model.dart';
export 'connect_storefront_model.dart';

/// Design Orija "Connect Storefront to Communities" screen.
///
/// Flutter mobile app.
///
/// Design system: bg #FFF5EE, Primary #86370E, CTA #FE6601, Tertiary #ED9E66,
///
/// Ink #2A1005, Muted #8B6553, Card white. Arial. Radius lg 12px, full 999px.
///
/// Top app bar: back arrow, title "Communities", storefront logo+name pill
/// right.
///
/// Storefront card: logo 48px, name bold, slug Muted, category pill,
/// community
/// count badge #FE6601 right.
///
/// Connected section: list rows — community cover 44px, name bold, city
/// Muted,
/// type pill (amber=Market teal=Community), disconnect icon right. If
/// removed_by_head show red "Removed" pill, row dimmed, not tappable.
///
/// Discover section: search bar full width. Filter chips scrollable — All,
/// Near
/// Me, Same Category, Markets, Free to Join. Active chip #FE6601.
///
/// Community cards: cover, name, @slug, city+state, member count, vendor
/// count,
/// category pill, is_seed gold badge, annual_fee amber badge. Join button
/// #FE6601 full-width pill. If already connected show green "Connected" pill.
class ConnectStorefrontWidget extends StatefulWidget {
  const ConnectStorefrontWidget({
    super.key,
    required this.storeID,
  });

  final String? storeID;

  static String routeName = 'ConnectStorefront';
  static String routePath = 'connectStorefront';

  @override
  State<ConnectStorefrontWidget> createState() =>
      _ConnectStorefrontWidgetState();
}

class _ConnectStorefrontWidgetState extends State<ConnectStorefrontWidget> {
  late ConnectStorefrontModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnectStorefrontModel());

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
            child: custom_widgets.OrijaConnectStorefront(
              storeId: widget.storeID,
            ),
          ),
        ),
      ),
    );
  }
}
