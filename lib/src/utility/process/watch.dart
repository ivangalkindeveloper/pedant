import 'dart:io';

import 'package:tint/tint.dart';

void watch({
  required String currentPath,
}) {
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
  stdout.write(
    "\n",
  );
}
