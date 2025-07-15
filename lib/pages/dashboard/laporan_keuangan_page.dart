// LaporanKeuanganPage dengan tombol tambah dan update otomatis

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend_blockhain/pages/utils/helpers.dart';

class LaporanKeuanganPage extends StatefulWidget {
  const LaporanKeuanganPage({super.key});

  @override
  State<LaporanKeuanganPage> createState() => _LaporanKeuanganPageState();
}

class _LaporanKeuanganPageState extends State<LaporanKeuanganPage> {
  int pemasukan = 0;
  int pengeluaran = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    fetchLaporanKeuangan();
  }

  Future<void> fetchLaporanKeuangan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception("Token tidak ditemukan.");

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/keuangan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200)
        throw Exception("Status: ${response.statusCode}");

      final data = jsonDecode(response.body);

      setState(() {
        pemasukan = (double.tryParse(data['pemasukan'].toString()) ?? 0)
            .toInt();
        pengeluaran = (double.tryParse(data['pengeluaran'].toString()) ?? 0)
            .toInt();
        history = List<Map<String, dynamic>>.from(data['history'] ?? []);
        isLoading = false;
      });
    } catch (e) {
      print("❌ Gagal ambil laporan: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat data keuangan")),
      );
    }
  }

  Future<void> tambahCatatan() async {
    String? jenis;
    final jumlahController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Catatan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: jenis,
              items: const [
                DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                DropdownMenuItem(
                  value: 'pengeluaran',
                  child: Text('Pengeluaran'),
                ),
              ],
              onChanged: (value) => jenis = value,
              decoration: const InputDecoration(labelText: "Jenis"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (jenis == null || jumlahController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mohon isi semua data")),
                );
                return;
              }
              Navigator.pop(context);
              await submitCatatan(jenis!, jumlahController.text);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Future<void> submitCatatan(String jenis, String jumlah) async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/keuangan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {'jenis': jenis, 'jumlah': jumlah},
      );

      if (response.statusCode == 201) {
        await fetchLaporanKeuangan();
      } else {
        final result = jsonDecode(response.body);
        throw Exception(result['message'] ?? 'Gagal tambah catatan');
      }
    } catch (e) {
      print("❌ Gagal tambah catatan: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal tambah catatan: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2F56),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Laporan Keuangan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatItem(
                      "Pemasukan",
                      formatRupiah(pemasukan),
                      Colors.green,
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem(
                      "Pengeluaran",
                      formatRupiah(pengeluaran),
                      Colors.red,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Grafik & Analisis Keuangan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: history.isEmpty
                          ? const Center(child: Text("Data belum tersedia"))
                          : BarChart(
                              BarChartData(
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() < history.length) {
                                          final label =
                                              history[value.toInt()]['jenis'] ??
                                              '';
                                          return Text(
                                            label.toString()[0].toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                barGroups: history.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  final jumlah =
                                      double.tryParse(
                                        item['jumlah'].toString(),
                                      ) ??
                                      0;
                                  final isPemasukan =
                                      item['jenis'] == 'pemasukan';

                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: jumlah,
                                        color: isPemasukan
                                            ? Colors.green
                                            : Colors.red,
                                        width: 14,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
