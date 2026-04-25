# Modèles de Données — Cache

## Ressources (modèle principal)

**Fichier :** `lib/models/ressources.dart`

```dart
class Ressources extends Equatable {
  String? id;
  String? title;
  String? description;
  String? categorie;
  String? image;          // Chemin relatif vers assets/images/
  List<Types>? type;      // Liste des types (peut appartenir à plusieurs)
  String? followLink;     // URL externe (http/https)
  String? localLink;      // Chemin fichier local (pdf, html) - défaut: ""
  List<String>? niveau;   // Ex: ["1", "2"] ou ["0"] pour pré-scolaire
}
```

**Constructeurs :**
- `Ressources.fromJson(Map<String, dynamic>)` : désérialise depuis JSON
- `Ressources.fromJsonToSting(Map<String, dynamic>)` : variante avec Types comme string
- `Ressources.copyWith(...)` : crée une copie modifiée

**Méthodes sérialisation :**
- `toJson()` : sérialise avec Types comme objets
- `toJsonFromString()` : sérialise avec Types comme strings (pour SharedPreferences)

**Équalité :** basée sur `title`, `description`, `type`

---

## Types

**Fichier :** `lib/models/types.dart`

```dart
class Types {
  String? id;    // "1" à "7"
  String? title; // Ex: "Fiches d'activités"
}
```

| id | title |
|----|-------|
| "1" | Fiches d'activités |
| "2" | Banque de projets STIM |
| "3" | Histoires personnalisées |
| "4" | Matériel de classe |
| "5" | Activités en ligne |
| "6" | Jeux en ligne |
| "7" | Cahiers d'activités |

**Méthode spéciale :**
```dart
static List<Types> toJsonList(dynamic data)  // Reconstruit depuis string sérialisé
```

---

## Niveaux

**Fichier :** `lib/models/niveaux.dart`

```dart
class Niveaux {
  String? id;    // "0" à "6"
  String? title; // Ex: "Pré-scolaire"
}
```

| id | title | Correspondance dans Ressources.niveau |
|----|-------|--------------------------------------|
| "0" | Pré-scolaire | "0" ou "prescolaire" |
| "1" | Niveau 1 | "1" ou "1ere" |
| "2" | Niveau 2 | "2" |
| "3" | Niveau 3 | "3" |
| "4" | Niveau 4 | "4" |
| "5" | Niveau 5 | "5" |
| "6" | Niveau 6 | "6" |

**Conversion :** `convertLevel(String niveau)` dans `lib/widgets/helper.dart`
- "0" → "prescolaire"
- "1" → "1ere"
- "2"-"6" → "2"-"6" (identiques)

---

## Sponsor / Person

**Fichier :** `lib/models/sponsor.dart`

```dart
class Person {
  final String? username;  // GitHub handle
  final String name;       // Nom affiché
  final String imageUrl;   // Avatar URL
}
```

---

## RessourceItemPaged (pagination)

**Fichier :** `lib/screens/ressources/core/domaine/ressources_item_page.dart`

```dart
class RessourceItemPaged {
  int page;            // Page courante
  List<Ressources> data; // Items de la page
  bool hasNext;        // Page suivante disponible
  bool hasPrev;        // Page précédente disponible
  int perPage;         // Items par page
  int dataCount;       // Total items
  int totalPages;      // Nombre total de pages
}
```
