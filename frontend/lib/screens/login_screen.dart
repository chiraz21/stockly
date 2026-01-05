import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'farmer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  void login() async {
    final res = await ApiService.login(
      email.text,
      password.text,
    );

    if (res['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FarmerDashboard(user: res['user']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63C092),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Login",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          labelText: "Email")),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password"),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text("LOGIN"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
