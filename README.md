# 🎬 CineApp

> Aplicativo mobile desenvolvido em Flutter que exibe filmes populares consumindo a [API do TMDB](https://www.themoviedb.org/) e utiliza Firebase Firestore para salvar favoritos.

---

## 🏗️ Arquitetura

```
lib/
├── core/
│   ├── app_theme.dart          # Tema visual centralizado (cores, fontes)
│   ├── constants.dart          # URLs e constantes globais
│   └── secrets.dart            # ⚠️ Chave da API (não sobe ao GitHub)
├── models/
│   └── movie.dart              # Entidade de domínio (fromJson, toMap)
├── services/
│   ├── tmdb_service.dart       # Integração com TMDB (REST)
│   └── favorites_service.dart  # Integração com Firebase Firestore
├── screens/
│   ├── home_screen.dart        # Lista paginada + busca com debounce
│   ├── detail_screen.dart      # Detalhes + favoritar (optimistic update)
│   └── favorites_screen.dart   # Favoritos em tempo real (Stream)
├── widgets/
│   └── movie_card.dart         # Card reutilizável com Hero animation
└── main.dart                   # Entry point + inicialização Firebase
```

Consulte o [diagrama de arquitetura](architecture.svg).

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Uso |
|---|---|---|
| Flutter | 3.x | Framework mobile |
| Dart | 3.x | Linguagem |
| [TMDB API](https://www.themoviedb.org/documentation/api) | v3 | Dados de filmes |
| Firebase Firestore | ^4.15.9 | Banco de dados (favoritos) |
| `http` | ^1.2.1 | Requisições HTTP |
| `cached_network_image` | ^3.3.1 | Cache de imagens |
| `flutter_rating_bar` | ^4.0.1 | Avaliação com estrelas |

---

## ⚙️ Como Rodar o Projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- Conta no [Firebase](https://firebase.google.com/)
- Conta no [TMDB](https://www.themoviedb.org/signup) para obter a chave da API
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

---

### 1. Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/cineapp.git
cd cineapp
```

### 2. Configure a chave da API do TMDB

1. Acesse [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
2. Crie uma conta gratuita e solicite uma chave de API (Developer)
3. Crie o arquivo `lib/core/secrets.dart`:

```dart
const String tmdbApiKey = 'SUA_CHAVE_AQUI';
```


### 3. Configure o Firebase

```bash
# Instale a FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure o projeto (segue o wizard)
flutterfire configure
```

No Firebase Console:
- Crie um projeto
- Ative o **Cloud Firestore** em modo de teste
- O arquivo `lib/firebase_options.dart` é gerado automaticamente

### 4. Instale as dependências e execute

```bash
flutter pub get
flutter run
```


## 🌐 API Utilizada

**TMDB API** — `https://api.themoviedb.org/3`

| Endpoint | Uso |
|---|---|
| `GET /movie/popular` | Lista de filmes populares paginada |
| `GET /search/movie?query=X` | Busca por título |
| `GET /movie/{id}` | Detalhes completos do filme |

---

## 📦 Firebase

- **Cloud Firestore** — coleção `favorites`
- Documentos identificados pelo ID do filme
- Atualização reativa em tempo real via `Stream` (sem polling)

---

## 👨‍💻 Autor

Otávio Salomão
