import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
import 'package:frontend_blockhain/pages/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final namaController = TextEditingController();
  final jenisUsahaController = TextEditingController();
  final tahunController = TextEditingController();
  final alamatController = TextEditingController();

  bool isLoading = false;
  bool isProfilFilled = false;

  @override
  void initState() {
    super.initState();
    checkProfilExist();
  }

  Future<void> checkProfilExist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/profil-umkm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          namaController.text = data['nama_usaha'] ?? '';
          jenisUsahaController.text = data['jenis_usaha'] ?? '';
          tahunController.text = data['tahun_berdiri'] ?? '';
          alamatController.text = data['alamat'] ?? '';
          isProfilFilled = true;
        });
      }
    } catch (e) {
      print("❌ Gagal mengambil data profil: $e");
    }
  }

  Future<void> handleNext() async {
    final namaUsaha = namaController.text.trim();
    final jenisUsaha = jenisUsahaController.text.trim();
    final tahun = tahunController.text.trim();
    final alamat = alamatController.text.trim();

    if (namaUsaha.isEmpty ||
        jenisUsaha.isEmpty ||
        tahun.isEmpty ||
        alamat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/profil-umkm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'user_id': userId.toString(),
          'nama_usaha': namaUsaha,
          'jenis_usaha': jenisUsaha,
          'tahun_berdiri': tahun,
          'alamat': alamat,
        },
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print("✅ Profil disimpan: ${result['data']}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profil berhasil disimpan")),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        throw Exception(result['message'] ?? 'Gagal menyimpan profil');
      }
    } catch (e) {
      print("❌ Error simpan profil: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan profil: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
        ),
        title: const Text("Profil UMKM", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lengkapi Profil UMKM Anda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _buildTextField(
                      namaController,
                      "Nama Usaha",
                      readOnly: isProfilFilled,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      jenisUsahaController,
                      "Jenis Usaha",
                      readOnly: isProfilFilled,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      tahunController,
                      "Tahun Berdiri",
                      keyboardType: TextInputType.number,
                      readOnly: isProfilFilled,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      alamatController,
                      "Alamat Usaha",
                      maxLines: 3,
                      readOnly: isProfilFilled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : isProfilFilled
                  ? const Center(
                      child: Text(
                        "✅ Profil sudah terisi",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : CustomButton(text: "Selanjutnya", onPressed: handleNext),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
