Feature: Activités En Ligne
  En tant qu'enseignant
  Je veux accéder aux activités disponibles en ligne
  Afin de proposer des ressources interactives nécessitant Internet

  Background:
    Given l'utilisateur est sur la page "/category/activite_en_ligne"
    And "activiteLigneList" est chargé (typeId='5')

  Scenario: Chargement des activités en ligne
    When la page est affichée
    Then "onLineNotifierProvider" déclenche "fetchRessource(typeId: '5')"

  Scenario: Affichage des activités
    Given le chargement réussit
    Then une liste d'activités en ligne est affichée
    And chaque activité indique son nom et une description

  Scenario: Vérification de la connectivité Internet
    Given l'utilisateur ouvre la page des activités en ligne
    When "isConnectedProvider" est vérifié
    And l'appareil n'est pas connecté à Internet
    Then un message d'avertissement de connectivité est affiché

  Scenario: Ouverture d'une activité en ligne
    Given une activité a un "followLink" valide
    When l'utilisateur clique sur l'activité
    Then la WebView intégrée (flutter_inappwebview) s'ouvre avec l'URL
    Or le navigateur système s'ouvre si WebView non disponible

  Scenario: Filtrage par niveau
    Given le niveau courant est "Niveau 5"
    When les activités sont chargées
    Then seules les activités ayant "5" dans leur liste "niveau" sont affichées

  Scenario: Recherche dans les activités en ligne
    Given les activités sont affichées
    When l'utilisateur recherche "lecture"
    Then les activités contenant "lecture" sont affichées (insensible accents)
