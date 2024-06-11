import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFunction(
    void Function(
      FunctionDeclaration functionDeclaration,
      ExecutableElement executableElement,
    ) execute,
  ) =>
      this.registry.addFunctionDeclaration(
        (
          FunctionDeclaration functionDeclaration,
        ) {
          final ExecutableElement? executableElement =
              functionDeclaration.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            functionDeclaration,
            executableElement,
          );
        },
      );

  void addFunctionIntersects(
    AnalysisError analysisError,
    void Function(
      FunctionDeclaration functionDeclaration,
      ExecutableElement executableElement,
    ) execute,
  ) =>
      this.registry.addFunctionDeclaration(
        (
          FunctionDeclaration functionDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                functionDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final ExecutableElement? executableElement =
              functionDeclaration.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            functionDeclaration,
            executableElement,
          );
        },
      );
}
