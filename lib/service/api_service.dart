import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unganishwa_mobile/model/article.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const defaultBaseUrl = 'http://10.0.2.2:5000';
  final http.Client _client;

  String get baseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: defaultBaseUrl,
      );

  Future<List<Article>> fetchArticles({
    required String country,
    required String topic,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/articles').replace(
      queryParameters: {'country': country, 'topic': topic, 'limit': '50'},
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Unable to load news (${response.statusCode})');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    return (payload['data'] as List<dynamic>)
        .map((item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Article>> search(String query) async {
    final uri = Uri.parse('$baseUrl/api/v1/search').replace(
      queryParameters: {'q': query, 'limit': '50'},
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Unable to search news (${response.statusCode})');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    return (payload['data'] as List<dynamic>)
        .map((item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void dispose() => _client.close();
}
