// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'FlutterSweep';

  @override
  String get welcome => 'Bienvenido a FlutterSweep';

  @override
  String get welcomeMessage =>
      'FlutterSweep te ayuda a administrar el espacio en disco limpiando archivos temporales de tus proyectos Flutter.';

  @override
  String get chooseProjectFolder => 'Elegir carpeta de proyectos Flutter';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get archiveFolder => 'Carpeta de archivos';

  @override
  String get version => 'Versión';

  @override
  String get rescan => 'Re-escanear';

  @override
  String get projectCount => 'Proyectos';

  @override
  String get totalSize => 'Tamaño total';

  @override
  String get purgeableSize => 'Tamaño purgeable';

  @override
  String get tagIntact => 'Intacto';

  @override
  String get tagPurgeSafe => 'Purga segura';

  @override
  String get tagArchive => 'Archivar';

  @override
  String get search => 'Buscar';

  @override
  String get all => 'Todos';

  @override
  String get purgeProjects => 'Purgar proyectos';

  @override
  String get archiveProjects => 'Archivar proyectos';

  @override
  String get logs => 'Registros';

  @override
  String potentialSavings(String size) {
    return 'FlutterSweep puede liberar potencialmente $size';
  }

  @override
  String get scanning => 'Escaneando...';

  @override
  String get noProjectsFound => 'No se encontraron proyectos Flutter';

  @override
  String get selectRootFolder => 'Seleccionar carpeta raíz';

  @override
  String get changeFolder => 'Cambiar carpeta';

  @override
  String get rootFolder => 'Carpeta raíz';

  @override
  String get lastModified => 'Última modificación';

  @override
  String get logStartingArchive => 'Iniciando operación de archivado';

  @override
  String get logPurgingTempFiles => 'Eliminando archivos temporales';

  @override
  String get logCreatedArchiveFolder => 'Carpeta de archivos creada';

  @override
  String get logCreatingZip => 'Creando archivo ZIP';

  @override
  String logArchiveCreated(String filename) {
    return 'Archivo creado: $filename';
  }

  @override
  String get logRemovingOriginal => 'Eliminando carpeta del proyecto original';

  @override
  String get logArchiveCompleted =>
      'Operación de archivado completada con éxito';

  @override
  String logArchiveFailed(String error) {
    return 'Falló la operación de archivado: $error';
  }

  @override
  String get logBulkArchiveStarted => 'Iniciando archivado masivo';

  @override
  String get logNoGitWarning =>
      'No se detectó repositorio Git - el archivo será la única copia';

  @override
  String logBulkArchiveCompleted(int success, int failed) {
    return 'Archivado masivo completado: $success exitosos, $failed fallidos';
  }

  @override
  String get logStartingPurge => 'Iniciando operación de purga';

  @override
  String logPurgingFolder(String folder) {
    return 'Purgando: $folder';
  }

  @override
  String get logPurgeCompleted => 'Purga completada con éxito';

  @override
  String logPurgeFailed(String error) {
    return 'Falló la purga: $error';
  }

  @override
  String get logBulkPurgeStarted => 'Iniciando purga masiva';

  @override
  String logBulkPurgeCompleted(int success, int failed) {
    return 'Purga masiva completada: $success exitosos, $failed fallidos';
  }

  @override
  String get archives => 'Archivos';

  @override
  String get archivesPageTitle => 'Proyectos archivados';

  @override
  String get noArchivesFound => 'No se encontraron archivos';

  @override
  String get openInFinder => 'Abrir en Finder';

  @override
  String get archiveFolderLocation => 'Ubicación de la carpeta de archivos';

  @override
  String get archiveDate => 'Fecha de archivo';

  @override
  String get archiveSize => 'Tamaño del archivo';

  @override
  String get totalArchives => 'Total de archivos';

  @override
  String get totalArchivesSize => 'Tamaño total';

  @override
  String get sortBy => 'Ordenar por:';

  @override
  String get sortByName => 'Nombre';

  @override
  String get sortBySize => 'Tamaño';

  @override
  String get sortByPurgeable => 'Purgeable';

  @override
  String get sortByDate => 'Fecha';

  @override
  String get confirmPurge => 'Confirmar purga';

  @override
  String purgeMessage(int count) {
    return 'Está a punto de purgar $count proyecto(s):';
  }

  @override
  String andMore(int count) {
    return '... y $count más';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get purge => 'Purgar';

  @override
  String purgeFailedMessage(String error) {
    return 'Falló la purga: $error';
  }

  @override
  String get confirmArchive => 'Confirmar archivado';

  @override
  String archiveMessage(int count) {
    return 'Está a punto de archivar $count proyecto(s):';
  }

  @override
  String get archiveStep1 => '1. Purgar archivos temporales';

  @override
  String get archiveStep2 => '2. Crear archivo ZIP';

  @override
  String get archiveStep3 => '3. Eliminar carpeta original';

  @override
  String get archive => 'Archivar';

  @override
  String archiveFailedMessage(String error) {
    return 'Falló el archivado: $error';
  }

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String deleteArchiveMessage(String name) {
    return '¿Está seguro de que desea eliminar $name?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get archiveDeleted => 'Archivo eliminado';

  @override
  String errorOpeningFolder(String error) {
    return 'Error al abrir la carpeta: $error';
  }

  @override
  String errorDeletingArchive(String error) {
    return 'Error al eliminar el archivo: $error';
  }

  @override
  String errorScanning(String error) {
    return 'Error al escanear: $error';
  }
}
