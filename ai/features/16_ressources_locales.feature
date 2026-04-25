Feature: Gestion des Ressources Locales et Serveur HTTP
  En tant qu'enseignant
  Je veux accéder à des ressources pédagogiques stockées localement
  Afin d'utiliser des jeux et documents sans connexion Internet

  Background:
    Given l'application est démarrée sur Windows ou macOS

  # --- Serveur HTTP local ---

  Scenario: Démarrage automatique du serveur au lancement
    When l'application démarre
    Then "readGameFiles()" est appelé
    And le serveur HTTP local tente de démarrer sur le port 8080

  Scenario: Vérification si le serveur est déjà actif
    When "isServerRunning()" est appelé
    Then la fonction vérifie si le port 8080 est utilisé
    And retourne true si actif, false sinon

  Scenario: Chemin des ressources sur macOS
    Given l'application tourne sur macOS
    When "getGameDataDirectory()" est appelé
    Then le dossier "~/Library/html" est utilisé ou créé

  Scenario: Chemin des ressources sur Windows
    Given l'application tourne sur Windows
    When "getGameDataDirectory()" est appelé
    Then le dossier "%AppData%/html" est utilisé ou créé

  # --- Accès aux fichiers locaux ---

  Scenario: Ouverture d'un PDF stocké localement
    Given une ressource a un "localLink" = "/path/to/document.pdf"
    When l'utilisateur ouvre cette ressource
    Then "isPDFPath(localLink)" retourne true
    And SfPdfViewer (Syncfusion) ou flutter_pdfview s'ouvre avec le chemin local

  Scenario: Ouverture d'un HTML/jeu local via serveur
    Given une ressource a un "localLink" = "games/math_game/index.html"
    And le serveur HTTP est actif sur le port 8080
    When l'utilisateur ouvre cette ressource
    Then la WebView navigue vers "http://localhost:8080/games/math_game/index.html"

  Scenario: Ouverture d'une ressource via URL externe
    Given une ressource a un "followLink" = "https://example.com/resource"
    When l'utilisateur ouvre cette ressource
    Then "isURL(followLink)" retourne true
    And "url_launcher" ouvre l'URL dans le navigateur ou la WebView

  # --- Explorateur de fichiers ---

  Scenario: Ouverture de l'explorateur de fichiers
    When l'utilisateur clique sur "Ouvrir le dossier" dans les paramètres
    Then "openScriptDirectory()" est appelé
    And l'explorateur système s'ouvre sur le dossier html configuré

  Scenario: Ouverture du terminal dans le dossier html
    When l'utilisateur clique sur "Ouvrir le terminal"
    Then "openTerminal()" est appelé
    And un terminal s'ouvre avec "cd [chemin_html]" préchargé

  # --- LocalhostServer (InAppLocalhostServer) ---

  Scenario: Configuration du serveur avec le chemin sauvegardé
    Given "CashHelper.getData(key: 'html')" retourne un chemin valide
    When MyHomePage est créé
    Then "localhostServer" est configuré avec ce chemin comme "documentRoot"
    And "shared: true" permet le partage entre plusieurs WebViews

  Scenario: Accès au serveur depuis la WebView
    Given le serveur HTTP est démarré
    And une WebView est ouverte
    When la WebView charge "http://localhost:8080/[fichier]"
    Then le fichier est servi depuis le dossier documentRoot
