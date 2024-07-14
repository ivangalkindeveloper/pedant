import 'dart:io';

import 'package:collection/collection.dart';
import 'package:tint/tint.dart';
import 'package:yaml/yaml.dart';

import 'package:pedant/src/utility/convert_import.dart';

void sortConvertExportImportPart({
  required String currentPath,
}) {
  stdout.write(
    "Sorting/converting import, export and part declarations...\n".yellow(),
  );

  final File pubspecFile = File(
    "$currentPath/pubspec.yaml",
  );
  final dynamic pubspecYaml = loadYaml(
    pubspecFile.readAsStringSync(),
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

    sortedDartFiles.add(
      sortedFile,
    );
  }

  if (sortedDartFiles.isEmpty) {
    stdout.write(
      "No import, exports or part declarations files for sorting/converting.\n\n",
    );
    return;
  }

  for (final File file in sortedDartFiles) {
    stdout.write(
      "Sorted/converted: ${file.path.replaceAll("$currentPath/lib/", "")}\n",
    );
  }
  stdout.write(
    "\n",
  );
}

List<File> _getFiles({
  required String path,
}) {
  final List<File> dartFiles = [];
  final List<FileSystemEntity> entities = Directory(
    path,
  ).listSync(
    recursive: true,
  );
  for (final FileSystemEntity entity in entities) {
    if (entity is! File ||
        !entity.path.endsWith(
          ".dart",
        ) ||
        entity.path.contains(
          "generated_plugin_registrant",
        )) {
      continue;
    }

    if (!entity.path.contains("edit_relative_import.dart")) {
      continue;
    }

    dartFiles.add(
      entity,
    );
  }

  return dartFiles;
}

File? _sortFile({
  required String projectName,
  required File file,
}) {
  final RegExp prefixLibrary = RegExp(
    "library ",
  );
  final RegExp prefixExport = RegExp(
    "export [\"']",
  );
  final RegExp prefixDart = RegExp(
    "import [\"']dart:",
  );
  final RegExp prefixFlutter = RegExp(
    "import [\"']package:flutter/",
  );
  final RegExp prefixPackage = RegExp(
    "import [\"']package:/",
  );
  final RegExp prefixProject = RegExp(
    "import [\"']package:$projectName/",
  );
  final RegExp prefixPart = RegExp(
    "part [\"']",
  );
  final RegExp prefixPartOf = RegExp(
    "part of [\"']",
  );

  final List<String> lines = file.readAsLinesSync();
  if (lines.isEmpty) {
    return null;
  }
  if (lines.length == 1 && lines.first == "") {
    return null;
  }

  final List<String> libraries = [];
  final List<String> exports = [];
  final List<String> importsDart = [];
  final List<String> importsFlutter = [];
  final List<String> importsPackage = [];
  final List<String> importsProject = [];
  final List<String> parts = [];
  final List<String> partOfs = [];

  final List<String> linesBeforeDeclarations = [];
  final List<String> linesAfterDeclarations = [];

  bool isDeclarationsEmpty() =>
      libraries.isEmpty &&
      exports.isEmpty &&
      importsDart.isEmpty &&
      importsFlutter.isEmpty &&
      importsPackage.isEmpty &&
      importsProject.isEmpty &&
      parts.isEmpty &&
      partOfs.isEmpty;

  for (int index = 0; index < lines.length; index++) {
    String line = lines[index];

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

    if (line.startsWith(
      prefixLibrary,
    )) {
      libraries.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixExport,
    )) {
      exports.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixDart,
    )) {
      final (
        int,
        String,
      ) multilineOffset = _multilineOffset(
        lines: lines,
        currentIndex: index,
        line: line,
      );
      index += multilineOffset.$1;
      line = multilineOffset.$2;

      importsDart.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixFlutter,
    )) {
      final (
        int,
        String,
      ) multilineOffset = _multilineOffset(
        lines: lines,
        currentIndex: index,
        line: line,
      );
      index += multilineOffset.$1;
      line = multilineOffset.$2;

      importsFlutter.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixProject,
    )) {
      final (
        int,
        String,
      ) multilineOffset = _multilineOffset(
        lines: lines,
        currentIndex: index,
        line: line,
      );
      index += multilineOffset.$1;
      line = multilineOffset.$2;

      importsProject.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixPackage,
    )) {
      final (
        int,
        String,
      ) multilineOffset = _multilineOffset(
        lines: lines,
        currentIndex: index,
        line: line,
      );
      index += multilineOffset.$1;
      line = multilineOffset.$2;

      importsPackage.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixPart,
    )) {
      parts.add(
        line,
      );
      continue;
    }

    if (line.startsWith(
      prefixPartOf,
    )) {
      partOfs.add(
        line,
      );
      continue;
    }

    if (isDeclarationsEmpty()) {
      linesBeforeDeclarations.add(
        line,
      );
    } else {
      linesAfterDeclarations.add(
        line,
      );
    }
  }

  if (isDeclarationsEmpty()) {
    return null;
  }

  final List<String> linesSorted = [];

  if (linesBeforeDeclarations.isNotEmpty) {
    linesSorted.addAll(
      linesBeforeDeclarations,
    );
    if (linesBeforeDeclarations.last.isNotEmpty) {
      linesSorted.add(
        "",
      );
    }
  }

  void combineLines({
    required List<String> list,
  }) {
    if (list.isNotEmpty) {
      list.sort();
      linesSorted.addAll(
        list,
      );
      linesSorted.add(
        "",
      );
    }
  }

  combineLines(
    list: libraries,
  );
  combineLines(
    list: exports,
  );
  combineLines(
    list: importsDart,
  );
  combineLines(
    list: importsFlutter,
  );
  combineLines(
    list: importsPackage,
  );
  combineLines(
    list: importsProject,
  );
  combineLines(
    list: parts,
  );
  combineLines(
    list: partOfs,
  );

  linesSorted.addAll(
    linesAfterDeclarations,
  );

  for (int i = linesSorted.length - 1; i > 0; i--) {
    if (linesSorted[i] == "" && linesSorted[i - 1] == "") {
      linesSorted.removeAt(
        i,
      );
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
    linesSorted.join(
      "\n",
    ),
  );

  return sortedFile;
}

bool _isRelativeImport({
  required String line,
}) =>
    line.startsWith(
      "import '",
    ) &&
    (line.contains(
          "../",
        ) ||
        line.contains(
          "./",
        ));

(
  int,
  String,
) _multilineOffset({
  required List<String> lines,
  required int currentIndex,
  required String line,
}) {
  if (line.endsWith(
    ";",
  )) {
    return (
      0,
      line,
    );
  }

  int offset = 0;
  for (int index = currentIndex + 1; index < lines.length; index++) {
    final String currentLine = lines[index];

    offset++;
    line += " $currentLine";

    if (line.endsWith(
      ";",
    )) {
      break;
    }
  }

  return (
    offset,
    line,
  );
}
