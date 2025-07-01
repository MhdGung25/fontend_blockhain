import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TujuanPage extends StatefulWidget {
  final Map<String, dynamic> umkmData;

  const TujuanPage({super.key, required this.umkmData});

  @override
  State<TujuanPage> createState() => _TujuanPageState();
}

class _TujuanPageState extends State<TujuanPage> {
  final List<String> tujuanList = [
    "Mencatat transaksi harian",
    "Membuat laporan usaha",
    "Mengakses pembiayaan/ modal",
    "Monitoring arus kas",
    "Melihat perkembangan bisnis",
  ];

  List<bool> isCheckedList = [false, false, false, false, false];
  bool _isLoading = false;

  Future<void> _handleFinish() async {
    if (!isCheckedList.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu tujuan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final selectedTujuan = <String>[];
    for (int i = 0; i < tujuanList.length; i++) {
      if (isCheckedList[i]) {
        selectedTujuan.add(tujuanList[i]);
      }
    }

    final url = Uri.parse("http://127.0.0.1:8000/api/tujuan");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'umkm_id': widget.umkmData['id'],
          'tujuan': selectedTujuan,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tujuan berhasil disimpan')),
        );

        // Navigasi ke Dashboard setelah sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal kirim tujuan: ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052159),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Apa yang Ingin Anda Capai dengan Aplikasi Ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Image.asset('assets/register_illustration.png', height: 160),
              const SizedBox(height: 24),

              // Daftar Tujuan dengan Ceklis
              Column(
                children: List.generate(tujuanList.length, (index) {
                  return TujuanItem(
                    text: tujuanList[index],
                    isChecked: isCheckedList[index],
                    onChanged: (value) {
                      setState(() {
                        isCheckedList[index] = value!;
                      });
                    },
                  );
                }),
              ),
              const Spacer(),

              // Tombol Selesai
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleFinish,
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
                      : const Text("Selesai dan Masuk Dashboard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TujuanItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const TujuanItem({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: Colors.black,
            activeColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
