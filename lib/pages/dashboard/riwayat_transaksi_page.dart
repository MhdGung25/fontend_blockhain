import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/services/api_service.dart';
import 'package:frontend_blockhain/pages/utils/helpers.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _transaksiFuture;
  List<Map<String, dynamic>> _allTransaksi = [];

  late TabController _tabController;

  final Color primaryColor = const Color.fromARGB(255, 6, 71, 141);

  @override
  void initState() {
    super.initState();
    _fetchData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _fetchData() {
    _transaksiFuture = ApiService.getRiwayatTransaksi().then((data) {
      setState(() {
        _allTransaksi = data;
      });
      return data;
    });
  }

  List<Map<String, dynamic>> _filterTransaksi(String jenis) {
    return _allTransaksi.where((item) => item['jenis'] == jenis).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Riwayat Transaksi"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pemasukan"),
            Tab(text: "Pengeluaran"),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchData),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transaksiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                '❌ Gagal memuat data.\nSilakan coba lagi nanti.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              _buildRingkasan(),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListView("pemasukan"),
                    _buildListView("pengeluaran"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(String jenis) {
    final data = _filterTransaksi(jenis);

    if (data.isEmpty) {
      return const Center(child: Text("Tidak ada transaksi."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final jumlah = int.tryParse(item['jumlah'].toString()) ?? 0;
        final deskripsi = item['deskripsi'] ?? 'Transaksi';
        final createdAt = item['created_at']?.substring(0, 10) ?? '-';
        final hash = item['hash'] ?? 'Belum diverifikasi';
        final hashStatus = hash == 'Belum diverifikasi' || hash == 'null'
            ? '⛔ Belum diverifikasi'
            : '✅ $hash';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(
              jenis == 'pemasukan' ? Icons.arrow_downward : Icons.arrow_upward,
              color: jenis == 'pemasukan' ? Colors.green : Colors.red,
            ),
            title: Text(
              deskripsi,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tanggal: $createdAt"),
                Text("Hash: $hashStatus", style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: Text(
              (jenis == 'pemasukan' ? '+ ' : '- ') + formatRupiah(jumlah),
              style: TextStyle(
                color: jenis == 'pemasukan' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRingkasan() {
    int pemasukan = 0;
    int pengeluaran = 0;

    for (var item in _allTransaksi) {
      int jumlah = int.tryParse(item['jumlah'].toString()) ?? 0;
      if (item['jenis'] == 'pemasukan') {
        pemasukan += jumlah;
      } else if (item['jenis'] == 'pengeluaran') {
        pengeluaran += jumlah;
      }
    }

    final saldo = pemasukan - pengeluaran;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard("Pemasukan", pemasukan, Colors.green),
          _buildSummaryCard("Pengeluaran", pengeluaran, Colors.red),
          _buildSummaryCard("Saldo", saldo, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          formatRupiah(value),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
