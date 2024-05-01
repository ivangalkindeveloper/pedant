import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_package_list.dart';

class DeletePackageRule extends LintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<DeleteListItem> deletePackageList =
        config.deletePackageList ?? defaultDeletePackageList;
    for (final DeleteListItem deleteListItem in deletePackageList) {
      ruleList.add(
        DeletePackageRule(
          deleteListItem: deleteListItem,
        ),
      );
    }
  }

  DeletePackageRule({
    required this.deleteListItem,
  }) : super(
          code: LintCode(
            name: "delete_package",
            problemMessage:
                "Delete package and its dependencies: ${deleteListItem.nameList.first}.",
            correctionMessage:
                "Please delete this package from pubspec.yaml.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final DeleteListItem deleteListItem;

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
    final File file = File(
      resolver.path,
    );
    final String fileContent = file.readAsStringSync();
    final List<(int, String)> indexList = [];

    for (final String packageName in deleteListItem.nameList) {
      final int indexOf = fileContent.lastIndexOf(
        "  $packageName:",
      );
      if (indexOf == -1) {
        continue;
      }
      indexList.add(
        (
          indexOf,
          packageName,
        ),
      );
    }

    for (final (int, String) packageLine in indexList) {
      reporter.reportErrorForOffset(
        code,
        packageLine.$1 + 2,
        packageLine.$2.length + 1,
      );
    }
  }

  @override
  List<Fix> getFixes() => [
        _Fix(
          packageList: deleteListItem.nameList,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.packageList,
  });

  final List<String> packageList;

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

    for (final String packageName in packageList) {
      final int indexOf = lines.lastIndexOf("  $packageName:");
      if (indexOf == -1) {
        continue;
      }
      lines.remove(indexOf);
    }

    file.writeAsStringSync(
      lines.join(
        '\n',
      ),
    );
  }
}
