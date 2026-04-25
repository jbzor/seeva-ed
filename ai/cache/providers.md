# Providers Riverpod — Cache

**Fichier principal :** `lib/provider/providers.dart`

## Providers Infrastructure

```dart
// Connectivité réseau
final networkInfoProvider = Provider<NetworkInfo>((ref) => di.sl<NetworkInfo>());
final isConnectedProvider = FutureProvider<bool>(...);

// Routage
final appRouterProvider = Provider((ref) => AppRouter(ref));

// UI State
final detailProvider = ChangeNotifierProvider<DetailsProvider>(...);
final downloadProvider = ChangeNotifierProvider<DownloadProvider>(...);
```

## Providers de Données (Source)

```dart
// Chargement depuis ressources.json
final databaseProvider = FutureProvider<List<Ressources>>(() => DatabaseService().getActivities());

// Chargement depuis activity.json
final databasesProvider = FutureProvider<List<Ressources>>(() => DatabaseService().getActivity());
```

## Providers Repository

```dart
final repositoryProvider = Provider((ref) async =>
  RessourcesRepository(await ref.watch(databaseProvider.future)));

final niveauRepositoryProvider = Provider((ref) async {
  // Filtre par niveau courant depuis downloadProvider.niveauStat
  return NiveauRepository(filteredList);
});

final activitiesRepositoryProvider = Provider((ref) async =>
  ActivitiesRepository(await ref.watch(databasesProvider.future)));
```

## StateNotifierProviders (Logique Métier)

| Provider | Notifier | State | TypeId | Source |
|----------|---------|-------|--------|--------|
| `fichesNotifierProvider` | FichesNotifier | FichesState | '1' | repositoryProvider |
| `bankNotifierProvider` | BankNotifier | BankState | '2' | repositoryProvider |
| `historyNotifierProvider` | HistoryNotifier | HistoryState | '3' | repositoryProvider |
| `classeNotifierProvider` | ClasseNotifier | ClasseState | '4' | repositoryProvider |
| `onLineNotifierProvider` | OnlineNotifier | OnlineState | '5' | repositoryProvider |
| `ressourcesNotifierProvider` | RessourceNotifier | RessourceState | '6' | repositoryProvider |
| `activityNotifierProvider` | ActivitiesNotifier | FichesState | '1' | repositoryProvider |
| `activitiesNotifierProvider` | ClasseActivitiesNotifier | ClasseActivitiesState | — | activitiesRepositoryProvider |
| `niveauNotifierProvider` | NiveauNotifier | FichesState | — | niveauRepositoryProvider |
| `allActivityNotifierProvider` | SearchNotifier | FichesState | — | repositoryProvider (toutes) |

## Providers Onboarding

```dart
final onBoardingProvider =
  StateNotifierProvider<OnboardingStateNotifier, OnboardingState>(...);
```

## Providers Pagination

```dart
final currentPageProvider = StateProvider<int>((ref) => 1);
final dataPageProvider = StateProvider<List<Ressources>?>((ref) => null);
final totalDataCountProvider = StateProvider<int>((ref) => 100);
final pageLimitProvider = StateProvider<int>((ref) => 10);
final pageLimitOptionsProvider = StateProvider<List<int>>((ref) => [10, 15, 25, 50]);
final zoomLimitOptionsProvider = StateProvider<List<int>>((ref) => [75, 100, 125]);

final paginateProvider = FutureProvider.family<RessourceItemPaged, List<Ressources>?>(
  (ref, liste) async {
    int page = ref.watch(currentPageProvider);
    int perPage = ref.watch(pageLimitProvider);
    int offset = (page - 1) * perPage;
    // ...
  }
);
```

## Providers UI (main_home.dart)

```dart
final indexPage = StateProvider<int>((ref) => 0);          // Index nav courant
final isCloneHome = StateProvider<bool>((ref) => false);   // Affichage home clone
final isNotExpired = StateProvider<bool>((ref) => false);  // Licence valide
```

## Providers Filtrage

```dart
final filteredActivityProvider =
  FutureProvider.family<List<Ressources>, String>((ref, typeId) async {
    final activities = await ref.watch(databaseProvider.future);
    return activities.where((a) => a.type!.any((t) => t.id == typeId)).toList();
  });
```

## Thème

```dart
// Dans lib/theme.dart (implicitement)
// AppTheme est ChangeNotifier
final themeProvider = ChangeNotifierProvider<AppTheme>(...);
```

## Pattern d'utilisation dans les Widgets

```dart
// Lecture simple
final state = ref.watch(fichesNotifierProvider);

// Appel action
ref.read(fichesNotifierProvider.notifier).fetchRessource(typeId: '1');

// Déclenchement à l'init
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(fichesNotifierProvider.notifier).fetchRessource();
  });
}
```
