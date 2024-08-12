import 'package:apk_roti/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class TransactionSuccessPage extends StatelessWidget {
  final String name;
  final String address;
  final String phoneNumber;
  final Position? location;
  final Map<String, dynamic> product;

  TransactionSuccessPage({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.location,
    required this.product,
  });

  Future<void> _sendTransactionData() async {
    final url = 'http://192.168.0.101/sertifikasi_jmp/transactions/create.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'address': address,
          'phoneNumber': phoneNumber,
          'latitude': location?.latitude ?? 0.0,
          'longitude': location?.longitude ?? 0.0,
          'product': product['name'] ?? '',
          'price': product['price'] ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        print('Transaction data sent successfully!');
      } else {
        print(
            'Failed to send transaction data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: Colors.brown[100],
        title: Text(
          'Transaksi Berhasil',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Lucu dalam bentuk lingkaran
            ClipOval(
              child: Image.network(
                'https://st2.depositphotos.com/8684932/48275/v/380/depositphotos_482755030-stock-illustration-mascot-fried-egg-holding-banner.jpg',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            // Teks Terima Kasih
            Text(
              'Terima kasih atas pembelian Anda!',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Tombol Kembali ke Beranda
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.home, color: Colors.white),
              label: Text('Ke Beranda',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[300],
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                textStyle:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
