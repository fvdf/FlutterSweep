# 📁 PLAN.md – FlutterSweep

> **FlutterSweep** est une application Flutter desktop qui aide les développeurs à garder de la place sur leur disque, en ciblant en priorité les projets Flutter et leurs fichiers “purgables”.  
> Plateformes : **macOS d’abord**, mais les choix techniques doivent permettre un portage futur vers **Windows** et **Linux**.  
> Internationalisation (FR/EN) et choix du thème (clair/sombre/système) prévus **dès le départ**.

---

## 🤖 Consignes pour l’IA qui lira ce PLAN.md

Si tu es une IA utilisée pour développer **FlutterSweep** :

1. **Ne commence pas par coder immédiatement.**
   - Lis entièrement ce `PLAN.md`.
   - Si la demande de l’utilisateur ne correspond plus exactement à ce plan, **mets à jour ce `PLAN.md` en priorité**, de manière cohérente et structurée.

2. **Maintiens `PLAN.md` et `README.md` synchronisés :**
   - À chaque ajout/modification de fonctionnalité significative :
     - mets à jour ce `PLAN.md` (architecture, roadmap, périmètre),
     - mets à jour le `README.md` (fonctionnalités disponibles, installation, compatibilité, limitations).
   - Ne laisse jamais le `README.md` en retard par rapport au code réel.

3. **Pense multi-plateforme (Desktop) :**
   - Même si l’implémentation initiale cible **macOS**, les packages et API choisis doivent :
     - rester compatibles avec **Windows** et **Linux** autant que possible,  
       **ou**
     - être isolés dans des services facilement remplaçables par plateforme.
   - Documente dans le `README.md` :
     - les plateformes **testées**,
     - les plateformes **visées** (avec mention “expérimental” si nécessaire),
     - les éventuelles différences de comportement selon l’OS.

4. **Internationalisation & thème dès le départ :**
   - Mets en place dès le début :
     - l’i18n (ex. `flutter_localizations` + `intl` ou système équivalent),
     - les thèmes (clair, sombre, système).
   - Crée une **page Paramètres** permettant de choisir :
     - la langue (au moins FR / EN),
     - le thème (clair / sombre / système).
   - Documente clairement dans le `README.md` :
     - quelles langues sont supportées,
     - comment fonctionne le thème (utilisation du thème système, override utilisateur).

5. **Logs visibles pour l’utilisateur :**
   - Les logs ne sont pas uniquement internes.
   - Ajoute une **console intégrée** dans l’interface de FlutterSweep :
     - suffisamment compacte pour ne pas prendre tout l’écran,
     - capable d’afficher en temps réel au moins les **10 dernières lignes** de logs,
     - qui s’active/affiche clairement lors d’une purge ou d’un archivage.
   - Plus tard, ces logs pourront aussi être exportés ou affichés sur une page dédiée.

---

## 🧠 Vision générale de FlutterSweep

- Application Flutter desktop pour **gérer l’espace disque occupé par les projets Flutter**.
- Périmètre initial :
  - un seul **dossier racine** contenant des projets Flutter (ex. `~/developpement/flutter`).
- FlutterSweep permet à l’utilisateur de :
  - **sélectionner le dossier racine** des projets,
  - **scanner automatiquement** ce dossier,
  - **détecter les projets Flutter** (via `pubspec.yaml` + `lib/`),
  - **calculer la taille totale** de chaque projet,
  - **estimer la taille “purgable”** (fichiers temporaires / build),
  - **catégoriser les projets** via des tags (`Intact`, `Purge safe`, `Archiver`),
  - **purger** les dossiers temporaires,
  - **archiver** certains projets (purge + zip + déplacement vers un dossier d’archives),
  - **suivre en temps réel les actions** via la console de logs intégrée.

Aucun projet n’est supprimé “brutalement” :

- mode purge : on supprime uniquement les dossiers temporaires “safe” ;
- mode archivage : purge → zip → déplacement → suppression du projet original **uniquement si le zip a réussi**.

---

## 🧱 Concept & Terminologie

- **Dossier racine** : dossier choisi par l’utilisateur, qui contient les projets Flutter (souvent un “workspace” ou dossier de dev).
- **Projet Flutter** :
  - Dossier contenant au minimum :
    - un fichier `pubspec.yaml`,
    - un dossier `lib/`.
- **Dossiers purgables** (par projet) – V1 :
  - `build/`
  - `.dart_tool/`
  - `ios/Pods/`
  - `ios/.symlinks/` (si présent)
  - `android/.gradle/`
  - `android/app/build/`
  - (Extensions possibles plus tard selon les besoins et l’OS).
