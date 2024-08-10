import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final url = 'http://192.168.0.101/sertifikasi_jmp/transactions/get.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        transactions =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Transactions'),
        backgroundColor: Colors.brown[100],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            title: Text('${transaction['name']} - \$${transaction['price']}'),
            subtitle: Text(
                'Address: ${transaction['address']}\nPhone: ${transaction['phoneNumber']}'),
          );
        },
      ),
    );
  }
}
