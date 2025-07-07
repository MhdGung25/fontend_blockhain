import 'package:intl/intl.dart';

String formatRupiah(int number) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return format.format(number);
}
