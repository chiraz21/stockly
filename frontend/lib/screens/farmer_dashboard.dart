import 'package:flutter/material.dart';
import 'request_appointment_screen.dart';
import 'scheduled_appointments_screen.dart';
import 'appointment_history_screen.dart';
import 'manage_account_screen.dart';

class FarmerDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const FarmerDashboard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Safely extract user info
    final int userId = user['id'] ?? 0;
    final String userEmail = user['email'] ?? "No Email";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Stockly", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF63C092),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          // Keep the width you liked for your PC testing
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Text(
                "Welcome back,",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 30),

              // ===== ROW 1: Request & Scheduled =====
              Row(
                children: [
                  Expanded(
                    child: dashboardCard(
                      context: context,
                      icon: Icons.add_circle_outline,
                      title: "Request Appointment",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RequestAppointmentScreen(userId: userId),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: dashboardCard(
                      context: context,
                      icon: Icons.schedule,
                      title: "Scheduled Appointments",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScheduledAppointmentsScreen(userId: userId),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===== ROW 2: History & Manage Account =====
              Row(
                children: [
                  Expanded(
                    child: dashboardCard(
                      context: context,
                      icon: Icons.history,
                      title: "Appointment History",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentHistoryScreen(userId: userId),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: dashboardCard(
                      context: context,
                      icon: Icons.person_outline,
                      title: "Manage Account",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageAccountScreen(user: user),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ===== LOGOUT =====
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== YOUR ORIGINAL CARD WIDGET DESIGN =====
  Widget dashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 140, // Keeps the square look you preferred
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: const Color(0xFF63C092),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
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