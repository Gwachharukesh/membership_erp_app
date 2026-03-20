import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../bloc/checkout_bloc.dart';
import '../state/checkout_state.dart';
import '../utils/payment_config.dart';

/// Full-screen WebView that loads the self-submitting gateway form.
///
/// Monitors URL changes and intercepts the response URL to trigger
/// transaction status verification via [CheckoutBloc.onGatewayCallback].
class GatewayWebViewScreen extends StatefulWidget {
  final String htmlContent;
  final String merchantTxnId;
  final CheckoutBloc bloc;

  const GatewayWebViewScreen({
    super.key,
    required this.htmlContent,
    required this.merchantTxnId,
    required this.bloc,
  });

  @override
  State<GatewayWebViewScreen> createState() => _GatewayWebViewScreenState();
}

class _GatewayWebViewScreenState extends State<GatewayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _callbackHandled = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A1F42))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: _onNavigationRequest,
          onWebResourceError: (e) =>
              debugPrint('[NPS WebView] Error: ${e.description}'),
        ),
      )
      ..loadHtmlString(widget.htmlContent);
  }

  NavigationDecision _onNavigationRequest(NavigationRequest req) {
    if (_callbackHandled) return NavigationDecision.prevent;

    final url = req.url;

    if (url.startsWith(PaymentConfig.responseUrlPrefix)) {
      _callbackHandled = true;
      final uri = Uri.tryParse(url);

      final merchantTxnId =
          uri?.queryParameters['MerchantTxnId'] ?? widget.merchantTxnId;

      widget.bloc.add(OnGatewayCallbackEvent(merchantTxnId: merchantTxnId));

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<bool> _onBackPressed() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Payment?'),
        content: const Text(
          'Are you sure? Your transaction will not be completed if you leave now.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pop();
            },
            child: const Text('Cancel Payment'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutBloc>.value(
      value: widget.bloc,
      child: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state.loadingStatus) {
            setState(() => _isLoading = true);
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final should = await _onBackPressed();
            if (should && context.mounted) Navigator.of(context).pop();
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF0A1F42),
            appBar: AppBar(
              backgroundColor: const Color(0xFF071628),
              foregroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Cancel',
                onPressed: _confirmCancel,
              ),
              title: const Row(
                children: [
                  _LockChip(),
                  SizedBox(width: 8),
                  Text(
                    'Secure Payment',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading) const _LoadingOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LockChip extends StatelessWidget {
  const _LockChip();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.green.shade600,
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Icon(Icons.lock, size: 11, color: Colors.white),
  );
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF0A1F42),
    child: const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          SizedBox(height: 16),
          Text(
            'Connecting to gateway…',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
