import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
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
    final String fileString = file.readAsStringSync();
    final List<(int, String)> indexList = [];

    for (final String packageName in this.deleteListItem.nameList) {
      final int indexOf = fileString.lastIndexOf(
        "$packageName:",
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
        packageLine.$1,
        packageLine.$2.length,
      );
    }
  }

  @override
  List<Fix> getFixes() => [
        _Fix(),
      ];
}

class _Fix extends DartFix {
  _Fix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    final File file = File(
      resolver.path,
    );
    final List<String> lines = file.readAsLinesSync();
    final String? line = lines.firstWhereOrNull(
      (
        String currentLine,
      ) =>
          currentLine.contains(
        analysisError.message.split(":")[1].replaceAll(
              ".",
              "",
            ),
      ),
    );
    if (line == null) {
      return;
    }

    lines.remove(
      line,
    );
    file.writeAsStringSync(
      lines.join(
        "\n",
      ),
    );
  }
}
