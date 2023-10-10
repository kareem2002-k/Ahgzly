import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  final String _apiKey;
  final String _integrationId;
  final String _currency;
  final String _paymentKey;

  PaymentService(this._apiKey, this._integrationId, this._currency, this._paymentKey);

  Future<Map<String, dynamic>> createOrder(int amount, String orderId) async {
    final url = 'https://accept.paymob.com/api/ecommerce/orders';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = {
      'auth_token': _apiKey,
      'delivery_needed': false,
      'amount_cents': amount,
      'currency': _currency,
      'merchant_order_id': orderId,
      'items': [],
      'shipping_data': {},
      'integration_id': _integrationId,
    };
    final response = await http.post(url, headers: headers, body: json.encode(body));
    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<Map<String, dynamic>> createPaymentKey(String orderId) async {
    final url = 'https://accept.paymob.com/api/acceptance/payment_keys';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = {
      'auth_token': _apiKey,
      'amount_cents': 0,
      'currency': _currency,
      'order_id': orderId,
      'billing_data': {},
      'shipping_data': {},
      'integration_id': _integrationId,
    };
    final response = await http.post(url, headers: headers, body: json.encode(body));
    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<Map<String, dynamic>> makePayment(String paymentKey, String cardNumber, String expiryMonth, String expiryYear, String cvv) async {
    final url = 'https://accept.paymob.com/api/acceptance/payments/pay';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = {
      'auth_token': _apiKey,
      'amount_cents': 0,
      'currency': _currency,
      'payment_token': paymentKey,
      'card_number': cardNumber,
      'expiration_month': expiryMonth,
      'expiration_year': expiryYear,
      'cvv': cvv,
      'billing_data': {},
      'shipping_data': {},
      'integration_id': _integrationId,
    };
    final response = await http.post(url, headers: headers, body: json.encode(body));
    final responseData = json.decode(response.body);
    return responseData;
  }
}
