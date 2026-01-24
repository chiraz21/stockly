import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockly/config/api_config.dart';


class ScheduledAppointmentsScreen extends StatefulWidget {
  final int userId;
  const ScheduledAppointmentsScreen({super.key, required this.userId});

  @override
  State<ScheduledAppointmentsScreen> createState() =>
      _ScheduledAppointmentsScreenState();
}

class _ScheduledAppointmentsScreenState
    extends State<ScheduledAppointmentsScreen> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      // Replace with your server's IP
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/get_appointments.php").replace(
         queryParameters: {"user_id": widget.userId.toString()},)
      
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          appointments = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching: $e");
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Approved':
      case 'Scheduled':
        return const Color(0xFF63C092); // Matches Stockly Green
      case 'Rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9), // Soft background color
      body: Column(
        children: [
          // ===== GRADIENT HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF76D1A6), Color(0xFF5AB688)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Scheduled Appointments",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appointments.length} upcoming items",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== FILTER BAR (Responsive Width) =====
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.filter_alt_outlined, color: Color(0xFF63C092)),
                  hintText: "mm / dd / yyyy",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFF63C092)),
                  ),
                ),
              ),
            ),
          ),

          // ===== APPOINTMENT LIST =====
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF63C092)))
                : appointments.isEmpty
                    ? const Center(child: Text("No appointments found"))
                    : Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              return _buildAppointmentCard(appointments[index]);
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map item) {
    final String status = item['status'] ?? 'Scheduled';
    // If your API doesn't return 'farmer_name' yet, this will use the fallback
    final String farmerName = item['farmer_name'] ?? "John Farmer";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['grain_type'] ?? "Grain",
                      style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF2D3142)
                      ),
                    ),
                    Text(
                      "Farmer: $farmerName",
                      style: const TextStyle(
                        color: Color(0xFF63C092), 
                        fontWeight: FontWeight.w600, 
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor(status), 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "ID: APT00${item['id']}",
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(color: Color(0xFFF1F1F1), height: 1),
            ),
            _buildInfoRow(Icons.calendar_today_outlined, item['delivery_date'] ?? "N/A"),
            _buildInfoRow(Icons.access_time_rounded, item['preferred_time'] ?? "N/A"),
            _buildInfoRow(Icons.scale_outlined, "${item['quantity_kg']} kg"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1FBF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF63C092)),
          ),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15, 
              color: Color(0xFF4A4A4A), 
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}