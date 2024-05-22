import 'dart:io';

import 'package:collection/collection.dart';
import 'package:pedant/src/utility/convert_import.dart';
import 'package:yaml/yaml.dart';

void sortImportDeclarations({
  required String currentPath,
}) {
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
    "Sorted or converted import for files: ${sortedDartFiles.length}\n",
  );
  for (final file in sortedDartFiles) {
    stdout.write(
      "${file.path.replaceAll("${Directory.current.path}/lib/", "")}\n",
    );
  }
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

  final List<String> lines = file.readAsLinesSync();
  if (lines.isEmpty) {
    return null;
  }
  if (lines.length == 1 && lines.first == "") {
    return null;
  }

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

  for (String line in lines) {
    if (_isRelativeImport(
      line: line,
    )) {
      line = convertImport(
        projectName: projectName,
        libPath: "${Directory.current.path}/lib/",
        filePath: file.path,
        line: line,
      );
    }

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

  if (isImportEmpty()) {
    return null;
  }

  final List<String> linesSorted = [];

  if (linesBeforeImports.isNotEmpty) {
    linesSorted.addAll(
      linesBeforeImports,
    );
    if (linesBeforeImports.last.isNotEmpty) {
      linesSorted.add("");
    }
  }

  void combineImportLines({
    required List<String> importList,
  }) {
    if (importList.isNotEmpty) {
      importList.sort();
      linesSorted.addAll(
        importList,
      );
      linesSorted.add("");
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

  linesSorted.addAll(
    linesAfterImports,
  );

  for (int i = linesSorted.length - 1; i > 0; i--) {
    if (linesSorted[i] == "" && linesSorted[i - 1] == "") {
      linesSorted.removeAt(i);
    }
  }

  if (ListEquality().equals(
    lines,
    linesSorted,
  )) {
    return null;
  }

  final File sortedFile = File(
    file.path,
  );
  sortedFile.writeAsStringSync(
    linesSorted.join("\n"),
  );

  return sortedFile;
}

bool _isRelativeImport({
  required String line,
}) =>
    line.startsWith("import '") &&
    (line.contains("../") || line.contains("./"));
