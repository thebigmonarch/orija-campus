

bool hasUppercase(String password) {
  return RegExp(r'[A-Z]').hasMatch(password);
}
