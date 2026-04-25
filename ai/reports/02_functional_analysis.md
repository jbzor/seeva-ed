# Analyse Fonctionnelle — Seeva Education

## 1. Écran Splash / Démarrage

**Fichier :** `lib/screens/splash/splash_page.dart`

- Animation Lottie plein écran
- Lecture audio `loader.mp3`
- Durée : ~12 secondes
- Décision de navigation :
  - Si `seenOnboard == null` → `NiveauPage`
  - Sinon → `MyHomePage`
- Clé SharedPrefs : `seenOnboard` (bool)

---

## 2. Onboarding / Sélection de Niveau

**Fichier :** `lib/screens/niveau/niveau_page.dart`

- Affiché une seule fois au premier lancement
- Présente 7 cartes (pré-scolaire + 1-6) avec images
- Sélectionner un niveau → sauvegarde `indexNiveau` dans SharedPrefs
- Déclenche `OnboardingStateNotifier.setOnboarded()`
- Redirige vers `MyHomePage`

---

## 3. Validation Licence

**Fichier :** `lib/keys/licence_manager.dart`

- Appelée via `FutureBuilder` dans `MyHomePage`
- `LicenseManager.validateLicense(ref)` :
  1. Charge clé depuis SharedPrefs (`licenseKey`)
  2. Déchiffre via AES pour obtenir date d'expiration
  3. Compare avec `DateTime.now()`
- Si invalide → `LicenseErrorScreen`
- Si valide → `isNotExpired` provider mis à `true`
- Clé secrète : `SeevaEducation@2024`

---

## 4. Navigation Principale

**Fichier :** `lib/screens/main_home.dart`

### Structure NavigationView (Fluent UI)

| Index | Route | Écran | Chargement |
|-------|-------|-------|-----------|
| 0 | `/` | HomeMainPage | Immédiat |
| - | Header "Categories" | — | — |
| 1 | `/category/activite_en_ligne` | OnlineActivityPage | Deferred |
| 2 | `/category/b_projet_stim` | BankActivityPage | Deferred |
| 3 | `/category/fiche_activite` | FichesActivityPage | Deferred |
| 4 | `/category/jeu_en_ligne` | JeuxActivityPage | Deferred |
| 5 | `/category/historiq_perso` | HistoriqueActivityPage | Deferred |
| 6 | `/category/material_class` | ClasseActivityPage | Deferred |
| - | Footer | — | — |
| 7 | `/settings` | Settings | Deferred |

### Comportements Navigation

- Providers : `indexPage` (StateProvider<int>) pour index courant
- Keyboard shortcuts via `hotkey_manager`
- Window Management : boutons titre custom (minifier, fermer)
- Comportement `setPreventClose(true)` → dialogue de confirmation avant fermeture
- LocalhostServer démarré depuis `main_home.dart`

---

## 5. Accueil (HomeMainPage)

**Fichier :** `lib/screens/home/presentation/home_main.dart`

### PageView avec 4 onglets internes :

| Index | Onglet | Fichier | Description |
|-------|--------|---------|-------------|
| 0 | Activités | `home.dart` | Liste des activités filtrées par niveau courant |
| 1 | Ressources | `ressources.dart` | Ressources filtrées pour le niveau |
| 2 | Favoris | `favorite_page.dart` | Liste des favoris sauvegardés |
| 3 | Recherche | `search_activity_page.dart` | Recherche globale |

---

## 6. Pages de Ressources (par catégorie)

### Pattern commun

Chaque page de ressources suit le même pattern :

```
1. initState → appel du notifier (fetchRessource)
2. Consumer → watch du StateNotifierProvider
3. État initial/loading → indicateur de chargement
4. État success → GridView paginé
5. État failure → message d'erreur
6. SearchBar → appel searchRessource
```

### Grille d'affichage

- `CustomGridView` avec `flutter_staggered_grid_view`
- Colonnes : adaptatives selon largeur écran
- Carte : image + titre + bouton favoris + lien

### Filtrage

- Chaque page utilise les listes globales pré-filtrées depuis `main.dart`
- Filtre supplémentaire par niveau scolaire via `DownloadProvider.niveauStat`
- Recherche via `removeDiacritics()` pour ignorer accents

---

## 7. Fiches d'Activités

**Fichier :** `lib/screens/ressources/presentation/fiches_activity.dart`  
**Provider :** `fichesNotifierProvider` (typeId='1')  
**Données :** `ficheActiviteList` (global)

---

## 8. Banque de Projets STIM

**Fichier :** `lib/screens/ressources/presentation/bank_Activity.dart`  
**Provider :** `bankNotifierProvider` (typeId='2')  
**Données :** `banqueProjetList` (global)

---

## 9. Histoires Personnalisées

**Fichier :** `lib/screens/ressources/presentation/historique_activity.dart`  
**Provider :** `historyNotifierProvider` (typeId='3')  
**Données :** `histoiresPersonnaList` (global)

---

## 10. Matériel de Classe

**Fichier :** `lib/screens/ressources/presentation/classe_activity.dart`  
**Provider :** `classeNotifierProvider` (typeId='4')  
**Données :** `materielClassList` (global)

---

## 11. Activités En Ligne

**Fichier :** `lib/screens/activity/presentation/online_activity.dart`  
**Provider :** `onLineNotifierProvider` (typeId='5')  
**Données :** `activiteLigneList` (global)

