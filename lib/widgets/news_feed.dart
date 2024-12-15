import 'package:flutter/material.dart';
import 'package:stocks_app/models/news.dart';
import 'package:stocks_app/services/finnhub_service.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final FinnhubService _finnhubService = FinnhubService();
  List<News> _news = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final news = await _finnhubService.getMarketNews();
    if (mounted) {
      // Check if the widget is still mounted before calling setState
      setState(() {
        _news = news;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Latest News',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _news.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _news.length,
                  itemBuilder: (context, index) {
                    final news = _news[index];
                    return ListTile(
                      title: Text(
                        news.headline,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        news.source,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
