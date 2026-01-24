import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stockly/config/api_config.dart';


class UserDirectoryScreen extends StatefulWidget {
  const UserDirectoryScreen({super.key});

  @override
  State<UserDirectoryScreen> createState() => _UserDirectoryScreenState();
}

class _UserDirectoryScreenState extends State<UserDirectoryScreen> {
  List users = [];
  bool loading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      loading = true;
      errorMessage = "";
    });
    try {
      // Ensure this IP matches your local XAMPP/WAMP server IP
      final res = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/admin_get_users.php"),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success']) {
          setState(() {
            users = data['data'];
            loading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? "Failed to load users";
            loading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection Error: Check if server is running";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 15, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF76D1A6), Color(0xFF5AB688)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Farmer Directory",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 28, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Monitoring strikes and account status",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF63C092)))
                : errorMessage.isNotEmpty
                    ? _buildErrorWidget()
                    : RefreshIndicator(
                        onRefresh: fetchUsers,
                        color: const Color(0xFF63C092),
                        child: users.isEmpty
                            ? const Center(child: Text("No farmers registered yet."))
                            : ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: users.length,
                                itemBuilder: (context, i) => _buildUserCard(users[i]),
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map user) {
    // Parsing values safely
    int strikes = int.tryParse(user['no_show_count'].toString()) ?? 0;
    bool isSuspended = user['status'].toString().toLowerCase() == 'suspended';
    
    // Formatting date
    String formattedDate = "N/A";
    if (user['created_at'] != null) {
      DateTime regDate = DateTime.parse(user['created_at']);
      formattedDate = DateFormat('MMM dd, yyyy').format(regDate);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSuspended ? Border.all(color: Colors.red.shade200, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: isSuspended ? Colors.red.shade50 : const Color(0xFFF1FBF6),
          child: Text(
            user['name'][0].toUpperCase(),
            style: TextStyle(
              color: isSuspended ? Colors.red : const Color(0xFF63C092),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          user['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSuspended ? Colors.red.shade900 : const Color(0xFF2D3142),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                // Strike Indicator Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: strikes >= 2 ? Colors.red.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded, 
                        size: 12, 
                        color: strikes >= 2 ? Colors.red : Colors.orange.shade800
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Strikes: $strikes/3",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: strikes >= 2 ? Colors.red : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text("Joined $formattedDate", style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSuspended ? Icons.block_flipped : Icons.check_circle_outline,
              color: isSuspended ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 2),
            Text(
              isSuspended ? "BANNED" : "ACTIVE",
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: isSuspended ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(errorMessage, textAlign: TextAlign.center),
          TextButton(onPressed: fetchUsers, child: const Text("Retry")),
        ],
      ),
    );
  }
}