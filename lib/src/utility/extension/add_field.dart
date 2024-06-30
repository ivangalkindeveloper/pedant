import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addField(
    void Function(
      FieldDeclaration fieldDeclaration,
      Element element,
    ) execute,
  ) =>
      this.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          final Element? element = fieldDeclaration.declaredElement;
          if (element == null) {
            return;
          }

          execute(
            fieldDeclaration,
            element,
          );
        },
      );

  void addFieldElementIntersects(
    AnalysisError analysisError,
    void Function(
      FieldDeclaration fieldDeclaration,
      Element element,
    ) execute,
  ) =>
      this.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                fieldDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final Element? element = fieldDeclaration.declaredElement;
          if (element == null) {
            return;
          }

          execute(
            fieldDeclaration,
            element,
          );
        },
      );

  void addFieldVariableIntersects(
    AnalysisError analysisError,
    void Function(
      FieldDeclaration fieldDeclaration,
      VariableElement variableElement,
    ) execute,
  ) =>
      this.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                fieldDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          for (final VariableDeclaration variable
              in fieldDeclaration.fields.variables) {
            if (analysisError.sourceRange.intersects(
                  variable.sourceRange,
                ) ==
                false) {
              continue;
            }

            final VariableElement? variableElement = variable.declaredElement;
            if (variableElement == null) {
              continue;
            }

            execute(
              fieldDeclaration,
              variableElement,
            );
          }
        },
      );
}
