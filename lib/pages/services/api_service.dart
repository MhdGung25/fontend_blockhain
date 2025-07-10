import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Ubah saat deploy

  // Fungsi untuk ambil data keuangan
  static Future<Map<String, dynamic>> getKeuanganData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/keuangan'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal fetch keuangan: ${res.statusCode}");
    }

    final body = jsonDecode(res.body);
    return body['data'] ?? {}; // return Map kosong jika null
  }

  // Fungsi untuk ambil riwayat transaksi
  static Future<List<Map<String, dynamic>>> getRiwayatTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/transaksi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> dataList = decoded is List
          ? decoded
          : decoded['data'] ?? [];

      return dataList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil riwayat transaksi');
    }
  }
}
