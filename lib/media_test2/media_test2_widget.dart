import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'media_test2_model.dart';
export 'media_test2_model.dart';

class MediaTest2Widget extends StatefulWidget {
  const MediaTest2Widget({
    super.key,
    required this.imageOut,
  });

  final List<String>? imageOut;

  static String routeName = 'mediaTest2';
  static String routePath = 'mediaTest2';

  @override
  State<MediaTest2Widget> createState() => _MediaTest2WidgetState();
}

class _MediaTest2WidgetState extends State<MediaTest2Widget> {
  late MediaTest2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MediaTest2Model());

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
          child: Builder(
            builder: (context) {
              final imageOut = widget.imageOut!.toList();

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(imageOut.length, (imageOutIndex) {
                    final imageOutItem = imageOut[imageOutIndex];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        valueOrDefault<String>(
                          imageOutItem,
                          'https://picsum.photos/seed/327/600',
                        ),
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
