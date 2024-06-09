import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addVariable(
    void Function(
      VariableDeclaration variableDeclaration,
      VariableElement variableElement,
    ) execute,
  ) =>
      this.registry.addVariableDeclaration(
        (
          VariableDeclaration variableDeclaration,
        ) {
          final VariableElement? variableElement =
              variableDeclaration.declaredElement;
          if (variableElement == null) {
            return;
          }

          execute(
            variableDeclaration,
            variableElement,
          );
        },
      );

  void addVariableIntersects(
    AnalysisError analysisError,
    void Function(
      VariableDeclaration variableDeclaration,
      VariableElement variableElement,
    ) execute,
  ) =>
      this.registry.addVariableDeclaration(
        (
          VariableDeclaration variableDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                variableDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final VariableElement? variableElement =
              variableDeclaration.declaredElement;
          if (variableElement == null) {
            return;
          }

          execute(
            variableDeclaration,
            variableElement,
          );
        },
      );
}
