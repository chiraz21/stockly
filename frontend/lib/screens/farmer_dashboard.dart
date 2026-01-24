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
    final int userId = user['id'] ?? 0;
    final String userEmail = user['email'] ?? "john@farm.com";
    final String userName = user['name'] ?? "John Farmer";

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: Column(
        children: [
          // ===== STYLIZED GRADIENT HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 25, right: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF76D1A6), Color(0xFF5AB688)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF63C092), size: 30),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stockly", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("Farmer Dashboard", style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30),
                // Welcome Card inside header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back, $userName!", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== RESPONSIVE GRID/LIST BODY =====
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Decide if we use 1 column (phone) or 2 columns (desktop)
                    int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                    double childAspectRatio = constraints.maxWidth > 600 ? 2.5 : 4.0;

                    return GridView.count(
                      padding: const EdgeInsets.all(25),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: childAspectRatio,
                      children: [
                        dashboardActionCard(
                          icon: Icons.calendar_today_outlined,
                          title: "Request Appointment",
                          subtitle: "Schedule a new delivery",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestAppointmentScreen(userId: userId))),
                        ),
                        dashboardActionCard(
                          icon: Icons.event_note_outlined,
                          title: "Scheduled Appointments",
                          subtitle: "View upcoming deliveries",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduledAppointmentsScreen(userId: userId))),
                        ),
                        dashboardActionCard(
                          icon: Icons.history,
                          title: "Appointment History",
                          subtitle: "View past appointments",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AppointmentHistoryScreen(userId: userId))),
                        ),
                        dashboardActionCard(
                          icon: Icons.person_outline,
                          title: "Manage Account",
                          subtitle: "Update your profile",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageAccountScreen(user: user))),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // ===== LOGOUT BUTTON =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Center(
              child: SizedBox(
                width: 400,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFFEBEE)),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dashboardActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF81D4AD), Color(0xFFA5E6C8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
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