import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/validate/validate_const_initializer.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

class AddConstConstructorRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConstConstructor == false) {
      return;
    }

    ruleList.add(
      AddConstConstructorRule(
        priority: config.priority,
      ),
    );
  }

  const AddConstConstructorRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_const_constructor",
            problemMessage: "Pedant: Add const constructor.",
            correctionMessage:
                "Please add const keyword to default constructor of this class.",
            errorSeverity: ErrorSeverity.ERROR,
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
          int constFieldCounter = 0;
          ConstructorElement? validatedConstructorElement;

          classDeclaration.visitChildren(
            AstTreeVisitor(
              onFieldDeclaration: (
                FieldDeclaration fieldDeclaration,
              ) {
                // Validate class fields
                if (fieldDeclaration.isStatic == true) {
                  return;
                }

                validateConstVariableList(
                  variableList: fieldDeclaration.fields,
                  onSuccess: () => constFieldCounter++,
                );
              },
              onConstructorDeclaration: (
                ConstructorDeclaration constructorDeclaration,
              ) {
                // Validate constructor initializers
                int constInitializer = 0;
                constructorDeclaration.visitChildren(
                  AstTreeVisitor(
                    onConstructorFieldInitializer: (
                      ConstructorFieldInitializer constructorFieldInitializer,
                    ) =>
                        validateConstChildren(
                      node: constructorFieldInitializer,
                      onSuccess: () => constInitializer++,
                    ),
                  ),
                );
                if (constInitializer !=
                    constructorDeclaration.initializers.length) {
                  return;
                }

                // Validate constrcutor body function
                if (constructorDeclaration.body.beginToken.type !=
                    TokenType.SEMICOLON) {
                  return;
                }

                // Validate constructor
                final ConstructorElement? constructorElement =
                    constructorDeclaration.declaredElement;
                if (constructorElement == null) {
                  return;
                }
                if (constructorElement.isConst == true) {
                  return;
                }
                if (constructorElement.isFactory == true) {
                  return;
                }

                // Validate super constructor
                final ConstructorElement? superConstructor =
                    constructorElement.superConstructor;
                if (superConstructor?.isConst == false) {
                  return;
                }

                validatedConstructorElement = constructorElement;
              },
            ),
          );

          if (constFieldCounter != classElement.fields.length) {
            return;
          }
          if (validatedConstructorElement == null) {
            return;
          }

          reporter.atElement(
            validatedConstructorElement!,
            this.code,
          );
        },
      );

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
  ) =>
      context.addConstructorElementIntersects(
        analysisError,
        (
          ConstructorDeclaration constructorDeclaration,
          ConstructorElement constructorElement,
        ) {
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message:
                "Pedant: Add const to '${constructorElement.displayName}' constructor",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addInsertion(
              constructorElement.nameOffset,
              (
                DartEditBuilder builder,
              ) =>
                  builder.write(
                "const ",
              ),
            ),
          );
        },
      );
}
