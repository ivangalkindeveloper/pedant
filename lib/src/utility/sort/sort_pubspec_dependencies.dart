import 'dart:io';

import 'package:collection/collection.dart';
import 'package:tint/tint.dart';
import 'package:yaml/yaml.dart';

void sortPubspecDependencies({
  required String currentPath,
}) {
  stdout.write(
    "Sorting pubspec dependencies...\n".yellow(),
  );

  final File pubspecFile = File(
    "$currentPath/pubspec.yaml",
  );
  if (pubspecFile.existsSync() == false) {
    stdout.write(
      "File not found: $pubspecFile",
    );
    return;
  }

  final YamlMap pubspecYaml = loadYaml(
    pubspecFile.readAsStringSync(),
  );
  final List<String> pubspecLines = pubspecFile.readAsLinesSync();
  final List<String> sortedKeys = [];

  _sortNode(
    pubspecYaml: pubspecYaml,
    pubspecLines: pubspecLines,
    key: "dependencies",
    sortedKeys: sortedKeys,
  );
  _sortNode(
    pubspecLines: pubspecLines,
    pubspecYaml: pubspecYaml,
    key: "dev_dependencies",
    sortedKeys: sortedKeys,
  );
  _sortNode(
    pubspecLines: pubspecLines,
    pubspecYaml: pubspecYaml,
    key: "dependency_overrides",
    sortedKeys: sortedKeys,
  );

  pubspecFile.writeAsStringSync(
    pubspecLines.join(
      "\n",
    ),
  );

  if (sortedKeys.isEmpty) {
    stdout.write(
      "No pubspec dependencies for sorting.\n\n",
    );
    return;
  }

  for (final String key in sortedKeys) {
    stdout.write(
      "Sorted pubspec: '$key'\n",
    );
  }
  stdout.write(
    "\n",
  );
}

void _sortNode({
  required YamlMap pubspecYaml,
  required List<String> pubspecLines,
  required String key,
  required List<String> sortedKeys,
}) {
  final YamlMap? node = pubspecYaml[key];
  if (node == null) {
    return;
  }

  final int startIndex = pubspecLines.indexOf("$key:") + 1;
  final Map<String, dynamic> sorted = _sort(
    node: node,
  );
  final List<String> sortedLines = _dump(
    map: sorted,
  );
  final List<String> sourceLines = pubspecLines
      .getRange(
        startIndex,
        startIndex + (sortedLines.length),
      )
      .toList();
  if (ListEquality().equals(
    sourceLines,
    sortedLines,
  )) {
    return;
  }

  for (int index = startIndex;
      (index - startIndex) <= (sortedLines.length - 1);
      index++) {
    pubspecLines[index] = sortedLines[index - startIndex];
  }

  sortedKeys.add(
    key,
  );
}

Map<String, dynamic> _sort({
  required YamlMap node,
}) =>
    Map.fromEntries(
      node
          .map(
            (
              dynamic key,
              dynamic value,
            ) =>
                MapEntry(
              key as String,
              value is YamlMap
                  ? _sort(
                      node: value,
                    )
                  : value,
            ),
          )
          .entries
          .sorted(
            (
              MapEntry<String, dynamic> a,
              MapEntry<String, dynamic> b,
            ) =>
                a.key.compareTo(
              b.key,
            ),
          ),
    );

List<String> _dump({
  required Map<String, dynamic> map,
  int level = 1,
}) {
  final String indent = '  ' * level;
  final List<String> lines = [];

  for (final MapEntry<String, dynamic> entry in map.entries) {
    final String key = entry.key;
    final dynamic value = entry.value;
    if (value is String?) {
      if (value == null) {
        lines.add('$indent$key:');
      } else {
        lines.add('$indent$key: $value');
      }
    } else {
      lines.add('$indent$key:');
      lines.addAll(
        _dump(
          map: value as Map<String, dynamic>,
          level: level + 1,
        ),
      );
    }
  }

  return lines;
}
