import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockly/config/api_config.dart';


class RequestAppointmentScreen extends StatefulWidget {
  final int userId;
  const RequestAppointmentScreen({super.key, required this.userId});

  @override
  State<RequestAppointmentScreen> createState() => _RequestAppointmentScreenState();
}

class _RequestAppointmentScreenState extends State<RequestAppointmentScreen> {
  String? grainType;
  String? timeSlot;
  final quantityController = TextEditingController();
  DateTime? deliveryDate;
  bool loading = false;

 final grainTypes = [
  'Wheat',
  'Barley',
  'Corn',
  'Rice',
  'Oats',
  'Chickpeas',
  'Millet',
  'Lentils',
  'Soybean',
  'Sunflower'
];

  final timeSlots = ['8:00 AM - 12:00 PM', '1:00 PM - 5:00 PM'];

  // --- API LOGIC ---
  Future<void> submitRequest() async {
    if (grainType == null || timeSlot == null || quantityController.text.isEmpty || deliveryDate == null) {
      showMessage("Please fill all fields");
      return;
    }

    setState(() => loading = true);

    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/create.php");
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
      ).timeout(const Duration(seconds: 10));

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
      showMessage("Connection failed.");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, backgroundColor: const Color(0xFF5AB688))
    );
  }

  // --- STYLIZED COMPONENTS ---

  InputDecoration _fieldDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF63C092), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== MATCHING GRADIENT HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 40, left: 20, right: 20),
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.add_task_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Request",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Fill the details for grain delivery",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== FORM CONTENT =====
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Grain Type"),
                    DropdownButtonFormField<String>(
                      value: grainType,
                      items: grainTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => grainType = v),
                      decoration: _fieldDecoration("Select your grain"),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("Quantity (kg)"),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration("Enter amount in kilograms"),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("Preferred Date"),
                    TextField(
                      readOnly: true,
                      decoration: _fieldDecoration(
                        deliveryDate == null ? "Select Date" : "${deliveryDate!.month}/${deliveryDate!.day}/${deliveryDate!.year}",
                        suffixIcon: const Icon(Icons.calendar_month_rounded, color: Color(0xFF63C092)),
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
                    const SizedBox(height: 20),

                    _buildLabel("Preferred Time Slot"),
                    DropdownButtonFormField<String>(
                      value: timeSlot,
                      items: timeSlots.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => timeSlot = v),
                      decoration: _fieldDecoration("Select arrival time"),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                    const SizedBox(height: 35),

                    // ===== ACTION BUTTON =====
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: loading ? null : submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5AB688),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: loading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text(
                              "Submit Request", 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                            ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Info Footer
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1FBF6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF63C092), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Your request will be reviewed by our team. Check 'Scheduled' for status updates.",
                              style: TextStyle(fontSize: 12, color: Color(0xFF4A4A4A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }
}