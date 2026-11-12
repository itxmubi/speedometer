import 'package:flutter/material.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Displays the configured legal document destination in a read-only WebView.
class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({required this.title, super.key});

  final String title;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  static final _documentUri = Uri.https('www.google.com', '/');
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            final isReadOnlyRoot =
                uri != null &&
                uri.scheme == 'https' &&
                uri.host == _documentUri.host &&
                uri.path == '/' &&
                uri.query.isEmpty &&
                uri.fragment.isEmpty;
            return isReadOnlyRoot
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() {
                _isLoading = false;
                _hasLoadError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(_documentUri);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            AppLocalizations.of(context).readOnlyWebPage,
            textAlign: TextAlign.center,
          ),
        ),
        if (_isLoading) const LinearProgressIndicator(),
        if (_hasLoadError)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context).webPageLoadError,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    ),
  );
}
