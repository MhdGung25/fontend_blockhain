import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
import 'package:frontend_blockhain/pages/utils/constants.dart';

class TujuanPage extends StatefulWidget {
  const TujuanPage({super.key});

  @override
  State<TujuanPage> createState() => _TujuanPageState();
}

class _TujuanPageState extends State<TujuanPage> {
  int? selected;

  final List<String> tujuan = [
    "Pencatatan Keuangan Sederhana",
    "Melacak Arus Kas",
    "Mengajukan Modal Usaha",
    "Melihat Laporan Usaha",
  ];

  void handleLanjut() {
    // TODO: Kirim pilihan ke backend jika perlu
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Apa yang Ingin Anda Capai\nDengan Aplikasi Ini?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(tujuan.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selected,
                onChanged: (val) => setState(() => selected = val),
                title: Text(
                  tujuan[index],
                  style: const TextStyle(color: Colors.white),
                ),
                activeColor: Colors.orange,
              );
            }),
            const SizedBox(height: 24),
            CustomButton(text: "Lanjut ke Dashboard", onPressed: handleLanjut),
          ],
        ),
      ),
    );
  }
}
