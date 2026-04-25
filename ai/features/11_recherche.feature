Feature: Recherche Globale
  En tant qu'enseignant
  Je veux rechercher dans toutes les ressources disponibles
  Afin de trouver rapidement ce dont j'ai besoin

  Background:
    Given l'utilisateur est sur l'onglet "Recherche" de HomeMainPage
    And "allActivityNotifierProvider" (SearchNotifier) est initialisé
    And "result" global contient toutes les ressources

  Scenario: Affichage initial de la page de recherche
    When la page de recherche s'affiche
    Then une barre de recherche est visible et focalisée
    And aucun résultat n'est affiché (état initial)

  Scenario: Recherche simple par titre
    When l'utilisateur tape "géographie" dans la barre de recherche
    Then "searchRessource(searchItem: 'géographie')" est appelé sur toutes les ressources
    And les ressources dont le titre contient "géographie" sont affichées

  Scenario: Recherche insensible aux accents
    Given les ressources incluent "Géographie de l'Afrique"
    When l'utilisateur tape "geographie" (sans accent)
    Then "removeDiacritics('Géographie de l'Afrique')" retourne "Geographie de l'Afrique"
    And la ressource "Géographie de l'Afrique" apparaît dans les résultats

  Scenario: Recherche insensible à la casse
    Given une ressource s'intitule "MATHÉMATIQUES Avancées"
    When l'utilisateur tape "mathématiques"
    Then la ressource est trouvée malgré la différence de casse

  Scenario: Recherche sur tous les types à la fois
    When l'utilisateur recherche "activité"
    Then les résultats incluent des ressources de tous les types :
      | Type                    |
      | Fiches d'activités      |
      | Banque de projets STIM  |
      | Histoires personnalisées|
      | Matériel de classe      |
      | Activités en ligne      |

  Scenario: Résultat vide
    When l'utilisateur tape "xyzabcdef123" (terme inexistant)
    Then aucun résultat n'est trouvé
    And un état vide est affiché avec un message approprié

  Scenario: Effacer la recherche
    Given des résultats de recherche sont affichés
    When l'utilisateur vide le champ de recherche
    Then les résultats disparaissent ou l'état initial est restauré

  Scenario: Recherche dans la barre de recherche du panneau principal
    Given la barre de recherche est dans le header de NavigationView
    When l'utilisateur tape dans cette barre
    Then la recherche est déclenchée globalement sur toutes les ressources
    And les résultats sont affichés dans le contexte courant
