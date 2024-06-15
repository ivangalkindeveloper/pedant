import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/utility/type_checker/cubit_type_checkot.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addCubit(
    void Function(
      ClassDeclaration cubitDeclaration,
      ClassElement cubitElement,
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

          if (cubitTypeChecker.isAssignableFrom(
                classElement,
              ) ==
              false) {
            return;
          }

          execute(
            classDeclaration,
            classElement,
          );
        },
      );
}
