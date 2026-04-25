Feature: Paramètres de l'Application
  En tant qu'utilisateur de Seeva Education
  Je veux personnaliser l'application selon mes préférences
  Afin d'avoir une expérience adaptée à mon environnement de travail

  Background:
    Given l'utilisateur est sur la page "/settings"
    And SharedPreferences est accessible

  # --- Thème ---

  Scenario: Passage en mode sombre
    Given le mode actuel est "light"
    When l'utilisateur sélectionne "Sombre"
    Then "AppTheme.mode" passe à "ThemeMode.dark"
    And l'interface bascule immédiatement en mode sombre
    And le paramètre est sauvegardé

  Scenario: Passage en mode automatique (système)
    When l'utilisateur sélectionne "Automatique"
    Then "AppTheme.mode" passe à "ThemeMode.system"
    And l'interface suit le thème du système d'exploitation

  Scenario: Passage en mode clair
    When l'utilisateur sélectionne "Clair"
    Then "AppTheme.mode" passe à "ThemeMode.light"
    And l'interface passe en mode clair

  # --- Mode d'affichage de la navigation ---

  Scenario: Changement du mode de navigation vers "compact"
    When l'utilisateur sélectionne "Compact" pour le mode de navigation
    Then "AppTheme.displayMode" passe à "PaneDisplayMode.compact"
    And le panneau de navigation se réduit aux icônes uniquement

  Scenario: Modes de navigation disponibles
    When l'utilisateur ouvre le sélecteur de mode de navigation
    Then les options suivantes sont disponibles :
      | Mode     | Label      |
      | auto     | Automatique|
      | compact  | Compact    |
      | top      | Haut       |
      | open     | Ouvert     |
      | minimal  | Minimal    |

  # --- Niveau scolaire par défaut ---

  Scenario: Changement du niveau par défaut
    Given le niveau actuel est "Pré-scolaire"
    When l'utilisateur sélectionne "Niveau 4"
    Then "indexNiveau" est sauvegardé comme "4" dans SharedPreferences
    And toutes les listes de ressources sont filtrées avec le niveau 4 au prochain chargement

  Scenario: Persistance du niveau entre sessions
    Given l'utilisateur a sélectionné "Niveau 2"
    When l'application est fermée et relancée
    Then le niveau 2 est automatiquement appliqué

  # --- Chemin des ressources locales ---

  Scenario: Configuration du chemin HTML
    When l'utilisateur entre un chemin dans "Chemin des ressources"
    And clique sur "Enregistrer"
    Then le chemin est sauvegardé dans SharedPreferences clé "html"
    And le serveur HTTP utilisera ce chemin pour servir les fichiers

  Scenario: Ouverture du dossier de ressources
    Given un chemin de ressources est configuré
    When l'utilisateur clique sur "Consulter le dossier"
    Then l'explorateur de fichiers s'ouvre sur le dossier configuré

  # --- Serveur HTTP local ---

  Scenario: Démarrage du serveur HTTP local
    Given le serveur HTTP n'est pas démarré
    When l'utilisateur clique sur "Démarrer le serveur"
    Then "startHttpServer()" est appelé
    And le serveur HTTP démarre sur le port 8080
    And un message de confirmation est affiché

  Scenario: Le serveur est déjà démarré
    Given le serveur HTTP est déjà actif
    When l'utilisateur consulte les paramètres
    Then l'état "Serveur actif" est affiché
    And le bouton indique l'état courant du serveur

  Scenario: Ouverture du terminal
    When l'utilisateur clique sur "Ouvrir le terminal"
    Then un terminal s'ouvre dans le dossier de ressources HTML

  # --- Couleur d'accentuation ---

  Scenario: Sélection d'une couleur d'accentuation
    When l'utilisateur choisit la couleur "Bleu"
    Then "AppTheme.color" passe à "Colors.blue.toAccentColor()"
    And toute l'interface adopte la nouvelle couleur d'accent

  Scenario: Couleurs disponibles
    When l'utilisateur ouvre le sélecteur de couleur
    Then les couleurs suivantes sont disponibles :
      System, Yellow, Orange, Red, Magenta, Purple, Blue, Teal, Green
