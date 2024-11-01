import 'package:intl/intl.dart';
class FormatUtil {
  FormatUtil._();

  static int roundToMillion(int price) {
    return (price / 1000000).round();
  }

  static String formatCurrency(int amount) {
    final NumberFormat formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(amount)} đ';
  }

  static String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (phoneNumber.length >= 11) {
      return '+${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 8)} ${phoneNumber.substring(8)}';
    }
    return phoneNumber;
  }

  static String formatToDayMonthYearTime(String isoTime) {
    DateTime dateTime = DateTime.parse(isoTime).toLocal();
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}