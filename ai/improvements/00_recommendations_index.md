# Recommandations & Améliorations — Seeva Education

> Classées par priorité. Chaque fichier détaille le problème, la solution et l'effort estimé.

## Priorité HAUTE (bloquant ou UX critique)

| # | Fichier | Problème | Impact |
|---|---------|----------|--------|
| 1 | [01_server_http_automatique.md](01_server_http_automatique.md) | Serveur HTTP dépend de scripts shell externes — jeux inaccessibles pour les amateurs | Remplacer par serveur Dart pur (`dart:io`) |
| 2 | [02_licence_ux.md](02_licence_ux.md) | Aucune UI pour saisir/renouveler une licence expirée | Ajouter formulaire de saisie de licence |
| 3 | [03_erreur_niveau_null.md](03_erreur_niveau_null.md) | `Ressources.niveau` peut être null → crash potentiel sur `.cast<String>()` | Ajouter guard null |

## Priorité MOYENNE (qualité et robustesse)

| # | Fichier | Problème | Impact |
|---|---------|----------|--------|
| 4 | [04_variables_globales.md](04_variables_globales.md) | Listes globales dans `main.dart` — difficile à tester et à maintenir | Migrer vers providers |
| 5 | [05_hive_inutilise.md](05_hive_inutilise.md) | Hive importé et initialisé partiellement mais non utilisé réellement | Supprimer ou activer |
| 6 | [06_double_routing.md](06_double_routing.md) | Deux systèmes de routing cohabitent (GoRouter + AutoRoute) | Unifier sur GoRouter |
| 7 | [07_audio_lifecycle.md](07_audio_lifecycle.md) | AudioController ne reprend pas toujours correctement après lifecycle | Améliorer la reprise |

## Priorité BASSE (polish et UX)

| # | Fichier | Problème | Impact |
|---|---------|----------|--------|
| 8 | [08_pagination_reset.md](08_pagination_reset.md) | currentPage ne se remet pas à 1 lors d'un changement de catégorie | Navigation confuse |
| 9 | [09_onboarding_skip.md](09_onboarding_skip.md) | Impossible de changer le niveau depuis les paramètres sans onboarding | Synchroniser settings ↔ niveau |
| 10 | [10_feedback_serveur.md](10_feedback_serveur.md) | Aucun feedback visuel sur l'état du serveur HTTP dans l'UI | Indicateur de statut |

---

## Résumé Technique

### Amélioration la plus impactante : #1 Serveur HTTP

**Avant :** L'utilisateur doit avoir `script.sh` ou `start_http_server.bat` dans son dossier html. Sans ça, aucun jeu ne fonctionne. L'app échoue silencieusement.

**Après :** Un serveur Dart pur démarre automatiquement au lancement. L'utilisateur n'a rien à faire.

### Amélioration architecturale : #4 Variables globales

Les 8 listes globales dans `main.dart` (`result`, `ficheActiviteList`, etc.) sont un anti-pattern. Elles :
- Sont inaccessibles aux tests unitaires
- Ne peuvent pas être rechargées dynamiquement
- Créent un couplage fort entre `main.dart` et tous les widgets

**Solution :** Les exposer via un `FutureProvider` unique que les repositories consomment.
