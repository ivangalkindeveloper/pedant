import 'dart:io';

import 'package:args/args.dart';
import 'package:pedant/src/utility/sort_import_declarations.dart';

void main(
  List<String> arguments,
) {
  try {
    final ArgParser parser = ArgParser();
    parser.addFlag(
      'fix',
      negatable: false,
    );
    final List<String> argumentsResult = parser.parse(arguments).arguments;

    // if (argumentsResult.contains('--fix')) {
    sortImportDeclarations();
    // }
  } catch (error, stackTrace) {
    stdout.write(error);
    stdout.write(stackTrace);
  }
}
