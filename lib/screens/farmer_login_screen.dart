import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'farmer_register_screen.dart';
import 'farmer_dashboard_screen.dart'; 



class FarmerLoginScreen extends StatefulWidget {
  const FarmerLoginScreen({super.key});

  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    try {
      var result = await ApiService.login(
        emailController.text,
        passwordController.text,
      );

      // ✅ If login is successful → go to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const FarmerDashboardScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                SizedBox(height: 5),
                Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Form
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _inputField(
                  "Email / ID",
                  Icons.email,
                  controller: emailController,
                ),
                _inputField(
                  "Password",
                  Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: loginUser,
                  child: const Text("Login"),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FarmerRegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
