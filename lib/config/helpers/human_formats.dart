import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: decimals,
    ).format(number);

    return formattedNumber;
  }
}
