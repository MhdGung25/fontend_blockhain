import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/tujuan_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UmkmProfilePage extends StatefulWidget {
  const UmkmProfilePage({super.key});

  @override
  State<UmkmProfilePage> createState() => _UmkmProfilePageState();
}

class _UmkmProfilePageState extends State<UmkmProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();

  String? selectedJenisUsaha;
  String? selectedTahun;

  bool _isLoading = false;

  final List<String> jenisUsahaOptions = [
    'Makanan',
    'Fashion',
    'Jasa',
    'Retail',
    'Lainnya',
  ];

  final List<String> tahunOptions = List.generate(
    30,
    (index) => '${2000 + index}',
  );

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Siapkan data
      final body = {
        'nama_usaha': namaController.text,
        'jenis_usaha': selectedJenisUsaha!,
        'tahun_berdiri': selectedTahun!,
        'alamat': alamatController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/usaha'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(data['message'])));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TujuanPage()),
          );
        } else {
          final error = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error['message'] ?? 'Gagal simpan profil')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Lengkapi Profil\nUMKM Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Image.asset('assets/profile_illustration.png', height: 160),
                    const SizedBox(height: 24),

                    // Nama Usaha
                    TextFormField(
                      controller: namaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Nama Usaha"),
                      validator: (value) =>
                          value!.isEmpty ? 'Nama usaha wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Jenis Usaha
                    DropdownButtonFormField<String>(
                      value: selectedJenisUsaha,
                      decoration: _inputDecoration("Jenis Usaha"),
                      dropdownColor: const Color(0xFF0A2B6C),
                      style: const TextStyle(
                        color: Colors.white,
                      ), // warna teks saat dipilih
                      items: jenisUsahaOptions.map((jenis) {
                        return DropdownMenuItem(
                          value: jenis,
                          child: Text(
                            jenis,
                            style: const TextStyle(
                              color: Colors.white,
                            ), // teks di dropdown list
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedJenisUsaha = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih jenis usaha' : null,
                    ),

                    const SizedBox(height: 16),

                    // Tahun Berdiri
                    DropdownButtonFormField<String>(
                      value: selectedTahun,
                      decoration: _inputDecoration("Tahun Berdiri"),
                      dropdownColor: const Color(0xFF0A2B6C),
                      style: const TextStyle(color: Colors.white),
                      items: tahunOptions.map((tahun) {
                        return DropdownMenuItem(
                          value: tahun,
                          child: Text(
                            tahun,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTahun = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih tahun' : null,
                    ),

                    const SizedBox(height: 16),

                    // Alamat
                    TextFormField(
                      controller: alamatController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Alamat"),
                      validator: (value) =>
                          value!.isEmpty ? 'Alamat wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Lanjut
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : const Text("Lanjut"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: const Color(0xFF0A2B6C),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
