import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  register(BuildContext context) async {
    String url = 'http://192.168.0.101/sertifikasi_jmp/user/register.php';
    var response = await http.post(Uri.parse(url), body: {
      'username': controllerUsername.text,
      'password': controllerPassword.text,
    });
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      DInfo.toastSuccess('Success Register');
      Navigator.pop(context);
    } else {
      if (responseBody['message'] == 'username') {
        DInfo.toastError('Username has already exist');
      } else {
        DInfo.toastError('Failed Register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                "https://t3.ftcdn.net/jpg/02/11/40/60/360_F_211406021_UQZROEmT39lpI8ThPudBOEB0BrN4P8oj.jpg",
                width: 300 /
                    3, // Mengatur lebar gambar menjadi 1/3 dari sebelumnya
                height: 300 /
                    3, // Mengatur tinggi gambar menjadi 1/3 dari sebelumnya
                fit: BoxFit
                    .cover, // Agar gambar memenuhi area dan tetap proporsional
              ),
            ),
            DView.textTitle(
              'Register',
              color: Colors.black,
            ),
            DView.height(),
            TextField(
              controller: controllerUsername,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(FeatherIcons.logIn, size: 20.0),
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
            DView.height(),
            TextField(
              controller: controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(FeatherIcons.lock, size: 20.0),
                labelText: 'Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            DView.height(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => register(context),
                child: const Text('Register'),
              ),
            ),
            DView.height(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
