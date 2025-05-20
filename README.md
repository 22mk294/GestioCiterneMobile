
# Dossier `lib/` – GestioCiterneMobile

Ce dossier contient la logique principale de l’application mobile GestioCiterneMobile, développée en Dart/Flutter. Il regroupe l’ensemble du code source nécessaire au fonctionnement de l’application, de la gestion des interfaces à la manipulation des données.

## Structure générale

lib/
│

├── main.dart    # Point d’entrée de l’application

├── gestion_routes.dart                  # Fichier centralisé pour gérer les routes nommées
│
├── composants/
│   └── barre_navigation_inferieure.dart # Composant personnalisé pour la barre de navigation
│
├── vues/
│   ├── ecrans/
│   │   ├── ecran_accueil.dart           # Interface Accueil (niveau d’eau)
│   │   ├── ecran_parametres.dart        # Interface Paramètres
│   │   ├── ecran_historique.dart        # Interface Historique
│   │   ├── ecran_alertes.dart           # Interface Alertes
│   │   └── ecran_demarrage.dart         # Interface SplashScreen (affichée pendant 3s)
│   │
│   └── widgets/
│       └── (widgets réutilisables si besoin)
│
├── modèles/
│   └── (modèles de données, ex : Consommation, Alerte...)
│
├── services/
│   └── service_esp32_http.dart          # Service de communication HTTP avec l'ESP32
│
└── utils/
    └── constantes.dart                  # Constantes générales, couleurs, styles


- **main.dart** : Point d’entrée de l’application. Configure et lance l’application Flutter.
- **models/** : Définitions des modèles de données utilisés dans l’application (ex : citernes, utilisateurs, historiques…).
- **services/** : Services de gestion de données, d’accès à des API, ou de persistance locale.
- **screens/** : Les différentes pages ou vues de l’application (accueil, gestion des citernes, profils, etc.).
- **widgets/** : Composants réutilisables de l’interface utilisateur.
- **utils/** : Fonctions utilitaires et helpers divers.

_Remarque : adapte cette liste selon la structure réelle de ton dossier `lib/`._

## Technologies utilisées

- **Dart** (Flutter) – 95,7% du code
- **Swift** – 3,5% (principalement pour l’intégration native iOS si besoin)
- **Autres** – 0,8%

## Bonnes pratiques

- Organiser le code par fonctionnalités ou domaines (feature-based).
- Séparer clairement les responsabilités : présentation (UI), logique métier, accès aux données.
- Utiliser des widgets personnalisés pour réutiliser l’UI.
- Documenter chaque classe/fonction complexe.

## Exemple d’utilisation

Pour lancer l’application depuis la racine du projet :

```bash
flutter run
```

Pour ajouter une nouvelle fonctionnalité, crée un nouveau fichier dans le dossier approprié (`screens/`, `models/`, etc.), puis importe-le dans `main.dart` ou l’endroit nécessaire.

## Contribution

Merci de respecter la structure existante pour toute contribution ou modification. Pense à documenter tes ajouts et à maintenir la cohérence du code.

---
