import 'package:intl/intl.dart';

String formatNumber(int number, String currency, bool showCurrency) {
  String formattedNumber = NumberFormat('#,##0').format(number);
  if (showCurrency) {
    return '$currency $formattedNumber';
  }
  return formattedNumber;
}

String formatNumberDecimal(double number, String currency, bool showCurrency) {
  String formattedNumber = NumberFormat('#,##0.00').format(number);
  if (showCurrency) {
    return '$currency $formattedNumber';
  }
  return formattedNumber;
}
