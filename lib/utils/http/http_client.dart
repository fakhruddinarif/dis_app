import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DisHttpClient {
  static const String _baseUrl = 'http://api.dis.com/api'; // Change api.dis.com with your IP Address
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final response = await http.post(Uri.parse('$_baseUrl/$endpoint'), headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final response = await http.put(Uri.parse('$_baseUrl/$endpoint'), headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final response = await http.patch(Uri.parse('$_baseUrl/$endpoint'), headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> multipart(String endpoint, Map<String, String> files, Map<String, String> fields) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/$endpoint'));
    request.headers.addAll(headers);
    files.forEach((key, value) {
      request.files.add(http.MultipartFile.fromBytes(key, value.codeUnits, filename: key));
    });
    fields.forEach((key, value) {
      request.fields[key] = value;
    });
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return json.decode(responseString);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': '$token',
    };
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }
}