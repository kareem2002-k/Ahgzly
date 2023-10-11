import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ahgzly/models/PaymentResult.dart';

class PaymentPage extends StatefulWidget {
  final PaymentResult paymentResult;

  PaymentPage({required this.paymentResult});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(
          'https://accept.paymob.com/api/acceptance/iframes/793418?payment_token=${widget.paymentResult.paymentKey}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