- **Tags de projet** :
  - `Intact` : ne jamais purger ni archiver automatiquement ce projet.
  - `Purge safe` : autorisé à supprimer les dossiers purgables définis.
  - `Archiver` : autorisé à purger, zipper puis déplacer vers un dossier d’archives (suppression du dossier d’origine après succès).

---

## 🌐 Multi-plateforme (macOS / Windows / Linux)

Dès la conception :

- Utiliser **`dart:io`** et des packages **compatibles Desktop** :
  - macOS,
  - Windows,
  - Linux (si possible).
- Éviter les dépendances macOS-only (ou les encapsuler) :
  - Si des optimisations spécifiques à macOS sont ajoutées (ex. appels à `du`), elles doivent passer par une couche d’abstraction (ex. `FileSystemStatsService`) pouvant avoir d’autres implémentations pour Windows/Linux.
- Le `README.md` doit clairement indiquer :
  - “FlutterSweep est actuellement développé et testé sur macOS.  
    Le support Windows / Linux est prévu mais non garanti dans la version actuelle.”

---

## 🌍 Internationalisation & Thème

- Internationalisation :

  - Langues initiales :
    - Français,
    - Anglais.
  - Utiliser `flutter_localizations` + un système de ressources (ARB, JSON, etc.).
  - Tous les textes visibles de l’UI doivent passer par le système de traduction.

- Thème :

  - 3 modes :
    - **Thème clair** forcé,
    - **Thème sombre** forcé,
    - **Thème système** (par défaut recommandé).
  - Le choix est stocké dans les préférences (persistant).

- Page Paramètres (`SettingsPage`) :

  - Sélection de la langue (liste ou dropdown).
  - Sélection du thème (radio buttons / dropdown).
  - Affichage/modification du chemin du **dossier d’archives** (option V1 ou V2).
  - Affichage de la version de FlutterSweep.

---

## 🧩 Fonctionnalités – Version 1

### 1. Sélection du dossier racine

- Au premier lancement, si aucun dossier racine n’est défini :
  - écran de bienvenue **FlutterSweep** avec :
    - une courte explication,
    - un bouton “Choisir le dossier des projets Flutter”.

- Utiliser un **file picker multiplateforme** (ex. `file_picker`) pour le choix de dossier.
- Le chemin est mémorisé pour les prochaines sessions (via Hive ou autre persistance).

---

### 2. Scan des projets

- Un bouton “🔄 Re-scanner” dans la barre d’actions.
- Processus de scan :
  1. Parcourir récursivement le dossier racine.
  2. Détecter les projets Flutter (présence de `pubspec.yaml` + `lib/`).
  3. Pour chaque projet :
     - calculer :
       - **taille totale** (tous les fichiers),
       - **taille purgable** (somme de la taille des dossiers marqués purgables),
       - **date de dernière modification**,
       - **présence de `.git/`**.
  4. Construire une liste de `ProjectInfo`.
  5. Mettre à jour la liste dans l’UI + le dashboard.

- Performance :
  - V1 : implémentation simple tout en Dart.
  - Optimisable plus tard avec des commandes OS spécifiques via un service abstrait.

---

### 3. Dashboard global

En haut de l’écran principal de FlutterSweep :

- Afficher :
  - Nombre de projets détectés (`projectCount`).
  - Taille totale occupée par ces projets (`totalSizeBytes`).
  - Taille totale purgable (`totalPurgeableBytes`).
  - Taille totale occupée par les archives (facultatif en V1, mais à prévoir).

- Indicateur type :
  - “FlutterSweep peut potentiellement libérer **X Go** en nettoyant les projets marqués `Purge safe` ou `Archiver`.”

---

### 4. Liste des projets

- Liste (ListView / DataTable) avec :
  - **Barre de recherche** (filtre sur le nom du projet).
  - **Filtres par tags** : `Tous`, `Intact`, `Purge safe`, `Archiver`.
  - **Tri** :
    - par nom (A → Z),
    - par taille totale,
    - par taille purgable,
    - par date de dernière modification.

#### Carte projet (ou ligne de tableau)

Pour chaque projet, afficher :

- Nom du projet (nom du dossier).
- Chemin (relatif au dossier racine, ou coupé intelligemment).
- Tags sous forme de chips cliquables :
  - `Intact`,
  - `Purge safe`,
  - `Archiver`.
