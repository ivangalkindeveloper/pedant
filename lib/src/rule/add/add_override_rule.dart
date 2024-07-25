import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_method.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

class AddOverrideRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addOverride == false) {
      return;
    }

    ruleList.add(
      AddOverrideRule(
        priority: config.priority,
      ),
    );
  }

  const AddOverrideRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_override",
            problemMessage: "Pedant: Add override annotation.",
            correctionMessage:
                "Please add @override annotation to this field of method.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          final NodeList<NamedType>? interfaces =
              classDeclaration.implementsClause?.interfaces;
          final NamedType? superclass =
              classDeclaration.extendsClause?.superclass;
          final NodeList<NamedType>? mixinTypes =
              classDeclaration.withClause?.mixinTypes;

          final List<NamedType> superTypes = [];
          if (interfaces != null && interfaces.isNotEmpty) {
            superTypes.addAll(
              interfaces,
            );
          }
          if (superclass != null) {
            superTypes.add(
              superclass,
            );
          }
          if (mixinTypes != null && mixinTypes.isNotEmpty) {
            superTypes.addAll(
              mixinTypes,
            );
          }

          classDeclaration.visitChildren(
            AstTreeVisitor(
              onFieldDeclaration: (
                FieldDeclaration fieldDeclaration,
              ) {
                for (final Annotation annotation in fieldDeclaration.metadata) {
                  final String? displayName = annotation.element?.displayName;
                  if (displayName == "override") {
                    return;
                  }
                }

                final NodeList<VariableDeclaration> variables =
                    fieldDeclaration.fields.variables;
                for (final VariableDeclaration variableDeclaration
                    in variables) {
                  final VariableElement? variableElement =
                      variableDeclaration.declaredElement;
                  if (variableElement == null) {
                    continue;
                  }

                  this._validate(
                    classElement: classElement,
                    name: variableElement.name,
                    superTypes: superTypes,
                    onSuccess: () => reporter.atElement(
                      variableElement,
                      this.code,
                    ),
                  );
                }
              },
              onMethodDeclaration: (
                MethodDeclaration methodDeclaration,
              ) {
                final ExecutableElement? executableElement =
                    methodDeclaration.declaredElement;
                if (executableElement == null) {
                  return;
                }

                for (final Annotation annotation
                    in methodDeclaration.metadata) {
                  final String? displayName = annotation.element?.displayName;
                  if (displayName == "override") {
                    return;
                  }
                }

                this._validate(
                  classElement: classElement,
                  name: executableElement.name,
                  superTypes: superTypes,
                  onSuccess: () => reporter.atElement(
                    executableElement,
                    this.code,
                  ),
                );
              },
            ),
          );
        },
      );

  void _validate({
    required ClassElement classElement,
    required String name,
    required List<NamedType> superTypes,
    required void Function() onSuccess,
  }) {
    for (final NamedType superType in superTypes) {
      final LibraryElement? library = superType.element?.library;
      if (library == null) {
        continue;
      }

      final PropertyAccessorElement? inheritedGetter =
          classElement.lookUpInheritedConcreteGetter(
        name,
        library,
      );
      if (inheritedGetter != null) {
        return onSuccess();
      }

      final PropertyAccessorElement? inheritedSetter =
          classElement.lookUpInheritedConcreteSetter(
        name,
        library,
      );
      if (inheritedSetter != null) {
        return onSuccess();
      }

      final MethodElement? inheritedMethod =
          classElement.lookUpInheritedConcreteMethod(
        name,
        library,
      );
      if (inheritedMethod != null) {
        return onSuccess();
      }
    }
  }

  @override
  List<Fix> getFixes() => [
        _Fix(
          priority: this.priority,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.priority,
  });

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addFieldDeclaration(
      (
        FieldDeclaration fieldDeclaration,
      ) {
        if (analysisError.sourceRange.intersects(
              fieldDeclaration.sourceRange,
            ) ==
            false) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            fieldDeclaration.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
    context.addMethodIntersects(
      analysisError,
      (
        MethodDeclaration methodDeclaration,
        ExecutableElement executableElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            methodDeclaration.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
  }
}
