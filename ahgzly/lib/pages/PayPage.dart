import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPage extends StatefulWidget {
  final String? token;

  PayPage({Key? key, required this.token}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(
          'https://accept.paymob.com/api/acceptance/iframes/793418?payment_token=${widget.token}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
