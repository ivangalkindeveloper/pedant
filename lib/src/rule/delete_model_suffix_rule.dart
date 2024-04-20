import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class DeleteModelSuffixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteModelSuffix) {
      return;
    }

    ruleList.add(
      DeleteModelSuffixRule(),
    );
  }

  const DeleteModelSuffixRule()
      : super(
          code: const LintCode(
            name: "delete_model_suffix",
            problemMessage: "Сlass name must not contain an 'Model' suffix.",
            correctionMessage: "Please delete 'Model' suffix in class.",
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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final String lexeme = node.name.lexeme;
          if (!lexeme.endsWith("Model")) {
            return;
          }

          reporter.reportErrorForToken(
            this.code,
            node.name,
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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
            node.sourceRange,
          )) {
            final String validName = node.name.lexeme.replaceAll("Model", "");
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Raname to '$validName'",
              priority: 0,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) =>
                  builder.addSimpleReplacement(
                analysisError.sourceRange,
                validName,
              ),
            );
          }
        },
      );
}
