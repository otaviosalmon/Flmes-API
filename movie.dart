import '../core/constants.dart';

// O Model só conhece DADOS — não sabe nada de UI, HTTP ou Firestore.
// Isso é o princípio da responsabilidade única: uma classe, um papel.

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  // Factory para converter JSON da API em objeto Dart.
  // Usamos ?? para tratar campos nulos que a API pode retornar.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Sem título',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      // A API retorna nota de 0-10; protegemos contra null com 0.0
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String? ?? '',
      genreIds: (json['genre_ids'] as List?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  // toMap() para persistir no Firestore.
  // Salvamos só o necessário para a lista de favoritos.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'voteAverage': voteAverage,
        'releaseDate': releaseDate,
        'overview': overview,
      };

  // Factory para reconstruir o objeto a partir do Firestore.
  factory Movie.fromFirestore(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
      overview: map['overview'] as String? ?? '',
      posterPath: map['posterPath'] as String?,
      backdropPath: null,
      voteAverage: (map['voteAverage'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['releaseDate'] as String? ?? '',
      genreIds: [],
    );
  }

  // Getters que constroem URLs completas — a tela só chama movie.posterUrl.
  // Ela não precisa saber como a URL é formada.
  String? get posterUrl => posterPath != null
      ? '${AppConstants.tmdbImageBase}/${AppConstants.posterSize}$posterPath'
      : null;

  String? get backdropUrl => backdropPath != null
      ? '${AppConstants.tmdbImageBase}/${AppConstants.backdropSize}$backdropPath'
      : null;

  // Ano de lançamento extraído da string "2024-03-15"
  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';

  // Nota formatada para exibição
  String get rating => voteAverage.toStringAsFixed(1);
}
