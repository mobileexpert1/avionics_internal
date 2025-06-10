import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiErrorModel.dart';

class PostService {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> postRequest(
      String url,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
      }) async {
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: headers ?? defaultHeaders,
      body: jsonEncode(body),
    );

    _logRequest(uri.toString(), body, response);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final decodedBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return decodedBody;
      case 201:
        return decodedBody['detail'] ?? "Signup success";
      case 400:
        final messages = decodedBody.entries.map((e) => '${e.value}').join('\n');
        throw messages;
      case 422:
        final error = ApiErrorModel.fromJson(decodedBody);
        throw error.toString();
      default:
        throw 'POST failed with status: ${response.statusCode}';
    }
  }

  static void _logRequest(String url, Map<String, dynamic> body, http.Response response) {
    print('--- POST Request ---');
    print('URL: $url');
    print('Request Body: ${jsonEncode(body)}');
    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('--------------------');
  }
}
