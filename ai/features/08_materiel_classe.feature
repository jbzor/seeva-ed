Feature: Matériel de Classe
  En tant qu'enseignant
  Je veux accéder au matériel de classe
  Afin d'imprimer et utiliser des outils visuels dans ma classe

  Background:
    Given l'utilisateur est sur la page "/category/material_class"
    And "materielClassList" est chargé (typeId='4')

  Scenario: Chargement du matériel de classe
    When la page est affichée
    Then "classeNotifierProvider" déclenche "fetchRessource(typeId: '4')"
    And un indicateur de chargement est affiché

  Scenario: Affichage du matériel
    Given le chargement réussit
    Then une grille de matériel est affichée
    And chaque item affiche une image d'aperçu et un titre

  Scenario: Filtrage du matériel par niveau
    Given le niveau courant est "Niveau 1"
    When le matériel est chargé
    Then seul le matériel adapté au niveau 1 est affiché

  Scenario: Ouverture d'un document matériel (PDF)
    Given un item de matériel a un "localLink" PDF
    When l'utilisateur clique sur cet item
    Then SfPdfViewer ou flutter_pdfview s'ouvre avec le document

  Scenario: Recherche dans le matériel
    Given le matériel est affiché
    When l'utilisateur recherche "calendrier"
    Then les items contenant "calendrier" sont affichés

  Scenario: Matériel multi-niveaux
    Given un item de matériel est associé aux niveaux ["1", "2", "3"]
    When l'utilisateur est sur le niveau 2
    Then cet item apparaît dans les résultats
