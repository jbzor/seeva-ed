# Dépendances — Cache

**Fichier :** `pubspec.yaml`  
**App name :** `example` (interne) / "Seeva Education" (affiché)  
**Version :** 1.0.0+1  
**Dart SDK :** >=3.7.0 <4.0.0

## Dépendances par Catégorie

### UI & Design (Desktop-first)
| Package | Version | Usage |
|---------|---------|-------|
| `fluent_ui` | ^4.15.1 | Design system Windows Fluent — TOUT l'UI |
| `flutter_acrylic` | ^1.0.0+2 | Effets visuels Windows (Mica, Acrylic) |
| `window_manager` | ^0.3.0 | Contrôle de la fenêtre desktop |
| `system_theme` | ^2.3.1 | Lecture du thème système OS |
| `lottie` | ^3.0.0 | Animations JSON (splash, empty states) |
| `google_fonts` | ^6.1.0 | Polices Google |

### State Management
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_riverpod` | ^2.4.5 | Gestion d'état principale |
| `hooks_riverpod` | ^2.4.4 | Hooks Riverpod |
| `provider` | ^6.0.5 | ChangeNotifier (FavorisProvider, AppTheme) |
| `riverpod_generator` | ^2.3.3 | Génération providers |
| `riverpod_lint` | ^2.1.1 | Linting Riverpod |

### Routing
| Package | Version | Usage |
|---------|---------|-------|
| `auto_route` | 7.8.1 | Routing généré (legacy/secondaire) |
| `go_router` | ^10.0.0 | Routing principal |

### Stockage & Base de Données
| Package | Version | Usage |
|---------|---------|-------|
| `shared_preferences` | ^2.2.3 | Settings, favoris, licence |
| `hive` | ^2.2.3 | NoSQL local (initialisé mais peu utilisé) |
| `hive_flutter` | ^1.1.0 | Intégration Hive Flutter |
| `sqflite` | ^2.3.2 | SQLite (importé mais usage minimal) |

### Audio
| Package | Version | Usage |
|---------|---------|-------|
| `audioplayers` | ^6.0.0 | Lecteur audio principal |
| `just_audio` | ^0.9.38 | Alternative (backup) |

### Sécurité
| Package | Version | Usage |
|---------|---------|-------|
| `encrypt` | ^5.0.3 | Chiffrement AES (licence) |
| `crypto` | ^3.0.3 | Hashage cryptographique |

### Sérialisation & Modèles
| Package | Version | Usage |
|---------|---------|-------|
| `equatable` | ^2.0.5 | Égalité objets (Ressources) |
| `dartz` | ^0.10.1 | Either<L,R> pour gestion erreurs |
| `freezed_annotation` | ^2.4.1 | Classes immutables (States) |
| `json_annotation` | ^4.9.0 | Annotations JSON |
| `json_serializable` | ^6.3.1 | Génération JSON |

### Réseau & Connectivité
| Package | Version | Usage |
|---------|---------|-------|
| `http` | ^1.1.0 | Requêtes HTTP |
| `internet_connection_checker` | ^1.0.0+1 | Vérification connectivité |
| `url_launcher` | ^6.1.7 | Ouverture URLs externes |
| `url_strategy` | ^0.2.0 | URL strategy web |

### Gestion Fichiers
| Package | Version | Usage |
|---------|---------|-------|
| `file_manager` | ^1.0.1 | Navigation fichiers |
| `file_picker` | ^8.0.3 | Sélecteur de fichiers |
| `open_filex` | ^4.4.0 | Ouverture fichiers natifs |
| `path_provider` | ^2.1.3 | Chemins système |
| `path` | (transitive) | Manipulation chemins |

### Web & WebView
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_inappwebview` | ^6.0.0 | WebView intégré (jeux, ressources) |
| `desktop_webview_window` | ^0.2.3 | WebView desktop |
| `webview_windows` | ^0.4.0 | WebView natif Windows |
| `local_assets_server` | ^2.0.2+12 | Serveur HTTP local assets |

### PDF
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_pdfview` | ^1.3.2 | Lecteur PDF basique |
| `syncfusion_flutter_pdfviewer` | ^33.1.45 | Lecteur PDF avancé (Syncfusion) |

### UI Components
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_staggered_grid_view` | ^0.7.0 | Grilles décalées |
| `flutter_custom_pagination` | ^0.2.0 | Pagination UI |
| `like_button` | ^2.0.5 | Bouton favori animé |
| `flutter_markdown` | ^0.6.13 | Rendu Markdown |

### Utilitaires
| Package | Version | Usage |
|---------|---------|-------|
| `get_it` | ^7.7.0 | Service locator (NetworkInfo) |
| `get` | ^4.6.5 | Utilitaires GetX (legacy) |
| `hotkey_manager` | ^0.2.2 | Raccourcis clavier |
| `permission_handler` | ^11.0.1 | Permissions système |
| `process` | ^5.0.2 | Exécution processus |
| `process_run` | ^0.14.2 | Run commandes shell |
| `clipboard` | ^0.1.3 | Copie presse-papiers |
| `logging` | ^1.2.0 | Logs |
| `restart_app` | ^1.2.1 | Redémarrage app |
| `email_validator` | ^2.1.17 | Validation emails |
| `flutter_syntax_view` | ^4.1.0 | Affichage code source |

### Build & Dev Tools
| Package | Version | Usage |
|---------|---------|-------|
| `build_runner` | ^2.4.6 | Génération code (freezed, json, riverpod) |
| `hive_generator` | ^2.0.1 | Génération adapters Hive |
| `flutter_native_splash` | ^2.1.6 | Splash screen natif |
| `flutter_launcher_icons` | ^0.13.1 | Icônes launcher |
| `flutter_lints` | ^2.0.2 | Règles de lint |

## Commandes de Génération de Code

```bash
# Regénérer tous les fichiers .freezed.dart, .g.dart
dart run build_runner build --delete-conflicting-outputs

# Mode watch
dart run build_runner watch --delete-conflicting-outputs
```

## Assets Configurés

```yaml
assets:
  - assets/
  - assets/images/
  - assets/icons/
  - assets/json/
  - assets/sfx/
  - assets/gifs/
  - assets/images/niveau/
  - assets/images/ressources/
  - assets/images/ressources/jeux/
  - assets/images/ressources/sons/
  - assets/images/ressources/maths/
  - assets/images/ressources/accueil/
  - assets/images/ressources/histoire/
  - assets/images/ressources/bank/
  - assets/images/ressources/classe/
```
