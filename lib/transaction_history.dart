import 'package:apk_roti/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; // Make sure to import Geolocator

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
          'latitude': location?.latitude ??
              0.0, // Provide a default value if location is null
          'longitude': location?.longitude ??
              0.0, // Provide a default value if location is null
          'product': product['name'] ??
              '', // Provide a default value if product['name'] is null
          'price': product['price'] ??
              0.0, // Provide a default value if product['price'] is null
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
    // _sendTransactionData();

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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Terima kasih atas pembelian Anda!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
