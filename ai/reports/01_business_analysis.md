# Analyse Métier — Seeva Education

## Vision Produit

**Seeva Education** est une plateforme de ressources pédagogiques desktop destinée aux **enseignants du primaire** (pré-scolaire à 6e année). Elle agrège et centralise des ressources éducatives de différents types sous une interface unifiée Windows/macOS.

## Utilisateurs Cibles

| Profil | Description |
|--------|-------------|
| **Enseignant primaire** | Utilisateur principal. Cherche des ressources pédagogiques pour préparer ses cours |
| **Administrateur scolaire** | Gère les licences et l'accès au logiciel |

## Besoins Métier Identifiés

### 1. Centralisation des ressources pédagogiques

L'enseignant a besoin d'accéder en un seul endroit à plusieurs types de ressources :

| ID Type | Nom | Description |
|---------|-----|-------------|
| `1` | Fiches d'activités | Documents pédagogiques imprimables ou consultables |
| `2` | Banque de projets STIM | Projets Sciences, Technologies, Ingénierie, Mathématiques |
| `3` | Histoires personnalisées | Récits et narrations adaptés aux niveaux |
| `4` | Matériel de classe | Ressources visuelles, affiches, outils de classe |
| `5` | Activités en ligne | Ressources accessibles via Internet |
| `6` | Jeux en ligne | Jeux éducatifs interactifs (HTML/Web) |
| `7` | Cahiers d'activités | Cahiers d'exercices structurés |

### 2. Filtrage par niveau scolaire

Chaque ressource est associée à un ou plusieurs niveaux :

| ID | Niveau | Tranche d'âge |
|----|--------|---------------|
| `0` | Pré-scolaire | Maternelle |
| `1` | Niveau 1 | 1ère année |
| `2` | Niveau 2 | 2ème année |
| `3` | Niveau 3 | 3ème année |
| `4` | Niveau 4 | 4ème année |
| `5` | Niveau 5 | 5ème année |
| `6` | Niveau 6 | 6ème année |

### 3. Protection par licence

L'accès à l'application est protégé par une **licence à durée limitée** :
- Chaque licence encode une **date d'expiration** chiffrée en AES
- Sans licence valide : accès bloqué à l'écran d'erreur
- La licence est stockée dans SharedPreferences

### 4. Consultation multimédias

Les ressources peuvent être :
- **PDF** : Lecteur intégré (SfPdfViewer / flutter_pdfview)
- **HTML/Web** : Via WebView intégré
- **Jeux locaux** : Via serveur HTTP local sur port 8080
- **Lien externe** : Ouverture navigateur système

### 5. Favoris personnalisés

L'enseignant peut sauvegarder ses ressources préférées pour accès rapide :
- Persistance locale via SharedPreferences
- Disponible dans un onglet dédié "Favoris"
- Toggle immédiat (ajout/retrait) depuis n'importe quelle liste

### 6. Recherche globale

Recherche textuelle insensible aux accents et casse sur toutes les ressources.

### 7. Personnalisation de l'interface

- Thème clair/sombre/système
- Mode d'affichage du panneau de navigation
- Niveau scolaire par défaut (pré-sélection au démarrage)
- Effets visuels Windows (Mica, Acrylic, etc.)

### 8. Gestion de ressources locales

- L'enseignant peut configurer un chemin local vers ses ressources
- Un serveur HTTP local (port 8080) permet aux jeux HTML d'être servis localement
- Possibilité d'ouvrir l'explorateur de fichiers ou le terminal

## Contraintes Métier

| Contrainte | Détail |
|-----------|--------|
| Desktop-only | Application Windows/macOS prioritaire |
| Licence obligatoire | Accès bloqué sans clé valide |
| Données hors-ligne | Ressources chargées depuis JSON assets (pas d'API REST) |
| Pagination | Affichage limité à 10/15/25/50 items par page |
| Audio | Musique de fond et SFX contrôlables |

## Flux Utilisateur Principal

```
Démarrage app
    → Splash screen (animation Lottie + audio loader)
    → Vérification onboarding (vu ou pas ?)
      ├── Non vu → Page Niveau (sélection niveau par défaut)
      └── Vu → MyHomePage
              → Validation licence (FutureBuilder)
                ├── Invalide → LicenseErrorScreen
                └── Valide → NavigationView (8 sections)
                             ├── Accueil (4 onglets)
                             ├── Activités en ligne
                             ├── Banque STIM
                             ├── Fiches d'activités
                             ├── Jeux en ligne
                             ├── Histoires
                             ├── Matériel de classe
                             └── Paramètres
```

## Métriques de Données

| Source | Volume | Contenu |
|--------|--------|---------|
| `ressources.json` | 352 KB | Toutes ressources sauf jeux en ligne |
| `activity.json` | 122 KB | Jeux en ligne (typeId=6) |
| Types de ressources | 7 types | Voir tableau ci-dessus |
| Niveaux scolaires | 7 niveaux | Pré-scolaire + 1 à 6 |
