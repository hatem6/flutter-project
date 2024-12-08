import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/pages/signin_page.dart';

void main() {
  final apiClient = ApiClient(baseUrl: 'http://localhost:3001');
  final authRepository = AuthRepository(apiClient: apiClient);
  runApp(MyApp(authRepository: authRepository));
}
class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  // Constructor that requires the AuthRepository
  MyApp({required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Pass the repository to SignupPage
      home: SigninPage(repository: authRepository),
    );
  }
}