import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'menu_cat_model.dart';
export 'menu_cat_model.dart';

class MenuCatWidget extends StatefulWidget {
  const MenuCatWidget({super.key});

  @override
  State<MenuCatWidget> createState() => _MenuCatWidgetState();
}

class _MenuCatWidgetState extends State<MenuCatWidget> {
  late MenuCatModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuCatModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.8,
      ),
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Container(
          width: 50.0,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 30.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
        Container(
          width: 50.0,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 30.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
        Container(
          width: 50.0,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 30.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel6,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
        Container(
          width: 50.0,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 30.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel8,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
        Container(
          width: 50.0,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel9,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  width: 30.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel10,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ],
    );
  }
}
