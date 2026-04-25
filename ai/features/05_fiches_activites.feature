Feature: Fiches d'Activités
  En tant qu'enseignant
  Je veux consulter les fiches d'activités pédagogiques
  Afin de préparer mes cours

  Background:
    Given l'utilisateur est sur la page "/category/fiche_activite"
    And "ficheActiviteList" est chargé (typeId='1')

  Scenario: Chargement initial des fiches d'activités
    When la page est affichée
    Then "fichesNotifierProvider" déclenche "fetchRessource(typeId: '1')"
    And l'état passe de "initial" à "loadInProgress"
    And un indicateur de chargement est affiché

  Scenario: Affichage réussi des fiches
    Given le chargement se termine avec succès
    When l'état passe à "loadSuccess"
    Then une grille de fiches est affichée
    And chaque fiche affiche une image, un titre et une description
    And le nombre total de fiches est affiché

  Scenario: Affichage du placeholder si image manquante
    Given une fiche n'a pas d'image associée
    When la fiche est affichée
    Then l'image "assets/images/placeholder.png" est utilisée

  Scenario: Erreur de chargement des fiches
    Given une erreur survient lors du chargement
    When l'état passe à "loadFailure"
    Then un message d'erreur est affiché
    And l'utilisateur peut réessayer

  Scenario: Filtrage des fiches par niveau scolaire
    Given le niveau par défaut est "Niveau 2"
    When les fiches sont chargées
    Then seules les fiches ayant "2" dans leur attribut "niveau" sont affichées

  Scenario: Recherche dans les fiches d'activités
    Given les fiches sont affichées
    When l'utilisateur tape "mathématiques" dans la barre de recherche
    Then "searchRessource(typeId: '1', searchItem: 'mathématiques')" est appelé
    And les fiches dont le titre contient "mathématiques" (insensible aux accents) sont affichées

  Scenario: Recherche insensible aux accents
    Given les fiches sont affichées
    When l'utilisateur tape "mathematiques" (sans accent)
    Then les fiches contenant "mathématiques" sont quand même trouvées
    And "removeDiacritics()" est utilisé pour la comparaison

  Scenario: Recherche sans résultat
    Given les fiches sont affichées
    When l'utilisateur tape "xyzabc123" dans la barre de recherche
    Then la liste de résultats est vide
    And un état vide est affiché

  Scenario: Effacer la recherche
    Given l'utilisateur a effectué une recherche
    When l'utilisateur efface le champ de recherche
    Then "fetchRessource(typeId: '1')" est appelé à nouveau
    And toutes les fiches du niveau sélectionné sont affichées

  Scenario: Ouvrir le détail d'une fiche
    Given les fiches sont affichées
    When l'utilisateur clique sur une fiche
    Then la page de détail est ouverte
    And les informations de la fiche sont affichées (titre, description, image)
