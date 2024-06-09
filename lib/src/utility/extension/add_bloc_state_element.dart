import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addBlocStateElement(
    void Function(
      ClassElement blocElement,
      ClassElement stateElement,
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

          final InterfaceType? supertype = blocElement.supertype;
          if (supertype == null) {
            return;
          }

          final List<DartType> typeArguments = supertype.typeArguments;
          if (typeArguments.length != 2) {
            return;
          }

          final DartType stateType = typeArguments[1];
          if (stateType.element is! ClassElement) {
            return;
          }

          final ClassElement stateElement = stateType.element as ClassElement;
          final String blocPackagePath =
              blocElement.source.fullName.split("lib").first;
          final String statePackagePath =
              stateElement.source.fullName.split("lib").first;
          if (blocPackagePath != statePackagePath) {
            return;
          }

          on(
            blocElement,
            stateElement,
          );
        },
      );
}
