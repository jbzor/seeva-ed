Feature: Histoires Personnalisées
  En tant qu'enseignant
  Je veux accéder aux histoires personnalisées
  Afin d'enrichir l'apprentissage de la lecture de mes élèves

  Background:
    Given l'utilisateur est sur la page "/category/historiq_perso"
    And "histoiresPersonnaList" est chargé (typeId='3')

  Scenario: Chargement des histoires
    When la page est affichée
    Then "historyNotifierProvider" déclenche "fetchRessource(typeId: '3')"
    And un indicateur de chargement est affiché

  Scenario: Affichage des histoires
    Given le chargement réussit
    Then une grille d'histoires est affichée
    And chaque histoire affiche une image de couverture et un titre

  Scenario: Filtrage des histoires par niveau
    Given le niveau courant est "Pré-scolaire"
    When les histoires sont chargées
    Then seules les histoires adaptées au pré-scolaire sont affichées

  Scenario: Recherche dans les histoires
    Given les histoires sont affichées
    When l'utilisateur recherche "animaux"
    Then les histoires contenant "animaux" dans le titre sont affichées (insensible accents/casse)

  Scenario: Lecture d'une histoire PDF
    Given une histoire a un "localLink" pointant vers un fichier PDF
    When l'utilisateur clique sur l'histoire
    Then le lecteur PDF intégré s'ouvre avec le fichier correspondant

  Scenario: Lecture d'une histoire en ligne
    Given une histoire a un "followLink" URL
    When l'utilisateur clique sur l'histoire
    Then la WebView ou le navigateur externe s'ouvre avec l'URL

  Scenario: Ajout d'une histoire aux favoris
    Given une histoire est affichée
    When l'utilisateur clique sur le bouton favori (étoile/cœur)
    Then l'histoire est ajoutée à la liste des favoris
    And le bouton indique l'état "favori actif"
