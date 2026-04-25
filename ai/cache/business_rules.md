# Règles Métier Critiques — Cache

## Règle 1 : Source de données des Jeux En Ligne

**IMPORTANT :** Les jeux en ligne (typeId='6') proviennent de `activity.json` (via `jeuResult`), **pas** de `ressources.json` (via `result`).

```dart
// main.dart
jeuEnLigneList = jeuResult.where((item) =>
  item.type!.any((typeItem) => typeItem.id == "6")
).toList();
```

Toutes les autres catégories proviennent de `ressources.json`.

---

## Règle 2 : Licence obligatoire

L'accès à l'application est bloqué sans licence valide :
- Clé stockée : `SharedPreferences['licenseKey']`
- Validation : déchiffrement AES → compare date avec `DateTime.now()`
- Clé secrète hardcodée : `'SeevaEducation@2024'`
- Minimum longueur clé : > 40 caractères Base64 valide

---

## Règle 3 : Onboarding unique

- L'onboarding (sélection de niveau) ne s'affiche qu'UNE SEULE fois
- Contrôlé par `seenOnboard` dans SharedPreferences
- Une fois marqué comme vu, l'utilisateur va directement à `MyHomePage`

---

## Règle 4 : Niveau par défaut contrôle tous les filtres

- Le niveau sélectionné (`indexNiveau` dans SharedPrefs) filtre TOUTES les listes
- Stocké comme index string : "0" à "6"
- Conversion : `convertLevel(index)` → "prescolaire", "1ere", "2"..."6"
- Le filtre s'applique sur `Ressources.niveau` (List<String>)

---

## Règle 5 : Filtrage au démarrage, pas à la demande

Les listes globales sont filtrées **une seule fois au démarrage** dans `loadList()` :
```dart
ficheActiviteList = result.where((item) =>
  item.type!.any((typeItem) => typeItem.id == "1")
).toList();
```
Les repositories travaillent sur ces listes déjà filtrées, pas sur le JSON brut.

---

## Règle 6 : Serveur HTTP local pour les jeux

- Les jeux HTML nécessitent un serveur HTTP local sur **port 8080**
- Démarré via `InAppLocalhostServer` (flutter_inappwebview)
- `documentRoot` = valeur de `CashHelper.getData(key: 'html')`
- Sans serveur actif, les jeux locaux ne fonctionnent pas

---

## Règle 7 : Recherche insensible aux accents ET à la casse

```dart
removeDiacritics(text.toLowerCase()).contains(
  removeDiacritics(searchTerm.toLowerCase())
)
```
Les deux termes (texte source ET terme recherché) doivent subir la transformation.

---

## Règle 8 : Favoris — pas de doublons

```dart
void addFav(Ressources r) {
  if (!favExist(r)) {
    list.add(r);
    // persist...
  }
}
```
Un favori existant ne peut pas être ajouté en double.

---

## Règle 9 : Pagination côté client uniquement

Toutes les données sont chargées en mémoire. La pagination est calculée par `sublist()` :
```dart
offset = (page - 1) * perPage
data = liste.sublist(offset, min(offset + perPage, liste.length))
```
Il n'y a pas d'API backend. Changer de page ne déclenche pas de requête réseau.

---

## Règle 10 : Fenêtre desktop — confirmation avant fermeture

```dart
await windowManager.setPreventClose(true);
```
L'application doit toujours demander confirmation avant de se fermer. Ne jamais retirer ce comportement.

---

## Règle 11 : Types de ressources et leurs pages

| TypeId | Catégorie | Page | Liste globale |
|--------|-----------|------|---------------|
| '1' | Fiches d'activités | /category/fiche_activite | ficheActiviteList |
| '2' | Banque STIM | /category/b_projet_stim | banqueProjetList |
| '3' | Histoires | /category/historiq_perso | histoiresPersonnaList |
| '4' | Matériel classe | /category/material_class | materielClassList |
| '5' | Activités en ligne | /category/activite_en_ligne | activiteLigneList |
| '6' | Jeux en ligne | /category/jeu_en_ligne | jeuEnLigneList (**jeuResult**) |
| '7' | Cahiers d'activités | (non implémenté en nav) | — |

---

## Règle 12 : Nom interne vs nom affiché

- Nom package (pubspec.yaml) : `example`
- Nom affiché (appTitle) : `Seeva Education`
- Imports : `package:example/...`

---

## Règle 13 : Détection type de contenu pour la vue détail

```dart
// lib/widgets/helper.dart
bool isPDFPath(String text)  // → lecteur PDF intégré
bool isURL(String text)      // → WebView ou url_launcher
// Sinon : affichage informations seulement
```

---

## Règle 14 : Chemin images — toujours relatif aux assets

Les images dans `Ressources.image` sont des chemins relatifs aux assets :
- Ex: `"assets/images/ressources/maths/fiche1.png"`
- Si null ou vide : utiliser `imgPlaceHolder = 'assets/images/placeholder.png'`

---

## Règle 15 : Code splitting obligatoire pour les pages de catégories

Toutes les pages de catégories DOIVENT être chargées en deferred :
```dart
import '...bank_Activity.dart' deferred as bank;
// Et préchargées après runApp :
DeferredWidget.preload(bank.loadLibrary);
```
Ne pas importer directement ces widgets dans le build tree synchrone.
