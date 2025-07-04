import 'package:flutter/material.dart';
import 'package:frontend_blockhain/pages/login_page.dart';
import 'package:frontend_blockhain/pages/register_page.dart';
import 'package:frontend_blockhain/pages/forgot_password_page.dart';
import 'package:frontend_blockhain/pages/umkm_profile_page.dart';
import 'package:frontend_blockhain/pages/form_transaksi_page.dart';
import 'package:frontend_blockhain/pages/laporan_keuangan_page.dart';
import 'package:frontend_blockhain/pages/riwayat_transaksi_page.dart';
import 'package:frontend_blockhain/pages/dashboard_page.dart';
import 'package:frontend_blockhain/pages/pengajuan_diterima_page.dart';
import 'package:frontend_blockhain/pages/pengajuan_disetujui_page.dart';
import 'package:frontend_blockhain/pages/detail_transaksi_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const profile = '/profile';
  static const dashboard = '/dashboard';
  static const formTransaksi = '/form-transaksi';
  static const laporan = '/laporan';
  static const riwayat = '/riwayat';
  static const pengajuanDiterima = '/pengajuan-diterima';
  static const pengajuanDisetujui = '/pengajuan-disetujui';
  static const detailTransaksi = '/detail-transaksi';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    profile: (context) => const UmkmProfilePage(),
    dashboard: (context) => const DashboardPage(),
    formTransaksi: (context) => const FormTransaksiPage(),
    laporan: (context) => const LaporanKeuanganPage(),
    riwayat: (context) => const RiwayatTransaksiPage(),
    pengajuanDiterima: (context) => const PengajuanDiterimaPage(),
    pengajuanDisetujui: (context) => const PengajuanDisetujuiPage(),

    // Sementara diisi dummy data, harusnya dipanggil lewat push dengan parameter
    detailTransaksi: (context) => const DetailTransaksiPage(
      tanggal: '01 Januari 2025',
      waktu: '00:00 WIB',
      jenis: 'Pemasukan',
      kategori: 'Penjualan',
      jumlah: 0, // default safe value
      deskripsi: '-',
      imageAsset: 'assets/bukti_nota.png',
      idHash: '0x...',
    ),
  };
}
