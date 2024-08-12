import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Transaction Details',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Customer Name: ${transaction['name']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  'Address: ${transaction['address']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  'Phone: ${transaction['phoneNumber']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  'Price: \$${transaction['price']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  'Date: ${transaction['created_at']}', // Tanggal pembelian
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bread Details:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                Text(
                  'Bread Name: ${transaction['product']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  'Quantity: ${transaction['quantity']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Colors.brown[600],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin - Transactions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        backgroundColor: Colors.brown[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: transactions.isEmpty
            ? Center(
                child: Text(
                  'No transactions available',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.brown[700],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown[200],
                        child: Icon(
                          Icons.receipt,
                          color: Colors.brown[800],
                        ),
                      ),
                      title: Text(
                        transaction['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: \$${transaction['price']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.brown[600],
                              ),
                            ),
                            Text(
                              'Date: ${transaction['created_at']}', // Tanggal pembelian
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.brown[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Colors.brown[800],
                        ),
                        onPressed: () => _showTransactionDetails(transaction),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
