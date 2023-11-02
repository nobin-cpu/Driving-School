import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewS extends StatelessWidget {
  final String url;

  const WebViewS({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
