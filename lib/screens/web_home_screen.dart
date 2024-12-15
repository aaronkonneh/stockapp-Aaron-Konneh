import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:stocks_app/providers/stocks_provider.dart';
import 'package:stocks_app/widgets/news_feed.dart';
import 'package:stocks_app/widgets/search_bar.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current date and format it
    String currentDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Stocks'), // Main title
            Text(
              currentDate, // Display the current date below the title
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const StockSearchBar(),
                Consumer<StocksProvider>(
                  builder: (context, stocksProvider, child) {
                    return Expanded(
                      child: StockList(
                        stocks: stocksProvider.isSearching
                            ? stocksProvider.searchResults
                            : stocksProvider.defaultStocks,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          const Expanded(
            flex: 1,
            child: NewsFeed(),
          ),
        ],
      ),
    );
  }
}
