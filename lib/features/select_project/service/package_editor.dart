import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class PackageEditor {
  static Future<void> addGoogleMapsFlutter(String projectPath) async {
    final file = File('$projectPath/pubspec.yaml');

    // Check if the pubspec.yaml file exists
    if (!file.existsSync()) {
      throw Exception("pubspec.yaml not found in $projectPath");
    }

    // Read the content of the pubspec.yaml file
    final content = await file.readAsString();
    final editor = YamlEditor(content);

    // Load the YAML content into a structure
    final yaml = loadYaml(content);

    // Initialize the dependencies section if it does not exist
    if (yaml['dependencies'] == null) {
      editor.update(['dependencies'], {});
    }

    // Convert current dependencies to a map for easy checking
    final currentDeps = Map<String, dynamic>.from(yaml['dependencies'] ?? {});

    // Check if the google_maps_flutter package is already included
    if (!currentDeps.containsKey('google_maps_flutter')) {
      // Add the google_maps_flutter package with the specified version
      editor.update(['dependencies', 'google_maps_flutter'], '^2.12.1');
      // Write the updated content back to the pubspec.yaml file
      await file.writeAsString(editor.toString());
    } else {
      throw Exception('pubspec.yaml already have google_maps_flutter package.');
    }
  }
}
