import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/utility/type_checker/bloc_type_checker.dart';

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
          final ClassElement? classElement = classDeclaration.declaredElement;
          if (classElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFrom(
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

  void addBlocEvent(
    void Function(
      ClassElement blocElement,
      ClassElement eventElement,
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

          final InterfaceType? supertype = blocElement.supertype;
          if (supertype == null) {
            return;
          }

          final List<DartType> typeArguments = supertype.typeArguments;
          if (typeArguments.length != 2) {
            return;
          }

          final DartType eventType = typeArguments.first;
          if (eventType.element is! ClassElement) {
            return;
          }

          final ClassElement eventElement = eventType.element as ClassElement;
          final String blocPackagePath =
              blocElement.source.fullName.split("lib").first;
          final String eventPackagePath =
              eventElement.source.fullName.split("lib").first;
          if (blocPackagePath != eventPackagePath) {
            return;
          }

          execute(
            blocElement,
            eventElement,
          );
        },
      );

  void addBlocState(
    void Function(
      ClassElement blocElement,
      ClassElement stateElement,
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

          execute(
            blocElement,
            stateElement,
          );
        },
      );
}
