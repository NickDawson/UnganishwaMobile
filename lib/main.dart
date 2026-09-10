import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/article.dart';
import 'service/api_service.dart';

void main() => runApp(const UnganishwaApp());

class UnganishwaApp extends StatelessWidget {
  const UnganishwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unganishwa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff087f73)),
        useMaterial3: true,
      ),
      home: const NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final ApiService _api = ApiService();
  final Set<String> _favorites = <String>{};
  final List<String> _countries = const ['tanzania', 'kenya', 'uganda', 'rwanda', 'burundi'];
  final List<String> _topics = const ['Top Stories', 'National', 'Business', 'Technology', 'Health', 'Sports'];
  String _country = 'tanzania';
  String _topic = 'Top Stories';
  String _query = '';
  int _tab = 0;
  Future<List<Article>>? _articles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  void _loadArticles() {
    setState(() {
      _articles = _query.isEmpty
          ? _api.fetchArticles(country: _country, topic: _topic)
          : _api.search(_query);
    });
  }

  Future<void> _openArticle(Article article) async {
    final uri = Uri.tryParse(article.link);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('unganishwa.', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: _showSearch)],
      ),
      body: _tab == 1 ? _favoritesView() : _feedView(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.newspaper_outlined), selectedIcon: Icon(Icons.newspaper), label: 'News'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
        ],
      ),
    );
  }

  Widget _feedView() {
    return RefreshIndicator(
      onRefresh: () async => _loadArticles(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _filterRow(),
          const SizedBox(height: 16),
          FutureBuilder<List<Article>>(
            future: _articles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) return _errorState(snapshot.error.toString());
              final articles = snapshot.data ?? const <Article>[];
              if (articles.isEmpty) return _errorState('No stories found.');
              return Column(children: articles.map(_articleCard).toList());
            },
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropdownButton<String>(
        value: _country,
        isExpanded: true,
        items: _countries.map((country) => DropdownMenuItem(value: country, child: Text(country.toUpperCase()))).toList(),
        onChanged: (value) { if (value != null) { setState(() { _country = value; _query = ''; }); _loadArticles(); } },
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _topics.map((topic) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(label: Text(topic), selected: _topic == topic, onSelected: (_) { setState(() { _topic = topic; _query = ''; }); _loadArticles(); }),
        )).toList()),
      ),
    ]);
  }

  Widget _articleCard(Article article) {
    final saved = _favorites.contains(article.link);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openArticle(article),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${article.source} · ${article.published}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(article.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(article.summary, maxLines: 4, overflow: TextOverflow.ellipsis),
            Align(alignment: Alignment.centerRight, child: IconButton(icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border), onPressed: () => setState(() => saved ? _favorites.remove(article.link) : _favorites.add(article.link)))),
          ]),
        ),
      ),
    );
  }

  Widget _favoritesView() => ListView(padding: const EdgeInsets.all(16), children: [const Text('Saved stories', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 16), Text(_favorites.isEmpty ? 'Stories you save will appear here.' : '${_favorites.length} saved link(s).')]);

  Widget _errorState(String message) => Padding(padding: const EdgeInsets.all(32), child: Column(children: [const Icon(Icons.cloud_off, size: 48), const SizedBox(height: 12), Text(message, textAlign: TextAlign.center), TextButton(onPressed: _loadArticles, child: const Text('Try again'))]));

  Future<void> _showSearch() async {
    final controller = TextEditingController(text: _query);
    final query = await showDialog<String>(context: context, builder: (context) => AlertDialog(title: const Text('Search Unganishwa'), content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Search stories')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Search'))]));
    controller.dispose();
    if (query != null) { setState(() => _query = query); _loadArticles(); }
  }
}
