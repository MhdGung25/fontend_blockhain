import 'package:flutter/material.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksi = [
      {
        'tanggal': '12 Jun 2025',
        'judul': 'Penjualan Toko',
        'keterangan': 'Transaksi langsung',
        'jumlah': 150000,
        'tipe': 'masuk',
      },
      {
        'tanggal': '10 Jun 2025',
        'judul': 'Pembayaran Utang',
        'keterangan': 'Pelunasan faktur #123',
        'jumlah': 20000,
        'tipe': 'keluar',
      },
      {
        'tanggal': '8 Jun 2025',
        'judul': 'Pendapatan Online',
        'keterangan': 'Penjualan bulan Mei+',
        'jumlah': 1200000,
        'tipe': 'masuk',
      },
      {
        'tanggal': '5 Jun 2025',
        'judul': 'Beli Bahan Baku',
        'keterangan': 'Pembelian dari supplier',
        'jumlah': 50000,
        'tipe': 'keluar',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1931),
        title: const Text('Riwayat Transaksi'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Aksi mulai catat
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Mulai Catat Sekarang'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: transaksi.length,
                itemBuilder: (context, index) {
                  final item = transaksi[index];
                  final isMasuk = item['tipe'] == 'masuk';
                  final color = isMasuk ? Colors.green : Colors.red;

                  return Card(
                    color: const Color(0xFF112B55),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        item['judul'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item['keterangan'].toString(),
                        style: TextStyle(color: color),
                      ),
                      leading: Text(
                        item['tanggal'].toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        "${isMasuk ? '+' : '-'} Rp${item['jumlah'].toString()}",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
