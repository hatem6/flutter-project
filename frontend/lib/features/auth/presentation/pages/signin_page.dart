import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import 'signup_page.dart';
import '../../../article/presentation/ArticlesPage.dart';

class SigninPage extends StatelessWidget {
  final AuthRepository repository;

  SigninPage({required this.repository});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signin(BuildContext context) async {
    // Validate email and password
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Call the signin method from the repository
    final userId = await repository.signin(email, password);

    // Handle the response
    if (userId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signin Successful')),
      );
      // Navigate to ArticlesPage and replace the SigninPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlesPage(userId: userId), // Pass the userId here
        ),
      );
    } else {
      // If failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signin Failed')),
      );
    }
  }

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(repository: repository), // Navigate to the SignUpPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Log in to your account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.emailAddress, // Improved for email input
              ),
              SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 20),

              // Sign In Button
              ElevatedButton(
                onPressed: () => signin(context),
                child: Text('Sign in'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
              ),
              SizedBox(height: 20),

              TextButton(
                onPressed: () => navigate(context),
                child: Text(
                  "Don't you have an account?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
