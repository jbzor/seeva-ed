Feature: Splash Screen et Onboarding
  En tant qu'utilisateur de Seeva Education
  Je veux voir un écran d'introduction au démarrage
  Afin d'être guidé vers le bon contenu

  Background:
    Given l'application Seeva Education est installée

  # --- Splash Screen ---

  Scenario: Premier démarrage - animation splash
    Given l'utilisateur lance l'application pour la première fois
    When le splash screen s'affiche
    Then une animation Lottie est jouée en plein écran
    And le son "loader.mp3" est joué
    And l'animation dure environ 12 secondes

  Scenario: Transition vers onboarding au premier démarrage
    Given l'utilisateur n'a jamais complété l'onboarding
    And la clé "seenOnboard" n'existe pas dans SharedPreferences
    When le splash screen se termine
    Then l'utilisateur est redirigé vers la page de sélection de niveau

  Scenario: Transition vers l'accueil si onboarding déjà fait
    Given l'utilisateur a déjà complété l'onboarding
    And la clé "seenOnboard" est "true" dans SharedPreferences
    When le splash screen se termine
    Then l'utilisateur est redirigé vers MyHomePage

  # --- Onboarding / Sélection Niveau ---

  Scenario: Affichage de la page de sélection de niveau
    Given l'utilisateur arrive sur la page de sélection de niveau
    When la page s'affiche
    Then 7 cartes de niveau sont visibles
    And chaque carte affiche une image et un titre
    And les niveaux sont "Pré-scolaire", "Niveau 1", "Niveau 2", "Niveau 3", "Niveau 4", "Niveau 5", "Niveau 6"

  Scenario: Sélection d'un niveau lors de l'onboarding
    Given l'utilisateur est sur la page de sélection de niveau
    When l'utilisateur clique sur "Niveau 3"
    Then le niveau "3" est sauvegardé dans SharedPreferences clé "indexNiveau"
    And l'état OnboardingState passe à "onboarded"
    And l'utilisateur est redirigé vers MyHomePage

  Scenario: Sélection du niveau pré-scolaire
    Given l'utilisateur est sur la page de sélection de niveau
    When l'utilisateur clique sur "Pré-scolaire"
    Then le niveau "0" est sauvegardé dans SharedPreferences clé "indexNiveau"
    And l'application démarre avec le niveau pré-scolaire comme filtre par défaut

  Scenario: Onboarding ne s'affiche qu'une seule fois
    Given l'utilisateur a déjà sélectionné un niveau
    And "seenOnboard" est "true"
    When l'utilisateur relance l'application
    Then la page de sélection de niveau n'est pas affichée
    And l'utilisateur arrive directement sur MyHomePage
