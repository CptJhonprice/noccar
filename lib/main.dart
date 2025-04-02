import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oto_randevu_mobil/main.dart';


void main() {
  runApp(MaterialApp(home: RandevuForm()));
}

class RandevuForm extends StatefulWidget {
  @override
  State<RandevuForm> createState() => _RandevuFormState();
}

class _RandevuFormState extends State<RandevuForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  bool _isLoading = false;

Future<void> sendAppointment() async {
  if (_isLoading) return;

  setState(() => _isLoading = true);

  final url = Uri.parse('http://77.92.154.106:3000/api/appointments');
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'phone': phoneController.text,
        'date': dateController.text,
        'time': timeController.text,
      }));

  setState(() => _isLoading = false);

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Randevu alındı ✅")),
    );
  } else {
    final data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Hata: ${data['error']}")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Randevu Al")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Ad Soyad"),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Telefon"),
            ),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(labelText: "Tarih (YYYY-MM-DD)"),
            ),
            TextFormField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Saat (HH:MM:SS)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                  onPressed: _isLoading ? null : sendAppointment,
                  child: _isLoading ? CircularProgressIndicator() : Text("Randevu Al"),
                ),

          ]),
        ),
      ),
    );
  }
}
