import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../core/app_theme.dart';
import '../models/movie.dart';
import '../services/favorites_service.dart';
import '../services/tmdb_service.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? _detail;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Future.wait = busca detalhe e status de favorito em paralelo.
    // Sem isso: aguardaria cada um terminar sequencialmente (mais lento).
    final results = await Future.wait([
      TmdbService.instance.fetchDetail(widget.movie.id),
      FavoritesService.instance.isFavorite(widget.movie.id),
    ]);

    if (mounted) {
      setState(() {
        _detail = results[0] as Map<String, dynamic>;
        _isFavorite = results[1] as bool;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    // Optimistic update: muda o ícone ANTES de confirmar no servidor.
    // O usuário percebe velocidade; revertemos se der erro.
    setState(() => _isFavorite = !_isFavorite);
    try {
      if (_isFavorite) {
        await FavoritesService.instance.add(widget.movie);
      } else {
        await FavoritesService.instance.remove(widget.movie.id);
      }
    } catch (_) {
      setState(() => _isFavorite = !_isFavorite); // reverte
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final movie = widget.movie;
    final genres = (_detail?['genres'] as List?)
            ?.map((g) => g['name'] as String)
            .toList() ??
        [];
    final runtime = _detail?['runtime'] as int?;
    final tagline = _detail?['tagline'] as String? ?? '';

    return CustomScrollView(
      slivers: [
        // SliverAppBar com backdrop = efeito de colapso profissional
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppTheme.primary,
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_isFavorite),
                  color: AppTheme.secondary,
                  size: 28,
                ),
              ),
              onPressed: _toggleFavorite,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: movie.backdropUrl != null
                ? CachedNetworkImage(
                    imageUrl: movie.backdropUrl!,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.surface,
                    ),
                  )
                : Container(color: AppTheme.surface),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster + info básica lado a lado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'movie-${movie.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: movie.posterUrl != null
                            ? CachedNetworkImage(
                                imageUrl: movie.posterUrl!,
                                width: 110,
                                height: 165,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 110,
                                height: 165,
                                color: AppTheme.cardBg,
                                child: const Icon(Icons.movie_outlined,
                                    color: AppTheme.textMuted),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (tagline.isNotEmpty) ...[
                            Text(
                              '"$tagline"',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          _infoRow(Icons.calendar_today, movie.year),
                          if (runtime != null && runtime > 0)
                            _infoRow(Icons.access_time,
                                '${runtime ~/ 60}h ${runtime % 60}min'),
                          const SizedBox(height: 8),
                          // RatingBar mostra estrelas visuais
                          RatingBarIndicator(
                            rating: movie.voteAverage / 2,
                            itemCount: 5,
                            itemSize: 18,
                            itemBuilder: (_, __) => const Icon(
                              Icons.star_rounded,
                              color: AppTheme.gold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${movie.rating} / 10',
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Chips de gênero
                if (genres.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: genres
                        .map(
                          (g) => Chip(
                            label: Text(
                              g,
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: AppTheme.secondary.withOpacity(0.3),
                            side: BorderSide(
                              color: AppTheme.secondary.withOpacity(0.6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Sinopse
                if (movie.overview.isNotEmpty) ...[
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.textMuted),
            const SizedBox(width: 4),
            Text(text,
                style:
                    const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          ],
        ),
      );
}
