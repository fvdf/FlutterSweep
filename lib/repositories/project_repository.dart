import 'package:hive/hive.dart';
import '../models/project_tag.dart';

class ProjectRepository {
  static const String _boxName = 'projects';

  Box get _box => Hive.box(_boxName);

  Future<ProjectTag> getProjectTag(String projectPath) async {
    final tagString = _box.get(projectPath);
    if (tagString == null) {
      return ProjectTag.intact;
    }
    return ProjectTag.fromString(tagString);
  }

  Future<void> setProjectTag(String projectPath, ProjectTag tag) async {
    await _box.put(projectPath, tag.toStorageString());
  }

  Future<Map<String, ProjectTag>> getAllProjectTags() async {
    final Map<String, ProjectTag> tags = {};
    for (var key in _box.keys) {
      final tagString = _box.get(key);
      if (tagString != null) {
        tags[key as String] = ProjectTag.fromString(tagString);
      }
    }
    return tags;
  }

  Future<void> removeProject(String projectPath) async {
    await _box.delete(projectPath);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
