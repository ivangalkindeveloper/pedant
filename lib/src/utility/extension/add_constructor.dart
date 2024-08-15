import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addConstructor(
    void Function(
      ConstructorDeclaration constructorDeclaration,
      ConstructorElement constructorElement,
    ) execute,
  ) =>
      this.registry.addConstructorDeclaration(
        (
          ConstructorDeclaration constructorDeclaration,
        ) {
          final ConstructorElement? constructorElement =
              constructorDeclaration.declaredElement;
          if (constructorElement == null) {
            return;
          }

          execute(
            constructorDeclaration,
            constructorElement,
          );
        },
      );

  void addConstructorElementIntersects(
    error.AnalysisError analysisError,
    void Function(
      ConstructorDeclaration constructorDeclaration,
      ConstructorElement constructorElement,
    ) execute,
  ) =>
      this.registry.addConstructorDeclaration(
        (
          ConstructorDeclaration constructorDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                constructorDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final ConstructorElement? constructorElement =
              constructorDeclaration.declaredElement;
          if (constructorElement == null) {
            return;
          }

          execute(
            constructorDeclaration,
            constructorElement,
          );
        },
      );

  void addConstructorParameterIntersects(
    error.AnalysisError analysisError,
    void Function(
      ConstructorDeclaration constructorDeclaration,
      FormalParameter formalParameter,
      ParameterElement parameterElement,
    ) execute,
  ) =>
      this.registry.addConstructorDeclaration(
        (
          ConstructorDeclaration constructorDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                constructorDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          for (final FormalParameter formalParameter
              in constructorDeclaration.parameters.parameters) {
            if (analysisError.sourceRange.intersects(
                  formalParameter.sourceRange,
                ) ==
                false) {
              continue;
            }

            final ParameterElement? parameterElement =
                formalParameter.declaredElement;
            if (parameterElement == null) {
              continue;
            }

            execute(
              constructorDeclaration,
              formalParameter,
              parameterElement,
            );
          }
        },
      );
}
