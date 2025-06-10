import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ApiErrorModel.dart';

class ApiService {
  static final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  /// POST request
  static Future<dynamic> post({
    required Uri url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
    );
  }

  /// GET request
  static Future<dynamic> get({
    required Uri url,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      method: 'GET',
      url: url,
      headers: headers,
    );
  }

  /// PUT request
  static Future<dynamic> put({
    required Uri url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
    );
  }

  /// DELETE request
  static Future<dynamic> delete({
    required Uri url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      method: 'DELETE',
      url: url,
      headers: headers,
      body: body,
    );
  }

  /// Internal method to handle all HTTP verbs
  static Future<dynamic> _handleRequest({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final requestHeaders = {...defaultHeaders, if (headers != null) ...headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    print('[$method] URL: $url');
    if (encodedBody != null) print('Request Body: $encodedBody');

    late http.Response response;

    try {
      switch (method) {
        case 'POST':
          response = await http.post(url, headers: requestHeaders, body: encodedBody);
          break;
        case 'GET':
          response = await http.get(url, headers: requestHeaders);
          break;
        case 'PUT':
          response = await http.put(url, headers: requestHeaders, body: encodedBody);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: requestHeaders, body: encodedBody);
          break;
        default:
          throw 'Unsupported HTTP method: $method';
      }

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonResponse;
        case 422:
          throw ApiErrorModel.fromJson(jsonResponse).toString();
        case 400:
          final messages = jsonResponse.entries.map((e) => '${e.value}').join('\n');
          throw messages;
        default:
          throw 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Request Exception: $e');
      rethrow;
    }
  }
}
