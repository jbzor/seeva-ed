Feature: Banque de Projets STIM
  En tant qu'enseignant
  Je veux accéder à la banque de projets STIM
  Afin de proposer des projets interdisciplinaires à mes élèves

  Background:
    Given l'utilisateur est sur la page "/category/b_projet_stim"
    And "banqueProjetList" est chargé (typeId='2')

  Scenario: Chargement de la banque de projets STIM
    When la page est affichée
    Then "bankNotifierProvider" déclenche "fetchRessource(typeId: '2')"
    And un indicateur de chargement est affiché

  Scenario: Affichage des projets STIM
    Given le chargement réussit
    When l'état passe à "loadSuccess"
    Then une grille de projets est affichée
    And chaque projet affiche une image, un titre et sa description

  Scenario: Filtrage des projets par niveau
    Given le niveau courant est "Niveau 4"
    When les projets sont chargés
    Then seuls les projets ayant "4" dans leur attribut "niveau" sont affichés

  Scenario: Recherche dans la banque STIM
    Given les projets sont affichés
    When l'utilisateur tape "robotique" dans la barre de recherche
    Then "searchRessource(typeId: '2', searchItem: 'robotique')" est appelé
    And les projets contenant "robotique" dans le titre ou la description sont affichés

  Scenario: Consultation d'un projet STIM
    Given les projets sont affichés
    When l'utilisateur clique sur un projet
    Then la page de détail est ouverte
    And si le projet a un "localLink" PDF, le lecteur PDF s'ouvre
    And si le projet a un "followLink" URL, le navigateur ou WebView s'ouvre

  Scenario: Projet sans lien
    Given un projet n'a ni "localLink" ni "followLink"
    When l'utilisateur clique sur ce projet
    Then seules les informations (titre, description, image) sont affichées
