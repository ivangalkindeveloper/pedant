import 'dart:io';

import 'package:args/args.dart';
import 'package:pedant/src/utility/process/fix.dart';
import 'package:pedant/src/utility/process/format.dart';
import 'package:pedant/src/utility/process/watch.dart';
import 'package:tint/tint.dart';

import 'package:pedant/src/utility/sort/sort_arb_files.dart';
import 'package:pedant/src/utility/sort/sort_import_declarations.dart';
import 'package:pedant/src/utility/sort/sort_pubspec_dependencies.dart';

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

    watch(
      currentPath: currentPath,
    );

    if (argumentsResult.contains(
          "--no-fix",
        ) ==
        false) {
      fix(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains(
          "--no-sort-arb-files",
        ) ==
        false) {
      sortArbFiles(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains(
          "--no-sort-dart-import-declarations",
        ) ==
        false) {
      sortImportDeclarations(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains(
          "--no-sort-pubspec-dependencies",
        ) ==
        false) {
      sortPubspecDependencies(
        currentPath: currentPath,
      );
    }

    if (argumentsResult.contains(
          "--no-dart-format",
        ) ==
        false) {
      format(
        currentPath: currentPath,
      );
    }

    watch(
      currentPath: currentPath,
    );

    stdout.write(
      "Done.\n".green(),
    );
  } catch (error, stackTrace) {
    stdout.write(error);
    stdout.write(stackTrace);
  }
}
