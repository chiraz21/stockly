import 'package:flutter/material.dart';
import '../theme.dart';

class FarmerRegisterScreen extends StatelessWidget {
  const FarmerRegisterScreen({super.key});

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
                Text("Create Account",
                    style: TextStyle(color: Colors.white, fontSize: 26)),
                SizedBox(height: 5),
                Text("Join Stockly today",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Form
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _inputField("Full Name", Icons.person),
                _inputField("Email", Icons.email),
                _inputField("Phone Number", Icons.phone),
                _inputField("Enter Password", Icons.lock, isPassword: true),
                _inputField("Confirm Password", Icons.lock, isPassword: true),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    // API call to register
                  },
                  child: const Text("Register"),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // go back to login
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
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
