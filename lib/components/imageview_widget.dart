import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'imageview_model.dart';
export 'imageview_model.dart';

class ImageviewWidget extends StatefulWidget {
  const ImageviewWidget({
    super.key,
    required this.medialist,
  });

  final List<String>? medialist;

  @override
  State<ImageviewWidget> createState() => _ImageviewWidgetState();
}

class _ImageviewWidgetState extends State<ImageviewWidget> {
  late ImageviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImageviewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final imageList = widget.medialist!.map((e) => e).toList();

        return Container(
          width: double.infinity,
          height: 350.0,
          child: Stack(
            children: [
              PageView.builder(
                controller: _model.pageViewController ??= PageController(
                    initialPage: max(0, min(0, imageList.length - 1))),
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (context, imageListIndex) {
                  final imageListItem = imageList[imageListIndex];
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: custom_widgets.SocialMediaMediaPlayer(
                      width: double.infinity,
                      height: double.infinity,
                      mediaUrl: imageListItem,
                      autoPlay: true,
                      showMuteButton: true,
                      initialMute: true,
                      loopVideo: true,
                      enableZoomForImages: false,
                    ),
                  );
                },
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  child: smooth_page_indicator.SmoothPageIndicator(
                    controller: _model.pageViewController ??= PageController(
                        initialPage: max(0, min(0, imageList.length - 1))),
                    count: imageList.length,
                    axisDirection: Axis.horizontal,
                    onDotClicked: (i) async {
                      await _model.pageViewController!.animateToPage(
                        i,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                      safeSetState(() {});
                    },
                    effect: smooth_page_indicator.ExpandingDotsEffect(
                      expansionFactor: 2.0,
                      spacing: 8.0,
                      radius: 8.0,
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      dotColor: FlutterFlowTheme.of(context).tertiary,
                      activeDotColor: FlutterFlowTheme.of(context).primary,
                      paintStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
