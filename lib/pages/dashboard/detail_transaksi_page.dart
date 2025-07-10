import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  // Method to format number to Rupiah currency
  String formatRupiah(int amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = formatRupiah(2500000); // will become Rp2.500.000
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Center(child: Text(formatted)),
    );
  }
}
