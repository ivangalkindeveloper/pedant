import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/convert_import.dart';

class EditRelativeImportRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editRelativeImport == false) {
      return;
    }

    ruleList.add(
      EditRelativeImportRule(
        priority: config.priority,
      ),
    );
  }

  EditRelativeImportRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_relative_import",
            problemMessage: "Edit relative resource import.",
            correctionMessage:
                "Please edit for this resource relative import to absolute.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addImportDirective(
        (
          ImportDirective node,
        ) {
          final String source = node.toSource();
          if (source.contains("../") == false) {
            return;
          }

          reporter.atNode(
            node,
            this.code,
          );
        },
      );

  @override
  List<Fix> getFixes() => [
        _Fix(
          priority: this.priority,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.priority,
  });

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) =>
      context.registry.addImportDirective(
        (
          ImportDirective node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final String source = node.toSource();
          final String sourceValid = convertImport(
            projectName: context.pubspec.name,
            libPath: "${resolver.path.split("/lib").first}/lib/",
            filePath: resolver.path,
            line: source,
          );
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Rename to '$sourceValid'",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addSimpleReplacement(
              analysisError.sourceRange,
              sourceValid,
            ),
          );
        },
      );
}
