Feature: Jeux En Ligne
  En tant qu'enseignant
  Je veux accéder aux jeux éducatifs en ligne
  Afin de rendre l'apprentissage ludique pour mes élèves

  Background:
    Given l'utilisateur est sur la page "/category/jeu_en_ligne"
    And "jeuEnLigneList" est chargé depuis "activity.json" (typeId='6')

  Scenario: Chargement des jeux en ligne
    When la page est affichée
    Then "ressourcesNotifierProvider" déclenche "fetchRessource(typeId: '6')"
    And les données viennent de "jeuResult" (activity.json), pas de "result"

  Scenario: Affichage des jeux
    Given le chargement réussit
    Then une grille de jeux est affichée
    And chaque jeu affiche une image d'illustration et un titre

  Scenario: Lancement d'un jeu HTML local
    Given un jeu a un "localLink" pointant vers un fichier HTML
    And le serveur HTTP local est démarré sur le port 8080
    When l'utilisateur clique sur le jeu
    Then le jeu s'ouvre via "http://localhost:8080/[chemin]" dans la WebView

  Scenario: Lancement d'un jeu via URL externe
    Given un jeu a un "followLink" URL externe valide
    When l'utilisateur clique sur le jeu
    Then la WebView ou le navigateur s'ouvre avec l'URL

  Scenario: Jeu inaccessible car serveur HTTP non démarré
    Given le serveur HTTP local n'est pas démarré
    And un jeu nécessite le serveur local
    When l'utilisateur tente d'ouvrir le jeu
    Then un message indique que le serveur doit être démarré

  Scenario: Filtrage des jeux par niveau
    Given le niveau courant est "Niveau 3"
    When les jeux sont chargés
    Then seuls les jeux pour le niveau 3 sont affichés

  Scenario: Source de données différente pour les jeux
    Given les données globales sont chargées
    Then "jeuEnLigneList" provient de "jeuResult" (activity.json)
    And non pas de "result" (ressources.json)
    And c'est la seule catégorie avec cette particularité
