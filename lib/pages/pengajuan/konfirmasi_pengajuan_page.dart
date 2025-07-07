import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
import 'package:frontend_blockhain/pages/utils/constants.dart';

class KonfirmasiPengajuanPage extends StatelessWidget {
  const KonfirmasiPengajuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Konfirmasi Pengajuan",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildItem("Nama Usaha", "Warung Sembako Ibu Tini"),
            const SizedBox(height: 12),
            _buildItem("Jumlah Pengajuan", "Rp10.000.000"),
            const SizedBox(height: 12),
            _buildItem(
              "Alasan",
              "Untuk pengembangan dan modal beli stok barang",
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: "Ajukan Sekarang",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.lokasiBank);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
