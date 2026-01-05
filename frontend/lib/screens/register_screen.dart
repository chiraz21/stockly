import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  void register() async {
    if (password.text != confirm.text) return;

    final res = await ApiService.register(
      name.text,
      email.text,
      phone.text,
      password.text,
    );

    if (res['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63C092),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Create Account",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                      controller: name,
                      decoration: const InputDecoration(
                          labelText: "Full Name")),
                  TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          labelText: "Email")),
                  TextField(
                      controller: phone,
                      decoration: const InputDecoration(
                          labelText: "Phone Number")),
                  TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password")),
                  TextField(
                      controller: confirm,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText:
                              "Confirm Password")),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      child: const Text("REGISTER"),
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
