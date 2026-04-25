# Routes & Navigation — Cache

## Router Configuration

**Fichier :** `lib/widgets/router.dart` + `lib/routes/router.dart`

**Framework :** Go Router (principal) + AutoRoute (secondaire/legacy)

## Routes Définies

| Route | Widget | Chargement | Fichier |
|-------|--------|-----------|---------|
| `/` | HomeMainPage | Immédiat | `lib/screens/home/presentation/home_main.dart` |
| `/category/activite_en_ligne` | OnlineActivityPage | Deferred | `lib/screens/activity/presentation/online_activity.dart` |
| `/category/b_projet_stim` | BankActivityPage | Deferred | `lib/screens/ressources/presentation/bank_Activity.dart` |
| `/category/fiche_activite` | FichesActivityPage | Deferred | `lib/screens/ressources/presentation/fiches_activity.dart` |
| `/category/jeu_en_ligne` | JeuxActivityPage | Deferred | `lib/screens/ressources/presentation/jeux_activity.dart` |
| `/category/historiq_perso` | HistoriqueActivityPage | Deferred | `lib/screens/ressources/presentation/historique_activity.dart` |
| `/category/material_class` | ClasseActivityPage | Deferred | `lib/screens/ressources/presentation/classe_activity.dart` |
| `/settings` | Settings | Deferred | `lib/screens/settings.dart` |

## Navigation Programmatique

```dart
// Via GoRouter (context)
context.go('/category/fiche_activite');
context.push('/settings');

// Via NavigationView (Fluent UI)
// L'index est synchronisé avec la route via indexPage provider
```

## Shell Route (Layout partagé)

Toutes les routes sont enveloppées dans `MyHomePage` qui fournit :
- NavigationView (panneau latéral)
- Barre de titre avec boutons de fenêtre
- LocalhostServer
- Validation de licence

## NavigationView Items

```dart
// lib/screens/main_home.dart
late final List<NavigationPaneItem> originalItems = [
  PaneItem(key: ValueKey('/'), icon: Icon(FluentIcons.home), title: Text('Accueil')),
  PaneItemHeader(header: Text('Categories')),
  PaneItem(key: ValueKey('/category/activite_en_ligne'), ...),
  PaneItem(key: ValueKey('/category/b_projet_stim'), ...),
  PaneItem(key: ValueKey('/category/fiche_activite'), ...),
  PaneItem(key: ValueKey('/category/jeu_en_ligne'), ...),
  PaneItem(key: ValueKey('/category/historiq_perso'), ...),
  PaneItem(key: ValueKey('/category/material_class'), ...),
];

final footerItems = [
  PaneItem(key: ValueKey('/settings'), icon: Icon(FluentIcons.settings), ...),
];
```

## Pages de Détail

La navigation vers les détails n'utilise pas de routes distinctes mais des overlays/dialogs ou des push internes au widget.

## Onglets HomeMainPage (PageView)

Ce n'est pas du routing Go Router, c'est un PageViewController interne :

| Index | Contenu | Fichier |
|-------|---------|---------|
| 0 | HomePage (activités filtrées par niveau) | `lib/screens/home/presentation/home.dart` |
| 1 | RessourcesPage (ressources niveau) | `lib/screens/home/presentation/ressources.dart` |
| 2 | FavoritePage | `lib/screens/home/presentation/favorite_page.dart` |
| 3 | SearchActivityPage | `lib/screens/home/presentation/search_activity_page.dart` |
