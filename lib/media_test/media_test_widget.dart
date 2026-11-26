import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'media_test_model.dart';
export 'media_test_model.dart';

class MediaTestWidget extends StatefulWidget {
  const MediaTestWidget({super.key});

  static String routeName = 'MediaTest';
  static String routePath = 'mediaTest';

  @override
  State<MediaTestWidget> createState() => _MediaTestWidgetState();
}

class _MediaTestWidgetState extends State<MediaTestWidget> {
  late MediaTestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MediaTestModel());

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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    final selectedMedia = await selectMedia(
                      mediaSource: MediaSource.photoGallery,
                      multiImage: true,
                    );
                    if (selectedMedia != null &&
                        selectedMedia.every((m) =>
                            validateFileFormat(m.storagePath, context))) {
                      safeSetState(
                          () => _model.isDataUploading_uploadDataDnp = true);
                      var selectedUploadedFiles = <FFUploadedFile>[];

                      try {
                        showUploadMessage(
                          context,
                          'Uploading file...',
                          showLoading: true,
                        );
                        selectedUploadedFiles = selectedMedia
                            .map((m) => FFUploadedFile(
                                  name: m.storagePath.split('/').last,
                                  bytes: m.bytes,
                                  height: m.dimensions?.height,
                                  width: m.dimensions?.width,
                                  blurHash: m.blurHash,
                                  originalFilename: m.originalFilename,
                                ))
                            .toList();
                      } finally {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        _model.isDataUploading_uploadDataDnp = false;
                      }
                      if (selectedUploadedFiles.length ==
                          selectedMedia.length) {
                        safeSetState(() {
                          _model.uploadedLocalFiles_uploadDataDnp =
                              selectedUploadedFiles;
                        });
                        showUploadMessage(context, 'Success!');
                      } else {
                        safeSetState(() {});
                        showUploadMessage(context, 'Failed to upload data');
                        return;
                      }
                    }

                    _model.mediaUrl = _model.uploadedLocalFiles_uploadDataDnp
                        .toList()
                        .cast<FFUploadedFile>();
                    _model.isMultiple =
                        _model.mediaUrl.length > 1 ? true : false;
                    _model.isVideo = false;
                    safeSetState(() {});
                    _model.mediaOut = await actions.pickUploadCloudinaryMedia(
                      _model.mediaUrl.toList(),
                      _model.urls.toList(),
                      _model.isMultiple!,
                      'post_media',
                      2160,
                      84,
                      80,
                    );

                    safeSetState(() {});
                  },
                  text: 'Test Pictures',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    final selectedMedia =
                        await selectMediaWithSourceBottomSheet(
                      context: context,
                      allowPhoto: false,
                      allowVideo: true,
                    );
                    if (selectedMedia != null &&
                        selectedMedia.every((m) =>
                            validateFileFormat(m.storagePath, context))) {
                      safeSetState(
                          () => _model.isDataUploading_uploadDataVideo = true);
                      var selectedUploadedFiles = <FFUploadedFile>[];

                      try {
                        showUploadMessage(
                          context,
                          'Uploading file...',
                          showLoading: true,
                        );
                        selectedUploadedFiles = selectedMedia
                            .map((m) => FFUploadedFile(
                                  name: m.storagePath.split('/').last,
                                  bytes: m.bytes,
                                  height: m.dimensions?.height,
                                  width: m.dimensions?.width,
                                  blurHash: m.blurHash,
                                  originalFilename: m.originalFilename,
                                ))
                            .toList();
                      } finally {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        _model.isDataUploading_uploadDataVideo = false;
                      }
                      if (selectedUploadedFiles.length ==
                          selectedMedia.length) {
                        safeSetState(() {
                          _model.uploadedLocalFile_uploadDataVideo =
                              selectedUploadedFiles.first;
                        });
                        showUploadMessage(context, 'Success!');
                      } else {
                        safeSetState(() {});
                        showUploadMessage(context, 'Failed to upload data');
                        return;
                      }
                    }

                    _model.addToMediaUrl(
                        _model.uploadedLocalFile_uploadDataVideo);
                    _model.isMultiple =
                        _model.mediaUrl.length > 1 ? true : false;
                    _model.isVideo = true;
                    safeSetState(() {});
                    _model.mediaOut2 = await actions.pickUploadCloudinaryMedia(
                      _model.mediaUrl.toList(),
                      _model.urls.toList(),
                      _model.isMultiple!,
                      'post_media',
                      2160,
                      84,
                      80,
                    );

                    safeSetState(() {});
                  },
                  text: 'Test Video',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                if (_model.mediaUrl.isNotEmpty)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: custom_widgets.AdvancedMediaEditorWidgetV2(
                        width: double.infinity,
                        height: double.infinity,
                        mediaUrls: _model.isVideo!
                            ? (getJsonField(
                                _model.mediaOut2,
                                r'''$.optimizedUrls''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>()
                            : (getJsonField(
                                _model.mediaOut,
                                r'''$.optimizedUrls''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>(),
                        thumbnailUrls: _model.isVideo!
                            ? (getJsonField(
                                _model.mediaOut2,
                                r'''$.thumbnailUrls''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>()
                            : (getJsonField(
                                _model.mediaOut,
                                r'''$.thumbnailUrls''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>(),
                        mediaTypes: _model.isVideo!
                            ? (getJsonField(
                                _model.mediaOut2,
                                r'''$.mediaTypes''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>()
                            : (getJsonField(
                                _model.mediaOut,
                                r'''$.mediaTypes''',
                                true,
                              ) as List?)
                                ?.map<String>((e) => e.toString())
                                .toList()
                                .cast<String>(),
                        aspectRatios: _model.isVideo!
                            ? (getJsonField(
                                _model.mediaOut2,
                                r'''$.aspectRatios''',
                                true,
                              ) as List?)
                                ?.cast<double>()
                            : (getJsonField(
                                _model.mediaOut,
                                r'''$.aspectRatios''',
                                true,
                              ) as List?)
                                ?.cast<double>(),
                        durations: _model.isVideo!
                            ? (getJsonField(
                                _model.mediaOut2,
                                r'''$.durations''',
                                true,
                              ) as List?)
                                ?.cast<int>()
                            : (getJsonField(
                                _model.mediaOut,
                                r'''$.durations''',
                                true,
                              ) as List?)
                                ?.cast<int>(),
                        uploadedFiles: _model.mediaUrl,
                        uploadContext: 'post_media',
                        maxImageSide: 2160,
                        imageQuality: 84,
                        maxVideoMb: 80,
                        onExport: (editPlan, quality) async {
                          _model.exportOut =
                              await actions.exportEditedMediaToCloudinary(
                            editPlan.toList(),
                            _model.inputPath.toList(),
                            _model.urls.toList(),
                            'post_media',
                            '1080p',
                          );

                          safeSetState(() {});
                        },
                        onClose: () async {
                          context.pushNamed(
                            MediaTest2Widget.routeName,
                            queryParameters: {
                              'imageOut': serializeParam(
                                (getJsonField(
                                  _model.exportOut,
                                  r'''$.finalCloudinaryUrls''',
                                  true,
                                ) as List?)
                                    ?.map<String>((e) => e.toString())
                                    .toList()
                                    .cast<String>(),
                                ParamType.String,
                                isList: true,
                              ),
                            }.withoutNulls,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
