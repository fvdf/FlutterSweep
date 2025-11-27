enum ProjectTag {
  intact,
  purgeSafe,
  archive;

  String get displayName {
    switch (this) {
      case ProjectTag.intact:
        return 'Intact';
      case ProjectTag.purgeSafe:
        return 'Purge Safe';
      case ProjectTag.archive:
        return 'Archive';
    }
  }

  static ProjectTag fromString(String value) {
    switch (value) {
      case 'intact':
        return ProjectTag.intact;
      case 'purgeSafe':
        return ProjectTag.purgeSafe;
      case 'archive':
        return ProjectTag.archive;
      default:
        return ProjectTag.intact;
    }
  }

  String toStorageString() {
    return name;
  }
}
