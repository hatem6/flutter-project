// lib/core/network/api_client.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;

  // Constructor to initialize the baseUrl
  ApiClient({required this.baseUrl});

  // POST request method
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    final bodyEncoded = json.encode(body);

    final response = await http.post(
      uri,
      headers: headers,
      body: bodyEncoded,
    );

    return response;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    final bodyEncoded = json.encode(body);

    final response = await http.put(
      uri,
      headers: headers,
      body: bodyEncoded,
    );

    return response;
  }

  // DELETE request method
  Future<http.Response> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(uri);

    return response;
  }

  // You can add other methods like GET, PUT, DELETE if needed
}
