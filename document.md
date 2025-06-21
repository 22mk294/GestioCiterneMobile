# Documentation Technique - GestioCiterneMobile

## 1. Introduction

GestioCiterneMobile est une application mobile Flutter complète pour la gestion et le monitoring de citernes d'eau. Cette documentation détaille l'ensemble des fichiers et fonctionnalités implémentées dans le dossier `lib`.

## 2. Structure du Projet

```
lib/
├── assets/              # Ressources statiques
├── controleurs/         # Logique métier
├── gestion_routes.dart  # Gestion de la navigation
├── main.dart           # Point d'entrée
├── modeles/            # Classes de données
├── services/           # Services et API
├── utils/              # Fonctions utilitaires
└── vues/              # Interface utilisateur
    ├── composants/    # Composants réutilisables
    └── ecrans/        # Écrans de l'application
```

## 3. Analyse Détaillée des Fichiers

### 3.1. Contrôleurs

#### ControleurAccueil.dart
- Gestion de l'écran d'accueil
- Fonctionnalités principales :
  - Chargement des données de la citerne
  - Contrôle de la pompe (activation/désactivation)
  - Contrôle de la vanne (ouverture/fermeture)
  - Gestion du buzzer (alarme)
  - Rafraîchissement périodique des données

#### ControleurAlertes.dart
- Gestion des alertes système
- Fonctionnalités :
  - Récupération et affichage des alertes
  - Marquage des alertes comme lues
  - Gestion des seuils d'alerte

#### ControleurAuth.dart
- Gestion de l'authentification
- Fonctionnalités :
  - Authentification des utilisateurs
  - Gestion des sessions
  - Sécurité des données

#### ControleurHistorique.dart
- Gestion de l'historique des données
- Fonctionnalités :
  - Stockage des données historiques
  - Affichage des tendances
  - Export des données

#### ControleurParametres.dart
- Gestion des paramètres de l'application
- Fonctionnalités :
  - Configuration des seuils d'alerte
  - Paramètres de rafraîchissement
  - Configuration utilisateur

### 3.2. Services

#### ServiceESP32_HTTP.dart
- Communication avec les capteurs ESP32
- Fonctionnalités :
  - Récupération des données de la citerne
  - Envoi de commandes de contrôle
  - Gestion des erreurs réseau
  - API RESTful

#### ServiceAuth.dart
- Service d'authentification
- Fonctionnalités :
  - Authentification des utilisateurs
  - Gestion des tokens
  - Sécurité des données

#### ServiceConnectivite.dart
- Gestion de la connexion réseau
- Fonctionnalités :
  - Vérification de la connexion
  - Gestion des erreurs réseau
  - Mode hors-ligne

#### ServiceRafraichissement.dart
- Gestion du rafraîchissement des données
- Fonctionnalités :
  - Rafraîchissement périodique
  - Gestion des timers
  - Optimisation des appels réseau

### 3.3. Modèles

#### ModeleDonnees.dart
- Modèle principal des données de la citerne
- Propriétés :
  - Niveau d'eau
  - État de la pompe
  - État de la vanne
  - État du buzzer
  - Capacité de la citerne
  - Type d'alerte
  - Consommation d'eau
  - Revenus générés

#### ModeleAlerte.dart
- Modèle des alertes
- Propriétés :
  - ID de l'alerte
  - ID de la citerne
  - Type d'alerte
  - Message
  - Timestamp
  - État de lecture

### 3.4. Vues

#### EcranAccueil.dart
- Page principale de l'application
- Composants :
  - Affichage du niveau d'eau
  - Contrôle de la pompe
  - Contrôle de la vanne
  - Gestion du buzzer
  - Indicateurs d'état

#### EcranAlertes.dart
- Gestion des alertes
- Fonctionnalités :
  - Liste des alertes
  - Filtres
  - Marquage comme lu
  - Historique

#### EcranConnexion.dart
- Écran de connexion
- Fonctionnalités :
  - Authentification
  - Récupération de mot de passe
  - Gestion des erreurs

#### EcranHistorique.dart
- Historique des données
- Fonctionnalités :
  - Graphiques
  - Export de données
  - Filtres temporels

#### EcranParametres.dart
- Configuration de l'application
- Fonctionnalités :
  - Paramètres généraux
  - Seuils d'alerte
  - Préférences utilisateur

### 3.5. Composants Réutilisables

#### BarreNavigationInferieure.dart
- Navigation principale
- Fonctionnalités :
  - Navigation entre écrans
  - État de connexion
  - Notifications

#### BarreSuperieure.dart
- Barre d'information
- Fonctionnalités :
  - Titre de l'écran
  - Boutons d'action
  - Indicateurs

#### CercleEau.dart
- Composant d'affichage du niveau d'eau
- Fonctionnalités :
  - Visualisation du niveau
  - Indicateurs de seuils
  - Animations

## 4. Architecture Technique

### 4.1. Communication avec les Capteurs
- API RESTful
- Format JSON
- Sécurité via API Key
- Gestion des erreurs réseau

### 4.2. Gestion des États
- Provider pour la gestion d'état
- États persistants
- Gestion des erreurs
- Mode hors-ligne

### 4.3. Sécurité
- Authentification
- Gestion des sessions
- Protection des données
- Vérification de la connexion

## 5. Points Clés de l'Application

### 5.1. Monitoring en Temps Réel
- Rafraîchissement automatique
- Mise à jour des données
- Notifications
- Indicateurs d'état

### 5.2. Contrôle des Équipements
- Pompe
- Vanne
- Buzzer
- Sécurité

### 5.3. Gestion des Alertes
- Détection automatique
- Notifications
- Historique
- Seuils personnalisables

### 5.4. Historique et Statistiques
- Graphiques
- Export de données
- Analyse des tendances
- Rapports

## 6. Bonnes Pratiques Implémentées

- Séparation claire des responsabilités
- Gestion des erreurs robuste
- Optimisation des appels réseau
- Interface utilisateur responsive
- Documentation complète
- Tests unitaires
- Sécurité renforcée

## 7. Conclusion

Cette documentation fournit une vue complète de l'application GestioCiterneMobile, expliquant en détail chaque composant et fonctionnalité. L'architecture modulaire et bien structurée facilite le développement et la maintenance de l'application.
