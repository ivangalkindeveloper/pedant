import 'dart:io';
import 'package:tint/tint.dart';

void dartFormat({
  required String currentPath,
}) {
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
  stdout.write(
    "\n",
  );
}
