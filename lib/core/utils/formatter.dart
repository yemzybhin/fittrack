class Formatter {
  static String formatK(num number) {
    if (number >= 0 && number < 1000) {
      return number.toStringAsFixed(2);
    } else if (number >= 1000 && number < 1000000) {
      double result = number / 1000;
      return '${result.toStringAsFixed(1)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      double result = number / 1000000;
      return '${result.toStringAsFixed(2)}M';
    } else if (number >= 1000000000) {
      double result = number / 1000000000;
      return '${result.toStringAsFixed(2)}B';
    } else {
      return 'Invalid Input';
    }
  }
}
