import 'dart:io';

import 'package:yaml/yaml.dart';

void sortImportDeclarations() {
  final String currentPath = Directory.current.path;
  final File pubspecYamlFile = File(
    "$currentPath/pubspec.yaml",
  );
  final dynamic pubspecYaml = loadYaml(
    pubspecYamlFile.readAsStringSync(),
  );
  final dynamic projectName = pubspecYaml["name"];

  final List<File> dartFiles = _getFiles(
    path: currentPath,
  );
  final List<File> sortedDartFiles = [];

  for (final File dartFile in dartFiles) {
    final File? sortedFile = _sortFile(
      projectName: projectName,
      file: dartFile,
    );
    if (sortedFile == null) {
      continue;
    }

    sortedDartFiles.add(sortedFile);
  }

  if (sortedDartFiles.isEmpty) {
    return;
  }

  stdout.write(
    "Sorted import for files: ${sortedDartFiles.length}",
  );
}

List<File> _getFiles({
  required String path,
}) {
  final List<File> dartFiles = [];
  final List<FileSystemEntity> entities = Directory(path).listSync(
    recursive: true,
  );
  for (final FileSystemEntity entity in entities) {
    if (entity is! File ||
        !entity.path.endsWith(".dart") ||
        entity.path.contains("generated_plugin_registrant")) {
      continue;
    }

    dartFiles.add(entity);
  }

  return dartFiles;
}

File? _sortFile({
  required String projectName,
  required File file,
}) {
  const String prefixDart = "import 'dart:";
  const String prefixFlutter = "import 'package:flutter/";
  final String prefixProject = "import 'package:$projectName";
  const String prefixPackage = "import 'package:";
  const String prefixPart = "part";

  final List<String> importsDart = [];
  final List<String> importsFlutter = [];
  final List<String> importsProject = [];
  final List<String> importsPackage = [];
  final List<String> importsPart = [];

  final List<String> linesBeforeImports = [];
  final List<String> linesAfterImports = [];

  bool isImportEmpty() =>
      importsDart.isEmpty &&
      importsFlutter.isEmpty &&
      importsProject.isEmpty &&
      importsPackage.isEmpty &&
      importsPart.isEmpty;

  final List<String> lines = file.readAsLinesSync();

  for (final String line in lines) {
    if (line.startsWith(prefixDart)) {
      importsDart.add(line);
      continue;
    }

    if (line.startsWith(prefixFlutter)) {
      importsFlutter.add(line);
      continue;
    }

    if (line.startsWith(prefixProject)) {
      importsProject.add(line);
      continue;
    }

    if (line.startsWith(prefixPackage)) {
      importsPackage.add(line);
      continue;
    }

    if (line.contains("../")) {
      //TODO Relative
      continue;
    }

    if (line.startsWith(prefixPart)) {
      importsPart.add(line);
      continue;
    }

    if (isImportEmpty()) {
      linesBeforeImports.add(line);
    } else {
      linesAfterImports.add(line);
    }
  }

  if (isImportEmpty() ||
      linesBeforeImports.isEmpty ||
      linesAfterImports.isEmpty) {
    return null;
  }

  final List<String> linesSorted = [];

  if (linesBeforeImports.isNotEmpty) {
    linesSorted.addAll(
      linesBeforeImports,
    );
    linesSorted.add('');
  }

  void combineImportLines({
    required List<String> importList,
  }) {
    if (importList.isNotEmpty) {
      importList.sort();
      lines.addAll(
        importList,
      );
      lines.add('');
    }
  }

  combineImportLines(
    importList: importsDart,
  );
  combineImportLines(
    importList: importsFlutter,
  );
  combineImportLines(
    importList: importsPackage,
  );
  combineImportLines(
    importList: importsProject,
  );
  combineImportLines(
    importList: importsPart,
  );

  final File sortedFile = File(
    file.path,
  );
  sortedFile.writeAsStringSync(
    linesSorted.join("\n"),
  );

  return sortedFile;
}
