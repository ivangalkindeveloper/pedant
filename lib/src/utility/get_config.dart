import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:pedant/src/core/config/config.dart';

Config getConfig() {
  final String currentPath = Directory.current.path;
  final File pedantYamlFile = File(
    "$currentPath/pedant.yaml",
  );
  if (pedantYamlFile.existsSync()) {
    final dynamic pedantYaml = loadYaml(
      pedantYamlFile.readAsStringSync(),
    );
    final String pedantString = jsonEncode(pedantYaml);
    final dynamic pedantJson = jsonDecode(pedantString);

    return Config.fromJson(
      json: pedantJson["pedant"],
    );
  }

  final File pubspecYamlFile = File(
    "$currentPath/pubspec.yaml",
  );
  if (pubspecYamlFile.existsSync()) {
    final dynamic pubspecYaml = loadYaml(
      pubspecYamlFile.readAsStringSync(),
    );
    final String pubspecString = jsonEncode(pubspecYaml);
    final dynamic pubspecJson = jsonDecode(pubspecString);

    return Config.fromJson(
      json: pubspecJson["pedant"],
    );
  }

  return const Config();
}
