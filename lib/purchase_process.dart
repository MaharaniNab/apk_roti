import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apk_roti/transaction_history.dart';

class PurchaseProcessPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function onStockUpdate; // Fungsi untuk memperbarui stok

  PurchaseProcessPage({required this.product, required this.onStockUpdate});

  @override
  _PurchaseProcessPageState createState() => _PurchaseProcessPageState();
}

class _PurchaseProcessPageState extends State<PurchaseProcessPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String address = '';
  String phoneNumber = '';
  int quantity = 1;
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Memeriksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // Jika izin diberikan, mendapatkan lokasi
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      print('Current Position: $_currentPosition');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    }
  }

  Future<void> _loadProductData() async {
    final url =
        'http://192.168.0.101/sertifikasi_jmp/transactions/stock.php'; // Ganti dengan URL yang sesuai

    final response = await http.get(Uri.parse(url));

    // Menampilkan body response yang dikembalikan oleh server
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Menampilkan data yang telah di-decode
      print('Parsed data: $data');

      if (data['success'] == true) {
        final List<dynamic> products = data['data'];
        final product =
            products.firstWhere((p) => p['name'] == widget.product['name']);

        setState(() {
          widget.product['stock'] = product['stock'];
          widget.product['sold'] = product['sold'];
        });
      } else {
        print('Failed to load product data: API response indicated failure.');
      }
    } else {
      print('Failed to load product data.');
    }
  }

  Future<void> _sendOrderData() async {
    final url =
        'http://192.168.0.101/sertifikasi_jmp/transactions/create.php'; // Ganti dengan URL yang sesuai

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'product': widget.product['name'],
        'price': int.parse(widget.product['price']) * quantity,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      print('Order data sent successfully!');
      return;
    } else {
      print('Failed to send order data.');
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _sendOrderData().then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionSuccessPage(
              name: name,
              address: address,
              phoneNumber: phoneNumber,
              location: _currentPosition,
              product: widget.product,
            ),
          ),
        );
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadProductData();
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product['price'] as String;
    final priceNumber =
        int.tryParse(price.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
    final totalPrice = priceNumber * quantity;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[100],
        title: Text(
          'Proses Pembelian',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  address = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nomor telepon harus diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: _decrementQuantity,
                  ),
                  SizedBox(width: 20),
                  Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _incrementQuantity,
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Jumlah Stok Tersedia: ${widget.product['stock']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Total Harga: Rp${totalPrice.toString()}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[300],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Kirim Pesanan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
