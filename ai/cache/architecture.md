# Architecture & Conventions — Cache

## Structure des Dossiers

```
lib/
├── main.dart                 # Point d'entrée + variables globales
├── theme.dart                # AppTheme (ChangeNotifier)
├── app_lifecycle/            # Gestion cycle de vie
├── audio/                    # Système audio complet
│   ├── audio_controller.dart # Controller principal
│   ├── audio_manager.dart    # Wrapper AudioPlayer
│   ├── audio_setting.dart    # SettingsController
│   ├── sounds.dart           # SfxType enum
│   ├── songs.dart            # Playlist
│   ├── data/                 # Implémentation service
│   ├── services/             # Interface service
│   └── persistence/          # SharedPrefs audio
├── files/
│   └── folders.dart          # Serveur HTTP + gestion fichiers
├── helpers/                  # Dimensions, responsive
├── keys/                     # Système de licence
│   ├── licence_manager.dart
│   ├── license_error_screen.dart
│   └── core/infrastructure/  # AES encrypt/decrypt
├── models/                   # Modèles de données purs
│   ├── ressources.dart
│   ├── types.dart
│   ├── niveaux.dart
│   └── sponsor.dart
├── onboarding/               # Flow onboarding (legacy)
├── provider/                 # DI + providers globaux
│   ├── providers.dart        # TOUS les providers
│   ├── details_provider.dart
│   ├── download_provider.dart
│   ├── onboarding_notifier.dart
│   ├── db/database_service.dart
│   └── network/              # GetIt + NetworkInfo
├── routes/                   # Config routing
│   ├── router.dart
│   └── router.gr.dart        # AutoRoute généré
├── screens/                  # UI Screens
│   ├── main_home.dart        # Shell layout
│   ├── settings.dart
│   ├── splash/
│   ├── home/                 # Accueil + onglets
│   │   ├── presentation/     # Widgets
│   │   └── core/             # Clean arch
│   ├── niveau/               # Sélection niveau
│   ├── ressources/           # Toutes les catégories
│   │   ├── presentation/     # 6 pages de ressources
│   │   └── core/             # Notifiers + repos
│   ├── activity/             # Activités en ligne
│   ├── details/              # Vue détail ressource
│   ├── pagination/           # Composants pagination
│   ├── widget/               # Widgets partagés écrans
│   └── onboarding/           # Pages onboarding
├── utils/                    # Utilitaires
└── widgets/                  # Widgets réutilisables globaux
    ├── helper.dart           # Fonctions conversion
    ├── preference_helper.dart # Favoris + CashHelper
    ├── deferred_widget.dart  # Code splitting
    └── ...
```

## Clean Architecture Pattern

Chaque module de ressource respecte :

```
[module]/
├── presentation/           ← ONLY UI (Consumer widgets)
└── core/
    ├── application/        ← Business logic (StateNotifier + States)
    ├── domaine/            ← Domain models + interfaces
    └── insfrastructure/    ← Data access (Repository implementations)
```

**Note :** Le dossier est nommé `insfrastructure` (faute orthographique intentionnelle dans le projet) — ne pas corriger pour rester cohérent.

## Pattern StateNotifier + Freezed

```dart
// 1. Définir l'état avec Freezed
@freezed
class FichesState with _$FichesState {
  const FichesState._();
  const factory FichesState.initial(List<Ressources>? result) = _Initial;
  const factory FichesState.loadInProgress(List<Ressources>? result) = _LoadInProgress;
  const factory FichesState.loadSuccess(List<Ressources>? result) = _LoadSuccess;
  const factory FichesState.loadFailure(List<Ressources>? result, {required String failure}) = _loadFailure;
}

// 2. Implémenter le notifier
class FichesNotifier extends StateNotifier<FichesState> {
  final dynamic _repository;

  FichesNotifier(this._repository) : super(const FichesState.initial(null));

  Future<void> fetchRessource({String typeId = '1'}) async {
    state = FichesState.loadInProgress(state.result);
    final repo = await _repository;
    final result = await repo.fetchRessource(typeId: typeId);
    result.fold(
      (failure) => state = FichesState.loadFailure(null, failure: failure),
      (data) => state = FichesState.loadSuccess(data),
    );
  }
}

// 3. Consommer dans l'UI
final state = ref.watch(fichesNotifierProvider);
state.when(
  initial: (result) => LoadingWidget(),
  loadInProgress: (result) => LoadingWidget(),
  loadSuccess: (result) => GridView(...),
  loadFailure: (result, failure) => ErrorWidget(failure),
);
```

