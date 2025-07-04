import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'form_transaksi_page.dart';
import 'laporan_keuangan_page.dart';
import 'riwayat_transaksi_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String namaLengkap = '';
  String namaUsaha = '';
  String tujuanUmkm = '';
  String pemasukan = 'Rp 0';
  String pengeluaran = 'Rp 0';
  String saldo = 'Rp 0';

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchDashboardData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = prefs.getString('nama_lengkap') ?? 'Pengguna';
      namaUsaha = prefs.getString('nama_usaha') ?? 'UMKM Anda';
      tujuanUmkm = prefs.getString('tujuan_umkm') ?? 'Tujuan belum diisi';
    });
  }

  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('http://127.0.0.1:8000/api/umkm/dashboard');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        pemasukan = 'Rp ${data['total_pemasukan']}';
        pengeluaran = 'Rp ${data['total_pengeluaran']}';
        saldo = 'Rp ${data['saldo']}';
      });
    } else {
      debugPrint('Gagal fetch dashboard: ${response.statusCode}');
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi sesuai index
    switch (index) {
      case 0:
        // Beranda
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormTransaksiPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LaporanKeuanganPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RiwayatTransaksiPage()),
        );
        break;
    }
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
              const SizedBox(height: 2),
              Text(
                'Tujuan: $tujuanUmkm',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 2),
              const Text(
                '20 Mei 2024',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),

              _infoCard('Total Pemasukan Bulan Ini', pemasukan),
              const SizedBox(height: 12),
              _infoCard('Total Pengeluaran Bulan Ini', pengeluaran),
              const SizedBox(height: 12),
              _infoCard('Saldo Bersih', saldo),
              const SizedBox(height: 24),

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

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1565C0), // Biru terang
        selectedItemColor: Colors.white, // Aktif: putih
        unselectedItemColor: Colors.white60, // Tidak aktif: putih transparan
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Modal',
          ),
        ],
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

  Widget _menuItem(IconData icon, String label, Widget? page) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF052B6C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
