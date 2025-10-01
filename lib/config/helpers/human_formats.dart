import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 0,
    ).format(number);

    return formattedNumber;
  }
}
