import 'dart:convert';
import 'package:http/http.dart' as http;

class GetService {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> getRequest(
      String url, {
        Map<String, String>? headers,
      }) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers ?? defaultHeaders);

    _logRequest(uri.toString(), response);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final decodedBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return decodedBody;
      case 400:
        final messages = decodedBody.entries.map((e) => '${e.value}').join('\n');
        throw messages;
      default:
        throw 'GET failed with status: ${response.statusCode}';
    }
  }

  static void _logRequest(String url, http.Response response) {
    print('--- GET Request ---');
    print('URL: $url');
    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('------------------');
  }
}
