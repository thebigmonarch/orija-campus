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

import 'package:webview_flutter/webview_flutter.dart';

class PaystackWebView extends StatefulWidget {
  const PaystackWebView({
    super.key,
    this.width,
    this.height,
    required this.authorizationUrl,
    required this.referencee,
    required this.callbackUrl,
    this.onPaymentSuccess,
    this.onPaymentCancelled,
  });

  final double? width;
  final double? height;

  /// The authorization_url returned by your Supabase edge function
  final String authorizationUrl;

  /// The referencee string returned by your Supabase edge function
  final String referencee;

  /// The callback_url you passed to the edge function
  /// WebView watches for navigation to this URL to detect completion
  final String callbackUrl;

  /// Fires with the referencee when payment completes (callback URL hit)
  final Future<dynamic> Function(String referencee)? onPaymentSuccess;

  /// Fires when the user manually closes the WebView without completing
  final Future<dynamic> Function()? onPaymentCancelled;

  @override
  State<PaystackWebView> createState() => _PaystackWebViewState();
}

class _PaystackWebViewState extends State<PaystackWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // ── Detect callback URL ────────────────────────────────────────
            // Paystack appends ?trxref=...&referencee=... to your callback URL
            if (url.startsWith(widget.callbackUrl)) {
              _completed = true;

              // Extract referencee from URL params if present
              final uri = Uri.tryParse(url);
              final ref = uri?.queryParameters['referencee'] ??
                  uri?.queryParameters['trxref'] ??
                  widget.referencee;

              widget.onPaymentSuccess?.call(ref);

              // Close the WebView
              if (mounted) {
                Navigator.of(context)
                    .pop({'status': 'success', 'referencee': ref});
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  void _handleClose() {
    if (!_completed) {
      widget.onPaymentCancelled?.call();
    }
    Navigator.of(context)
        .pop({'status': 'cancelled', 'referencee': widget.referencee});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      // ── FIX: Replaced nested Scaffold (which caused the crash) with a
      //         plain Column + custom header row. A Scaffold inside another
      //         Scaffold's widget tree breaks Flutter's Navigator/context
      //         resolution and triggers a fatal layout error.
      child: Column(
        children: [
          // ── Custom AppBar replacement ──────────────────────────────────
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Close button (left)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.black87),
                            onPressed: _handleClose,
                          ),
                        ),
                        // Title (center)
                        const Text(
                          'Secure Payment',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress bar
                  if (_isLoading)
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF0BA4DB), // Paystack blue
                      minHeight: 3,
                    )
                  else
                    const Divider(height: 1, thickness: 0.5),
                ],
              ),
            ),
          ),
          // ── WebView ───────────────────────────────────────────────────
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
