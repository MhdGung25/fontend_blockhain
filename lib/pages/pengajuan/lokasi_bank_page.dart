import 'package:flutter/material.dart';

class LokasiBankPage extends StatelessWidget {
  const LokasiBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Lokasi Bank Terdekat",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.white24,
              child: const Center(
                child: Text(
                  "Map Placeholder",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Bank BRI KCP Bandung Utara\nJl. Sukajadi No. 42",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