## Pattern Repository

```dart
class RessourcesRepository {
  final List<Ressources> _ressources;
  RessourcesRepository(this._ressources);

  Future<Either<String, List<Ressources>?>> fetchRessource({
    String typeId = '1',
    String niveauId = '',
  }) async {
    try {
      final filtered = _ressources.where((r) =>
        r.type!.any((t) => t.id == typeId) &&
        (niveauId.isEmpty || r.niveau!.contains(niveauId))
      ).toList();
      return right(filtered);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<Ressources>?>> searchRessource({
    String typeId = '1',
    String searchItem = '',
  }) async {
    try {
      final filtered = _ressources.where((r) =>
        r.type!.any((t) => t.id == typeId) &&
        removeDiacritics(r.title!.toLowerCase())
          .contains(removeDiacritics(searchItem.toLowerCase()))
      ).toList();
      return right(filtered);
    } catch (e) {
      return left(e.toString());
    }
  }
}
```

## Conventions Importantes

### Nommage
- Fichiers : `snake_case.dart`
- Classes : `PascalCase`
- Variables/méthodes : `camelCase`
- Constantes : `camelCase` ou `SCREAMING_SNAKE` (rare)

### Imports
- Toujours `package:example/...` (pas de chemins relatifs)
- Exception : imports locaux dans le même dossier peuvent être relatifs

### Commentaires
- Peu de commentaires dans le code (style minimaliste)
- `// ignore_for_file:` utilisé pour suprimer warnings spécifiques

### Génération de code
- Fichiers générés : `*.freezed.dart`, `*.g.dart`, `router.gr.dart`
- **Ne jamais modifier manuellement** ces fichiers

### Variables globales (main.dart)
- Les listes filtrées sont des variables globales top-level
- Elles sont initialisées une seule fois dans `main()`
- Accessible depuis tout le projet sans provider

### Async Pattern
```dart
// Providers sont souvent Future — toujours await avant utilisation
final repo = await _repository;  // _repository est Future<RessourcesRepository>
```

## Widgets Réutilisables Clés

| Widget | Fichier | Usage |
|--------|---------|-------|
| `DeferredWidget` | `widgets/deferred_widget.dart` | Chargement lazy modules |
| `CardHighlight` | `widgets/card_highlight.dart` | Carte avec effet hover |
| `HoveredCard` | `widgets/hovered_card.dart` | Carte interactive |
| `EmptyPage` | `widgets/empty_page.dart` | État vide liste |
| `LikeAnimation` | `screens/widget/like_animation.dart` | Animation bouton favori |
| `CustomGridView` | `widgets/custom_gridview.dart` | Grille staggered |

## Helpers Critiques

**`lib/widgets/helper.dart`**

```dart
String convertLevel(String niveau)         // "1" → "1ere", "0" → "prescolaire"
String convertLevelTitle(String niveau)    // "1" → " Niveau 1ere"
String convertRessourceTitle(int index)    // 1 → "Fiches d'activité"
bool isURL(String text)                    // Détecte URLs http/https
bool isPDFPath(String text)                // Détecte chemins PDF (.pdf)
String removeDiacritics(String str)        // "Café" → "Cafe"
```

**`lib/widgets/preference_helper.dart`**

```dart
class CashHelper {
  static Future<void> init()
  static Future<bool> saveData({required key, required value})
  static dynamic getData({required String key})
  static addFav(Ressources r)
  static removeFav(Ressources r)
  static List<Ressources> getRessourcesList()
}

class FavorisProvider extends ChangeNotifier {
  List<Ressources> list = [];
  void getRessourcesList()
  void addFav(Ressources r)
  void removeFav(Ressources r)
  bool favExist(Ressources r)
}
```
