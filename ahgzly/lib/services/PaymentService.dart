import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ahgzly/models/AuthenticationResponse.dart';
import 'package:ahgzly/models/PaymentResult.dart';

class PaymentService {
  final Dio dio = Dio();
  final String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RJd016VTRMQ0p1WVcxbElqb2lNVFk1TnpJeE5qUTNNaTQ1TkRZek1EWWlmUS5CRlpKZHhJOWZvbjJWNGpycVMwT3QzbHdwaE5kYkh4eDZ4a2twTnJaV3pUNXM3WnFDanRmTzYzR1Ixdk52ZldrRFkxbFRtM0dVS3k2Z1JramEzSlpXZw==';

  Future<AuthenticationResponse> authenticate() async {
    try {
      final response = await dio.post(
          'https://accept.paymob.com/api/auth/tokens',
          data: {"api_key": apiKey});

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String;

        if (token == null) {
          throw Exception('Token not found in the response');
        }

        return AuthenticationResponse(token: token);
      } else {
        throw Exception(
            'Failed to authenticate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during authentication: $e');
    }
  }

  Future<PaymentResult> createOrder({
    required String amountCents,
    String currency = 'EGP',
  }) async {
    try {
      final validatetok = await authenticate();
      final token = validatetok.token;

      final body = {
        "auth_token": token,
        "delivery_needed": "false",
        "amount_cents": amountCents,
        "currency": currency,
        "items": [],
      };

      final response = await dio.post(
        'https://accept.paymob.com/api/ecommerce/orders',
        data: body,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final order = data['id'].toString();

        return PaymentResult(
            success: true, token: token, orderId: order, paymentKey: null);
      } else {
        throw Exception(
            'Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during order creation: $e');
    }
  }

  Future<PaymentResult> createPaymentKey({
    required String amount,
    required Map<String, dynamic> billingData,
  }) async {
    try {
      final resultOfOrder = await createOrder(
        amountCents: (double.parse(amount) * 100).toString(),
      );
      final token = resultOfOrder.token;
      final orderId = resultOfOrder.orderId;

      final paymentKeyData = {
        "auth_token": token!,
        "amount_cents": (double.parse(amount) * 100).toString(),
        "expiration": 36000,
        "order_id": orderId!,
        "billing_data": billingData,
        "currency": "EGP",
        "integration_id": 4271664,
        "lock_order_when_paid": "true",
      };

      final response = await dio.post(
          'https://accept.paymob.com/api/acceptance/payment_keys',
          data: paymentKeyData);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final paymentKey = data['token'].toString();

        return PaymentResult(
          success: true,
          token: token,
          orderId: orderId,
          paymentKey: paymentKey,
        );
      } else {
        throw Exception(
            'Failed to create payment key. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during payment key creation: $e');
    }
  }
}
