import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPengajuanPage extends StatefulWidget {
  const AdminPengajuanPage({super.key});

  @override
  State<AdminPengajuanPage> createState() => _AdminPengajuanPageState();
}

class _AdminPengajuanPageState extends State<AdminPengajuanPage> {
  List pengajuanList = [];
  String? token; // isi token dari SharedPreferences

  @override
  void initState() {
    super.initState();
    fetchPengajuan();
  }

  Future<void> fetchPengajuan() async {
    // Ambil token dari SharedPreferences (kalau sudah login)
    // Misalnya:
    // final prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/pengajuan/all'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pengajuanList = data['data'];
      });
    } else {
      print('Gagal mengambil data pengajuan: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Pengajuan UMKM")),
      body: ListView.builder(
        itemCount: pengajuanList.length,
        itemBuilder: (context, index) {
          final item = pengajuanList[index];
          return ListTile(
            title: Text('Jumlah: Rp${item['jumlah']}'),
            subtitle: Text('${item['alasan']} - Status: ${item['status']}'),
            trailing: Text(item['bank']),
          );
        },
      ),
    );
  }
}
