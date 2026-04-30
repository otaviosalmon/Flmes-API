import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';
import '../models/movie.dart';

// Isola toda lógica do Firebase aqui.
// Trocar Firestore por SQLite local? Só este arquivo muda.

class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final _col = FirebaseFirestore.instance
      .collection(AppConstants.favoritesCollection);

  // Usa o ID do filme como ID do documento — evita duplicatas naturalmente.
  Future<void> add(Movie movie) =>
      _col.doc(movie.id.toString()).set(movie.toMap());

  Future<void> remove(int movieId) =>
      _col.doc(movieId.toString()).delete();

  Future<bool> isFavorite(int movieId) async {
    final doc = await _col.doc(movieId.toString()).get();
    return doc.exists;
  }

  // Stream reativo: a UI atualiza automaticamente quando favoritos mudam.
  // Sem polling, sem setState manual — é o modelo reativo do Firestore.
  Stream<List<Movie>> watchAll() => _col.snapshots().map(
        (snap) => snap.docs
            .map((d) => Movie.fromFirestore(d.data()))
            .toList(),
      );
}
