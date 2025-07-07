import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/auth/login_page.dart';
import 'package:frontend_blockhain/pages/auth/register_page.dart';
import 'package:frontend_blockhain/pages/dashboard/dashboard_page.dart';
import 'package:frontend_blockhain/pages/dashboard/detail_transaksi_page.dart';
import 'package:frontend_blockhain/pages/dashboard/form_transaksi_page.dart';
import 'package:frontend_blockhain/pages/dashboard/laporan_keuangan_page.dart';
import 'package:frontend_blockhain/pages/dashboard/riwayat_transaksi_page.dart';
import 'package:frontend_blockhain/pages/pengajuan/konfirmasi_pengajuan_page.dart';
import 'package:frontend_blockhain/pages/pengajuan/lokasi_bank_page.dart';
import 'package:frontend_blockhain/pages/pengajuan/pengajuan_diterima_page.dart';
import 'package:frontend_blockhain/pages/pengajuan/pengajuan_ditinjau_page.dart';
import 'package:frontend_blockhain/pages/profile/profil_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String formTransaksi = '/form-transaksi';
  static const String detailTransaksi = '/detail-transaksi';
  static const String laporanKeuangan = '/laporan-keuangan';
  static const String riwayatTransaksi = '/riwayat-transaksi';
  static const String profilUMKM = '/profil';
  static const String pengajuanDisetujui = '/pengajuan-disetujui';
  static const String pengajuanDitinjau = '/pengajuan-ditinjau';
  static const String konfirmasiPengajuan = '/konfirmasi-pengajuan';
  static const String lokasiBank = '/lokasi-bank';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case formTransaksi:
        return MaterialPageRoute(builder: (_) => const FormTransaksiPage());
      case detailTransaksi:
        return MaterialPageRoute(builder: (_) => const DetailTransaksiPage());
      case laporanKeuangan:
        return MaterialPageRoute(builder: (_) => const LaporanKeuanganPage());
      case riwayatTransaksi:
        return MaterialPageRoute(builder: (_) => const RiwayatTransaksiPage());
      case profilUMKM:
        return MaterialPageRoute(builder: (_) => const ProfilPage());
      case pengajuanDisetujui:
        return MaterialPageRoute(builder: (_) => const PengajuanDiterimaPage());
      case pengajuanDitinjau:
        return MaterialPageRoute(builder: (_) => const PengajuanDitinjauPage());
      case konfirmasiPengajuan:
        return MaterialPageRoute(
          builder: (_) => const KonfirmasiPengajuanPage(),
        );
      case lokasiBank:
        return MaterialPageRoute(builder: (_) => const LokasiBankPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("404 - Halaman tidak ditemukan")),
          ),
        );
    }
  }
}
