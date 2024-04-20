import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class DeleteImplementationSuffixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteImplementationSuffix) {
      return;
    }

    ruleList.add(
      DeleteImplementationSuffixRule(),
    );
  }

  const DeleteImplementationSuffixRule()
      : super(
          code: const LintCode(
            name: "delete_implementation_suffix",
            problemMessage:
                "Delete 'Impl' or 'Implementation' suffix in class.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  List<String> get filesToAnalyze => const [
        '**.dart',
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
          final String className = node.name.lexeme;
          if (className.endsWith("Impl") ||
              className.endsWith("Implementation")) {
            reporter.reportErrorForToken(
              this.code,
              node.name,
            );
          }
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
            final String validName = node.name.lexeme.replaceAll("Impl", "");
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Raname to '$validName'",
              priority: 0,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) =>
                  builder.addSimpleReplacement(
                SourceRange(
                  node.name.offset,
                  node.name.length,
                ),
                validName,
              ),
            );
          }
        },
      );
}
