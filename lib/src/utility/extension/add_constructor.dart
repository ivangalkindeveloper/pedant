import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
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

  void addConstructorIntersects(
    AnalysisError analysisError,
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
}
