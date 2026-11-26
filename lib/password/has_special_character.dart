

bool hasSpecialCharacter(String password) {
  return RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\/~`]').hasMatch(password);
}
