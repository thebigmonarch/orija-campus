
import '/flutter_flow/custom_functions.dart';

String passwordStrengthLabel(String password) {
  final score = passwordScore(password);

  switch (score) {
    case 0:
      return 'Very Weak';
    case 1:
      return 'Weak';
    case 2:
      return 'Fair';
    case 3:
      return 'Good';
    case 4:
      return 'Strong';
    default:
      return 'Very Weak';
  }
}
