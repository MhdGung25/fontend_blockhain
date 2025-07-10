import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final data = await getHashHistory();
      if (!mounted) return;
      setState(() {
        historyList = data;
        isLoading = false;
      });

      print("📦 Riwayat hash diterima (${data.length} data):");
      for (var item in data) {
        final jenis = item['jenis'];
        final jumlah = item['jumlah'];
        final deskripsi = item['deskripsi'] ?? '-';
        print("• [$jenis] $deskripsi: $jumlah");
      }
    } catch (e) {
      print('❌ Gagal load history: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> getHashHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/blockchain/history'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception("Gagal mengambil riwayat hash");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi Blockchain"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
          ? const Center(child: Text("Belum ada transaksi."))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final jumlah =
                    double.tryParse(item['jumlah'].toString()) ?? 0.0;
                final jenis = item['jenis'].toString().toUpperCase();
                final tanggal =
                    item['created_at']?.toString().substring(0, 10) ?? '-';

                return ListTile(
                  leading: Icon(
                    jenis == 'PEMASUKAN' ? Icons.download : Icons.upload,
                    color: jenis == 'PEMASUKAN' ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    '$jenis - ${jumlah.toStringAsFixed(4)} ETH',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['deskripsi']?.toString().isNotEmpty == true
                        ? item['deskripsi']
                        : item['hash'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    tanggal,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
