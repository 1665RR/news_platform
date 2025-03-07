import 'package:http/http.dart' as http;

import 'http_service.dart';

class ApiService {
  static late final String baseUrl;
  static late final HttpService _client;

  static void init() {
    baseUrl = "https://api.arena-collabiz.ito.dev/api";
    _client = HttpService();
  }

  static String getFullPath(String path) => "$baseUrl/$path";
  static Future<http.Response> get(String path,
      {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    return _client.get(
        Uri.parse(getFullPath(path)).replace(queryParameters: queryParams),
        headers: headers);
  }

  static Future<http.Response> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    return _client.post(Uri.parse(getFullPath(path)),
        headers: headers, body: body);
  }

  static Future<http.Response> delete(String path,
      {Map<String, String>? headers, Object? body}) async {
    return _client.delete(Uri.parse(getFullPath(path)),
        headers: headers, body: body);
  }
}
