# Référence Rapide — Pour les Tickets

> Lire ce fichier EN PREMIER avant de commencer tout ticket.

## Contexte en 1 minute

- **App :** Seeva Education — ressources pédagogiques desktop (Windows/macOS)
- **Framework :** Flutter + Fluent UI (PAS Material Design)
- **State :** Riverpod (StateNotifier + Freezed states)
- **Routing :** Go Router (ShellRoute avec MyHomePage comme layout)
- **Données :** JSON assets locaux (352KB + 122KB), pas d'API
- **Package name :** `example` (imports: `package:example/...`)

## Avant tout changement, lire

1. `lib/main.dart` → variables globales, initialisation
2. `lib/provider/providers.dart` → tous les providers
3. `lib/models/ressources.dart` → modèle principal

## Ajouter une nouvelle catégorie de ressource

1. Ajouter `typeId` dans `assets/json/types.json`
2. Ajouter le filtre dans `loadList()` → `main.dart:154`
3. Créer `lib/screens/ressources/core/application/xxx_notifier.dart`
4. Créer `lib/screens/ressources/presentation/xxx_activity.dart`
5. Ajouter provider dans `lib/provider/providers.dart`
6. Ajouter route dans `lib/screens/main_home.dart` (originalItems)
7. Ajouter import deferred + preload dans `main.dart`

## Ajouter un champ au modèle Ressources

1. Modifier `lib/models/ressources.dart` (class + fromJson + toJson + copyWith + props)
2. Mettre à jour `assets/json/ressources.json` si applicable
3. Mettre à jour `assets/json/activity.json` si jeux

## Modifier la pagination

- Défaut items/page : `pageLimitProvider` défaut = 10
- Options : `pageLimitOptionsProvider` = [10, 15, 25, 50]
- Logique calcul : `paginateProvider` dans `lib/provider/providers.dart:195`

## Modifier le système de favoris

- Logique : `lib/widgets/preference_helper.dart`
- Clé SharedPrefs : `'ressources'`
- Format : JSON array de strings

## Modifier la validation de licence

- Manager : `lib/keys/licence_manager.dart`
- Chiffrement : `lib/keys/core/infrastructure/encrypt_service.dart`
- Clé secrète : `'SeevaEducation@2024'`
- Clé SharedPrefs : `'licenseKey'`

## Ajouter un paramètre dans Settings

1. Ajouter champ dans `AppTheme` → `lib/theme.dart`
2. Ajouter UI dans `lib/screens/settings.dart`
3. Persister via `CashHelper.saveData()`
4. Lire au démarrage dans `AppTheme` constructor

## Modifier la navigation principale

- Fichier : `lib/screens/main_home.dart`
- Liste items : `originalItems` (vers ligne 77)
- Footer items : `footerItems`

## Modifier l'audio

- Controller : `lib/audio/audio_controller.dart`
- SFX types : `lib/audio/sounds.dart`
- Playlist : `lib/audio/songs.dart`
- Fichiers audio : `assets/sfx/`

## Régénérer le code après modification des modèles Freezed/JSON

```bash
cd /Users/paysika/projets/mobiles/flutter/seeva_education
dart run build_runner build --delete-conflicting-outputs
```

## Chemins importants

| Chemin | Contenu |
|--------|---------|
| `lib/main.dart` | Point d'entrée + variables globales |
| `lib/provider/providers.dart` | Tous les providers Riverpod |
| `lib/screens/main_home.dart` | Navigation + Shell layout |
| `lib/models/ressources.dart` | Modèle principal |
| `lib/widgets/helper.dart` | Fonctions utilitaires |
| `lib/widgets/preference_helper.dart` | Favoris + CashHelper |
| `lib/keys/licence_manager.dart` | Gestion licences |
| `assets/json/ressources.json` | Source données (352KB) |
| `assets/json/activity.json` | Source jeux (122KB) |
| `assets/json/types.json` | Liste types (7 types) |

## Pièges courants à éviter

1. **Ne jamais modifier** les fichiers `.freezed.dart` et `.g.dart` — regénérer avec build_runner
2. **jeuEnLigneList provient de jeuResult** (activity.json), pas de result (ressources.json)
3. **Imports toujours** `package:example/...` jamais de chemins relatifs inter-modules
4. **Fluent UI** et non Material — utiliser `FluentIcons`, `FluentTheme`, `NavigationView`, pas les widgets Material
5. **`insfrastructure`** s'écrit avec la faute dans le projet — ne pas corriger
6. Les **providers retournent des Future** → toujours `await _repository` dans les notifiers
7. **setPreventClose(true)** — ne jamais retirer le dialogue de confirmation de fermeture
