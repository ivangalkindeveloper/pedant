import 'dart:io';

import 'package:args/args.dart';

import 'package:pedant/src/utility/sort_import_declarations.dart';

void main(
  List<String> arguments,
) {
  try {
    final ArgParser parser = ArgParser();
    final List<String> argumentsResult = parser
        .parse(
          arguments,
        )
        .arguments;
    final String currentPath = Directory.current.path;

    if (argumentsResult.contains('--no-fix') == false) {
      print("Fix current lint problems");
      Process.runSync(
        "dart",
        const [
          "run",
          "custom_lint",
          "--fix",
        ],
        workingDirectory: currentPath,
      );
    }

    if (argumentsResult.contains('--no-sort-import') == false) {
      print("Sorting import and part declarations");
      sortImportDeclarations(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains('--no-dart-format') == false) {
      print("Formatting Dart code");
      Process.runSync(
        "dart",
        const [
          "format",
          ".",
        ],
        workingDirectory: currentPath,
      );
    }

    print("Updating lint problems");
    Process.runSync(
      "dart",
      const [
        "run",
        "custom_lint",
        "--watch",
      ],
      workingDirectory: currentPath,
    );
    print("Done");
  } catch (error, stackTrace) {
    stdout.write(error);
    stdout.write(stackTrace);
  }
}
