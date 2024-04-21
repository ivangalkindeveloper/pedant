import 'dart:io';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/delete/delete_list_item.dart';
import 'package:pedant/src/core/delete/delete_package_list.dart';
import 'package:pedant/src/core/config/config.dart';

class DeletePackageRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deletePackage) {
      return;
    }

    final List<DeleteListItem> deleteList = config.deletePackageList.isNotEmpty
        ? config.deletePackageList
        : deletePackageList;
    for (final DeleteListItem item in deleteList) {
      for (final String name in item.nameList) {
        ruleList.add(
          DeletePackageRule(
            packageName: name,
            description: item.description,
          ),
        );
      }
    }
  }

  DeletePackageRule({
    required this.packageName,
    this.description,
  }) : super(
          code: LintCode(
            name: "delete_package",
            problemMessage: "Don't use unrecommended package: $packageName.",
            correctionMessage:
                "Please delete this package from pubspec.yaml.${description != null ? "\n$description" : ""}",
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
    final int indexOf = fileContent.lastIndexOf("  $packageName:");
    if (indexOf == -1) {
      return;
    }

    reporter.reportErrorForOffset(
      code,
      indexOf,
      packageName.length,
    );
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
    final int indexOf = lines.indexWhere(
      (
        String value,
      ) =>
          value.contains(
        packageName,
      ),
    );
    lines.removeAt(indexOf);
    file.writeAsStringSync(
      lines.join(
        '\n',
      ),
    );
  }
}
