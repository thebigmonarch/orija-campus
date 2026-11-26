import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'share_profile_popup_model.dart';
export 'share_profile_popup_model.dart';

class ShareProfilePopupWidget extends StatefulWidget {
  const ShareProfilePopupWidget({
    super.key,
    required this.fullName,
    required this.profileImage,
    required this.profileUrl,
  });

  final String? fullName;
  final String? profileImage;
  final String? profileUrl;

  @override
  State<ShareProfilePopupWidget> createState() =>
      _ShareProfilePopupWidgetState();
}

class _ShareProfilePopupWidgetState extends State<ShareProfilePopupWidget> {
  late ShareProfilePopupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShareProfilePopupModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        decoration: BoxDecoration(),
        child: Align(
          alignment: AlignmentDirectional(0.0, 1.0),
          child: Container(
            width: double.infinity,
            height: 750.0,
            child: custom_widgets.ProfileSharePopup(
              width: double.infinity,
              height: 750.0,
              fullName: widget.fullName!,
              profileImage: widget.profileImage!,
              profileUrl: widget.profileUrl!,
            ),
          ),
        ),
      ),
    );
  }
}
