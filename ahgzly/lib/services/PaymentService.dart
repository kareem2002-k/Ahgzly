import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ahgzly/models/AuthenticationResponse.dart';
import 'package:ahgzly/models/PaymentResult.dart';

class PaymentService {
  // ignore: constant_identifier_names
  static const String api_key =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RJd016VTRMQ0p1WVcxbElqb2lNVFk1TnpBME5UYzBOeTQwTVRrM055SjkuZWZEa2VTTVlZSEZyQjRGZjc2SDBNN0FsY05KRVQ3aWxfVWUyXzBHY21ncUdFaG5jRmVHUHhGMm5iQk5SdXBvcTEwUmgyNWtBd1JrMG1tOXduMG9VaVE=';
  static const String baseUrl = 'https://accept.paymob.com/api';

  Future<AuthenticationResponse> authenticate() async {
    try {
      final url = Uri.parse('$baseUrl/auth/tokens');
      final body = json.encode({
        'api_key': api_key,
      });

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] as String;
        // ignore: unnecessary_null_comparison
        if (token != null) {
          return AuthenticationResponse(token: token);
        } else {
          throw Exception('Token not found in the response');
        }
      } else {
        throw Exception(
            'Failed to authenticate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during authentication: $e');
    }
  }

  Future<PaymentResult> createOrder({required String amount}) async {
    try {
      final validatetok = await authenticate();
      final token = validatetok.token;
      final url = Uri.parse('$baseUrl/ecommerce/orders');
      final body = json.encode({
        "auth_token": token,
        "delivery_needed": "false",
        "amount_cents": "100",
        "currency": "EGP",
        "merchant_order_id": 5,
        "items": [],
        "shipping_data": {
          "apartment": "803",
          "email": "claudette09@exa.com",
          "floor": "42",
          "first_name": "Clifford",
          "street": "Ethan Land",
          "building": "8028",
          "phone_number": "+86(8)9135210487",
          "postal_code": "01898",
          "extra_description": "8 Ram , 128 Giga",
          "city": "Jaskolskiburgh",
          "country": "CR",
          "last_name": "Nicolas",
          "state": "Utah"
        },
        "shipping_details": {
          "notes": " test",
          "number_of_packages": 1,
          "weight": 1,
          "weight_unit": "Kilogram",
          "length": 1,
          "width": 1,
          "height": 1,
          "contents": "product of some sorts"
        }
      });

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final order = data['id'];
        return PaymentResult(
          success: true,
          token: token,
          orderId: order,
        );
      } else {
        throw Exception(
            'Failed to authenticate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during authentication: $e');
    }
  }
}
