import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/routes/app_routes.dart';
import 'package:frontend_blockhain/pages/services/api_service.dart';
import 'package:frontend_blockhain/pages/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_blockhain/pages/services/blockchain_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = "Pengguna";
  String email = "-";
  int userId = 0;

  int pemasukan = 0;
  int pengeluaran = 0;
  int saldo = 0;

  String namaUsaha = "-";
  String jenisUsaha = "-";
  String tahunBerdiri = "-";
  String alamatUsaha = "-";

  bool isLoadingKeuangan = true;
  bool isLoadingHash = true;
  List<Map<String, dynamic>> hashHistory = [];

  final Color primaryColor = const Color(0xFF0E2F56);
  final Color accentColor = Colors.orange;
  final BlockchainService _blockchainService = BlockchainService();

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadKeuanganData();
    fetchUMKMProfile();
    fetchHashHistory();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Pengguna';
      email = prefs.getString('email') ?? '-';
      userId = prefs.getInt('user_id') ?? 0;
    });
  }

  Future<void> loadKeuanganData() async {
    try {
      final data = await ApiService.getKeuanganData();
      setState(() {
        pemasukan = (double.tryParse(data['pemasukan'].toString()) ?? 0)
            .toInt();
        pengeluaran = (double.tryParse(data['pengeluaran'].toString()) ?? 0)
            .toInt();
        saldo = pemasukan - pengeluaran;
        isLoadingKeuangan = false;
      });
    } catch (e) {
      setState(() => isLoadingKeuangan = false);
      print('❌ Gagal load keuangan: $e');
    }
  }

  Future<void> fetchUMKMProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception("Token tidak ditemukan");

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/profil-umkm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          namaUsaha = data['nama_usaha'] ?? '-';
          jenisUsaha = data['jenis_usaha'] ?? '-';
          tahunBerdiri = data['tahun_berdiri'] ?? '-';
          alamatUsaha = data['alamat'] ?? '-';
        });
      } else {
        print("⚠️ Gagal ambil profil UMKM, kode: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error ambil profil UMKM: $e");
    }
  }

  Future<void> fetchHashHistory() async {
    try {
      final data = await _blockchainService.getHashHistory();
      setState(() {
        hashHistory = data;
        isLoadingHash = false;
      });
    } catch (e) {
      print("❌ Gagal ambil hash blockchain: $e");
      setState(() => isLoadingHash = false);
    }
  }

  Future<void> handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  void refreshAllData() {
    loadKeuanganData();
    fetchHashHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Halo, $userName",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: accentColor),
              accountName: Text(
                userName,
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 30, color: Colors.orange),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.person,
              "Profil",
              AppRoutes.profilUMKM,
            ),
            _buildDrawerItem(
              context,
              Icons.list,
              "Riwayat Transaksi",
              AppRoutes.riwayatTransaksi,
            ),
            _buildDrawerItem(
              context,
              Icons.insert_chart,
              "Laporan Keuangan",
              AppRoutes.laporanKeuangan,
            ),
            const Divider(color: Colors.white70),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => handleLogout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildProfilUMKMCard(),
            const SizedBox(height: 16),
            _buildKeuanganCard(),
            const SizedBox(height: 24),
            _buildBlockchainHistorySection(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuItem(
                  context,
                  Icons.add_circle,
                  "Catat",
                  AppRoutes.formTransaksi,
                ),
                _menuItem(
                  context,
                  Icons.list_alt,
                  "Riwayat",
                  AppRoutes.riwayatTransaksi,
                ),
                _menuItem(
                  context,
                  Icons.insert_chart,
                  "Laporan",
                  AppRoutes.laporanKeuangan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeuanganCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: isLoadingKeuangan
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  formatRupiah(saldo),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Total Saldo"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text("Pemasukan"),
                        Text(
                          formatRupiah(pemasukan),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Pengeluaran"),
                        Text(
                          formatRupiah(pengeluaran),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildBlockchainHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Riwayat Blockchain Terbaru",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        isLoadingHash
            ? const Center(child: CircularProgressIndicator())
            : hashHistory.isEmpty
            ? const Text("Belum ada transaksi blockchain.")
            : Column(
                children: hashHistory.take(3).map((item) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text('${item['jenis']} - ${item['jumlah']} ETH'),
                      subtitle: Text(item['hash']),
                      trailing: Text(
                        item['created_at'].toString().substring(0, 10),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildProfilUMKMCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profil UMKM",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Nama Usaha: $namaUsaha"),
          Text("Jenis Usaha: $jenisUsaha"),
          Text("Tahun Berdiri: $tahunBerdiri"),
          Text("Alamat: $alamatUsaha"),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: 28, color: Colors.white),
            onPressed: () async {
              if (route == AppRoutes.formTransaksi) {
                await Navigator.pushNamed(context, route);
                refreshAllData();
              } else {
                Navigator.pushNamed(context, route);
              }
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
