import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_app/providers/stocks_provider.dart';

class StockSearchBar extends StatelessWidget {
  const StockSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search stocks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          Provider.of<StocksProvider>(context, listen: false).searchStock(value);
        },
      ),
    );
  }
}