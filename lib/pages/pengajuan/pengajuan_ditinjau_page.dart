import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
//import 'package:frontend_blockhain/widgets/custom_button.dart';

class PengajuanDitinjauPage extends StatelessWidget {
  const PengajuanDitinjauPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Pengajuan Modal",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Pilih Bank Mitra",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.pengajuanDisetujui);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/bri_logo.png", width: 48),
                    const SizedBox(width: 16),
                    const Text("Bank BRI", style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
