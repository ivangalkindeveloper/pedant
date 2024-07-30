import 'dart:io';
import 'package:args/args.dart';
import 'package:tint/tint.dart';
import 'package:pedant/src/utility/process/fix.dart';
import 'package:pedant/src/utility/process/format.dart';
import 'package:pedant/src/utility/process/watch.dart';
import 'package:pedant/src/utility/sort_convert/convert_import.dart';
import 'package:pedant/src/utility/sort_convert/sort_arb.dart';
import 'package:pedant/src/utility/sort_convert/sort_pubspec.dart';

Future<void> main(
  List<String> arguments,
) async {
  final String currentPath = Directory.current.path;

  final ArgParser argParser = ArgParser()
    ..addFlag(
      'no-fix',
      negatable: false,
      help: "Don't automatic fix all detected linter errors.",
    )
    ..addFlag(
      'no-sort-arb',
      negatable: false,
      help: "Don't sorting in alphabetical order of the fields of .arb files.",
    )
    ..addFlag(
      'no-convert-import',
      negatable: false,
      help:
          "Don't sorting/converting in alphabetical order of declarations of imports, exports and parts of .dart files.",
    )
    ..addFlag(
      'no-sort-pubspec',
      negatable: false,
      help:
          "Don't sorting in alphabetical order of dependencies, dev_dependencies, dependency_overrides keys in pubspec.yaml.",
    )
    ..addFlag(
      'no-format',
      negatable: false,
      help: "Don't Dart code formatting.",
    )
    ..addFlag(
      'help',
      negatable: false,
      help: 'Prints command usage',
    );
  final ArgResults argResults = argParser.parse(
    arguments,
  );

  try {
    if (argResults['help'] == true) {
      stdout.writeln(
        'Usage: pedant',
      );
      stdout.writeln(
        argParser.usage,
      );
      return;
    }

    watch(
      currentPath: currentPath,
    );

    if (argResults["no-fix"] == false) {
      fix(
        currentPath: currentPath,
      );
    }

    if (argResults["no-sort-arb"] == false) {
      sortArb(
        currentPath: currentPath,
      );
    }

    if (argResults["no-convert-import"] == false) {
      await convertImport(
        currentPath: currentPath,
      );
    }

    if (argResults["no-sort-pubspec"] == false) {
      sortPubspec(
        currentPath: currentPath,
      );
    }

    if (argResults["no-format"] == false) {
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
    stdout.write(
      error,
    );
    stdout.write(
      stackTrace,
    );
  }
}
