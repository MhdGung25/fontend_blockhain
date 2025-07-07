import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';

class FormTransaksiPage extends StatefulWidget {
  const FormTransaksiPage({super.key});

  @override
  State<FormTransaksiPage> createState() => _FormTransaksiPageState();
}

class _FormTransaksiPageState extends State<FormTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  String jenis = 'pemasukan';
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF0E2F56);

  Future<void> simpanTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('user_id');

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Sesi berakhir, silakan login ulang")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/transaksi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'user_id': userId.toString(),
          'jenis': jenis,
          'jumlah': jumlahController.text,
          'deskripsi': deskripsiController.text,
        },
      );

      final data = jsonDecode(response.body);
      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Transaksi berhasil disimpan")),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        final msg = data['message'] ?? 'Gagal menyimpan transaksi';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ $msg")));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Terjadi kesalahan: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Form Transaksi"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: jenis,
                decoration: InputDecoration(
                  labelText: 'Jenis Transaksi',
                  border: inputBorder,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'pemasukan',
                    child: Text('Pemasukan'),
                  ),
                  DropdownMenuItem(
                    value: 'pengeluaran',
                    child: Text('Pengeluaran'),
                  ),
                ],
                onChanged: (value) => setState(() => jenis = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: inputBorder,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Jumlah wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: inputBorder,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Simpan Transaksi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            simpanTransaksi();
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
