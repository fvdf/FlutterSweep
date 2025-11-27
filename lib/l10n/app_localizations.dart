import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'FlutterSweep'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to FlutterSweep'**
  String get welcome;

  /// Welcome screen description
  ///
  /// In en, this message translates to:
  /// **'FlutterSweep helps you manage disk space by cleaning up Flutter project temporary files.'**
  String get welcomeMessage;

  /// Button text to select the root folder
  ///
  /// In en, this message translates to:
  /// **'Choose Flutter Projects Folder'**
  String get chooseProjectFolder;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Archive folder setting label
  ///
  /// In en, this message translates to:
  /// **'Archive Folder'**
  String get archiveFolder;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Re-scan button text
  ///
  /// In en, this message translates to:
  /// **'Re-scan'**
  String get rescan;

  /// Project count label
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectCount;

  /// Total size label
  ///
  /// In en, this message translates to:
  /// **'Total Size'**
  String get totalSize;

  /// Purgeable size label
  ///
  /// In en, this message translates to:
  /// **'Purgeable Size'**
  String get purgeableSize;

  /// Intact tag
  ///
  /// In en, this message translates to:
  /// **'Intact'**
  String get tagIntact;

  /// Purge Safe tag
  ///
  /// In en, this message translates to:
  /// **'Purge Safe'**
  String get tagPurgeSafe;

  /// Archive tag
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tagArchive;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Purge projects button
  ///
  /// In en, this message translates to:
  /// **'Purge Projects'**
  String get purgeProjects;

  /// Archive projects button
  ///
  /// In en, this message translates to:
  /// **'Archive Projects'**
  String get archiveProjects;

  /// Logs console title
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Potential savings message
  ///
  /// In en, this message translates to:
  /// **'FlutterSweep can potentially free up {size}'**
  String potentialSavings(String size);

  /// Scanning status message
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No projects found message
  ///
  /// In en, this message translates to:
  /// **'No Flutter projects found'**
  String get noProjectsFound;

  /// Select root folder button
  ///
  /// In en, this message translates to:
  /// **'Select Root Folder'**
  String get selectRootFolder;

  /// Change folder button
  ///
  /// In en, this message translates to:
  /// **'Change Folder'**
  String get changeFolder;

  /// Root folder label
  ///
  /// In en, this message translates to:
  /// **'Root Folder'**
  String get rootFolder;

  /// Last modified label
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @logStartingArchive.
  ///
  /// In en, this message translates to:
  /// **'Starting archive operation'**
  String get logStartingArchive;

  /// No description provided for @logPurgingTempFiles.
  ///
  /// In en, this message translates to:
  /// **'Purging temporary files'**
  String get logPurgingTempFiles;

  /// No description provided for @logCreatedArchiveFolder.
  ///
  /// In en, this message translates to:
  /// **'Created archive folder'**
  String get logCreatedArchiveFolder;

  /// No description provided for @logCreatingZip.
  ///
  /// In en, this message translates to:
  /// **'Creating ZIP archive'**
  String get logCreatingZip;

  /// No description provided for @logArchiveCreated.
  ///
  /// In en, this message translates to:
  /// **'Archive created: {filename}'**
  String logArchiveCreated(String filename);

  /// No description provided for @logRemovingOriginal.
  ///
  /// In en, this message translates to:
  /// **'Removing original project folder'**
  String get logRemovingOriginal;

  /// No description provided for @logArchiveCompleted.
  ///
  /// In en, this message translates to:
  /// **'Archive operation completed successfully'**
  String get logArchiveCompleted;

  /// No description provided for @logArchiveFailed.
  ///
  /// In en, this message translates to:
  /// **'Archive operation failed: {error}'**
  String logArchiveFailed(String error);

  /// No description provided for @logBulkArchiveStarted.
  ///
  /// In en, this message translates to:
  /// **'Starting bulk archive operation'**
  String get logBulkArchiveStarted;

  /// No description provided for @logNoGitWarning.
  ///
  /// In en, this message translates to:
  /// **'No Git repository detected - archive will be the only copy'**
  String get logNoGitWarning;

  /// No description provided for @logBulkArchiveCompleted.
  ///
  /// In en, this message translates to:
  /// **'Bulk archive completed: {success} succeeded, {failed} failed'**
  String logBulkArchiveCompleted(int success, int failed);

  /// No description provided for @logStartingPurge.
  ///
  /// In en, this message translates to:
  /// **'Starting purge operation'**
  String get logStartingPurge;

  /// No description provided for @logPurgingFolder.
  ///
  /// In en, this message translates to:
  /// **'Purging: {folder}'**
  String logPurgingFolder(String folder);

  /// No description provided for @logPurgeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purge completed successfully'**
  String get logPurgeCompleted;

  /// No description provided for @logPurgeFailed.
  ///
  /// In en, this message translates to:
  /// **'Purge failed: {error}'**
  String logPurgeFailed(String error);

  /// No description provided for @logBulkPurgeStarted.
  ///
  /// In en, this message translates to:
  /// **'Starting bulk purge operation'**
  String get logBulkPurgeStarted;

  /// No description provided for @logBulkPurgeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Bulk purge completed: {success} succeeded, {failed} failed'**
  String logBulkPurgeCompleted(int success, int failed);

  /// No description provided for @archives.
  ///
  /// In en, this message translates to:
  /// **'Archives'**
  String get archives;

  /// No description provided for @archivesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Archived Projects'**
  String get archivesPageTitle;

  /// No description provided for @noArchivesFound.
  ///
  /// In en, this message translates to:
  /// **'No archives found'**
  String get noArchivesFound;

  /// No description provided for @openInFinder.
  ///
  /// In en, this message translates to:
  /// **'Open in Finder'**
  String get openInFinder;

  /// No description provided for @archiveFolderLocation.
  ///
  /// In en, this message translates to:
  /// **'Archive Folder Location'**
  String get archiveFolderLocation;

  /// No description provided for @archiveDate.
  ///
  /// In en, this message translates to:
  /// **'Archive Date'**
  String get archiveDate;

  /// No description provided for @archiveSize.
  ///
  /// In en, this message translates to:
  /// **'Archive Size'**
  String get archiveSize;

  /// No description provided for @totalArchives.
  ///
  /// In en, this message translates to:
  /// **'Total Archives'**
  String get totalArchives;

  /// No description provided for @totalArchivesSize.
  ///
  /// In en, this message translates to:
  /// **'Total Size'**
  String get totalArchivesSize;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get sortBy;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortBySize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sortBySize;

  /// No description provided for @sortByPurgeable.
  ///
  /// In en, this message translates to:
  /// **'Purgeable'**
  String get sortByPurgeable;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @confirmPurge.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purge'**
  String get confirmPurge;

  /// No description provided for @purgeMessage.
  ///
  /// In en, this message translates to:
  /// **'You are about to purge {count} project(s):'**
  String purgeMessage(int count);

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more'**
  String andMore(int count);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @purge.
  ///
  /// In en, this message translates to:
  /// **'Purge'**
  String get purge;

  /// No description provided for @purgeFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Purge failed: {error}'**
  String purgeFailedMessage(String error);

  /// No description provided for @confirmArchive.
  ///
  /// In en, this message translates to:
  /// **'Confirm Archive'**
  String get confirmArchive;

  /// No description provided for @archiveMessage.
  ///
  /// In en, this message translates to:
  /// **'You are about to archive {count} project(s):'**
  String archiveMessage(int count);

  /// No description provided for @archiveStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Purge temporary files'**
  String get archiveStep1;

  /// No description provided for @archiveStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Create a ZIP archive'**
  String get archiveStep2;

  /// No description provided for @archiveStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Delete the original folder'**
  String get archiveStep3;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @archiveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Archive failed: {error}'**
  String archiveFailedMessage(String error);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteArchiveMessage(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @archiveDeleted.
  ///
  /// In en, this message translates to:
  /// **'Archive deleted'**
  String get archiveDeleted;

  /// No description provided for @errorOpeningFolder.
  ///
  /// In en, this message translates to:
  /// **'Error opening folder: {error}'**
  String errorOpeningFolder(String error);

  /// No description provided for @errorDeletingArchive.
  ///
  /// In en, this message translates to:
  /// **'Error deleting archive: {error}'**
  String errorDeletingArchive(String error);

  /// No description provided for @errorScanning.
  ///
  /// In en, this message translates to:
  /// **'Error scanning: {error}'**
  String errorScanning(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
