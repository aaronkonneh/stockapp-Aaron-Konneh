class News {
  final String headline;
  final String summary;
  final String url;
  final String source;

  News({
    required this.headline,
    required this.summary,
    required this.url,
    required this.source,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? '',
    );
  }
}