import 'package:email_validator/email_validator.dart';

class Validator {
  static String? validateEmail(String value) {
    if (value.isEmpty) return "Required";
    if (!EmailValidator.validate(value)) {
      return "Invalid email";
    }
    return null;
  }

  static String? validateEmpty(String value) {
    if (value.isEmpty) return "Required";
    return null;
  }

  static String? confirmPassword(String confirmPass, String origPass) {
    if (confirmPass.isEmpty) return "Required";
    if (confirmPass.trim() != origPass.trim()) {
      return "Password does not match";
    }
    return null;
  }
}
