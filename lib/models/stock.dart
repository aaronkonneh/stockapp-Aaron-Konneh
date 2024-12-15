class Stock {
  final String symbol;
  final double currentPrice;
  final double change;
  final double percentChange;

  Stock({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.percentChange,
  });
}