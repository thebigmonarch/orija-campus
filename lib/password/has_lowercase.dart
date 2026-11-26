

bool hasLowercase(String password) {
  return RegExp(r'[a-z]').hasMatch(password);
}
