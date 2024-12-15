import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/news.dart';

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = 'ctf5eu9r01qngiddatvgctf5eu9r01qngiddau00';

  Future<Stock?> getStockQuote(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Stock(
          symbol: symbol,
          currentPrice: data['c'].toDouble(),
          change: data['d'].toDouble(),
          percentChange: data['dp'].toDouble(),
        );
      }
    } catch (e) {
      print('Error fetching stock quote: $e');
    }
    return null;
  }

  Future<List<News>> getMarketNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/news?category=general&token=$_apiKey'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.take(5).map((item) => News.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error fetching market news: $e');
    }
    return [];
  }
}