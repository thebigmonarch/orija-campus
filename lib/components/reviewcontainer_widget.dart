import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'reviewcontainer_model.dart';
export 'reviewcontainer_model.dart';

class ReviewcontainerWidget extends StatefulWidget {
  const ReviewcontainerWidget({
    super.key,
    this.parameter1,
    this.parameter2,
    this.parameter3,
    this.parameter4,
    this.parameter5,
  });

  final String? parameter1;
  final String? parameter2;
  final String? parameter3;
  final int? parameter4;
  final String? parameter5;

  @override
  State<ReviewcontainerWidget> createState() => _ReviewcontainerWidgetState();
}

class _ReviewcontainerWidgetState extends State<ReviewcontainerWidget> {
  late ReviewcontainerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewcontainerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: custom_widgets.OrijaReviewCard(
        avatarUrl: widget.parameter1,
        comment: widget.parameter5,
        createdAt: widget.parameter3,
        overallRating: widget.parameter4,
        reviewerName: widget.parameter2,
        reviewId: '',
        vendorReply: '',
        isOwner: false,
      ),
    );
  }
}
