import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/services/finnhub_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StocksProvider with ChangeNotifier {
  final FinnhubService _finnhubService = FinnhubService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Stock> _defaultStocks = [];
  List<Stock> _searchResults = [];
  List<String> _favoriteSymbols = [];
  bool _isSearching = false;

  List<Stock> get defaultStocks => _defaultStocks;
  List<Stock> get searchResults => _searchResults;
  List<String> get favoriteSymbols => _favoriteSymbols;
  bool get isSearching => _isSearching;

  StocksProvider() {
    _initializeStocks();
    _loadFavorites(); // Load favorites when provider is initialized
  }

  /// Initialize default stocks
  Future<void> _initializeStocks() async {
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA'];

    _defaultStocks = await Future.wait(
      symbols.map((symbol) async {
        final stock = await _finnhubService.getStockQuote(symbol);
        if (stock == null) {
          throw Exception('Failed to load stock data for $symbol');
        }
        return stock;
      }),
    );
    notifyListeners();
  }

  /// Load favorite stocks for the current user
  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data();
      if (data != null && data['favorites'] is List) {
        _favoriteSymbols = List<String>.from(data['favorites']);
      } else {
        _favoriteSymbols = []; // Initialize if no favorites field exists
      }
    } else {
      _favoriteSymbols = []; // No logged-in user
    }
    notifyListeners();
  }

  /// Save the updated favorite stocks to Firestore
  Future<void> _saveFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'favorites': _favoriteSymbols,
      }, SetOptions(merge: true)); // Merge to preserve other fields
    }
  }

  /// Clear the favorite stocks locally (called when the user signs out)
  void clearFavorites() {
    _favoriteSymbols = []; // Clear the local list only
    notifyListeners();
  }

  /// Toggle favorite status for a stock symbol
  Future<void> toggleFavorite(String symbol) async {
    if (_favoriteSymbols.contains(symbol)) {
      _favoriteSymbols.remove(symbol);
    } else if (_favoriteSymbols.length < 3) {
      _favoriteSymbols.add(symbol);

      // Check if the stock exists in defaultStocks; if not, fetch it
      if (_defaultStocks.every((stock) => stock.symbol != symbol)) {
        final newStock = await _finnhubService.getStockQuote(symbol);
        if (newStock != null) {
          _defaultStocks.add(newStock);
        }
      }
    }
    await _saveFavorites();
    notifyListeners();
  }

  /// Check if a stock is in the favorite list
  bool isFavorite(String symbol) => _favoriteSymbols.contains(symbol);

  /// Reload favorites when the user logs in
  Future<void> reloadFavorites() async {
    await _loadFavorites(); // Fetch the favorites from Firestore
    notifyListeners();
  }

  /// Search for a stock by query
  Future<void> searchStock(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
    } else {
      _isSearching = true;

      final stock = await _finnhubService.getStockQuote(query.toUpperCase());
      _searchResults = stock != null ? [stock] : [];
    }
    notifyListeners();
  }
}
