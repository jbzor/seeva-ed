Feature: Navigation Principale
  En tant qu'enseignant utilisant Seeva Education
  Je veux naviguer facilement entre les sections de l'application
  Afin d'accéder rapidement aux ressources dont j'ai besoin

  Background:
    Given l'utilisateur est authentifié avec une licence valide
    And l'utilisateur est sur MyHomePage

  # --- Panneau de navigation ---

  Scenario: Affichage du panneau de navigation
    When MyHomePage est chargé
    Then un NavigationView Fluent UI est affiché
    And les sections suivantes sont visibles dans le panneau :
      | Section                  | Route                          |
      | Accueil                  | /                              |
      | Activités en ligne       | /category/activite_en_ligne    |
      | Banque de projets STIM   | /category/b_projet_stim        |
      | Fiches d'activités       | /category/fiche_activite       |
      | Jeux en ligne            | /category/jeu_en_ligne         |
      | Histoires personnalisées | /category/historiq_perso       |
      | Matériel de classe       | /category/material_class       |
      | Paramètres               | /settings                      |

  Scenario: Navigation vers Accueil
    Given l'utilisateur est dans n'importe quelle section
    When l'utilisateur clique sur "Accueil" dans le panneau
    Then l'URL change vers "/"
    And HomeMainPage est affiché
    And "indexPage" est mis à 0

  Scenario: Navigation vers Fiches d'activités
    When l'utilisateur clique sur "Fiches d'activités"
    Then l'URL change vers "/category/fiche_activite"
    And FichesActivityPage est chargé (deferred si première visite)
    And le chargement des fiches commence automatiquement

  Scenario: Navigation vers Banque de projets STIM
    When l'utilisateur clique sur "Banque de projets STIM"
    Then l'URL change vers "/category/b_projet_stim"
    And BankActivityPage est chargé

  Scenario: Navigation vers Jeux en ligne
    When l'utilisateur clique sur "Jeux en ligne"
    Then l'URL change vers "/category/jeu_en_ligne"
    And JeuxActivityPage est chargé avec les données de "activity.json"

  Scenario: Navigation vers Paramètres
    When l'utilisateur clique sur "Paramètres" dans le pied du panneau
    Then l'URL change vers "/settings"
    And l'écran de paramètres est affiché

  # --- Comportement de la fenêtre ---

  Scenario: Tentative de fermeture de l'application
    Given l'application est ouverte
    When l'utilisateur clique sur le bouton de fermeture
    Then un dialogue de confirmation s'affiche (setPreventClose: true)
    And l'application ne se ferme pas sans confirmation

  Scenario: Minimisation de la fenêtre
    When l'utilisateur clique sur le bouton de minimisation
    Then la fenêtre est réduite dans la barre des tâches

  # --- Hotkeys ---

  Scenario: Utilisation des raccourcis clavier
    Given l'application est focalisée
    When l'utilisateur utilise un raccourci clavier configuré
    Then la navigation correspondante est déclenchée

  # --- Modes d'affichage du panneau ---

  Scenario: Panneau en mode compact
    Given le mode d'affichage est configuré sur "compact"
    When le panneau est affiché
    Then seules les icônes sont visibles (pas les textes)
    And survoler une icône affiche le tooltip avec le nom

  Scenario: Panneau en mode top
    Given le mode d'affichage est configuré sur "top"
    When le panneau est affiché
    Then la navigation est affichée en haut de l'écran

  Scenario: Préchargement des modules deferred
    When l'application démarre après "runApp()"
    Then tous les modules deferred sont préchargés en arrière-plan :
      | Module    |
      | bank      |
      | classe    |
      | fiches    |
      | history   |
      | jeux      |
      | online    |
      | ressources|
      | settings  |
