import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class TujuanPage extends StatefulWidget {
  const TujuanPage({super.key});

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

  void _handleFinish() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // Navigasi ke halaman Dashboard / Beranda
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
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
                'Apa yang Ingin Anda Capai dengan Aplikasi Ini ?',
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
