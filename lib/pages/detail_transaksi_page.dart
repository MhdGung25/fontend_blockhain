import 'package:flutter/material.dart';

class DetailTransaksiPage extends StatelessWidget {
  final String tanggal;
  final String waktu;
  final String jenis; // "Pemasukan" atau "Pengeluaran"
  final String kategori;
  final int jumlah;
  final String deskripsi;
  final String imageAsset;
  final String idHash;

  const DetailTransaksiPage({
    super.key,
    required this.tanggal,
    required this.waktu,
    required this.jenis,
    required this.kategori,
    required this.jumlah,
    required this.deskripsi,
    required this.imageAsset,
    required this.idHash,
  });

  @override
  Widget build(BuildContext context) {
    bool isPemasukan = jenis.toLowerCase() == 'pemasukan';

    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1931),
        title: const Text('Detail Transaksi'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelValue('Tanggal & Waktu', '$tanggal • $waktu'),
            const SizedBox(height: 16),

            _buildLabelValue('Jenis Transaksi', jenis),
            const SizedBox(height: 16),

            _buildLabelValue('Kategori', kategori),
            const SizedBox(height: 16),

            const Text('Jumlah', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              '${isPemasukan ? '+' : '-'} Rp ${jumlah.toString()}',
              style: TextStyle(
                color: isPemasukan ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),
            _buildLabelValue('Deskripsi', deskripsi),

            const SizedBox(height: 16),
            const Text(
              'Bukti Transaksi',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
            _buildLabelValue('ID Hash', idHash),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // TODO: Navigasi ke EditTransaksiPage
              },
              child: const Text('Edit Transaksi'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber,
                side: const BorderSide(color: Colors.amber),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // TODO: Hapus logika transaksi
              },
              child: const Text('Hapus Transaksi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
