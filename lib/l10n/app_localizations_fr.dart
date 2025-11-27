// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'FlutterSweep';

  @override
  String get welcome => 'Bienvenue dans FlutterSweep';

  @override
  String get welcomeMessage =>
      'FlutterSweep vous aide à gérer l\'espace disque en nettoyant les fichiers temporaires de vos projets Flutter.';

  @override
  String get chooseProjectFolder => 'Choisir le dossier des projets Flutter';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get archiveFolder => 'Dossier d\'archives';

  @override
  String get version => 'Version';

  @override
  String get rescan => 'Re-scanner';

  @override
  String get projectCount => 'Projets';

  @override
  String get totalSize => 'Taille totale';

  @override
  String get purgeableSize => 'Taille purgeable';

  @override
  String get tagIntact => 'Intact';

  @override
  String get tagPurgeSafe => 'Purge sûre';

  @override
  String get tagArchive => 'Archiver';

  @override
  String get search => 'Rechercher';

  @override
  String get all => 'Tous';

  @override
  String get purgeProjects => 'Purger les projets';

  @override
  String get archiveProjects => 'Archiver les projets';

  @override
  String get logs => 'Journaux';

  @override
  String potentialSavings(String size) {
    return 'FlutterSweep peut potentiellement libérer $size';
  }

  @override
  String get scanning => 'Analyse en cours...';

  @override
  String get noProjectsFound => 'Aucun projet Flutter trouvé';

  @override
  String get selectRootFolder => 'Sélectionner le dossier racine';

  @override
  String get changeFolder => 'Changer de dossier';

  @override
  String get rootFolder => 'Dossier racine';

  @override
  String get lastModified => 'Dernière modification';

  @override
  String get logStartingArchive => 'Démarrage de l\'opération d\'archivage';

  @override
  String get logPurgingTempFiles => 'Suppression des fichiers temporaires';

  @override
  String get logCreatedArchiveFolder => 'Dossier d\'archives créé';

  @override
  String get logCreatingZip => 'Création de l\'archive ZIP';

  @override
  String logArchiveCreated(String filename) {
    return 'Archive créée : $filename';
  }

  @override
  String get logRemovingOriginal => 'Suppression du dossier du projet original';

  @override
  String get logArchiveCompleted =>
      'Opération d\'archivage terminée avec succès';

  @override
  String logArchiveFailed(String error) {
    return 'Échec de l\'opération d\'archivage : $error';
  }

  @override
  String get logBulkArchiveStarted => 'Démarrage de l\'archivage groupé';

  @override
  String get logNoGitWarning =>
      'Aucun dépôt Git détecté - l\'archive sera la seule copie';

  @override
  String logBulkArchiveCompleted(int success, int failed) {
    return 'Archivage groupé terminé : $success réussis, $failed échoués';
  }

  @override
  String get logStartingPurge => 'Démarrage de l\'opération de purge';

  @override
  String logPurgingFolder(String folder) {
    return 'Purge de : $folder';
  }

  @override
  String get logPurgeCompleted => 'Purge terminée avec succès';

  @override
  String logPurgeFailed(String error) {
    return 'Échec de la purge : $error';
  }

  @override
  String get logBulkPurgeStarted => 'Démarrage de la purge groupée';

  @override
  String logBulkPurgeCompleted(int success, int failed) {
    return 'Purge groupée terminée : $success réussis, $failed échoués';
  }

  @override
  String get archives => 'Archives';

  @override
  String get archivesPageTitle => 'Projets archivés';

  @override
  String get noArchivesFound => 'Aucune archive trouvée';

  @override
  String get openInFinder => 'Ouvrir dans le Finder';

  @override
  String get archiveFolderLocation => 'Emplacement du dossier d\'archives';

  @override
  String get archiveDate => 'Date d\'archivage';

  @override
  String get archiveSize => 'Taille de l\'archive';

  @override
  String get totalArchives => 'Total des archives';

  @override
  String get totalArchivesSize => 'Taille totale';

  @override
  String get sortBy => 'Trier par :';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortBySize => 'Taille';

  @override
  String get sortByPurgeable => 'Purgeable';

  @override
  String get sortByDate => 'Date';

  @override
  String get confirmPurge => 'Confirmer la purge';

  @override
  String purgeMessage(int count) {
    return 'Vous êtes sur le point de purger $count projet(s) :';
  }

  @override
  String andMore(int count) {
    return '... et $count de plus';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get purge => 'Purger';

  @override
  String purgeFailedMessage(String error) {
    return 'Échec de la purge : $error';
  }

  @override
  String get confirmArchive => 'Confirmer l\'archivage';

  @override
  String archiveMessage(int count) {
    return 'Vous êtes sur le point d\'archiver $count projet(s) :';
  }

  @override
  String get archiveStep1 => '1. Purger les fichiers temporaires';

  @override
  String get archiveStep2 => '2. Créer une archive ZIP';

  @override
  String get archiveStep3 => '3. Supprimer le dossier original';

  @override
  String get archive => 'Archiver';

  @override
  String archiveFailedMessage(String error) {
    return 'Échec de l\'archivage : $error';
  }

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String deleteArchiveMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer $name ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get archiveDeleted => 'Archive supprimée';

  @override
  String errorOpeningFolder(String error) {
    return 'Erreur lors de l\'ouverture du dossier : $error';
  }

  @override
  String errorDeletingArchive(String error) {
    return 'Erreur lors de la suppression de l\'archive : $error';
  }

  @override
  String errorScanning(String error) {
    return 'Erreur lors de l\'analyse : $error';
  }
}
