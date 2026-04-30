import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/secrets.dart';
import '../models/movie.dart';

// Service = porta de entrada para tudo que é externo.
// As telas nunca fazem http.get diretamente — delegam aqui.
// Benefício: se a API mudar, só este arquivo é alterado.

class TmdbService {
  TmdbService._();
  static final TmdbService instance = TmdbService._();

  // Monta a URI com a chave e os parâmetros extras.
  // Método privado = só usado internamente, não expõe detalhes para o resto do app.
  Uri _uri(String path, [Map<String, String>? extra]) {
    return Uri.parse(
      '${AppConstants.tmdbBaseUrl}$path',
    ).replace(queryParameters: {
      'api_key': tmdbApiKey,
      'language': 'pt-BR', // respostas em português!
      ...?extra,
    });
  }

  Future<List<Movie>> _fetchMovies(Uri uri) async {
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro na API: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['results'] as List)
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Filmes populares — página paginada para o infinite scroll
  Future<List<Movie>> fetchPopular({int page = 1}) =>
      _fetchMovies(_uri('/movie/popular', {'page': '$page'}));

  // Pesquisa por texto — retorna lista filtrada pela API
  Future<List<Movie>> searchMovies(String query, {int page = 1}) =>
      _fetchMovies(_uri('/search/movie', {
        'query': query,
        'page': '$page',
      }));

  // Detalhes completos de um filme (gêneros, duração, tagline, etc.)
  Future<Map<String, dynamic>> fetchDetail(int movieId) async {
    final response = await http.get(_uri('/movie/$movieId'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar detalhe: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
