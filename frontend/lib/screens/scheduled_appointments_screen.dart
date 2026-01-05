import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduledAppointmentsScreen extends StatefulWidget {
  final int userId;
  const ScheduledAppointmentsScreen({super.key, required this.userId});

  @override
  State<ScheduledAppointmentsScreen> createState() => _ScheduledAppointmentsScreenState();
}

class _ScheduledAppointmentsScreenState extends State<ScheduledAppointmentsScreen> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.11/stockly/backend/api/get_appointments.php?user_id=${widget.userId}"),
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
      print("Error fetching: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // GREEN HEADER (Matches your Screenshot)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: Color(0xFF63C092),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                const Text("Scheduled Appointments",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                Text("${appointments.length} upcoming",
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),

          // DATE FILTER BAR
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.filter_list),
                hintText: "mm / dd / yyyy",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),

          // LIST OF CARDS
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                    ? const Center(child: Text("No appointments found"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final item = appointments[index];
                          return appointmentCard(item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget appointmentCard(Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['grain_type'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF63C092), borderRadius: BorderRadius.circular(10)),
                child: const Text("Scheduled", style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text("ID: APT00${item['id']}", style: const TextStyle(color: Colors.grey)),
          const Divider(height: 30),
          rowInfo(Icons.calendar_today_outlined, item['delivery_date']),
          rowInfo(Icons.access_time, item['preferred_time']),
          rowInfo(Icons.inventory_2_outlined, "${item['quantity_kg']} kg"),
        ],
      ),
    );
  }

  Widget rowInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF63C092)),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}