import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class DeletePrintRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deletePrint) {
      return;
    }

    ruleList.add(
      DeletePrintRule(),
    );
  }

  DeletePrintRule()
      : super(
          code: LintCode(
            name: "delete_print",
            problemMessage:
                "Don't use 'print' / 'debugPrint' function in code snippet.",
            correctionMessage: "Please delete 'print' / 'debugPrint' function.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  List<String> get filesToAnalyze => const [
        "**.dart",
      ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addFunctionReference(
        (
          node,
        ) {
          final String? name = node.staticType?.alias?.element.name;
          if (name != "print" && name != "debugPrint") {
            return;
          }

          reporter.reportErrorForNode(
            this.code,
            node,
          );
        },
      );

  @override
  List<Fix> getFixes() => [
        _Fix(),
      ];
}

class _Fix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) =>
      context.registry.addCommentReference(
        (
          CommentReference node,
        ) {
          if (analysisError.sourceRange.intersects(
            node.sourceRange,
          )) {
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Delete 'new'",
              priority: 0,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) =>
                  builder.addDeletion(
                analysisError.sourceRange,
              ),
            );
          }
        },
      );
}