---

## 12. Jeux En Ligne

**Fichier :** `lib/screens/ressources/presentation/jeux_activity.dart`  
**Provider :** `ressourcesNotifierProvider` (typeId='6')  
**Données :** `jeuEnLigneList` (depuis `activity.json`)  
**Particularité :** Source JSON différente (`activity.json` au lieu de `ressources.json`)

---

## 13. Détails d'une Ressource

**Fichier :** `lib/screens/details/details_activity.dart`

### Modes d'affichage selon type de ressource :

| Condition | Comportement |
|-----------|-------------|
| `isPDFPath(localLink)` | PdfViewer intégré |
| `isURL(followLink)` | WebView ou navigateur externe |
| Jeu HTML local | LocalhostServer sur port 8080 |
| Aucun lien | Affichage informations seulement |

### Helpers détection :
- `isPDFPath(text)` → detecte extensions .pdf
- `isURL(text)` → detecte http:// ou https://

---

## 14. Favoris

**Fichier :** `lib/widgets/preference_helper.dart`

### Fonctionnement :
- `FavorisProvider` extends `ChangeNotifier`
- Stockage : `SharedPreferences` clé `'ressources'` = `List<String JSON>`
- `addFav(Ressources)` → vérifie si déjà présent, sinon ajoute
- `removeFav(Ressources)` → retire de la liste
- `favExist(Ressources)` → retourne bool
- `getRessourcesList()` → charge depuis SharedPrefs au démarrage

### CashHelper (utilitaire statique) :
- `CashHelper.init()` → initialise SharedPreferences
- `CashHelper.saveData(key, value)` → sauvegarde clé/valeur
- `CashHelper.getData(key: '...')` → lecture clé
- `CashHelper.addFav()`, `removeFav()`, `getRessourcesList()`

---

## 15. Recherche

**Fichier :** `lib/screens/home/presentation/search_activity_page.dart`  
**Provider :** `allActivityNotifierProvider` (SearchNotifier)

### Comportement :
- Recherche sur **toutes** les ressources (`result` global)
- Insensible aux accents via `removeDiacritics()`
- Insensible à la casse
- Résultats temps réel (onChange)

---

## 16. Pagination

**Fichier :** `lib/screens/pagination/paginate.dart`

### Providers :
- `currentPageProvider` : page courante (défaut: 1)
- `pageLimitProvider` : items/page (défaut: 10)
- `pageLimitOptionsProvider` : [10, 15, 25, 50]
- `paginateProvider` : FutureProvider.family calculant offset/sublist

### Logique :
```dart
offset = (page - 1) * perPage
data = liste.sublist(offset, min(offset + perPage, liste.length))
totalPages = (liste.length / perPage).ceil()
hasNext = page < totalPages
hasPrev = page > 1
```

---

## 17. Audio

**Fichiers :** `lib/audio/`

### AudioController :
- Gère musique de fond (loop) + effets sonores
- States: playing, paused, stopped
- Polyphonie : 2 joueurs simultanés max
- Pause automatique si app passe en arrière-plan (AppLifecycle)

### SFX types :
| Enum | Volume | Usage |
|------|--------|-------|
| `buttonTap` | 1.0 | Clic bouton |
| `score` | 0.4 | Réussite |
| `jump` | 0.4 | Navigation |
| `hit` | 0.4 | Impact |
| `damage` | 0.4 | Erreur |

### Settings persistés (SharedPreferences) :
- `audioOn` : bool (audio global)
- `musicOn` : bool (musique fond)
- `soundsOn` : bool (effets sonores)

---

## 18. Paramètres

**Fichier :** `lib/screens/settings.dart`

### Sections :

| Section | Options | Clé SharedPrefs |
|---------|---------|-----------------|
| Thème | light / dark / system | `themeMode` |
| Navigation mode | auto / compact / top / open / minimal | `paneDisplayMode` |
| Niveau par défaut | Pré-scolaire, 1-6 | `indexNiveau` |
| Chemin ressources | Champ texte libre | `html` |
| Serveur HTTP | Bouton start + bouton terminal | — |

---

## 19. Gestion Fichiers & Serveur HTTP

**Fichier :** `lib/files/folders.dart`

### Chemins par OS :
- **macOS** : `~/Library/html`
- **Windows** : `%AppData%/html`

### Serveur HTTP local :
- Port : `8080`
- Démarré via `startHttpServer()`
- Vérifié via `isServerRunning()`
- Utilisé par jeux HTML (`InAppLocalhostServer`)

### Actions disponibles :
- `openScriptDirectory()` → ouvre Finder/Explorer
- `openTerminal()` → ouvre terminal et `cd` vers le dossier html

---

## 20. Thème & Apparence

**Fichier :** `lib/theme.dart`  
**Provider :** `themeProvider` (ChangeNotifierProvider)

### AppTheme properties :
- `color` : AccentColor (system, yellow, orange, red, magenta, purple, blue, teal, green)
- `mode` : ThemeMode (light, dark, system)
- `displayMode` : PaneDisplayMode
- `indicator` : NavigationIndicators (sticky, end)
- `windowEffect` : WindowEffect (disabled, solid, acrylic, mica, etc.)
- `textDirection` : TextDirection (ltr, rtl)
- `locale` : Locale?
