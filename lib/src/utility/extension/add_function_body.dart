import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFunctionBodyIntersects(
    error.AnalysisError analysisError,
    void Function(
      FunctionBody functionBody,
    ) execute,
  ) =>
      this.registry.addFunctionBody(
        (
          FunctionBody functionBody,
        ) {
          if (analysisError.sourceRange.intersects(
                functionBody.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            functionBody,
          );
        },
      );
}
