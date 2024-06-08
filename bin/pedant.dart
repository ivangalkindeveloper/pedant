import 'dart:io';

import 'package:args/args.dart';
import 'package:tint/tint.dart';

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

    stdout.write(
      "Watching lint problems...\n".yellow(),
    );
    Process.runSync(
      "dart",
      const [
        "run",
        "custom_lint",
        "--watch",
      ],
      workingDirectory: currentPath,
    );

    if (argumentsResult.contains(
          "--no-fix",
        ) ==
        false) {
      stdout.write(
        "Fix current lint problems...\n".yellow(),
      );
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

    if (argumentsResult.contains(
          "--no-sort-import",
        ) ==
        false) {
      stdout.write(
        "Sorting import and part declarations...\n".yellow(),
      );
      sortImportDeclarations(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains(
          "--no-dart-format",
        ) ==
        false) {
      stdout.write(
        "Formatting Dart code...\n".yellow(),
      );
      Process.runSync(
        "dart",
        const [
          "format",
          ".",
        ],
        workingDirectory: currentPath,
      );
    }

    stdout.write(
      "Updating lint problems...\n".yellow(),
    );
    Process.runSync(
      "dart",
      const [
        "run",
        "custom_lint",
        "--watch",
      ],
      workingDirectory: currentPath,
    );

    stdout.write(
      "Done.\n".green(),
    );
  } catch (error, stackTrace) {
    stdout.write(error);
    stdout.write(stackTrace);
  }
}
