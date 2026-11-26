import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/feed_slide_compoonet_widget.dart';
import '/emptystate/feed_empty_state/feed_empty_state_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'oja_feed_model.dart';
export 'oja_feed_model.dart';

class OjaFeedWidget extends StatefulWidget {
  const OjaFeedWidget({
    super.key,
    this.parameter1,
    this.parameter2,
    this.parameter3,
    this.parameter4,
    this.parameter5,
  });

  final ReelFeedStruct? parameter1;
  final int? parameter2;
  final int? parameter3;
  final ReelFeedStruct? parameter4;
  final int? parameter5;

  @override
  State<OjaFeedWidget> createState() => _OjaFeedWidgetState();
}

class _OjaFeedWidgetState extends State<OjaFeedWidget> {
  late OjaFeedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OjaFeedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: GetReelFeedCall.call(
        userID: currentUserUid,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return FeedEmptyStateWidget();
        }
        final pageViewGetReelFeedResponse = snapshot.data!;

        return Builder(
          builder: (context) {
            final feed = (pageViewGetReelFeedResponse.jsonBody
                        .toList()
                        .map<ReelFeedStruct?>(ReelFeedStruct.maybeFromMap)
                        .toList() as Iterable<ReelFeedStruct?>)
                    .withoutNulls
                    .toList() ??
                [];

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                child: PageView.builder(
                  key: ValueKey(feed.length.toString()),
                  controller: _model.pageViewController ??= PageController(
                      initialPage: max(0, min(0, feed.length - 1))),
                  scrollDirection: Axis.vertical,
                  itemCount: feed.length,
                  itemBuilder: (context, feedIndex) {
                    final feedItem = feed[feedIndex];
                    return Container(
                      key: ValueKey(feedItem.slidePosition.toString()),
                      child: wrapWithModel(
                        model: _model.feedSlideCompoonetModels.getModel(
                          feedIndex.toString(),
                          feedIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: FeedSlideCompoonetWidget(
                          key: Key(
                            'Keyral_${feedIndex.toString()}',
                          ),
                          feedData: feedItem,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
