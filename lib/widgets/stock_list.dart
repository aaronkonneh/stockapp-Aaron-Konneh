import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;

  const StockList({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return ListTile(
          title: Text(stock.symbol),
          subtitle: Text('\$${stock.currentPrice.toStringAsFixed(2)}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)}',
                style: TextStyle(
                  color: stock.change >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                '${stock.percentChange >= 0 ? '+' : ''}${stock.percentChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: stock.percentChange >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}