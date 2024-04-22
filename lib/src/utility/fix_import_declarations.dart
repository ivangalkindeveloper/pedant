import 'dart:io';

import 'package:yaml/yaml.dart';

void fixImportDeclarations() {
  final String currentPath = Directory.current.path;
  final File pubspecYamlFile = File(
    "$currentPath/pubspec.yaml",
  );
  final dynamic pubspecYaml = loadYaml(
    pubspecYamlFile.readAsStringSync(),
  );
  final dynamic packageName = pubspecYaml["name"];
}
