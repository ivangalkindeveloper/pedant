import 'dart:io';

import 'package:tint/tint.dart';

void fix({
  required String currentPath,
}) {
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
