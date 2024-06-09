import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addClass(
    void Function(
      ClassDeclaration classDeclaration,
      ClassElement classElement,
    ) execute,
  ) =>
      this.registry.addClassDeclaration(
        (
          ClassDeclaration classDeclaration,
        ) {
          final ClassElement? classElement = classDeclaration.declaredElement;
          if (classElement == null) {
            return;
          }

          execute(
            classDeclaration,
            classElement,
          );
        },
      );

  void addClassIntersects(
    AnalysisError analysisError,
    void Function(
      ClassDeclaration classDeclaration,
      ClassElement classElement,
    ) execute,
  ) =>
      this.registry.addClassDeclaration(
        (
          ClassDeclaration classDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                classDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final ClassElement? classElement = classDeclaration.declaredElement;
          if (classElement == null) {
            return;
          }

          execute(
            classDeclaration,
            classElement,
          );
        },
      );
}
