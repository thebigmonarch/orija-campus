// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PaystackCheckoutWidget extends StatelessWidget {
  const PaystackCheckoutWidget({
    super.key,
    this.width,
    this.height,
    required this.checkoutUrl,
  });

  final double? width;
  final double? height;
  final String? checkoutUrl;

  static const _marker = '#ff_access=';

  static String _hostedUrlOf(String? raw) {
    final value = raw ?? '';
    final i = value.indexOf(_marker);
    return i == -1 ? value : value.substring(0, i);
  }

  static String? _accessCodeOf(String? raw) {
    final value = raw ?? '';
    final i = value.indexOf(_marker);
    return i == -1 ? null : value.substring(i + _marker.length);
  }

  String _inlineJsHtml(String accessCode) {
    final safeCode = accessCode.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
    return """
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://js.paystack.co/v2/inline.js"></script>
    <style>
      html, body { margin: 0; height: 100%; background: #ffffff; }
      #msg {
        font-family: -apple-system, Roboto, Arial, sans-serif;
        padding: 32px 24px;
        text-align: center;
        color: #666666;
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <div id="msg">Loading secure checkout&hellip;</div>
    <script>
      try {
        var popup = new PaystackPop();
        popup.resumeTransaction("$safeCode", {
          onSuccess: function () {
            document.getElementById("msg").innerText =
              "Payment received \\u2014 confirming your order\\u2026";
          },
          onCancel: function () {
            document.getElementById("msg").innerText =
              "Payment cancelled. You can close this window.";
          }
        });
      } catch (e) {
        document.getElementById("msg").innerText =
          "Could not load the payment form. Please try again.";
      }
    </script>
  </body>
</html>
""";
  }

  Widget _errorPane(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.error, fontSize: 14),
          ),
        ),
      ),
    );
  }

  // Uses webviewx_plus directly (the package FlutterFlowWebView wraps).
  // FlutterFlow only emits flutter_flow_web_view.dart while some page in the
  // project uses a WebView widget, so importing that file from custom code
  // breaks the build as soon as the last such page is gone.
  Widget _webView(BuildContext context, String content, {required bool html}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = MediaQuery.sizeOf(context);
        final w = width ??
            (constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : screen.width);
        final h = height ??
            (constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : screen.height -
                    kToolbarHeight -
                    MediaQuery.paddingOf(context).top);
        return WebViewX(
          key: ValueKey(content),
          width: w,
          height: h,
          initialContent: content,
          initialSourceType: html ? SourceType.html : SourceType.url,
          javascriptMode: JavascriptMode.unrestricted,
          webSpecificParams:
              const WebSpecificParams(webAllowFullscreenContent: true),
          mobileSpecificParams: MobileSpecificParams(
            debuggingEnabled: false,
            gestureNavigationEnabled: true,
            androidEnableHybridComposition: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final accessCode = _accessCodeOf(checkoutUrl);
      if (accessCode == null || accessCode.isEmpty) {
        return _errorPane(
            context, 'Payment link was not returned. Please try again.');
      }
      return _webView(context, _inlineJsHtml(accessCode), html: true);
    }

    final hostedUrl = _hostedUrlOf(checkoutUrl);
    if (hostedUrl.isEmpty) {
      return _errorPane(
          context, 'Payment link was not returned. Please try again.');
    }
    return _webView(context, hostedUrl, html: false);
  }
}
