import 'dart:convert';
import 'dart:io';

void sortArb({
  required String currentPath,
}) {
  final List<File> arbFiles = _getFiles(
    path: currentPath,
  );
  final List<File> sortedArbFiles = [];

  for (final File arbFile in arbFiles) {
    final File? sortedFile = _sortFile(
      file: arbFile,
    );
    if (sortedFile == null) {
      continue;
    }

    sortedArbFiles.add(sortedFile);
  }

  if (sortedArbFiles.isEmpty) {
    stdout.write(
      "\nNo files for sorting .arb files.\n\n",
    );
    return;
  }

  stdout.write(
    "\nSorted .arb files: ${sortedArbFiles.length}\n",
  );
  for (final File file in sortedArbFiles) {
    stdout.write(
      "${file.path.replaceAll("$currentPath/", "")}\n",
    );
  }
  stdout.write(
    "\n",
  );
}

List<File> _getFiles({
  required String path,
}) {
  final List<File> arbFiles = [];
  final List<FileSystemEntity> entities = Directory(path).listSync(
    recursive: true,
  );
  for (final FileSystemEntity entity in entities) {
    if (entity is! File || !entity.path.endsWith(".arb")) {
      continue;
    }

    arbFiles.add(entity);
  }

  return arbFiles;
}

File? _sortFile({
  required File file,
}) {
  final String fileString = file.readAsStringSync();
  final Map<String, dynamic> json = jsonDecode(
    fileString,
  );

  final Map<String, dynamic> sortedJson = Map.fromEntries(
    json.entries.toList()
      ..sort(
        (
          MapEntry<String, dynamic> a,
          MapEntry<String, dynamic> b,
        ) {
          final String akey = a.key.startsWith("@") == true
              ? a.key.replaceFirst(
                  "@",
                  "",
                )
              : a.key;
          ;
          final String bkey = b.key.startsWith("@") == true
              ? b.key.replaceFirst(
                  "@",
                  "",
                )
              : b.key;
          ;

          return akey.compareTo(
            bkey,
          );
        },
      ),
  );

  const JsonEncoder encoder = JsonEncoder.withIndent(
    '  ',
  );
  final String sortedString = encoder.convert(
    sortedJson,
  );

  final File sortedFile = File(
    file.path,
  );
  sortedFile.writeAsStringSync(
    sortedString,
  );

  return sortedFile;
}
