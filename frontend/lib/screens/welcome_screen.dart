import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63C092),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Stockly",
              style: TextStyle(fontSize: 42, color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Smart Warehouse Management",
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 60),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              minimumSize: const Size(300, 50),
            ),
            child: const Text("Login"),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              minimumSize: const Size(300, 50),
            ),
            child: const Text("Create Account"),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
          ),
        ],
      ),
    );
  }
}
