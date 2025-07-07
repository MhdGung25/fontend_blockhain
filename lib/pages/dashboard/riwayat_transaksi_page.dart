import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/services/api_service.dart';
import 'package:frontend_blockhain/pages/utils/helpers.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  late Future<List<Map<String, dynamic>>> _transaksiFuture;

  final Color primaryColor = const Color(0xFF0E2F56);

  @override
  void initState() {
    super.initState();
    _transaksiFuture = ApiService.getRiwayatTransaksi().then((data) {
      print("✅ Transaksi dimuat (${data.length} data):");
      for (var item in data) {
        final jenis = item['jenis'];
        final jumlah = item['jumlah'];
        final deskripsi = item['deskripsi'] ?? '-';
        print("• [$jenis] $deskripsi: $jumlah");
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transaksiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final transaksi = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: transaksi.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = transaksi[index];
                final jumlah = int.tryParse(item['jumlah'].toString()) ?? 0;
                final jenis = item['jenis'] ?? 'pemasukan';
                final isPemasukan = jenis == 'pemasukan';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      item['deskripsi'] ?? 'Transaksi',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      item['created_at']?.substring(0, 10) ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      (isPemasukan ? '+' : '-') + formatRupiah(jumlah),
                      style: TextStyle(
                        color: isPemasukan ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
