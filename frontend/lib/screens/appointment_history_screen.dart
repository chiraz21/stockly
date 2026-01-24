import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockly/config/api_config.dart';


class AppointmentHistoryScreen extends StatefulWidget {
  final int userId;
  const AppointmentHistoryScreen({super.key, required this.userId});

  @override
  State<AppointmentHistoryScreen> createState() => _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  List history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/get_history.php?user_id=${widget.userId}"),
      );
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          history = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching history: $e");
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF63C092); // Matches Scheduled Green
      case 'Rejected':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: Column(
        children: [
          // ===== DARK GREEN HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF5AB688), // Darker green as per history screen design
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
                    const Icon(Icons.history, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Appointment History",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${history.length} past appointments",
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== SEARCH BAR =====
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search by ID or grain type...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFF5AB688)),
                  ),
                ),
              ),
            ),
          ),

          // ===== HISTORY LIST =====
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF63C092)))
                : history.isEmpty
                    ? const Center(child: Text("No records found", style: TextStyle(color: Colors.grey)))
                    : Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: history.length,
                            itemBuilder: (context, index) => _buildHistoryCard(history[index]),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map item) {
    final String status = item['status'] ?? 'Completed';
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
                      item['grain_type'] ?? "Rice",
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
                    color: getStatusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: getStatusColor(status), 
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
            // Specific for history: Showing both requested and delivered amounts
            _buildInfoRow(Icons.scale_outlined, "Requested: ${item['quantity_kg']} kg"),
            if (status == 'Completed')
              _buildInfoRow(Icons.check_circle_outline, "Delivered: ${item['delivered_kg'] ?? item['quantity_kg']} kg"),
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