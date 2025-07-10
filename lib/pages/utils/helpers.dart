String formatRupiah(dynamic value) {
  final intValue = int.tryParse(value.toString()) ?? 0;
  return 'Rp ${intValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}
