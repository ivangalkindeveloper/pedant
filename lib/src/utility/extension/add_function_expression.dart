import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFunctionExpression(
    void Function(
      FunctionExpression functionExpression,
      ExecutableElement executableElement,
    ) execute,
  ) =>
      this.registry.addFunctionExpression(
        (
          FunctionExpression functionExpression,
        ) {
          final ExecutableElement? executableElement =
              functionExpression.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            functionExpression,
            executableElement,
          );
        },
      );

  void addFunctionExpressionIntersects(
    error.AnalysisError analysisError,
    void Function(
      FunctionExpression functionExpression,
      ExecutableElement executableElement,
    ) execute,
  ) =>
      this.registry.addFunctionExpression(
        (
          FunctionExpression functionExpression,
        ) {
          if (analysisError.sourceRange.intersects(
                functionExpression.sourceRange,
              ) ==
              false) {
            return;
          }

          final ExecutableElement? executableElement =
              functionExpression.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            functionExpression,
            executableElement,
          );
        },
      );
}
