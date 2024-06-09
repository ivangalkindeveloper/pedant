import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addBlocElement(
    void Function(
      ClassElement blocElement,
    ) on,
  ) =>
      this.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? blocElement = node.declaredElement;
          if (blocElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFrom(
                blocElement,
              ) ==
              false) {
            return;
          }

          on(
            blocElement,
          );
        },
      );
}
