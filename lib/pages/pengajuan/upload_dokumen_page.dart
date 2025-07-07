import 'package:flutter/material.dart';

class UploadDokumenPage extends StatelessWidget {
  const UploadDokumenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Upload Dokumen",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Silakan unggah dokumen pendukung",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Drop / Upload File",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text("Upload")),
          ],
        ),
      ),
    );
  }
}
