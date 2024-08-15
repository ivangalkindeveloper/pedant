import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addImportDirectiveIntersects(
    error.AnalysisError analysisError,
    void Function(
      ImportDirective importDirective,
    ) execute,
  ) =>
      this.registry.addImportDirective(
        (
          ImportDirective importDirective,
        ) {
          if (analysisError.sourceRange.intersects(
                importDirective.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            importDirective,
          );
        },
      );
}
