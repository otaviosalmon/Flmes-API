# 🎬 CineApp

> Aplicativo mobile desenvolvido em Flutter que exibe filmes populares consumindo a [API do TMDB](https://www.themoviedb.org/) e utiliza Firebase Firestore para salvar favoritos.

---

## 📸 Prints da Aplicação

> *(Adicione aqui os prints após rodar o app — substitua os caminhos abaixo)*

| Tela Inicial | Detalhes | Favoritos |
|---|---|---|
| ![home](prints/home.png) | ![detail](prints/detail.png) | ![favorites](prints/favorites.png) |

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

> ⚠️ Este arquivo já está no `.gitignore` — nunca suba sua chave para o GitHub.

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

### 5. Gerar APK para Android

```bash
flutter build apk --release
# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

### 6. Gerar para Web

```bash
flutter build web --release
# Arquivos em: build/web/
```

---

## 🔗 Links

- 📦 [Download APK](#) ← *veja abaixo como gerar o link*
- 🌐 [Versão Web](#) ← *veja abaixo como publicar*

---

## 📤 Como gerar link de download do APK

### Opção 1 — GitHub Releases (recomendado)

```bash
# 1. Gere o APK
flutter build apk --release

# 2. No GitHub, vá em Releases → Create a new release
# 3. Faça upload do arquivo:
#    build/app/outputs/flutter-apk/app-release.apk
# 4. Publique — o link de download aparece automaticamente
```

### Opção 2 — Google Drive / Dropbox

```bash
# 1. Gere o APK
flutter build apk --release

# 2. Faça upload do APK para o Google Drive
# 3. Clique com o botão direito → Compartilhar → Qualquer pessoa com o link
# 4. Copie o link e cole no README
```

### Como publicar a versão Web (gratuito via Firebase Hosting)

```bash
# Instale o Firebase CLI
npm install -g firebase-tools
firebase login

# Build e deploy
flutter build web --release
firebase init hosting   # aponte para a pasta build/web
firebase deploy

# Você receberá um link tipo: https://seu-projeto.web.app
```

---

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

**Seu Nome** — [GitHub](https://github.com/SEU_USUARIO)
