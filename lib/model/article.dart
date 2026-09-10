class Article {
  const Article({
    required this.title,
    required this.summary,
    required this.source,
    required this.country,
    required this.topic,
    required this.link,
    required this.published,
    this.minutes,
  });

  final String title;
  final String summary;
  final String source;
  final String country;
  final String topic;
  final String link;
  final String published;
  final String? minutes;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] as String? ?? 'Untitled story',
        summary: json['summary'] as String? ?? '',
        source: json['source'] as String? ?? 'Source',
        country: json['country'] as String? ?? '',
        topic: json['topic'] as String? ?? 'Top Stories',
        link: json['link'] as String? ?? '#',
        published: json['published'] as String? ?? 'Recently',
        minutes: json['minutes'] as String?,
      );
}
