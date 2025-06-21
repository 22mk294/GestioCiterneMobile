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

### Structure functionnel du fiechier pubspec.yaml:

```yaml
name: water
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.7.2

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_launcher_icons: ^0.14.3


  flutter_test:
    sdk: flutter


  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

flutter_icons:
  android: true
  ios: true
  image_path: "lib/assets/icones/iconeApk.png"

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:

    - lib/assets/images/logoo.png
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```

### Conseils

- À chaque modification de ce fichier, n’oublie pas de lancer la commande :  
  ```bash
  flutter pub get
  ```
- Vérifie la compatibilité des versions des dépendances pour éviter les conflits.
- Utilise ce fichier pour centraliser la configuration de ton application Flutter.

---

## Exemple d’utilisation

Pour lancer l’application depuis la racine du projet :

tapez cette commande dans la console 

```bash
flutter run
```

## Contribution

Merci de respecter la structure existante pour toute contribution ou modification. Pense à documenter tes ajouts et à maintenir la cohérence du code.

---

# GestioCiterneMobile

## Description du Projet

GestioCiterneMobile est une application mobile Flutter pour la gestion et le monitoring de citernes d'eau. L'application permet de surveiller en temps réel le niveau d'eau, les consommations, les revenus et de gérer les alertes liées aux citernes.

## Architecture du Projet

L'application suit une architecture MVVM (Model-View-ViewModel) avec une séparation claire des responsabilités :

### Structure des Dossiers

```
lib/
├── assets/              # Ressources statiques (images, icônes)
├── controleurs/         # Logique métier et état de l'application
├── gestion_routes.dart  # Gestion de la navigation
├── main.dart           # Point d'entrée de l'application
├── modeles/            # Classes de données
├── services/           # Services et API
├── utils/              # Fonctions utilitaires
└── vues/              # Interface utilisateur
    ├── composants/    # Composants réutilisables
    └── ecrans/        # Écrans de l'application
```

### Composants Principaux

#### Vues
- **EcranAccueil** : Page principale montrant le niveau d'eau et les données principales
- **EcranAlertes** : Gestion des alertes liées aux citernes
- **EcranConnexion** : Authentification des utilisateurs
- **EcranControle** : Contrôle des équipements (pompe, vanne)
- **EcranHistorique** : Historique des données
- **EcranParametres** : Configuration de l'application
- **EcranProfil** : Gestion du profil utilisateur

#### Modèles
- **DonneesCiterne** : Modèle principal contenant :
  - Niveau d'eau en %
  - État de la pompe
  - État de la vanne
  - État du buzzer
  - Capacité de la citerne
  - Type d'alerte
  - Consommation d'eau
  - Revenus générés

#### Services
- **ServiceConnectivite** : Gestion de la connexion réseau
- **ServiceEtatEau** : Gestion de l'état des citernes
- **ServiceRafraichissement** : Mise à jour périodique des données
- **ServiceESP32_HTTP** : Communication avec les capteurs ESP32
- **ServiceAuth_HTTP** : Authentification utilisateur
- **ServiceAlertes_HTTP** : Gestion des alertes
- **ServiceHistorique** : Historique des données
- **ServiceParametre** : Paramètres de l'application
- **ServiceSession** : Gestion des sessions utilisateur

### Fonctionnalités Principales

1. **Monitoring en Temps Réel**
   - Suivi du niveau d'eau
   - Affichage des consommations
   - Calcul des revenus
   - État des équipements (pompe, vanne, buzzer)

2. **Gestion des Alertes**
   - Détection automatique des problèmes
   - Notifications en cas de seuils dépassés
   - Historique des alertes

3. **Contrôle des Équipements**
   - Activation/désactivation de la pompe
   - Contrôle des vannes
   - Gestion des alertes sonores

4. **Historique et Statistiques**
   - Historique des niveaux d'eau
   - Statistiques de consommation
   - Évolution des revenus

5. **Paramètres et Configuration**
   - Configuration des seuils d'alerte
   - Paramètres de rafraîchissement
   - Configuration utilisateur

### Architecture Technique

- **Framework** : Flutter
- **État de l'Application** : Provider
- **Navigation** : Routes nommées
- **API** : Communication HTTP avec les capteurs ESP32
- **Sécurité** : Authentification utilisateur
- **Responsive Design** : Interface adaptative

### Prerequisites

- Flutter SDK
- Dart
- IDE compatible (VSCode, Android Studio, IntelliJ IDEA)

### Installation

1. Cloner le repository
2. Installer les dépendances :
   ```
   flutter pub get
   ```
3. Lancer l'application :
   ```
   flutter run
   ```

## Contributing

Pour contribuer au projet :
1. Faites un fork du repository
2. Créez votre branche de fonctionnalité (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add some amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

## License

Ce projet est sous licence MIT - voir le fichier LICENSE pour plus de détails.

## Contact

Pour toute question ou problème, veuillez ouvrir une issue sur le repository.
