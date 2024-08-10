import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_roti/admin_page.dart'; // Import AdminPage

class AdminLoginPage extends StatelessWidget {
  AdminLoginPage({super.key});
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  Future<void> loginAsAdmin(BuildContext context) async {
    String url =
        'http://192.168.0.101/sertifikasi_jmp/admin/login.php'; // Replace with your admin login URL
    var response = await http.post(
      Uri.parse(url),
      body: {
        'username': controllerUsername.text,
        'password': controllerPassword.text,
      },
    );
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      // Navigate to AdminPage on successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Admin Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controllerUsername,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.admin_panel_settings),
                labelText: 'Admin Username',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginAsAdmin(context);
              },
              child: Text("Login as Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
