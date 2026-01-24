import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;

  void register() async {
    if (password.text != confirm.text) {
      showMessage("Passwords do not match");
      return;
    }
    
    setState(() => loading = true);
    final res = await ApiService.register(
      name.text.trim(),
      email.text.trim(),
      phone.text.trim(),
      password.text.trim(),
    );
    setState(() => loading = false);

    if (res['success']) {
      Navigator.pop(context);
    } else {
      showMessage(res['message'] ?? "Registration failed");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Reusable TextField style to match Login Screen
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
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
      backgroundColor: const Color(0xFFF7FBF9), // Match login background
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500, // Slightly wider for desktop to accommodate form fields
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                // Curved Green Header (Consistent with Login)
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.person_add_alt_1_outlined, color: Color(0xFF63C092), size: 40),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Join Stockly", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Create your account", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // Registration Form
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      _buildTextField(label: "Full Name", hint: "Enter your name", icon: Icons.person_outline, controller: name),
                      const SizedBox(height: 15),
                      _buildTextField(label: "Email", hint: "Enter your email", icon: Icons.email_outlined, controller: email),
                      const SizedBox(height: 15),
                      _buildTextField(label: "Phone", hint: "Enter phone number", icon: Icons.phone_outlined, controller: phone),
                      const SizedBox(height: 15),
                      _buildTextField(label: "Password", hint: "Create password", icon: Icons.lock_outline, controller: password, isPassword: true),
                      const SizedBox(height: 15),
                      _buildTextField(label: "Confirm Password", hint: "Repeat password", icon: Icons.lock_reset_outlined, controller: confirm, isPassword: true),
                      const SizedBox(height: 40),
                      
                      // Register Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF63C092),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                        ),
                        onPressed: loading ? null : register,
                        child: loading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text("Register Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      
                      // Back to Login Link
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Color(0xFF63C092), fontWeight: FontWeight.w600),
                        ),
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