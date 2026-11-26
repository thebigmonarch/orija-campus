

bool hasNumber(String password) {
  return RegExp(r'\d').hasMatch(password);
}
