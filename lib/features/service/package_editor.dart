import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class PackageEditor {
  static Future<void> addGoogleMapsFlutter(String projectPath) async {
    final file = File('$projectPath/pubspec.yaml');

    if (!file.existsSync()) {
      throw Exception("pubspec.yaml not found in $projectPath");
    }

    final content = await file.readAsString();
    final editor = YamlEditor(content);

    final yaml = loadYaml(content);

    if (yaml['dependencies'] == null) {
      editor.update(['dependencies'], {});
    }

    final currentDeps = Map<String, dynamic>.from(yaml['dependencies'] ?? {});
    if (!currentDeps.containsKey('google_maps_flutter')) {
      editor.update(['dependencies', 'google_maps_flutter'], '^2.12.1');
      await file.writeAsString(editor.toString());
    } else {
      throw Exception('pubspec.yaml already have google_maps_flutter package.');
    }
  }
}
