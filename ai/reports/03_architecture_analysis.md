# Architecture Technique — Seeva Education

## Vue d'ensemble

```
┌──────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                   │
│  SplashPage → NiveauPage → MyHomePage                │
│  ├── HomeMainPage (PageView 4 tabs)                  │
│  ├── *ActivityPage ×6 (Deferred Loading)             │
│  ├── DetailsActivity (PDF/WebView/HTTP)              │
│  └── Settings                                       │
├──────────────────────────────────────────────────────┤
│              STATE MANAGEMENT (RIVERPOD)             │
│  StateNotifierProviders × 9                          │
│  FutureProviders × 3                                 │
│  StateProviders × 5 (pagination + UI state)          │
│  ChangeNotifierProviders × 3                         │
├──────────────────────────────────────────────────────┤
│              APPLICATION / DOMAIN                    │
│  Notifiers (Freezed states) × 9                      │
│  Repositories × 3                                   │
│  Models: Ressources, Types, Niveaux, Sponsor         │
├──────────────────────────────────────────────────────┤
│                    DATA LAYER                        │
│  JSON Assets (352KB + 122KB) → DatabaseService       │
│  SharedPreferences → Favoris, Settings, Licence      │
│  HTTP Server local (port 8080) → Jeux HTML           │
└──────────────────────────────────────────────────────┘
```

## Pattern Clean Architecture

Chaque module de ressource suit la même structure :

```
screens/ressources/
├── presentation/
│   └── *_activity.dart          ← Widget UI pur
├── core/
│   ├── application/
│   │   ├── *_notifier.dart      ← StateNotifier (logique métier)
│   │   └── *_notifier.freezed.dart
│   ├── domaine/
│   │   ├── *_item_page.dart     ← Modèles domaine (pagination)
│   │   └── *_item_page.g.dart
│   └── insfrastructure/
│       ├── *_repository.dart    ← Accès données
│       └── save_*_provider.dart
```

## Gestion d'État — Riverpod

### Hiérarchie des providers

```
databaseProvider (FutureProvider)
    └── repositoryProvider (Provider)
            ├── fichesNotifierProvider (StateNotifierProvider)
            ├── bankNotifierProvider
            ├── historyNotifierProvider
            ├── classeNotifierProvider
            ├── onLineNotifierProvider
            ├── ressourcesNotifierProvider
            ├── activityNotifierProvider
            └── allActivityNotifierProvider

databasesProvider (FutureProvider)
    └── activitiesRepositoryProvider (Provider)
            └── activitiesNotifierProvider (StateNotifierProvider)

downloadProvider (ChangeNotifierProvider)
    └── niveauRepositoryProvider (Provider)
            └── niveauNotifierProvider (StateNotifierProvider)
```

### Pattern Freezed States

Tous les notifiers utilisent des états Freezed :

```dart
@freezed
class XxxState {
  const factory XxxState.initial(List<Ressources>? result) = _Initial;
  const factory XxxState.loadInProgress(List<Ressources>? result) = _LoadInProgress;
  const factory XxxState.loadSuccess(List<Ressources>? result) = _LoadSuccess;
  const factory XxxState.loadFailure(..., {required String failure}) = _loadFailure;
}
```

### Pattern Either (dartz)

Les repositories retournent `Either<String, List<Ressources>?>` :
- `Left(String)` = erreur
- `Right(List<Ressources>?)` = succès

## Chargement Différé (Deferred Loading)

Toutes les pages de catégories sont chargées en lazy loading :

```dart
import 'package:example/screens/.../bank_Activity.dart' deferred as bank;

// Dans la navigation :
DeferredWidget(
  bank.loadLibrary,
  () => bank.BankActivityPage(),
)

// Préchargé après runApp :
Future.wait([
  DeferredWidget.preload(bank.loadLibrary),
  DeferredWidget.preload(classe.loadLibrary),
  // ...
]);
```

## Injection de Dépendances

