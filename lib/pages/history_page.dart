import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/services/blockchain_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final BlockchainService _blockchainService = BlockchainService();
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final data = await _blockchainService.getHashHistory();
      if (!mounted) return;
      setState(() {
        historyList = data;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Gagal load history: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
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
                return ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(
                    '${item['jenis'].toUpperCase()} - ${item['jumlah']} ETH',
                  ),
                  subtitle: Text(item['hash']),
                  trailing: Text(
                    item['created_at'].toString().substring(0, 10),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}
