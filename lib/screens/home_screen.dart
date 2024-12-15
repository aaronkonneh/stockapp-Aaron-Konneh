import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:stocks_app/providers/stocks_provider.dart';
import 'package:stocks_app/widgets/news_feed.dart';
import 'package:stocks_app/widgets/search_bar.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore access

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> _fetchUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data()!['fullName'] ?? 'User';
      } else {
        debugPrint('User document not found.');
        return 'User'; // Fallback if no data
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
      return 'User'; // Fallback on error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date and format it
    String currentDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    final authService = Provider.of<AuthService>(context, listen: false);
    final stocksProvider = Provider.of<StocksProvider>(context, listen: false);
    final userId = authService.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Unable to fetch user information.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Reload favorites when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await stocksProvider.reloadFavorites();
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stocks'), // Main title
            Text(
              currentDate, // Display the current date below the title
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ],
        ),
        actions: [
          FutureBuilder<String>(
            future: _fetchUserName(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              final userName = snapshot.data ?? 'User';
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Hello, $userName!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      // Clear favorites before signing out
                      stocksProvider.clearFavorites();

                      await authService.signOut();
                    },
                    icon: const Icon(Icons.logout),
                    color: Colors.grey, // Optional: Make the icon gray
                    tooltip: 'Sign Out',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const StockSearchBar(),
          Expanded(
            child: Consumer<StocksProvider>(
              builder: (context, stocksProvider, child) {
                return stocksProvider.isSearching
                    ? ListView.builder(
                        itemCount: stocksProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          final stock = stocksProvider.searchResults[index];
                          return _buildStockRow(
                            context,
                            stock,
                            isFavorite: stocksProvider.isFavorite(stock.symbol),
                            onToggleFavorite: () =>
                                stocksProvider.toggleFavorite(stock.symbol),
                          );
                        },
                      )
                    : Column(
                        children: [
                          // Favorite Watchlist Section
                          if (stocksProvider.favoriteSymbols.isNotEmpty)
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Favorite Watchlist',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          stocksProvider.favoriteSymbols.length,
                                      itemBuilder: (context, index) {
                                        final symbol = stocksProvider
                                            .favoriteSymbols[index];
                                        final stock = stocksProvider
                                            .defaultStocks
                                            .firstWhere(
                                          (s) => s.symbol == symbol,
                                          orElse: () => Stock(
                                            symbol: symbol,
                                            currentPrice: 0.0,
                                            change: 0.0,
                                            percentChange: 0.0,
                                          ),
                                        );

                                        return _buildStockRow(
                                          context,
                                          stock,
                                          isFavorite: true,
                                          onToggleFavorite: () => stocksProvider
                                              .toggleFavorite(stock.symbol),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Default Stock List
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: stocksProvider.defaultStocks.length,
                              itemBuilder: (context, index) {
                                final stock =
                                    stocksProvider.defaultStocks[index];

                                return _buildStockRow(
                                  context,
                                  stock,
                                  isFavorite:
                                      stocksProvider.isFavorite(stock.symbol),
                                  onToggleFavorite: () => stocksProvider
                                      .toggleFavorite(stock.symbol),
                                );
                              },
                            ),
                          ),
                          // News Feed Section
                          Expanded(
                            flex: 1,
                            child: const NewsFeed(),
                          ),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockRow(
    BuildContext context,
    Stock stock, {
    required bool isFavorite,
    required VoidCallback onToggleFavorite,
  }) {
    return ListTile(
      title: Text(stock.symbol),
      subtitle: Text(
        'Price: \$${stock.currentPrice.toStringAsFixed(2)} | Change: ${stock.change.toStringAsFixed(2)} (${stock.percentChange.toStringAsFixed(2)}%)',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
          ),
          if (isFavorite)
            IconButton(
              onPressed: onToggleFavorite,
              icon: const Icon(Icons.remove_circle, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
