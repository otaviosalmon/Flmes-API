import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Movie> _movies = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Timer para debounce da busca:
  // Sem debounce, cada letra digitada dispara uma chamada à API.
  // Com debounce de 500ms, só dispara quando o usuário parou de digitar.
  Timer? _debounce;

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _query = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel(); // cancelar o timer evita memory leak
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  void _onSearchChanged(String value) {
    // Cancela o timer anterior e inicia um novo — só executa depois de 500ms de silêncio.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _resetAndLoad(query: value.trim());
    });
  }

  void _resetAndLoad({String query = ''}) {
    setState(() {
      _movies.clear();
      _page = 1;
      _hasMore = true;
      _query = query;
      _isSearching = query.isNotEmpty;
    });
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final results = _query.isEmpty
          ? await TmdbService.instance.fetchPopular(page: _page)
          : await TmdbService.instance.searchMovies(_query, page: _page);

      setState(() {
        _movies.addAll(results);
        _page++;
        _hasMore = results.length == 20;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppTheme.secondary,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎬 CineApp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: AppTheme.secondary),
            tooltip: 'Favoritos',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AppTheme.textLight),
              decoration: InputDecoration(
                hintText: 'Buscar filmes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          _resetAndLoad();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Label dinâmico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _isSearching
                    ? 'Resultados para "$_query"'
                    : 'Filmes Populares',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Grid de filmes
          Expanded(
            child: _movies.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _movies.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum filme encontrado.',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _resetAndLoad(query: _query),
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _movies.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _movies.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final movie = _movies[index];
                            return MovieCard(
                              movie: movie,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(movie: movie),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
