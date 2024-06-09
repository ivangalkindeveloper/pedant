import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFunctionInvocationIntersects(
    AnalysisError analysisError,
    void Function(
      FunctionExpressionInvocation functionExpressionInvocation,
    ) execute,
  ) =>
      this.registry.addFunctionExpressionInvocation(
        (
          FunctionExpressionInvocation functionExpressionInvocation,
        ) {
          if (analysisError.sourceRange.intersects(
                functionExpressionInvocation.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            functionExpressionInvocation,
          );
        },
      );
}
