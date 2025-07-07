import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Ubah jika deploy

  // Fungsi untuk ambil data keuangan
  static Future<Map<String, dynamic>> getKeuanganData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/keuangan'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMsg = 'Gagal memuat data keuangan';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) {
          errorMsg = body['message'];
        }
      } catch (_) {
        // Gagal decode body? kemungkinan bukan JSON.
        errorMsg = 'Response bukan format JSON';
      }
      throw Exception(errorMsg);
    }
  }

  static Future<List<Map<String, dynamic>>> getRiwayatTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/transaksi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil riwayat transaksi');
    }
  }
}
