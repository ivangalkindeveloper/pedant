import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/extension/add_constructor_field_initializer.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';
import 'package:pedant/src/utility/extension/add_field.dart';
import 'package:pedant/src/utility/tree_visitor.dart';
import 'package:pedant/src/utility/type_checker/bloc_type_checker.dart';
import 'package:pedant/src/utility/type_checker/cubit_type_checkot.dart';

class DeleteBlocCubitDependentBlocCubitFlutterRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteBlocCubitDependentBlocCubit == true) {
      ruleList.add(
        DeleteBlocCubitDependentBlocCubitFlutterRule(
          code: const LintCode(
            name: "delete_bloc_cubit_dependent_bloc_cubit",
            problemMessage:
                "Pedant: Delete Bloc or Cubit dependency in current Bloc or Cubit.",
            correctionMessage:
                "Please delete this Bloc or Cubit dependency.\nCommunication between Bloc's or Cubit's should occur only through widgets.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
          validaton: ({
            required DartType? type,
            required String? packageName,
          }) {
            if (type == null) {
              return false;
            }

            if (blocTypeChecker.isAssignableFromType(
                      type,
                    ) ==
                    false &&
                cubitTypeChecker.isAssignableFromType(
                      type,
                    ) ==
                    false) {
              return false;
            }

            return true;
          },
          priority: config.priority,
        ),
      );
    }

    if (config.deleteBlocCubitDependentFlutter == true) {
      ruleList.add(
        DeleteBlocCubitDependentBlocCubitFlutterRule(
          code: const LintCode(
            name: "delete_bloc_cubit_dependent_flutter",
            problemMessage:
                "Delete Flutter resource dependency in current Bloc or Cubit.",
            correctionMessage:
                "Please delete this Flutter resource dependency.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
          validaton: ({
            required DartType? type,
            required String? packageName,
          }) {
            if (packageName == null) {
              return false;
            }

            if (packageName.startsWith("package:flutter") == false) {
              return false;
            }

            return true;
          },
          priority: config.priority,
        ),
      );
    }
  }

  const DeleteBlocCubitDependentBlocCubitFlutterRule({
    required super.code,
    required this.validaton,
    required this.priority,
  });

  final bool Function({
    required DartType? type,
    required String? packageName,
  }) validaton;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addBloc(
      (
        ClassDeclaration blocDeclaration,
        ClassElement blocElement,
      ) =>
          this._visitChildren(
        reporter: reporter,
        classDeclaration: blocDeclaration,
      ),
    );
    context.addCubit(
      (
        ClassDeclaration cubitDeclaration,
        ClassElement cubitElement,
      ) =>
          this._visitChildren(
        reporter: reporter,
        classDeclaration: cubitDeclaration,
      ),
    );
  }

  void _visitChildren({
    required ErrorReporter reporter,
    required ClassDeclaration classDeclaration,
  }) =>
      classDeclaration.visitChildren(
        TreeVisitor(
          onConstructorDeclaration: (
            ConstructorDeclaration constructorDeclaration,
          ) {
            for (final FormalParameter parameter
                in constructorDeclaration.parameters.parameters) {
              final ParameterElement? parameterElement =
                  parameter.declaredElement;
              if (parameterElement == null) {
                continue;
              }

              if (this.validaton(
                    type: parameterElement.type,
                    packageName:
                        parameterElement.type.element?.library?.identifier,
                  ) ==
                  false) {
                continue;
              }

              reporter.atElement(
                parameterElement,
                this.code,
              );
            }

            constructorDeclaration.visitChildren(
              TreeVisitor(
                onConstructorFieldInitializer: (
                  ConstructorFieldInitializer constructorFieldInitializer,
                ) {
                  final DartType? staticType =
                      constructorFieldInitializer.expression.staticType;
                  if (staticType == null) {
                    return;
                  }

                  if (this.validaton(
                        type: staticType,
                        packageName: staticType.element?.library?.identifier,
                      ) ==
                      false) {
                    return;
                  }

                  reporter.atNode(
                    constructorFieldInitializer,
                    this.code,
                  );
                },
              ),
            );
          },
          onFieldDeclaration: (
            FieldDeclaration fieldDeclaration,
          ) {
            for (final VariableDeclaration variable
                in fieldDeclaration.fields.variables) {
              final VariableElement? variableElement = variable.declaredElement;
              if (variableElement == null) {
                continue;
              }

              if (this.validaton(
                    type: variableElement.type,
                    packageName:
                        variableElement.type.element?.library?.identifier,
                  ) ==
                  false) {
                continue;
              }

              reporter.atNode(
                fieldDeclaration,
                this.code,
              );
            }
          },
        ),
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
  ) {
    context.addConstructorParameterIntersects(
      analysisError,
      (
        ConstructorDeclaration constructorDeclaration,
        FormalParameter formalParameter,
        ParameterElement parameterElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '${parameterElement.displayName}'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addDeletion(
            SourceRange(
              formalParameter.sourceRange.offset,
              formalParameter.endToken.next?.type == TokenType.COMMA
                  ? (formalParameter.sourceRange.length + 1)
                  : formalParameter.sourceRange.length,
            ),
          ),
        );
      },
    );
    context.addConstructorFieldInitializerIntersects(
      analysisError,
      (
        ConstructorFieldInitializer constructorFieldInitializer,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '${constructorFieldInitializer.fieldName}'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addDeletion(
            SourceRange(
              constructorFieldInitializer.sourceRange.offset,
              constructorFieldInitializer.endToken.next?.type == TokenType.COMMA
                  ? (constructorFieldInitializer.sourceRange.length + 1)
                  : constructorFieldInitializer.sourceRange.length,
            ),
          ),
        );
      },
    );
    context.addFieldVariableIntersects(
      analysisError,
      (
        FieldDeclaration fieldDeclaration,
        VariableElement variableElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '${variableElement.displayName}'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addDeletion(
            analysisError.sourceRange,
          ),
        );
      },
    );
  }
}
