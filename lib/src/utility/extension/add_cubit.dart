import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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

  void addCubitState(
    void Function(
      ClassElement cubitElement,
      ClassElement stateElement,
    ) execute,
  ) =>
      this.registry.addClassDeclaration(
        (
          ClassDeclaration classDeclaration,
        ) {
          final ClassElement? cubitElement = classDeclaration.declaredElement;
          if (cubitElement == null) {
            return;
          }
          if (cubitTypeChecker.isAssignableFrom(
                cubitElement,
              ) ==
              false) {
            return;
          }

          final InterfaceType? supertype = cubitElement.supertype;
          if (supertype == null) {
            return;
          }

          final List<DartType> typeArguments = supertype.typeArguments;
          if (typeArguments.length != 1) {
            return;
          }

          final DartType stateType = typeArguments.first;
          if (stateType.element is! ClassElement) {
            return;
          }

          final ClassElement stateElement = stateType.element as ClassElement;
          final String blocPackagePath =
              cubitElement.source.fullName.split("lib").first;
          final String statePackagePath =
              stateElement.source.fullName.split("lib").first;
          if (blocPackagePath != statePackagePath) {
            return;
          }

          execute(
            cubitElement,
            stateElement,
          );
        },
      );
}
