import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avionics_internal/Constants/ApiClass/shared_prefs_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiErrorModel.dart';
import 'SessionTokenClass/refresh_accessRepository.dart';

class ApiService {
  static final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, String>> headersForTheMapSection({
    required String inputUrl,
    required String mapKeyValues,
  }) async {
    if (inputUrl.toLowerCase().contains("avioflai")) {
      return {
        'Accept': 'application/json',
        'access-token':
            'EwkiTKL4oecbj860tb1EvsVfH2z3Cppq6Va6LFfwwTxz1sQvTE6HUhdGYyHGm0FC',
      };
    } else {
      return {
        'Accept': 'application/json',
        'Accept-Version': 'v1',
        'Authorization': 'Bearer $mapKeyValues',
      };
    }
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
    bool? isForFlightRadar = false,
    required Uri url,
    Map<String, String>? headers,
    VoidCallback? onUnauthorized,
  }) {
    return _handleRequest(
      isForFlightRadar: isForFlightRadar,
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
  static Future<String?> getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserAccessTokenKey');
  }

  static Future<dynamic> _handleRequest({
    bool? isForFlightRadar = false,
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required bool retry,
    VoidCallback? onUnauthorized,
  }) async {
    final token = await getBearerToken();
    final mapKeyValues = await SharedPrefsHelper.getMapKeyValuesForApi();

    final requestHeaders = {
      ...(isForFlightRadar == true
          ? await headersForTheMapSection(
              inputUrl: url.toString(),
              mapKeyValues: mapKeyValues,
            )
          : defaultHeaders),
      if (isForFlightRadar == false) ...{
        if (headers != null) ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    };

    final encodedBody = body != null ? jsonEncode(body) : null;

    print("[$method] URL: $url\nHeaders: $requestHeaders\nBody: $encodedBody");

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
          throw Exception('Unsupported HTTP method: $method');
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      print('Status Code: ${response.statusCode}');
      print('Response Body: $decodedBody');

      dynamic jsonResponse;
      try {
        jsonResponse = jsonDecode(decodedBody);
      } catch (_) {
        jsonResponse = null; // In case of HTML (503 page)
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          if (jsonResponse != null) {
            return jsonResponse;
          } else {
            return decodedBody;
          }

        case 400:
        case 404:
          if (jsonResponse != null) {
            final message = jsonResponse['detail']?.toString() ?? '';
            if (message.contains('not more approved questions') || message.contains('Sorry')) {
              return {"empty": true, "message": message};
            }
            throw '400 $message';
          }
          // throw '400 Bad request';

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
            } catch (_) {
              throw '401 Unauthorized. Please log in again.';
            }
          } else {
            throw '401 Unauthorized. Please log in again.';
          }

        case 422:
          if (jsonResponse != null) {
            throw ApiErrorModel.fromJson(jsonResponse).toString();
          }
          throw '422 Validation error';

        case 500:
        case 502:
        case 503:
          throw '${response.statusCode} Server temporarily unavailable. Please try again later.';

        default:
          throw '${response.statusCode} Request failed.';
      }
    } on SocketException {
      throw SocketException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Connection timed out');
    } catch (e) {
      if (kDebugMode) {
        print('Request Exception: ${e.toString()}');
      }
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
