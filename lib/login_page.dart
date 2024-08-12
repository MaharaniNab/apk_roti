import 'dart:convert';
import 'package:apk_roti/home_page.dart';
import 'package:apk_roti/register_page.dart';
import 'package:apk_roti/admin_login.dart'; // Import halaman login admin
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  login(BuildContext context) async {
    String url = 'http://192.168.0.101/sertifikasi_jmp/user/login.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'username': controllerUsername.text,
        'password': controllerPassword.text,
      },
    );
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      DInfo.toastSuccess('Login Success');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      DInfo.toastError("Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                "https://t3.ftcdn.net/jpg/02/11/40/60/360_F_211406021_UQZROEmT39lpI8ThPudBOEB0BrN4P8oj.jpg",
                width: 300 / 3,
                height: 300 / 3,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Login',
              style: GoogleFonts.poppins(
                  fontSize: 24, color: Colors.black), // Applying Poppins font
            ),
            DView.height(),
            TextField(
              controller: controllerUsername,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(FeatherIcons.logIn, size: 20.0),
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(), // Applying Poppins font
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
              style: GoogleFonts.poppins(), // Applying Poppins font
            ),
            DView.height(),
            TextField(
              controller: controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(FeatherIcons.lock, size: 20.0),
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(), // Applying Poppins font
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
              style: GoogleFonts.poppins(), // Applying Poppins font
            ),
            DView.height(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  login(context);
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.poppins(), // Applying Poppins font
                ),
              ),
            ),
            DView.height(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
                child: Text(
                  "Register",
                  style: GoogleFonts.poppins(), // Applying Poppins font
                ),
              ),
            ),
            DView.height(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminLoginPage(),
                    ),
                  );
                },
                child: Text(
                  "Login as Admin",
                  style: GoogleFonts.poppins(), // Applying Poppins font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
