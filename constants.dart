// Centralizar constantes evita "magic strings" espalhadas pelo código.
// Se a URL base da API mudar, você muda em UM lugar — não em 10 arquivos.

class AppConstants {
  AppConstants._(); // construtor privado = não pode ser instanciado

  // ─── TMDB API ──────────────────────────────────────────────────────────────
  // Obtenha sua chave gratuita em: https://www.themoviedb.org/settings/api
  // Crie um arquivo lib/core/secrets.dart com:
  //   const String tmdbApiKey = 'SUA_CHAVE_AQUI';
  // e NÃO suba esse arquivo para o GitHub (adicione ao .gitignore).
  // Por segurança, nunca coloque chaves de API diretamente no código-fonte.

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBase = 'https://image.tmdb.org/t/p';

  // w500 = largura 500px — equilíbrio entre qualidade e tamanho de download
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';

  // ─── Firebase ──────────────────────────────────────────────────────────────
  static const String favoritesCollection = 'favorites';

  // ─── Paginação ─────────────────────────────────────────────────────────────
  static const int pageSize = 20; // TMDB retorna 20 por página por padrão

  // ─── UI ────────────────────────────────────────────────────────────────────
  static const String appName = 'CineApp';
}