- Infos :
  - Taille totale (format lisible : Ko / Mo / Go).
  - Taille purgable.
  - Date de dernière modification.
  - Badge “Git” si `.git/` détecté.
- Warning visuel si :
  - Tag = `Archiver` **et** pas de `.git/` → icône ⚠️ + tooltip.

---

## 🧹 Actions de nettoyage & archivage

### 5.1 Purge classique (`Purge safe`)

- Ne concerne jamais les projets `Intact`.
- Par défaut, l’action globale “Purger” vise :
  - tous les projets taggés `Purge safe`,
  - éventuellement les projets `Archiver` (car purge fait aussi partie de l’archivage), selon UX choisie.

- Dossiers supprimés par FlutterSweep :
  - `build/`
  - `.dart_tool/`
  - `ios/Pods/`
  - `ios/.symlinks/`
  - `android/.gradle/`
  - `android/app/build/`

Flux :

1. L’utilisateur assigne les tags.
2. Il clique sur un bouton du type :  
   “🧹 Purger les projets `Purge safe`”.
3. FlutterSweep affiche un **récapitulatif** :
   - liste des projets concernés,
   - taille totale estimée à libérer.
4. Confirmation.
5. Lancement de la purge :
   - la **console de logs** se met en avant (affichée en bas).
   - chaque projet/dossier traité génère une ligne de log.
6. Fin : affichage d’un message global (ex. “Purge terminée, X Go libérés”).

---

### 5.2 Archivage (`Archiver`)

- Concerne les projets taggés `Archiver`.
- Comportement :
  - purge des dossiers temporaires,
  - création d’un zip du projet complet,
  - déplacement du zip dans un **dossier d’archives**,
  - suppression du dossier projet original uniquement si le zip s’est bien créé et déplacé.

- Dossier d’archives :
  - Par défaut : à côté du dossier racine (ex. `<racine>/flutter_sweep_archives/`).
  - Chemin configurable plus tard via la page Paramètres.

Flux :

1. L’utilisateur tague certains projets en `Archiver`.
2. Il lance l’action :  
   “📦 Archiver les projets `Archiver`”.
3. Pour chaque projet `Archiver` :
   - si `.git/` absent → afficher un warning clair avant de continuer pour ce projet.
4. Confirmation globale.
5. Exécution :
   - purge,
   - zip,
   - déplacement,
   - suppression du projet d’origine.
   - toutes les étapes loggées dans la console (succès ou erreurs).
6. Résumé final en UI (ex. “3 projets archivés, 2 erreurs, X Go libérés”).

---

## 📜 Logs & Console utilisateur

### Objectif

Les logs dans FlutterSweep doivent :

- aider l’utilisateur à comprendre ce qui se passe pendant un **scan**, une **purge** ou un **archivage** ;
- permettre de diagnostiquer des problèmes (droits, fichiers verrouillés, etc.).

### Console intégrée

- Position : en bas de l’écran principal (dockable / repliable).
- Comportement :
  - mode **replié** par défaut, ou compact.
  - se **déploie automatiquement** lors d’une purge ou d’un archivage.
  - affiche les **N dernières lignes** (10 minimum, éventuellement paramétrable plus tard).
  - scroll interne si l’utilisateur veut remonter un peu.

- Contenu d’une ligne de log :
  - heure (hh:mm:ss),
  - nom du projet,
  - type d’action (`SCAN`, `PURGE`, `ARCHIVE`, `ZIP`, `ERROR`, etc.),
  - court message (ex. “Suppression de build/ OK” ou “Erreur: Permission denied”).

Exemples :

- `[12:03:10] [my_app] PURGE  → build/ supprimé`
- `[12:03:11] [my_app] PURGE  → .dart_tool/ supprimé`
- `[12:03:12] [my_app] ARCHIVE → archive créée: /archives/my_app_2025-11-27.zip`
- `[12:03:13] [old_app] ERROR  → accès refusé sur ios/Pods/`

### Modèle de données des logs

- `LogEntry` :
  - `DateTime timestamp`
  - `String projectName`
  - `String path`
  - `String action` (enum-like : `scan`, `purge`, `archive`, `zip`, `error`, etc.)
  - `int? sizeBytes` (facultatif)
  - `String status` (`success`, `error`, `info`, `progress`)
  - `String? message`

### Stockage des logs

- V1 :
  - stockés en mémoire pour la session,
  - optionnel : écriture dans un fichier texte ou JSON (`logs/`) pour debug avancé.
