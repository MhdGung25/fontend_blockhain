import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BlockchainService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  /// Kirim hash transaksi ke Laravel backend
  Future<bool> sendHashToBackend({
    required String hash,
    required String jenis, // 'pemasukan' atau 'pengeluaran'
    required double jumlah,
    String? deskripsi,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('🔒 Token tidak ditemukan. Harap login terlebih dahulu.');
        return false;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/store-hash'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'hash': hash,
          'jenis': jenis,
          'jumlah': jumlah,
          'deskripsi': deskripsi ?? '',
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Hash berhasil disimpan!');
        return true;
      } else {
        print('❌ Gagal simpan hash: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('❌ Error saat kirim hash: $e');
      return false;
    }
  }

  /// Ambil riwayat hash dari Laravel backend
  Future<List<Map<String, dynamic>>> getHashHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('🔒 Token tidak ditemukan.');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/hash-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        print('❌ Gagal ambil riwayat hash: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (e) {
      print('❌ Error saat ambil history: $e');
      return [];
    }
  }
}
