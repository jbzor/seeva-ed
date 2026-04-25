Feature: Système Audio
  En tant qu'utilisateur de Seeva Education
  Je veux que l'application propose une expérience sonore
  Afin d'enrichir l'interface et signaler les interactions

  Background:
    Given "AudioController" est initialisé
    And les fichiers audio sont disponibles dans "assets/sfx/"

  # --- Musique de fond ---

  Scenario: Démarrage de la musique de fond
    Given "musicOn" est true dans les paramètres
    When l'application démarre
    Then la piste musicale est jouée en boucle
    And le volume est configuré selon les paramètres

  Scenario: Musique de fond désactivée
    Given "musicOn" est false
    When l'application démarre
    Then aucune musique de fond n'est jouée

  Scenario: Pause automatique en arrière-plan
    Given la musique de fond est active
    When l'application passe en arrière-plan (AppLifecycle: paused)
    Then la musique est mise en pause automatiquement

  Scenario: Reprise de la musique au premier plan
    Given la musique était active avant la mise en arrière-plan
    When l'application revient au premier plan (AppLifecycle: resumed)
    Then la musique reprend là où elle s'était arrêtée

  # --- Effets sonores ---

  Scenario: Son de clic sur un bouton
    Given "soundsOn" est true
    When l'utilisateur clique sur un bouton interactif
    Then l'effet sonore "buttonTap" est joué (click1.mp3, volume 1.0)

  Scenario: Son de score / réussite
    Given "soundsOn" est true
    When une action réussie est signalée
    Then l'effet sonore "score" est joué (score1.mp3, volume 0.4)

  Scenario: Son d'impact
    Given "soundsOn" est true
    When une action d'impact est déclenchée
    Then l'effet sonore "hit" est joué (hit1.mp3, volume 0.4)

  Scenario: Effets sonores désactivés
    Given "soundsOn" est false
    When une interaction se produit
    Then aucun effet sonore n'est joué

  # --- Paramètres audio ---

  Scenario: Désactiver tout l'audio
    Given l'utilisateur est dans les paramètres
    When l'utilisateur désactive "Audio global" ("audioOn" = false)
    Then ni la musique ni les effets sonores ne sont joués
    And ce paramètre est sauvegardé dans SharedPreferences

  Scenario: Désactiver uniquement les effets sonores
    Given "audioOn" est true et "musicOn" est true
    When l'utilisateur désactive "Effets sonores" ("soundsOn" = false)
    Then la musique continue de jouer
    And les effets sonores ne sont plus joués

  Scenario: Polyphonie - 2 sons simultanés max
    Given "AudioController" est configuré avec maxPolyphony = 2
    When 3 effets sonores sont déclenchés rapidement
    Then seulement 2 sons jouent simultanément
    And le troisième attend ou interrompt le plus ancien

  # --- Initialisation ---

  Scenario: Lecture du son de chargement au splash
    Given l'application démarre
    When le splash screen s'affiche
    Then "loader.mp3" est lu via AudioPlayer
