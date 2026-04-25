Feature: Validation de Licence
  En tant qu'administrateur ou utilisateur
  Je veux que l'accès à l'application soit protégé par une licence valide
  Afin de contrôler l'utilisation du logiciel

  Background:
    Given l'application est installée
    And l'utilisateur a complété l'onboarding

  # --- Validation au démarrage ---

  Scenario: Licence valide - accès accordé
    Given une clé de licence valide est stockée dans SharedPreferences
    And la date d'expiration déchiffrée est postérieure à aujourd'hui
    When MyHomePage charge la validation de licence
    Then l'état "isNotExpired" est mis à "true"
    And l'utilisateur peut naviguer dans l'application

  Scenario: Licence absente - accès refusé
    Given aucune clé de licence n'est stockée dans SharedPreferences
    When MyHomePage tente de valider la licence
    Then le déchiffrement retourne null
    And l'utilisateur est redirigé vers LicenseErrorScreen

  Scenario: Licence expirée - accès refusé
    Given une clé de licence est stockée dans SharedPreferences
    But la date d'expiration déchiffrée est antérieure à aujourd'hui
    When MyHomePage valide la licence
    Then "isLicenseValid" retourne false
    And l'état "isNotExpired" reste "false"
    And l'utilisateur est redirigé vers LicenseErrorScreen

  Scenario: Clé de licence corrompue
    Given une clé de licence invalide ou non Base64 est stockée
    When la validation tente de déchiffrer la clé
    Then le déchiffrement échoue gracieusement
    And l'utilisateur est redirigé vers LicenseErrorScreen

  # --- Saisie de licence ---

  Scenario: Saisie d'une nouvelle clé de licence valide
    Given l'utilisateur est sur LicenseErrorScreen
    When l'utilisateur entre une clé de licence valide (Base64, longueur > 40)
    And clique sur "Valider"
    Then "isValid(text)" retourne true
    And la clé est sauvegardée via "setLicense(licenseKey)"
    And l'application recharge la validation

  Scenario: Saisie d'une clé trop courte
    Given l'utilisateur est sur LicenseErrorScreen
    When l'utilisateur entre une clé de moins de 40 caractères
    Then "isValid(text)" retourne false
    And un message d'erreur est affiché

  Scenario: Saisie d'une clé non Base64
    Given l'utilisateur est sur LicenseErrorScreen
    When l'utilisateur entre un texte qui n'est pas du Base64 valide
    Then "isBase64(text)" retourne false
    And l'accès est refusé

  # --- Génération de licence ---

  Scenario: Génération d'une clé de licence
    Given une date d'expiration est choisie
    When "generateLicenseKey(expiryDate, secret)" est appelé
    Then une clé Base64 chiffrée AES est retournée
    And cette clé peut être déchiffrée avec la même clé secrète

  Scenario: Clé générée en mode debug
    Given l'application est en mode debug
    When "LicenseManager.init()" est appelé
    Then une clé valide pour 365 jours est générée et loguée en console
