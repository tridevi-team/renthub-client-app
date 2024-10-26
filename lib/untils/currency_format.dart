import 'package:intl/intl.dart';
class CurrencyFormat {

  static int roundToMillion(int price) {
    return (price / 1000000).round();
  }

  static String formatCurrency(int amount) {
    final NumberFormat formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(amount)} đ';
  }
}