class PriceFormatter {
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String formatChange(double change) {
    final prefix = change >= 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(2)}';
  }

  static String formatPercentage(double percentage) {
    final prefix = percentage >= 0 ? '+' : '';
    return '$prefix${percentage.toStringAsFixed(2)}%';
  }
}