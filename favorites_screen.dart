import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/movie.dart';
import '../services/favorites_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Favoritos'),
      ),
      // StreamBuilder = UI reativa: atualiza automaticamente quando
      // qualquer favorito é adicionado ou removido, em qualquer tela.
      body: StreamBuilder<List<Movie>>(
        stream: FavoritesService.instance.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 72, color: AppTheme.textMuted),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda.\nToque em ❤️ para salvar filmes!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie.posterUrl != null
                        ? CachedNetworkImage(
                            imageUrl: movie.posterUrl!,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.movie_outlined,
                              color: AppTheme.textMuted,
                            ),
                          )
                        : const Icon(Icons.movie_outlined,
                            color: AppTheme.textMuted),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppTheme.gold),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating}  •  ${movie.year}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppTheme.secondary),
                    onPressed: () =>
                        FavoritesService.instance.remove(movie.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(movie: movie),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
