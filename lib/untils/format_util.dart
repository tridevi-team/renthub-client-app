import 'package:intl/intl.dart';
class FormatUtil {
  FormatUtil._();

  static String roundToMillion(int price) {
    double rounded = (price / 100000).roundToDouble() / 10;
    final formatter = NumberFormat("##0.0", "vi");
    return formatter.format(rounded);
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

  static String formatToDayMonthYearTime(String? isoTime) {
    if (isoTime?.isEmpty ?? true) return "";
    DateTime dateTime = DateTime.parse(isoTime!).toLocal();
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatToDayMonthYear(String? isoTime) {
    if (isoTime?.isEmpty ?? true) return "";
    DateTime dateTime = DateTime.parse(isoTime!).toLocal();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth?.length != 8) {
      return "Invalid date format";
    }

    String day = dateOfBirth!.substring(0, 2);
    String month = dateOfBirth.substring(2, 4);
    String year = dateOfBirth.substring(4, 8);

    try {
      DateTime dob = DateTime.parse("$year-$month-$day");

      return DateFormat('dd/MM/yyyy').format(dob);
    } catch (e) {
      return "Invalid date format";
    }
  }
}