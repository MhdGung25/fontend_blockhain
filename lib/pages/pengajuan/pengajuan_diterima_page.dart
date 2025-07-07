import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
import 'package:frontend_blockhain/pages/utils/constants.dart';

class PengajuanDiterimaPage extends StatelessWidget {
  const PengajuanDiterimaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Status Pengajuan",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset("assets/bri_logo.png", width: 64),
            const SizedBox(height: 24),
            const Text(
              "Pengajuan Modal Diterima",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              "Bank BRI telah menyetujui pengajuan modal Anda",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jumlah Modal: Rp10.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Tanggal Disetujui: 6 Juli 2025"),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: "Selesai",
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              },
            ),
          ],
        ),
      ),
    );
  }
}
