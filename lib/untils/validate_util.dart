import 'package:rent_house/models/error_input_model.dart';

class ValidateUtil {
  static bool isValidEmail(String value) {
    var pattern = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isValidOTP(String value) {
    var pattern = r'^\d{6}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  // static bool isValidEmail2(String value) {
  //   var pattern = r"^[a-zA-Z0-9.a-zA-Z0-9]+@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$";
  //   RegExp regex = RegExp(pattern);
  //   return regex.hasMatch(value);
  // }

  static bool isValidPhone(String value) {
    RegExp regex = RegExp(r'(^(?:[+])?[0-9]{10}$)');
    return regex.hasMatch(value);
  }

  static bool isValidName(String value) {
    RegExp regex = RegExp(r'[0-9!@#\$%=^&*"()_+{}\[\]:;/<>,.?~\\]');
    RegExp myRegExp = RegExp(r"['-]");
    return !regex.hasMatch(value) && !myRegExp.hasMatch(value);
  }

  static bool isValidUrl(String url) {
    bool validURL = Uri.parse(url).isAbsolute;
    return validURL;
  }

  static bool validateRequiredPhoneNumber(String phoneNumber,
      {bool isOptional = false}) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (phoneNumber.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(phoneNumber)) {
      return false;
    } else {
      return true;
    }
  }

  static ErrorInputModel validateNonRequiredPhoneNumber(String phoneNumber,
      {bool isOptional = false}) {
    var option = ErrorInputModel();
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (phoneNumber.isEmpty) {
      option.isError = false;
      return option;
    } else if (!regExp.hasMatch(phoneNumber)) {
      option.isError = true;
      option.message = "Vui lòng nhập số điện thoại hợp lệ.";
      return option;
    } else {
      option.isError = false;
      option.message = "";
      return option;
    }
  }

  static bool validateRequiredEmailField(String email) {
    if (email.trim().isEmpty) {
      return false;
    } else if (email.contains(' ')) {
      return false;
    } else {
      if (!isValidEmail(email.trim())) {
        return false;
      } else {
        return true;
      }
    }
  }

  static bool isUpperCase(String string) {
    final pattern = RegExp(r'[A-Z]+');
    if (pattern.hasMatch(string)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSpecialOrNumberCharacter(String string) {
    var validCharacters =
    RegExp(r'[!@#\$%\^&*(),.?";:`{}|<>_+=~\[\]\\\/-0123456789]+');
    if (validCharacters.hasMatch(string)) {
      return true;
    } else {
      return false;
    }
  }

  static bool validateRequiredEmailAndPhoneNumberField(String email) {
    if (email.trim().isEmpty) {
      return false;
    } else {
      if (!isValidEmail(email.trim())) {
        return false;
      } else {
        return true;
      }
    }
  }

  static bool validateTaxNumber(String taxNumber) {
    String pattern = r'^\d{10,14}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(taxNumber);
  }

  static bool findSpecialCharacters(String text) {
    RegExp regExp = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
    return regExp.hasMatch(text);
  }

  static bool findSpecialDigits(String text) {
    RegExp regExp = RegExp(r'[0-9]');
    return regExp.hasMatch(text);
  }

  static String? validateTax(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return 'Vui lòng nhập thông tin';
    }
    if (value.length != 10 && value.length != 14) {
      return 'Vui lòng nhập đúng mã số thuế';
    }

    if (value.length == 10) {
      if (!ValidateUtil.isOnlyNumbers(value)) {
        return 'Vui lòng nhập đúng mã số thuế';
      }
    } else if (value.length != 14 || value[10] != '-') {
      return 'Vui lòng nhập đúng mã số thuế';
    }
    if (!ValidateUtil.isOnlyNumbers(value.replaceAll('-', ''))) {
      return 'Vui lòng nhập đúng mã số thuế';
    }
    return null;
  }

  static bool isOnlyNumbers(String input) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(input);
  }

  static bool isEAN13(String code) {
    RegExp regex = RegExp(r'^\d{13}$');
    var result = regex.hasMatch(code);
    return result;
  }

  static String? validateVietnamPhoneNumber(String value) {
    const String invalidFormatError = 'Số điện thoại của bạn sai định dạng, vui lòng thử lại';
    value = value.trim();
    if (value.isEmpty) {
      return 'Vui lòng nhập thông tin';
    }

    RegExp regExp = RegExp(r'^[0-9+]+$');
    if (!regExp.hasMatch(value)) {
      return invalidFormatError;
    }
    if (value.length < 10 || value.length > 12) {
      return invalidFormatError;
    }
    if (value.length == 10) {
      if (!value.startsWith('0') || value.contains('+')) {
        return invalidFormatError;
      }
    }
    if (value.length == 11) {
      if (!value.startsWith('84') || value.contains('+')) {
        return invalidFormatError;
      }
    }
    if (value.length == 12) {
      if (!value.startsWith('+84')) {
        return invalidFormatError;
      }
      if (value.replaceFirst("+", '').contains('+')) {
        return invalidFormatError;
      }
    }
    return null;
  }

  static String? validateSearchSuggest(String? suggest) {
    RegExp regex = RegExp(r'[\x00-\x1F\x7F]');
    var result = suggest?.replaceAll(regex, '');
    return result;
  }
}