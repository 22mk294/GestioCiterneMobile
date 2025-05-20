
# Dossier `lib/` – GestioCiterneMobile

Ce dossier contient la logique principale de l’application mobile GestioCiterneMobile, développée en Dart/Flutter. Il regroupe l’ensemble du code source nécessaire au fonctionnement de l’application, de la gestion des interfaces à la manipulation des données.

## Structure générale
```
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
```

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

Tu veux une description ou une documentation à mettre dans un README concernant le fichier pubspec.yaml du dépôt 22mk294/GestioCiterneMobile. Voici un exemple de section à inclure dans ton README :

---

## pubspec.yaml

Le fichier pubspec.yaml est un élément central dans tout projet Flutter/Dart. Il sert à définir les métadonnées du projet, à gérer les dépendances, les assets et les configurations essentielles.

### À quoi sert ce fichier ?

- **Nom du projet, description et version**  
  Le haut du fichier spécifie le nom, la version et une courte description du projet, ce qui est utile pour identifier le projet sur pub.dev ou dans d’autres outils.

- **Gestion des dépendances**  
  La section dependencies liste toutes les bibliothèques externes requises (par exemple flutter, provider, http, etc.), permettant à Flutter de les installer automatiquement.

- **Assets et fonts**  
  Les ressources telles que les images et les polices utilisées dans l’application sont déclarées ici afin d’être intégrées dans le bundle de l’application.

- **Scripts et configurations additionnelles**  
  D’autres sections peuvent inclure des scripts personnalisés, des configurations pour la génération de code, ou des paramètres propres à certains packages.

### Exemple de structure :

```yaml
name: gestiociternemobile
description: Application mobile de gestion de citernes.
version: 1.0.0

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

### Conseils

- À chaque modification de ce fichier, n’oublie pas de lancer la commande :  
  ```bash
  flutter pub get
  ```
- Vérifie la compatibilité des versions des dépendances pour éviter les conflits.
- Utilise ce fichier pour centraliser la configuration de ton application Flutter.

---

Si tu veux une documentation plus spécifique ou détaillée selon le contenu exact de ton fichier pubspec.yaml, fais-le moi savoir !

## Exemple d’utilisation

Pour lancer l’application depuis la racine du projet :

```bash
flutter run
```

Pour ajouter une nouvelle fonctionnalité, crée un nouveau fichier dans le dossier approprié (`screens/`, `models/`, etc.), puis importe-le dans `main.dart` ou l’endroit nécessaire.

## Contribution

Merci de respecter la structure existante pour toute contribution ou modification. Pense à documenter tes ajouts et à maintenir la cohérence du code.

---
