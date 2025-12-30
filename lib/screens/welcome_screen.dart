import 'package:flutter/material.dart';
import 'farmer_login_screen.dart';
import 'farmer_register_screen.dart';
import 'admin_login_screen.dart';
import '../theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.inventory_2, size: 50, color: primaryGreen),
            ),

            const SizedBox(height: 20),

            const Text(
              "Stockly",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Smart Warehouse Management",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // Login
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmerLoginScreen()),
                );
              },
              child: const Text("Login", style: TextStyle(color: primaryGreen)),
            ),

            const SizedBox(height: 15),

            // Register
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmerRegisterScreen()),
                );
              },
              child: const Text("Create Account", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 30),

            // Admin links
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminLoginScreen(role: "warehouse_admin"),
                  ),
                );
              },
              child: const Text("Warehouse Admin →", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminLoginScreen(role: "system_admin"),
                  ),
                );
              },
              child: const Text("System Admin →", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
