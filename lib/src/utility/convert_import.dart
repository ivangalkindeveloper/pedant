import 'package:path/path.dart';

String convertImport({
  required String projectName,
  required String libPath,
  required String filePath,
  required String line,
}) {
  String importPath = line.split(RegExp(r"\'*\'"))[1];
  final String fileDirectory = dirname(filePath);
  final String packagePrefix = "package:$projectName/";

  importPath = normalize("$fileDirectory/$importPath/");
  importPath = importPath.replaceAll(
    libPath,
    packagePrefix,
  );

  final List<String> splittedPath = line.split(RegExp(r"\'*\'"));
  splittedPath[1] = "'$importPath'";

  return splittedPath.join();
}
