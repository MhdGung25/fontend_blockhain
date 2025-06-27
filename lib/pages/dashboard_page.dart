import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String namaLengkap = '';
  String namaUsaha = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = prefs.getString('nama_lengkap') ?? 'Pengguna';
      namaUsaha = prefs.getString('nama_usaha') ?? 'UMKM Anda';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Halo, $namaLengkap',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                namaUsaha,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const Text(
                '20 Mei 2024',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Info cards
              _infoCard('Total Pemasukan Bulan Ini', 'Rp10.500.000'),
              const SizedBox(height: 12),
              _infoCard('Total Pengeluaran Bulan Ini', 'Rp 5.250.000'),
              const SizedBox(height: 12),
              _infoCard('Saldo Bersih', 'Rp 5.250.000'),
              const SizedBox(height: 24),

              // Menu Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _menuItem(Icons.add_circle, 'Tambah Transaksi'),
                    _menuItem(Icons.bar_chart, 'Laporan'),
                    _menuItem(Icons.account_balance_wallet, 'Akses Modal'),
                    _menuItem(Icons.receipt_long, 'Riwayat Transaksi'),
                  ],
                ),
              ),

              // Slider atau Footer
              const SizedBox(height: 16),
              Slider(
                value: 0.5,
                onChanged: (value) {},
                activeColor: Colors.yellow[700],
                inactiveColor: Colors.white24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF052B6C),
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF052B6C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Ganti dengan navigasi ke halaman masing-masing
          // Navigator.push(context, MaterialPageRoute(builder: (_) => TargetPage()));
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.yellow[700]),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
