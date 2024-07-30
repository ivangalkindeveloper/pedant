import 'dart:io';
import 'package:collection/collection.dart';
import 'package:tint/tint.dart';
import 'package:yaml/yaml.dart';
import 'package:pedant/src/utility/convert_relative_import.dart';

Future<void> convertImport({
  required String currentPath,
}) async {
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

  final Map<String, List<String>> unusedImportMap = await _getUnusedImportMap();
  final List<File> dartFiles = _getFileList(
    path: currentPath,
  );
  final List<File> sortedDartFiles = [];

  for (final File dartFile in dartFiles) {
    final File? sortedFile = _sortFile(
      projectName: projectName,
      file: dartFile,
      unusedImportMap: unusedImportMap,
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
      "Sorted/converted: ${file.path.replaceAll(
        "$currentPath/lib/",
        "",
      )}\n",
    );
  }
  stdout.write(
    "\n",
  );
}

Future<Map<String, List<String>>> _getUnusedImportMap() async {
  final ProcessResult processResult = await Process.run(
    'dart',
    const [
      'analyze',
    ],
  );

  final dynamic stdout = processResult.stdout;
  if (stdout is! String) {
    return const {};
  }

  final List<String> analyzeSplit = stdout.split(
    "\n",
  );
  analyzeSplit.removeWhere(
    (
      String element,
    ) =>
        element.contains(
          "unused_import",
        ) ==
        false,
  );

  final Map<String, List<String>> unusedImportMap = {};
  for (int index = 0; index <= analyzeSplit.length - 1; index++) {
    try {
      final String analyzeLine = analyzeSplit[index];
      final List<String> analyzeLineSplit = analyzeLine.split(
        " - ",
      );

      final String filePath = analyzeLineSplit[1].split(":").first;
      final String unusedImportLine = analyzeLineSplit[2].split("'")[1];
      final List<String>? key = unusedImportMap[filePath];
      if (key == null) {
        unusedImportMap[filePath] = [
          unusedImportLine,
        ];
        continue;
      }

      key.add(
        unusedImportLine,
      );
    } catch (error) {
      continue;
    }
  }

  return unusedImportMap;
}

List<File> _getFileList({
  required String path,
}) {
  final List<File> dartFiles = [];
  final List<FileSystemEntity> entities = Directory(
    path,
  ).listSync(
    recursive: true,
  );
  for (final FileSystemEntity entity in entities) {
    if (entity is! File) {
      continue;
    }

    final String entityPath = entity.path.replaceAll(
      path,
      "",
    );
    if (entityPath.endsWith(
          ".dart",
        ) ==
        false) {
      continue;
    }
    if (entityPath.startsWith(
              "/lib",
            ) ==
            false &&
        entityPath.startsWith(
              "/bin",
            ) ==
            false) {
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
  required Map<String, List<String>> unusedImportMap,
}) {
  final RegExp prefixLibrary = RegExp(
    "library ",
  );
  final RegExp prefixExport = RegExp(
    "export [\"']",
  );
  final RegExp prefixImportDart = RegExp(
    "import [\"']dart:",
  );
  final RegExp prefixImportFlutter = RegExp(
    "import [\"']package:flutter/",
  );
  final RegExp prefixImportPackage = RegExp(
    "import [\"']package:",
  );
  final RegExp prefixImportProject = RegExp(
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
      line = convertRelativeImport(
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
      prefixImportDart,
    )) {
      if (_isUnusedImport(
        projectName: projectName,
        file: file,
        unusedImportMap: unusedImportMap,
        line: line,
      )) {
        continue;
      }

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
      prefixImportFlutter,
    )) {
      if (_isUnusedImport(
        projectName: projectName,
        file: file,
        unusedImportMap: unusedImportMap,
        line: line,
      )) {
        continue;
      }

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
      prefixImportProject,
    )) {
      if (_isUnusedImport(
        projectName: projectName,
        file: file,
        unusedImportMap: unusedImportMap,
        line: line,
      )) {
        continue;
      }

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
      prefixImportPackage,
    )) {
      if (_isUnusedImport(
        projectName: projectName,
        file: file,
        unusedImportMap: unusedImportMap,
        line: line,
      )) {
        continue;
      }

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
  }
  if (linesSorted.isNotEmpty && linesSorted.last.isNotEmpty) {
    linesSorted.add(
      "",
    );
  }

  void combineLines({
    required List<String> list,
    required bool isIntent,
  }) {
    if (list.isEmpty) {
      return;
    }

    list.sort();
    linesSorted.addAll(
      list,
    );
    if (isIntent) {
      linesSorted.add(
        "",
      );
    }
  }

  combineLines(
    list: libraries,
    isIntent: true,
  );
  combineLines(
    list: exports,
    isIntent: true,
  );
  combineLines(
    list: importsDart,
    isIntent: false,
  );
  combineLines(
    list: importsFlutter,
    isIntent: false,
  );
  combineLines(
    list: importsPackage,
    isIntent: false,
  );
  combineLines(
    list: importsProject,
    isIntent: true,
  );
  combineLines(
    list: parts,
    isIntent: true,
  );
  combineLines(
    list: partOfs,
    isIntent: true,
  );
  if (linesSorted.isNotEmpty && linesSorted.last.isNotEmpty) {
    linesSorted.add(
      "",
    );
  }

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

bool _isUnusedImport({
  required String projectName,
  required File file,
  required Map<String, List<String>> unusedImportMap,
  required String line,
}) {
  try {
    for (final MapEntry<String, List<String>> entry
        in unusedImportMap.entries) {
      if (file.path.endsWith(
            entry.key,
          ) ==
          false) {
        continue;
      }

      return entry.value.contains(
        line.split("'")[1],
      );
    }

    return false;
  } catch (error) {
    return false;
  }
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
