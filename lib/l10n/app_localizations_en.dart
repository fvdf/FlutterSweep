// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FlutterSweep';

  @override
  String get welcome => 'Welcome to FlutterSweep';

  @override
  String get welcomeMessage =>
      'FlutterSweep helps you manage disk space by cleaning up Flutter project temporary files.';

  @override
  String get chooseProjectFolder => 'Choose Flutter Projects Folder';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get archiveFolder => 'Archive Folder';

  @override
  String get version => 'Version';

  @override
  String get rescan => 'Re-scan';

  @override
  String get projectCount => 'Projects';

  @override
  String get totalSize => 'Total Size';

  @override
  String get purgeableSize => 'Purgeable Size';

  @override
  String get tagIntact => 'Intact';

  @override
  String get tagPurgeSafe => 'Purge Safe';

  @override
  String get tagArchive => 'Archive';

  @override
  String get search => 'Search';

  @override
  String get all => 'All';

  @override
  String get purgeProjects => 'Purge Projects';

  @override
  String get archiveProjects => 'Archive Projects';

  @override
  String get logs => 'Logs';

  @override
  String potentialSavings(String size) {
    return 'FlutterSweep can potentially free up $size';
  }

  @override
  String get scanning => 'Scanning...';

  @override
  String get noProjectsFound => 'No Flutter projects found';

  @override
  String get selectRootFolder => 'Select Root Folder';

  @override
  String get changeFolder => 'Change Folder';

  @override
  String get rootFolder => 'Root Folder';

  @override
  String get lastModified => 'Last Modified';

  @override
  String get logStartingArchive => 'Starting archive operation';

  @override
  String get logPurgingTempFiles => 'Purging temporary files';

  @override
  String get logCreatedArchiveFolder => 'Created archive folder';

  @override
  String get logCreatingZip => 'Creating ZIP archive';

  @override
  String logArchiveCreated(String filename) {
    return 'Archive created: $filename';
  }

  @override
  String get logRemovingOriginal => 'Removing original project folder';

  @override
  String get logArchiveCompleted => 'Archive operation completed successfully';

  @override
  String logArchiveFailed(String error) {
    return 'Archive operation failed: $error';
  }

  @override
  String get logBulkArchiveStarted => 'Starting bulk archive operation';

  @override
  String get logNoGitWarning =>
      'No Git repository detected - archive will be the only copy';

  @override
  String logBulkArchiveCompleted(int success, int failed) {
    return 'Bulk archive completed: $success succeeded, $failed failed';
  }

  @override
  String get logStartingPurge => 'Starting purge operation';

  @override
  String logPurgingFolder(String folder) {
    return 'Purging: $folder';
  }

  @override
  String get logPurgeCompleted => 'Purge completed successfully';

  @override
  String logPurgeFailed(String error) {
    return 'Purge failed: $error';
  }

  @override
  String get logBulkPurgeStarted => 'Starting bulk purge operation';

  @override
  String logBulkPurgeCompleted(int success, int failed) {
    return 'Bulk purge completed: $success succeeded, $failed failed';
  }

  @override
  String get archives => 'Archives';

  @override
  String get archivesPageTitle => 'Archived Projects';

  @override
  String get noArchivesFound => 'No archives found';

  @override
  String get openInFinder => 'Open in Finder';

  @override
  String get archiveFolderLocation => 'Archive Folder Location';

  @override
  String get archiveDate => 'Archive Date';

  @override
  String get archiveSize => 'Archive Size';

  @override
  String get totalArchives => 'Total Archives';

  @override
  String get totalArchivesSize => 'Total Size';

  @override
  String get sortBy => 'Sort by:';

  @override
  String get sortByName => 'Name';

  @override
  String get sortBySize => 'Size';

  @override
  String get sortByPurgeable => 'Purgeable';

  @override
  String get sortByDate => 'Date';

  @override
  String get confirmPurge => 'Confirm Purge';

  @override
  String purgeMessage(int count) {
    return 'You are about to purge $count project(s):';
  }

  @override
  String andMore(int count) {
    return '... and $count more';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get purge => 'Purge';

  @override
  String purgeFailedMessage(String error) {
    return 'Purge failed: $error';
  }

  @override
  String get confirmArchive => 'Confirm Archive';

  @override
  String archiveMessage(int count) {
    return 'You are about to archive $count project(s):';
  }

  @override
  String get archiveStep1 => '1. Purge temporary files';

  @override
  String get archiveStep2 => '2. Create a ZIP archive';

  @override
  String get archiveStep3 => '3. Delete the original folder';

  @override
  String get archive => 'Archive';

  @override
  String archiveFailedMessage(String error) {
    return 'Archive failed: $error';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deleteArchiveMessage(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get archiveDeleted => 'Archive deleted';

  @override
  String errorOpeningFolder(String error) {
    return 'Error opening folder: $error';
  }

  @override
  String errorDeletingArchive(String error) {
    return 'Error deleting archive: $error';
  }

  @override
  String errorScanning(String error) {
    return 'Error scanning: $error';
  }
}
