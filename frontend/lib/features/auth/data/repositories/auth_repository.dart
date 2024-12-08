import 'dart:convert';

import '../../../../core/network/api_client.dart';
class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<bool> signup(String fullname, String email, String password) async {
    final response = await apiClient.post('/user/signup', {
      'fullname': fullname,
      'email': email,
      'password': password,
    });
    return response.statusCode == 201;
  }

  Future<int?> signin(String email, String password) async {
    final response = await apiClient.post('/user/signin', {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
    // Parse the response body as JSON
    final responseData = json.decode(response.body);
    print(responseData);
    // Check if the response is successful and contains a user object
    if (responseData['success']) {
      // Extract the userId from the response
      final userId = responseData['user']['id'];
      return userId;  // Return the userId for navigation
    } else {
      // If signin failed, return null
      return null;
    }
  }
    return null;
  }
}
