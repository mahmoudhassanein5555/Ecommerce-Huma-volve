/// Reusable form validators — return an error message or null.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? name(String? value) =>
      (value == null || value.trim().isEmpty)
          ? 'Please enter your full name'
          : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    return _emailRegex.hasMatch(value.trim())
        ? null
        : 'Please enter a valid email';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return value.length < 6 ? 'Password must be at least 6 characters' : null;
  }
}
