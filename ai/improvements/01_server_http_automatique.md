# Amélioration : Serveur HTTP automatique (sans script shell)

## Problème actuel

La fonction `startHttpServer()` dans `lib/files/folders.dart` tente de lancer un script externe :
- **macOS** : exécute `bash script.sh` dans le dossier html
- **Windows** : exécute `start_http_server.bat`

**Pourquoi c'est un problème :**
1. Le script doit exister manuellement dans le dossier — introuvable pour un utilisateur amateur
2. Si le script n'existe pas, le serveur ne démarre jamais silencieusement
3. Approche non cross-platform
4. L'utilisateur doit comprendre ce qu'est un script shell

**Pourquoi HTTP est obligatoire pour les jeux Construct 3 :**
- `index.html:22` bloque explicitement `file://` avec une alerte
- Les scripts utilisent `type="module"` (ES modules) — bloqués sur `file://`
- Un Service Worker (`sw.js`) est enregistré — impossible sur `file://`

## Solution : Serveur HTTP Dart pur (dart:io)

**Avantage :** Aucune dépendance externe. Démarre automatiquement. Fonctionne sur Windows/macOS/Linux.

**Fichier à modifier :** `lib/files/folders.dart`

### Remplacement complet de `startHttpServer()`

```dart
import 'dart:io';
import 'package:path/path.dart' as path;

HttpServer? _activeHttpServer;

Future<void> startHttpServer(Directory dir) async {
  // Arrêter le serveur existant si actif
  if (_activeHttpServer != null) {
    await _activeHttpServer!.close(force: true);
    _activeHttpServer = null;
  }

  try {
    _activeHttpServer = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      8080,
      shared: true,
    );

    _activeHttpServer!.listen((HttpRequest request) async {
      try {
        String requestPath = Uri.decodeFull(request.uri.path);
        if (requestPath.startsWith('/')) requestPath = requestPath.substring(1);
        if (requestPath.isEmpty) requestPath = 'index.html';

        final filePath = path.join(dir.path, requestPath);
        final file = File(filePath);

        // Headers nécessaires pour Construct 3 (SharedArrayBuffer/WASM)
        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.add('Cross-Origin-Opener-Policy', 'same-origin');
        request.response.headers.add('Cross-Origin-Embedder-Policy', 'require-corp');

        if (await file.exists()) {
          request.response.headers.contentType = _getContentType(filePath);
          await file.openRead().pipe(request.response);
        } else {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
        }
      } catch (e) {
        try {
          request.response.statusCode = HttpStatus.internalServerError;
          await request.response.close();
        } catch (_) {}
      }
    });

    if (kDebugMode) {
      print('Serveur HTTP démarré sur http://localhost:8080');
      print('Document root: ${dir.path}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur démarrage serveur HTTP: $e');
    }
  }
}

ContentType _getContentType(String filePath) {
  switch (path.extension(filePath).toLowerCase()) {
    case '.html': return ContentType.html;
    case '.js': return ContentType('application', 'javascript');
    case '.mjs': return ContentType('application', 'javascript');
    case '.css': return ContentType('text', 'css');
    case '.json': return ContentType.json;
    case '.png': return ContentType('image', 'png');
    case '.jpg':
    case '.jpeg': return ContentType('image', 'jpeg');
    case '.gif': return ContentType('image', 'gif');
    case '.svg': return ContentType('image', 'svg+xml');
    case '.wasm': return ContentType('application', 'wasm');
    case '.woff': return ContentType('font', 'woff');
    case '.woff2': return ContentType('font', 'woff2');
    case '.ico': return ContentType('image', 'x-icon');
    default: return ContentType.binary;
  }
}

Future<bool> isServerRunning(String url) async {
  // Vérifier directement si le serveur Dart est actif
  return _activeHttpServer != null;
}
```

### Supprimer dans `startHttpServer()` l'ancien code :
- Suppression du `Process.run('bash', ['script.sh'], ...)`
- Suppression du `Process.run('start_http_server.bat', ...)`

## Pourquoi les headers Cross-Origin sont nécessaires

Les jeux Construct 3 qui utilisent SharedArrayBuffer ou WASM nécessitent :
- `Cross-Origin-Opener-Policy: same-origin`
- `Cross-Origin-Embedder-Policy: require-corp`

Sans ces headers, le jeu peut se charger mais les features avancées échouent silencieusement.

## Impact

| Avant | Après |
|-------|-------|
| Dépend de `script.sh` existant sur le disque | 100% Dart, aucun fichier externe |
| Échoue silencieusement si script absent | Erreur loguée clairement |
| Bloquant pour les utilisateurs amateurs | Transparent, démarre automatiquement |
| Windows et macOS : chemins différents | Même code pour toutes plateformes |
| `isServerRunning()` fait une vraie requête HTTP | Vérifie directement l'état mémoire |

## Statut

- Priorité : **HAUTE** — Bloquant pour l'accès aux jeux
- Effort : Moyen (remplacement de fonction, pas de nouvelle architecture)
- Risque : Faible (dart:io est stable, toujours disponible)
