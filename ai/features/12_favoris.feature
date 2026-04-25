Feature: Gestion des Favoris
  En tant qu'enseignant
  Je veux sauvegarder mes ressources préférées
  Afin d'y accéder rapidement sans chercher à chaque fois

  Background:
    Given l'application est démarrée
    And "FavorisProvider" est initialisé avec les données de SharedPreferences

  # --- Ajout aux favoris ---

  Scenario: Ajouter une ressource aux favoris
    Given une ressource est affichée dans une liste (fiches, banque, etc.)
    And cette ressource n'est pas encore dans les favoris
    When l'utilisateur clique sur le bouton favori de la ressource
    Then "FavorisProvider.addFav(ressource)" est appelé
    And la ressource est ajoutée à "list" en mémoire
    And la ressource est persistée dans SharedPreferences clé "ressources"
    And le bouton bascule visuellement vers "actif" (étoile pleine ou cœur rouge)

  Scenario: Le bouton favori indique l'état courant
    Given l'utilisateur consulte une liste de ressources
    When la liste est affichée
    Then chaque ressource déjà en favori affiche le bouton dans l'état "actif"
    And "favExist(ressource)" est utilisé pour déterminer l'état

  # --- Retrait des favoris ---

  Scenario: Retirer une ressource des favoris depuis une liste
    Given une ressource est dans les favoris
    When l'utilisateur clique sur le bouton favori actif
    Then "FavorisProvider.removeFav(ressource)" est appelé
    And la ressource est retirée de "list" en mémoire
    And la modification est persistée dans SharedPreferences
    And le bouton bascule vers l'état "inactif"

  Scenario: Retirer une ressource depuis la page Favoris
    Given l'utilisateur est sur l'onglet "Favoris"
    And la ressource "Fiche de maths" est dans la liste
    When l'utilisateur clique sur le bouton de suppression
    Then la ressource disparaît de la liste affichée
    And elle est retirée de SharedPreferences

  # --- Consultation des favoris ---

  Scenario: Affichage de la liste des favoris
    Given l'utilisateur a 5 ressources en favoris
    When l'utilisateur navigue vers l'onglet "Favoris"
    Then "FavorisProvider.getRessourcesList()" est appelé
    And les 5 ressources favorites sont affichées

  Scenario: Favoris vides
    Given l'utilisateur n'a aucun favori
    When l'utilisateur ouvre l'onglet "Favoris"
    Then un état vide est affiché

  # --- Persistance ---

  Scenario: Les favoris persistent entre les sessions
    Given l'utilisateur a ajouté "Histoire des animaux" aux favoris
    And l'utilisateur ferme et relance l'application
    When l'application charge "FavorisProvider.getRessourcesList()"
    Then "Histoire des animaux" est toujours dans la liste des favoris

  Scenario: Format de stockage JSON
    Given l'utilisateur ajoute une ressource aux favoris
    When la persistance s'effectue
    Then la ressource est sérialisée en JSON via "toJsonFromString()"
    And stockée dans SharedPreferences clé "ressources" comme List<String>

  # --- Limites et edge cases ---

  Scenario: Ajouter deux fois la même ressource
    Given une ressource est déjà dans les favoris
    When l'utilisateur tente de l'ajouter à nouveau
    Then "favExist(ressource)" retourne true
    And la ressource n'est pas dupliquée dans la liste
