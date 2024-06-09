import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/extension/add_field.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

//TODO Fix initializer fields in Bloc constructor too
class DeleteBlocDependentBlocRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteBlocDependentBloc == false) {
      return;
    }

    ruleList.add(
      DeleteBlocDependentBlocRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteBlocDependentBlocRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_bloc_dependent_bloc",
            problemMessage: "Delete Bloc dependency in current Bloc.",
            correctionMessage:
                "Please delete this Bloc dependency.\nCommunication between Bloc's should occur only through widgets.",
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
      context.addBloc(
        (
          ClassDeclaration blocDeclaration,
          ClassElement blocElement,
        ) =>
            blocDeclaration.visitChildren(
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

                this._validateAndReport(
                  element: parameterElement,
                  onSuccess: () => reporter.atElement(
                    parameterElement,
                    this.code,
                  ),
                );
              }
            },
            onFieldDeclaration: (
              FieldDeclaration fieldDeclaration,
            ) {
              for (final VariableDeclaration variable
                  in fieldDeclaration.fields.variables) {
                final VariableElement? variableElement =
                    variable.declaredElement;
                if (variableElement == null) {
                  continue;
                }

                this._validateAndReport(
                  element: variableElement,
                  onSuccess: () => reporter.atNode(
                    fieldDeclaration,
                    this.code,
                  ),
                );
              }
            },
          ),
        ),
      );

  void _validateAndReport({
    required Element element,
    required void Function() onSuccess,
  }) {
    if (blocTypeChecker.isAssignableFrom(
          element,
        ) ==
        false) {
      return;
    }

    onSuccess();
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
    context.addConstructorIntersects(
      analysisError,
      (
        ConstructorDeclaration constructorDeclaration,
        ConstructorElement constructorElement,
      ) {
        for (final FormalParameter parameter
            in constructorDeclaration.parameters.parameters) {
          if (analysisError.sourceRange.intersects(
                parameter.sourceRange,
              ) ==
              false) {
            continue;
          }

          final ParameterElement? declaredElement = parameter.declaredElement;
          if (declaredElement == null) {
            continue;
          }

          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Delete '${declaredElement.displayName}'",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) {
              final String contentData = resolver.source.contents.data;
              if (contentData[parameter.sourceRange.end] == ",") {
                builder.addDeletion(
                  SourceRange(
                    parameter.sourceRange.end,
                    1,
                  ),
                );
              }

              builder.addDeletion(
                parameter.sourceRange,
              );
            },
          );
        }
      },
    );
    context.addFieldIntersects(
      analysisError,
      (
        FieldDeclaration fieldDeclaration,
        Element fieldElement,
      ) {
        for (final VariableDeclaration variable
            in fieldDeclaration.fields.variables) {
          if (analysisError.sourceRange.intersects(
                variable.sourceRange,
              ) ==
              false) {
            continue;
          }

          final VariableElement? declaredElement = variable.declaredElement;
          if (declaredElement == null) {
            continue;
          }

          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Delete '${declaredElement.displayName}'",
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
        }
      },
    );
  }
}