- Plus tard :
  - page dédiée pour visualiser les logs complets,
  - bouton “Exporter les logs”.

---

## 💾 Persistance & Données

Données à persister :

- Chemin du **dossier racine**.
- Chemin du **dossier d’archives** (ou usage du chemin par défaut).
- **Tags** par projet (`Intact`, `Purge safe`, `Archiver`).
- Préférences utilisateur :
  - langue,
  - thème,
  - éventuellement options de logs (si ajoutées).
- Éventuellement :
  - stats cumulées (Go libérés au total).

Solution technique envisagée :

- **Hive** (via `hive` + `hive_flutter`) :
  - `SettingsBox` :
    - dossier racine,
    - dossier d’archives,
    - langue,
    - thème.
  - `ProjectsBox` :
    - clé = chemin du projet,
    - valeur = tag + méta si nécessaire.
  - Eventuellement un `StatsBox` pour les stats cumulées.

---

## 🏛️ Architecture de FlutterSweep

### Structure générale

- `lib/main.dart`
  - init Flutter,
  - init Hive,
  - chargement des paramètres (langue, thème),
  - setup de l’i18n,
  - lancement de l’app.

- `lib/app.dart`
  - `MaterialApp`,
  - routes,
  - configuration locale & thème.

### Couches logiques

1. **Models**
   - `ProjectInfo`
   - `ProjectTag` (enum-like)
   - `ScanSummary`
   - `LogEntry`
   - `AppSettings` (langue, thème, chemins…)

2. **Services**
   - `SettingsService`
   - `ScanService`
   - `CleanupService`
   - `ArchiveService`
   - `LogService`
   - éventuellement `FileSystemStatsService` (abstraction pour calculer les tailles, pour support multi-OS).

3. **Repositories**
   - `SettingsRepository` (Hive)
   - `ProjectRepository` (Hive)
   - (optionnel) `StatsRepository`
   - (optionnel) `LogRepository` (si persistance des logs au-delà de la session est souhaitée)

4. **UI**
   - `HomePage`
     - dashboard,
     - liste des projets,
     - boutons d’actions (scan, purge, archive),
     - console de logs intégrée.
   - `SettingsPage`
     - langue,
     - thème,
     - dossier d’archives.
   - (plus tard) `LogsPage` si besoin.

---

## 🧪 UX & Flow utilisateur (Vue d’ensemble)

1. L’utilisateur lance **FlutterSweep** pour la première fois.
2. Écran de bienvenue :
   - Explication courte,
   - Bouton “Choisir le dossier des projets Flutter”.
3. Il sélectionne son dossier racine.
4. Il clique sur “🔄 Re-scanner”.
5. FlutterSweep :
   - scanne,
   - affiche le dashboard,
   - liste les projets détectés.
6. L’utilisateur :
   - applique des tags aux projets (`Intact`, `Purge safe`, `Archiver`),
   - ajuste si besoin les paramètres (langue, thème, dossier d’archives).
7. Il lance :
   - “🧹 Purger les projets `Purge safe`”,
   - puis éventuellement “📦 Archiver les projets `Archiver`”.
8. Pendant ces actions :
   - la **console de logs** s’affiche en bas,
   - l’utilisateur voit ce que FlutterSweep fait en temps réel.
9. Fin des actions :
   - message de succès / erreurs global,
   - possibilité de replier la console.

---

## 🔐 Sécurité & garde-fous

- **Jamais de suppression brute du projet sans zip** :
  - Les projets marqués `Archiver` sont toujours :
    - purgés,
    - zippés,
    - déplacés,
    - puis seulement après, leur dossier d’origine est supprimé.
- Warnings pour les projets `Archiver` :
  - si pas de `.git/` → message clair : l’archive zip sera la seule copie locale.
- Logs détaillés :
  - toutes les actions sur le système de fichiers sont loggées,
  - en cas de problème, l’utilisateur a un minimum de traçabilité.

---

## 🚧 Roadmap / Étapes de développement

> **Remarque importante** : la création du projet Flutter de base (commande `flutter create`) sera faite manuellement par le développeur (Rudy).  
> Les étapes ci-dessous partent du principe que le projet vierge **FlutterSweep** existe déjà.

### PHASE 0 – Setup général (dans le projet existant) ✅

- [x] Ajouter les dépendances :
  - [x] `hive`, `hive_flutter`,
  - [x] `file_picker`,
  - [x] libs nécessaires pour l'i18n (`flutter_localizations`, `intl`, etc.).
  - [x] `archive` pour la création de fichiers ZIP
  - [x] `path` pour la manipulation de chemins
