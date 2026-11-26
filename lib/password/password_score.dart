

int passwordScore(String password) {
  int score = 0;

  if (password.length >= 8) score++;

  if (RegExp(r'[A-Z]').hasMatch(password) &&
      RegExp(r'[a-z]').hasMatch(password)) {
    score++;
  }

  if (RegExp(r'\d').hasMatch(password)) {
    score++;
  }

  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\/~`]').hasMatch(password)) {
    score++;
  }

  return score;
}
