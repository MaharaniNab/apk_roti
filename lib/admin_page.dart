import 'dart:io'; // Perlu untuk mendeteksi platform
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> transactions = [];
  Position? position;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _getLastKnownPosition();
  }

  Future<void> _getLastKnownPosition() async {
    try {
      position = await Geolocator.getLastKnownPosition();
      // Optionally, use position here or set state
    } catch (e) {
      print('Error getting last known position: $e');
    }
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _openMap(
                      transaction['latitude'],
                      transaction['longitude'],
                      transaction['name'],
                      transaction['address']),
                  child: Text(
                    'View on Map',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
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

  void _openMap(
      String latitude, String longitude, String name, String address) {
    double lat = double.parse(latitude);
    double lon = double.parse(longitude);

    if (Platform.isWindows) {
      // Untuk Windows, buka Google Maps di browser
      final String googleMapsUrl = 'https://www.google.com/maps?q=$lat,$lon';
      _launchURL(googleMapsUrl);
    } else {
      // Untuk platform lain, tampilkan peta di aplikasi
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            latitude: lat,
            longitude: lon,
            customerName: name,
            customerAddress: address,
          ),
        ),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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


class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String customerName;
  final String customerAddress;

  MapScreen({
    required this.latitude,
    required this.longitude,
    required this.customerName,
    required this.customerAddress,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(latitude, longitude);

    final Marker marker = Marker(
      markerId: MarkerId('marker_$customerName'), // Menggunakan nama customer sebagai ID
      position: location,
      infoWindow: InfoWindow(
        title: customerName, // Menampilkan nama customer
        snippet: customerAddress, // Menampilkan alamat customer
        onTap: () {
          // Opsional: Aksi saat InfoWindow di-tap
          print('InfoWindow tapped');
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Pembeli'), // Judul pada AppBar
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 15,
            ),
            markers: {marker},
            onMapCreated: (GoogleMapController controller) {
              // Opsional, Anda bisa menyimpan controller untuk digunakan di masa mendatang
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Name: $customerName',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Address: $customerAddress',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
                      _launchURL(googleMapsUrl);
                    },
                    child: Text('Open in Google Maps'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
