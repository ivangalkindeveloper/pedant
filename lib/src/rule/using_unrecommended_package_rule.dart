import 'dart:io';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UsingUnrecommendedPackageRule extends DartLintRule {
  UsingUnrecommendedPackageRule({
    required this.packageName,
    this.description,
  }) : super(
          code: LintCode(
            name: "using_unrecommended_package",
            problemMessage: "Dont use unrecommended package: $packageName.\n"
                "Please remove this package from pubspec.yaml",
            correctionMessage: description,
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final String packageName;
  final String? description;

  @override
  List<String> get filesToAnalyze => const [
        "pubspec.yaml",
      ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final File file = File(resolver.path);
    final String fileContent = file.readAsStringSync();
    final int indexOf = fileContent.lastIndexOf(packageName);
    if (indexOf != -1) {
      reporter.reportErrorForOffset(
        code,
        indexOf,
        packageName.length,
      );
    }
  }

  @override
  List<Fix> getFixes() => [
        _Fix(
          packageName: packageName,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.packageName,
  });

  final String packageName;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    final File file = File(resolver.path);
    final List<String> lines = file.readAsLinesSync();
    final int indexOf =
        lines.indexWhere((value) => value.contains(packageName));
    lines.removeAt(indexOf);
    file.writeAsStringSync(lines.join('\n'));
  }
}
