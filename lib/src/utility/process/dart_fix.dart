import 'dart:io';
import 'package:tint/tint.dart';

void dartFix({
  required String currentPath,
}) {
  stdout.write(
    "Fix Dart code...\n".yellow(),
  );
  Process.runSync(
    "dart",
    const [
      "fix",
      "--apply",
    ],
    workingDirectory: currentPath,
  );
  stdout.write(
    "\n",
  );
}
