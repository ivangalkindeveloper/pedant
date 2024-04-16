import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class DeleteImplSuffixRule extends DartLintRule {
  const DeleteImplSuffixRule()
      : super(
          code: const LintCode(
            name: "delete_impl_suffix",
            problemMessage: "Delete 'Impl' suffix in class",
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
  ) {
    context.registry.addClassDeclaration(
      (node) {
        final className = node.name.lexeme;
        if (className.endsWith("Impl")) {
          reporter.reportErrorForToken(
            code,
            node.name,
          );
        }
      },
    );
  }

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
  ) {
    context.registry.addClassDeclaration(
      (node) {
        if (analysisError.sourceRange.intersects(node.sourceRange)) {
          final validName = node.name.lexeme.replaceAll("Impl", "");
          final changeBuilder = reporter.createChangeBuilder(
            message: "Raname to '$validName'",
            priority: 0,
          );
          changeBuilder.addDartFileEdit(
            (builder) {
              builder.addSimpleReplacement(
                SourceRange(
                  node.name.offset,
                  node.name.length,
                ),
                validName,
              );
            },
          );
        }
      },
    );
  }
}
