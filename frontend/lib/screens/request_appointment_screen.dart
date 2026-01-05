import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestAppointmentScreen extends StatefulWidget {
  final int userId;

  const RequestAppointmentScreen({
    super.key,
    required this.userId,
  });

  @override
  State<RequestAppointmentScreen> createState() =>
      _RequestAppointmentScreenState();
}

class _RequestAppointmentScreenState extends State<RequestAppointmentScreen> {
  String? grainType;
  String? timeSlot;
  final quantityController = TextEditingController();
  DateTime? deliveryDate;
  bool loading = false;

  final grainTypes = ['Wheat', 'Barley', 'Corn', 'Oats'];
  final timeSlots = ['Morning', 'Afternoon'];

  // --- API LOGIC ---
  Future<void> submitRequest() async {
    // 1. Validation
    if (grainType == null ||
        timeSlot == null ||
        quantityController.text.isEmpty ||
        deliveryDate == null) {
      showMessage("Please fill all fields");
      return;
    }

    setState(() => loading = true);

    try {
      // Use 10.0.2.2 for Android Emulator, or your PC's IP for physical device
      final url = Uri.parse("http://192.168.1.11/stockly/backend/api/create.php");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": widget.userId,
          "grain_type": grainType,
          "quantity_kg": int.tryParse(quantityController.text) ?? 0,
          "delivery_date": "${deliveryDate!.year}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
          "preferred_time": timeSlot,
        }),
      ).timeout(const Duration(seconds: 10)); // Prevents infinite waiting

      if (!mounted) return;
      setState(() => loading = false);

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        showMessage("Appointment request sent ✅");
        Navigator.pop(context);
      } else {
        showMessage(data['message'] ?? "Server error occurred");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showMessage("Connection failed. Check your PC server/IP.");
      print("Error details: $e");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // --- UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      // Using a CustomScrollView or SingleChildScrollView to prevent overflow
      body: SingleChildScrollView( 
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2F8F6B), Color(0xFF63C092)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.inventory_2, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Request Appointment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Schedule a grain delivery",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // FORM FIELDS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildDropdown(
                    label: "Grain Type",
                    value: grainType,
                    hint: "Select grain type",
                    items: grainTypes,
                    onChanged: (v) => setState(() => grainType = v),
                  ),
                  buildInput(
                    controller: quantityController,
                    label: "Quantity (kg)",
                    hint: "Enter quantity in kg",
                    keyboard: TextInputType.number,
                  ),
                  buildDatePicker(),
                  buildDropdown(
                    label: "Preferred Time",
                    value: timeSlot,
                    hint: "Select time slot",
                    items: timeSlots,
                    onChanged: (v) => setState(() => timeSlot = v),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F8F6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Submit Request",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Delivery Date",
          filled: true,
          fillColor: Colors.white,
          hintText: deliveryDate == null
              ? "Select Date"
              : "${deliveryDate!.month}/${deliveryDate!.day}/${deliveryDate!.year}",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2F8F6B)),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) setState(() => deliveryDate = picked);
        },
      ),
    );
  }
}