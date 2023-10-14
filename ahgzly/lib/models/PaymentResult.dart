class PaymentResult {
  final bool? success;
  final String? token;
  final String? orderId;
  String? paymentKey;

  PaymentResult({this.success, this.token, this.orderId, this.paymentKey});
}
