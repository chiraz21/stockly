import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'farmer_dashboard.dart';
import 'admin_dashboard.dart';
import 'register_screen.dart'; // Ensure this is imported

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  void login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      showMessage("Please enter email and password");
      return;
    }

    setState(() => loading = true);
    final res = await ApiService.login(email.text.trim(), password.text.trim());
    setState(() => loading = false);

    if (res['success'] == true) {
      final user = res['user'];
      if (user['role'] == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard(user: user)));
      } else if (user['role'] == 'farmer') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FarmerDashboard(user: user)));
      } else {
        showMessage("Unauthorized role");
      }
    } else {
      showMessage(res['message'] ?? "Login failed");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Helper to build the stylized TextFields from the image
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF63C092), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9), // Light background for the body
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 450, // Constrained width for Desktop
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: Column(
              children: [
                // Curved Green Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, bottom: 30, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF63C092),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                            child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF63C092), size: 40),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Login to your account", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // Form Content
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      _buildTextField(label: "Email / ID", hint: "Enter your email", icon: Icons.email_outlined, controller: email),
                      const SizedBox(height: 20),
                      _buildTextField(label: "Password", hint: "Enter password", icon: Icons.lock_outline, controller: password, isPassword: true),
                      const SizedBox(height: 40),
                      
                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF63C092),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                        ),
                        onPressed: loading ? null : login,
                        child: loading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 30),


                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                            child: const Text("Register", style: TextStyle(color: Color(0xFF63C092), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}