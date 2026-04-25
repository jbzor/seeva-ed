Feature: Page d'Accueil
  En tant qu'enseignant
  Je veux voir un accueil clair avec mes ressources et activités
  Afin de démarrer rapidement mon travail

  Background:
    Given l'utilisateur est sur la page d'accueil "/"
    And les données JSON sont chargées en mémoire

  # --- Structure de l'accueil ---

  Scenario: Affichage de HomeMainPage avec ses 4 onglets
    When HomeMainPage est chargé
    Then un PageView avec 4 onglets est affiché :
      | Index | Onglet      |
      | 0     | Activités   |
      | 1     | Ressources  |
      | 2     | Favoris     |
      | 3     | Recherche   |

  Scenario: Onglet Activités - affichage initial
    Given l'onglet "Activités" est sélectionné
    When les données sont chargées
    Then la liste des activités filtrées par le niveau courant est affichée
    And chaque item affiche une image, un titre et une description

  Scenario: Onglet Ressources - filtrage par niveau
    Given l'onglet "Ressources" est sélectionné
    And le niveau courant est "Niveau 3"
    When les ressources sont chargées
    Then seules les ressources ayant "3" dans leur liste "niveau" sont affichées

  Scenario: Onglet Favoris - liste vide
    Given l'onglet "Favoris" est sélectionné
    And l'utilisateur n'a aucun favori sauvegardé
    When l'onglet s'affiche
    Then un message "Aucun favori" ou un état vide est affiché

  Scenario: Onglet Favoris - avec favoris
    Given l'onglet "Favoris" est sélectionné
    And l'utilisateur a 3 ressources dans ses favoris
    When l'onglet s'affiche
    Then les 3 ressources favorites sont listées

  Scenario: Onglet Recherche
    Given l'onglet "Recherche" est sélectionné
    When l'onglet s'affiche
    Then une barre de recherche est visible
    And le champ est vide par défaut

  # --- Navigation entre onglets ---

  Scenario: Navigation entre onglets via swipe ou clic
    Given l'utilisateur est sur l'onglet "Activités"
    When l'utilisateur navigue vers l'onglet "Ressources"
    Then le PageView glisse vers l'onglet correspondant
    And l'onglet actif est mis en évidence

  # --- Chargement des données ---

  Scenario: Chargement initial des ressources
    Given les listes globales sont vides
    When "main.dart" charge les JSON au démarrage
    Then "result" contient toutes les ressources de "ressources.json"
    And "jeuResult" contient toutes les entrées de "activity.json"
    And "ficheActiviteList" contient les ressources avec typeId='1'
    And "banqueProjetList" contient les ressources avec typeId='2'
    And "histoiresPersonnaList" contient les ressources avec typeId='3'
    And "materielClassList" contient les ressources avec typeId='4'
    And "activiteLigneList" contient les ressources avec typeId='5'
    And "jeuEnLigneList" contient les ressources avec typeId='6' depuis jeuResult
