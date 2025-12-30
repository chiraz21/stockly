import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminLoginScreen extends StatefulWidget {
  final String role;

  const AdminLoginScreen({super.key, required this.role});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginAdmin() async {
    try {
      // Assuming backend uses the same login API
      var result = await ApiService.login(
        emailController.text,
        passwordController.text,
      );

      print(result); // response from backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.role} login successful")),
      );

      // Navigate to admin dashboard page (example)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen()));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.role} Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginAdmin,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
