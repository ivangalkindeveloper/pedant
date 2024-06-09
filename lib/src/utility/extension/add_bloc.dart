import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/utility/bloc_type_checker.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addBloc(
    void Function(
      ClassDeclaration blocDeclaration,
      ClassElement blocElement,
    ) execute,
  ) =>
      this.registry.addClassDeclaration(
        (
          ClassDeclaration classDeclaration,
        ) {
          final ClassElement? blocElement = classDeclaration.declaredElement;
          if (blocElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFrom(
                blocElement,
              ) ==
              false) {
            return;
          }

          execute(
            classDeclaration,
            blocElement,
          );
        },
      );
}