Dual approach :
- **Riverpod** : Providers (recommandé, utilisé partout)
- **GetIt** : Service locator pour NetworkInfo

```dart
// GetIt (injection_container.dart)
final sl = GetIt.instance;
sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

// Riverpod (providers.dart)
final networkInfoProvider = Provider<NetworkInfo>((ref) => di.sl<NetworkInfo>());
```

## Variables Globales (main.dart)

**Important :** Ces listes sont chargées au démarrage et partagées globalement :

```dart
List<Ressources> result = [];              // Toutes ressources (ressources.json)
List<Ressources> jeuResult = [];           // Activités (activity.json)
List<Ressources> ficheActiviteList = [];   // typeId='1'
List<Ressources> banqueProjetList = [];    // typeId='2'
List<Ressources> histoiresPersonnaList = []; // typeId='3'
List<Ressources> materielClassList = [];   // typeId='4'
List<Ressources> activiteLigneList = [];   // typeId='5'
List<Ressources> jeuEnLigneList = [];      // typeId='6' (depuis jeuResult)
```

Ces listes sont **filtrées une seule fois au démarrage** via `loadList(result)`.

## Routing (Go Router + AutoRoute)

Le projet utilise principalement **Go Router** :

```dart
// Routes dans widgets/router.dart et screens/main_home.dart
GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MyHomePage(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => HomeMainPage()),
        GoRoute(path: '/category/activite_en_ligne', ...),
        GoRoute(path: '/category/b_projet_stim', ...),
        GoRoute(path: '/category/fiche_activite', ...),
        GoRoute(path: '/category/jeu_en_ligne', ...),
        GoRoute(path: '/category/historiq_perso', ...),
        GoRoute(path: '/category/material_class', ...),
        GoRoute(path: '/settings', ...),
      ],
    ),
  ],
);
```

**AutoRoute** est également configuré mais semble secondaire (présence de `router.gr.dart` généré).

## Persistence

| Données | Mécanisme | Clés |
|---------|-----------|------|
| Favoris | SharedPreferences | `'ressources'` (JSON array) |
| Niveau courant | SharedPreferences | `'indexNiveau'` |
| Licence | SharedPreferences | `'licenseKey'` |
| Thème | SharedPreferences | `'themeMode'`, `'accentColor'` |
| Navigation mode | SharedPreferences | `'paneDisplayMode'` |
| Chemin HTML | SharedPreferences | `'html'` |
| Audio settings | SharedPreferences | `'audioOn'`, `'musicOn'`, `'soundsOn'` |
| Onboarding | SharedPreferences | `'seenOnboard'` |

## Sécurité — Chiffrement Licence

**Fichiers :** `lib/keys/core/infrastructure/`

```dart
// Algorithme : AES CBC
// Clé : 32 caractères (padding auto)
// Format sortie : Base64

String encryptMyData(DateTime expiryDate) {
  // Chiffre la date en AES et retourne Base64
}

DateTime decryptMyData(String text) {
  // Déchiffre le Base64 et parse la DateTime
}
```

Clé secrète : `'SeevaEducation@2024'` (padded à 32 chars)

## Performance

### Code Splitting
- Modules chargés en deferred (lazy) pour réduire le temps de démarrage
- Préchargement en arrière-plan après `runApp()`

### Pagination
- Côté client uniquement (les données JSON sont intégralement chargées en mémoire)
- `sublist()` pour découper les pages

### Images
- `imgPlaceHolder` utilisé si image absente
- Images stockées dans `assets/images/ressources/`

## Conventions de Code

| Convention | Détail |
|-----------|--------|
| Nommage fichiers | snake_case (ex: `bank_Activity.dart`) |
| Nommage classes | PascalCase |
| State management | Riverpod StateNotifier + Freezed |
| Async | Future/async-await |
| Error handling | Either<String, T> via dartz |
| UI framework | Fluent UI (pas Material Design) |
| Import style | `package:example/...` (pas de relatifs) |
| Génération code | build_runner (freezed, json_serializable, riverpod_generator) |
