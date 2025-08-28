import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiErrorModel.dart';
import 'SessionTokenClass/refresh_accessRepository.dart';

class ApiService {

  static final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // POST
  static Future<dynamic> post({
    required Uri url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
    bool retry = true,
  }) {
    return _handleRequest(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
      retry: retry,
      onUnauthorized: onUnauthorized,
    );
  }

  // GET
  static Future<dynamic> get({
    required Uri url,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
  }) {
    return _handleRequest(
      method: 'GET',
      url: url,
      headers: headers,
      retry: true,
      onUnauthorized: onUnauthorized,
    );
  }

  // PUT
  static Future<dynamic> put({
    required Uri url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
  }) {
    return _handleRequest(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
      retry: true,
      onUnauthorized: onUnauthorized,
    );
  }

  // PATCH
  static Future<dynamic> patch({
    required Uri url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
  }) {
    return _handleRequest(
      method: 'PATCH',
      url: url,
      headers: headers,
      body: body,
      retry: true,
      onUnauthorized: onUnauthorized,
    );
  }

  // DELETE
  static Future<dynamic> delete({
    required Uri url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
  }) {
    return _handleRequest(
      method: 'DELETE',
      url: url,
      headers: headers,
      body: body,
      retry: true,
      onUnauthorized: onUnauthorized,
    );
  }

  // Get bearer token from SharedPreferences
  static Future<String?> _getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserAccessTokenKey');
  }

  static Future<dynamic> _handleRequest({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required bool retry,
    VoidCallback? onUnauthorized,
  }) async {
    if (!await _hasInternetConnection()) {
      throw 'No internet connection. Please check your network.';
    }

    final token = await _getBearerToken();
    final requestHeaders = {
      ...defaultHeaders,
      if (headers != null) ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final encodedBody = body != null ? jsonEncode(body) : null;

    print('[$method] URL: $url');
    print('Bearer Token: $token');
    if (encodedBody != null) print('Request Body: $encodedBody');

    try {
      late http.Response response;

      switch (method) {
        case 'POST':
          response = await http.post(
            url,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case 'GET':
          response = await http.get(url, headers: requestHeaders);
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            url,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            url,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        default:
          throw 'Unsupported HTTP method: $method';
      }

      print('Response Code: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Response Body: $decodedBody');
      final jsonResponse = jsonDecode(decodedBody);

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonResponse;

        case 422:
          throw ApiErrorModel.fromJson(jsonResponse).toString();

        case 500:
        case 502:
          throw ApiErrorModel.fromJson(jsonResponse).toString();

        case 400:
        case 404:
          final messages = jsonResponse.entries
              .map((e) => '${e.value}')
              .join('\n');
          throw messages;

        case 401:
          if (retry) {
            try {
              await RefreshAccessTokenRepository().getAndUpdateTheRefreshToken(
                onUnauthorized: onUnauthorized,
              );

              return _handleRequest(
                method: method,
                url: url,
                headers: headers,
                body: body,
                retry: false,
                onUnauthorized: onUnauthorized,
              );
            } catch (e) {
              throw 'Unauthorized. Please log in again.';
            }
          } else {
            throw 'Unauthorized. Please log in again.';
          }
        default:
          throw 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Request Exception: $e');
      rethrow;
    }
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class HttpStatusException implements Exception {
  HttpStatusException(this.statusCode, this.body);

  final int statusCode;
  final dynamic body;

  @override
  String toString() => 'HTTP $statusCode → $body';
}
