# SEEVA EDUCATION — AI Cache & Documentation

> Généré le 2026-04-25 par analyse complète du projet.
> Ce répertoire est le point d'entrée de tout futur travail IA sur ce projet.

## Structure

```
ai/
├── README.md                          ← Ce fichier (index)
├── reports/
│   ├── 01_business_analysis.md        ← Besoins métier & vision produit
│   ├── 02_functional_analysis.md      ← Analyse fonctionnelle complète
│   └── 03_architecture_analysis.md   ← Architecture technique
├── features/                          ← Comportements Gherkin (BDD)
│   ├── 01_splash_onboarding.feature
│   ├── 02_licence_validation.feature
│   ├── 03_navigation.feature
│   ├── 04_accueil.feature
│   ├── 05_fiches_activites.feature
│   ├── 06_banque_stim.feature
│   ├── 07_histoires.feature
│   ├── 08_materiel_classe.feature
│   ├── 09_activites_en_ligne.feature
│   ├── 10_jeux_en_ligne.feature
│   ├── 11_recherche.feature
│   ├── 12_favoris.feature
│   ├── 13_pagination.feature
│   ├── 14_audio.feature
│   ├── 15_settings.feature
│   └── 16_ressources_locales.feature
└── cache/
    ├── models.md                      ← Tous les modèles de données
    ├── providers.md                   ← Tous les providers Riverpod
    ├── routes.md                      ← Toutes les routes & navigation
    ├── dependencies.md                ← Toutes les dépendances pubspec
    ├── architecture.md                ← Patterns & conventions du projet
    ├── business_rules.md              ← Règles métier critiques
    └── quick_reference.md             ← Référence rapide pour tickets
```

## Contexte Projet en 3 lignes

**Seeva Education** est une application desktop Flutter (Windows/macOS) qui centralise des ressources pédagogiques pour enseignants : fiches d'activités, jeux, histoires, matériel de classe, projets STIM. Elle utilise Fluent UI (Windows design), Riverpod pour la gestion d'état, et un système de licence AES pour protéger l'accès.

## Recommandations & Améliorations

Voir `improvements/00_recommendations_index.md` pour la liste priorisée.  
Amélioration #1 (serveur HTTP) **déjà implémentée** dans `lib/files/folders.dart`.

## Fichiers critiques à lire avant tout ticket

| Fichier | Rôle |
|---------|------|
| `lib/main.dart` | Point d'entrée, chargement JSON, variables globales |
| `lib/models/ressources.dart` | Modèle central de toutes les ressources |
| `lib/provider/providers.dart` | Tous les providers Riverpod |
| `lib/screens/main_home.dart` | Navigation principale (NavigationView) |
| `lib/widgets/helper.dart` | Fonctions utilitaires critiques |
| `lib/widgets/preference_helper.dart` | Gestion favoris & SharedPreferences |
| `lib/keys/licence_manager.dart` | Gestion des licences |
| `assets/json/ressources.json` | Source de données principale (352KB) |
| `assets/json/activity.json` | Source jeux/activités en ligne (122KB) |
