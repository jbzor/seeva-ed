Feature: Pagination des Ressources
  En tant qu'enseignant
  Je veux naviguer dans de grandes listes de ressources
  Afin de ne pas être submergé par trop d'items à la fois

  Background:
    Given une liste de ressources est chargée
    And "pageLimitProvider" est à 10 (valeur par défaut)
    And "currentPageProvider" est à 1

  Scenario: Affichage de la première page
    Given la liste contient 45 ressources
    When la page 1 est calculée
    Then "paginateProvider" retourne les items 1 à 10
    And "hasNext" est true
    And "hasPrev" est false
    And "totalPages" est 5

  Scenario: Navigation vers la page suivante
    Given l'utilisateur est sur la page 1
    When l'utilisateur clique sur "Page suivante"
    Then "currentPageProvider" passe à 2
    And "paginateProvider" recalcule avec offset = 10
    And les items 11 à 20 sont affichés
    And "hasPrev" est true

  Scenario: Navigation vers la page précédente
    Given l'utilisateur est sur la page 3
    When l'utilisateur clique sur "Page précédente"
    Then "currentPageProvider" passe à 2
    And les items 11 à 20 sont affichés

  Scenario: Dernière page avec items incomplets
    Given la liste contient 45 ressources
    And l'utilisateur est sur la page 5
    When la page est calculée
    Then les items 41 à 45 sont affichés (5 items)
    And "hasNext" est false

  Scenario: Changer le nombre d'items par page
    Given l'utilisateur sélectionne "25" dans le sélecteur de pagination
    When "pageLimitProvider" passe à 25
    Then "currentPageProvider" revient à 1
    And les 25 premiers items sont affichés
    And "totalPages" est recalculé

  Scenario: Options de pagination disponibles
    When l'utilisateur ouvre le sélecteur de pagination
    Then les options suivantes sont disponibles : 10, 15, 25, 50
    (provenant de "pageLimitOptionsProvider")

  Scenario: Calcul de l'offset
    Given "currentPageProvider" = 3 et "pageLimitProvider" = 15
    When "paginateProvider" calcule l'offset
    Then offset = (3-1) × 15 = 30
    And les items 31 à 45 sont affichés

  Scenario: Liste plus courte que la limite
    Given la liste contient 7 ressources
    And "pageLimitProvider" est à 10
    When "paginateProvider" calcule
    Then les 7 items sont affichés sur une seule page
    And "hasNext" est false
    And "hasPrev" est false
    And "totalPages" est 1

  Scenario: Réinitialisation de la pagination lors d'une recherche
    Given l'utilisateur est sur la page 3
    When l'utilisateur effectue une nouvelle recherche
    Then "currentPageProvider" revient à 1
    And la nouvelle liste filtrée est paginée depuis le début