- [x] Mettre en place :
  - [x] structure des dossiers : `models/`, `services/`, `repositories/`, `ui/`, `l10n/` ou équivalent,
  - [x] configuration de l'i18n et des thèmes dans `MaterialApp`.

### PHASE 1 – Paramètres, i18n & thème ✅

- [x] Implémenter `AppSettings` + `SettingsRepository` + `SettingsService`.
- [x] Créer `SettingsPage` avec :
  - [x] sélection de la langue,
  - [x] sélection du thème (clair / sombre / système),
  - [x] affichage / paramétrage du dossier d'archives.
- [x] Ajouter une entrée (icône ⚙️) pour ouvrir `SettingsPage`.

### PHASE 2 – Dossier racine & scan ✅

- [x] UI de sélection du **dossier racine** (onboarding + modification ultérieure).
- [x] Sauvegarde/rechargement du chemin.
- [x] Implémenter `ScanService` :
  - [x] détection des projets,
  - [x] calcul des tailles,
  - [x] détection `.git/`.
- [x] Bouton "🔄 Re-scanner" et état de chargement.
- [x] Correction des entitlements macOS pour l'accès aux fichiers.

### PHASE 3 – Tags, dashboard & liste des projets ✅

- [x] Implémenter `ProjectTag` + `ProjectRepository`.
- [x] Sauvegarder les tags par projet.
- [x] Dashboard (projets, taille totale, taille purgable).
- [x] Liste des projets :
  - [x] affichage des infos projet,
  - [x] filtres (tags),
  - [x] tri,
  - [x] recherche.
- [x] Cards expandables avec détails des projets.
- [x] Warning visuel pour projets sans Git.

### PHASE 4 – Purge, archivage & console de logs ✅

- [x] Implémenter `LogEntry` + `LogService`.
- [x] Intégrer la **console de logs** dans `HomePage` :
  - [x] section en bas de l'écran affichant les dernières lignes,
  - [x] dépliage automatique lors des actions.
- [x] Implémenter `CleanupService` (purge).
- [x] Implémenter `ArchiveService` (zip + déplacement + suppression).
- [x] Boutons d'action :
  - [x] "Purger les projets `Purge safe`",
  - [x] "Archiver les projets `Archiver`".
- [x] Gérer la progression et les logs temps réel.
- [x] Traduction complète des logs en français et anglais.
- [x] Correction du chemin d'archives (utilisation de ~/Documents/FlutterSweepArchives).

### PHASE 5 – Finitions & Open Source (FlutterSweep) ✅

- [x] Tester FlutterSweep sur macOS (priorité).
- [x] Rédiger / mettre à jour le `README.md` :
  - présentation de **FlutterSweep**,
  - fonctionnalités,
  - installation,
  - compatibilité,
  - avertissements.
- [x] Ajouter une licence Open Source (MIT).
- [x] Amélioration de la gestion d'erreurs (initialisation Hive).
- [x] Correction UI overflow dans LogsConsole.
- [x] Internationalisation complète des logs.
- [x] Page de gestion des archives (visualisation, ouverture dans Finder, suppression).
- [x] Correction du chemin d'archives (~/Documents/FlutterSweepArchives).
- [ ] Vérifier compilation / comportement sur Windows & Linux (si possible).
- [ ] Ajouter un fichier `CONTRIBUTING.md` si souhaité.
- [x] Vérifier la cohérence globale entre `PLAN.md`, `README.md` et le code.

**Date de dernière mise à jour** : 2025-11-27

**État actuel** : Application complète et fonctionnelle sur macOS. Toutes les fonctionnalités principales sont implémentées et testées. Les logs sont traduits en français et anglais. Le dossier d'archives utilise un emplacement accessible (~/Documents/FlutterSweepArchives). Une page dédiée permet de visualiser et gérer les archives créées.

---

## 💡 Idées futures pour FlutterSweep

- Mode "simulation" : afficher ce qui serait supprimé/archivé sans vraiment le faire.
- Support de plusieurs dossiers racine.
- Support de dossiers système (Xcode `DerivedData`, Android SDK caches, etc.).
- Page dédiée des logs avec export.
- Plus de langues (ES, DE, IT, etc.).
- Intégration de tests unitaires et de tests widget.
- Extraction d'archives depuis la page Archives.
- Prévisualisation du contenu des archives.
- Statistiques d'utilisation (espace libéré au fil du temps).

---