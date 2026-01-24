import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockly/config/api_config.dart';


class MonitorAppointmentsScreen extends StatefulWidget {
  const MonitorAppointmentsScreen({super.key});

  @override
  State<MonitorAppointmentsScreen> createState() => _MonitorAppointmentsScreenState();
}

class _MonitorAppointmentsScreenState extends State<MonitorAppointmentsScreen> {
  List appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("${ApiConfig.baseUrl}/admin_get_appointments.php"));
      final data = jsonDecode(res.body);
      if (data['success']) {
        List fetchedData = data['data'];

        // Logic: Sort by Priority (Not Completed > Pending > Approved > Others)
        fetchedData.sort((a, b) {
          int getPriority(String status) {
            switch (status) {
              case 'Not Completed': return 0;
              case 'Pending': return 1;
              case 'Approved': return 2;
              default: return 3;
            }
          }
          return getPriority(a['status']).compareTo(getPriority(b['status']));
        });

        setState(() {
          appointments = fetchedData;
          loading = false;
        });
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void confirmStrike(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm No-Show?"),
        content: const Text("This will add 1 strike to the farmer's account. At 3 strikes, the account is automatically suspended."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              updateStatus(id, "Not Completed");
            },
            child: const Text("Confirm Strike", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> updateStatus(int id, String status) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/update_appointment_status.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "status": status}),
      );
      
      if (response.statusCode == 200) {
        fetchAppointments(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status updated to $status"))
        );
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved': return const Color(0xFF63C092);
      case 'Pending': return Colors.orange;
      case 'Completed': return Colors.blue;
      case 'Not Completed': return Colors.red;
      case 'Rejected': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: loading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF63C092))) 
              : RefreshIndicator(
                  onRefresh: fetchAppointments,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: appointments.length,
                    itemBuilder: (_, i) => _buildAppointmentCard(appointments[i]),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF76D1A6), Color(0xFF5AB688)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          const Text("Appointments", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Priority tasks are sorted to the top", style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map a) {
    final statusColor = _getStatusColor(a['status']);
    final int appId = int.parse(a['id'].toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: a['status'] == 'Not Completed' ? Border.all(color: Colors.red.withOpacity(0.3), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['grain_type'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2D3142))),
                    Text("ID: APT${a['id'].toString().padLeft(4, '0')}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                _statusChip(a['status'], statusColor),
              ],
            ),
            const Divider(height: 30),
            _infoRow(Icons.person_outline, "Farmer: ", a['farmer_name'] ?? "Unknown", isBold: true, iconColor: const Color(0xFF63C092)),
            const SizedBox(height: 12),
            _infoRow(Icons.calendar_today_outlined, "", a['delivery_date'] ?? ""),
            _infoRow(Icons.access_time, "", a['preferred_time'] ?? "Not set"),
            _infoRow(Icons.fitness_center, "", "${a['quantity_kg'] ?? '0'} kg"),
            
            const SizedBox(height: 20),
            
            if (a['status'] == 'Pending') 
              Row(
                children: [
                  Expanded(child: _actionBtn("Reject", Colors.redAccent, () => updateStatus(appId, "Rejected"))),
                  const SizedBox(width: 10),
                  Expanded(child: _actionBtn("Approve", const Color(0xFF63C092), () => updateStatus(appId, "Approved"))),
                ],
              ),
            
            if (a['status'] == 'Approved')
              Row(
                children: [
                  Expanded(child: _actionBtn("Not Completed", Colors.red, () => confirmStrike(appId), icon: Icons.warning_amber)),
                  const SizedBox(width: 10),
                  Expanded(child: _actionBtn("Completed", Colors.blue, () => updateStatus(appId, "Completed"), icon: Icons.check)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  // Updated InfoRow to match the screenshot's clean look
  Widget _infoRow(IconData icon, String label, String value, {bool isBold = false, Color iconColor = Colors.grey}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          if(label.isNotEmpty) Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: TextStyle(
            color: isBold ? const Color(0xFF63C092) : const Color(0xFF2D3142), 
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 15
          )),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap, {IconData? icon}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? (label == "Approve" ? Icons.check : Icons.close), size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        foregroundColor: Colors.white, 
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      ),
    );
  }
}