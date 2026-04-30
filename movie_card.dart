import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/movie.dart';

// Widget extraído → reutilizado na HomeScreen e na busca sem duplicar código.
// Recebe apenas os dados que precisa — não depende de contexto externo.

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster com Hero para animação de transição entre telas
            Expanded(
              child: Hero(
                tag: 'movie-${movie.id}',
                child: movie.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),

            // Informações abaixo do poster
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.gold,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        movie.year,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppTheme.surface,
        child: const Center(
          child: Icon(Icons.movie_outlined, color: AppTheme.textMuted, size: 48),
        ),
      );
}
