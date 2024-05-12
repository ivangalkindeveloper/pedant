import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';
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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFromType(
                declaredElement.thisType,
              ) ==
              false) {
            return;
          }

          node.visitChildren(
            TreeVisitor(
              onConstructorDeclaration: (
                ConstructorDeclaration node,
              ) {
                for (final FormalParameter parameter
                    in node.parameters.parameters) {
                  final ParameterElement? declaredElement =
                      parameter.declaredElement;
                  if (declaredElement == null) {
                    continue;
                  }

                  this._validateAndReport(
                    type: declaredElement.type,
                    onSuccess: () => reporter.reportErrorForElement(
                      this.code,
                      declaredElement,
                    ),
                  );
                }
              },
              onFieldDeclaration: (
                FieldDeclaration node,
              ) {
                for (final VariableDeclaration variable
                    in node.fields.variables) {
                  final VariableElement? declaredElement =
                      variable.declaredElement;
                  if (declaredElement == null) {
                    continue;
                  }

                  this._validateAndReport(
                    type: declaredElement.type,
                    onSuccess: () => reporter.reportErrorForNode(
                      this.code,
                      node,
                    ),
                  );
                }
              },
            ),
          );
        },
      );

  void _validateAndReport({
    required DartType type,
    required void Function() onSuccess,
  }) {
    if (blocTypeChecker.isAssignableFromType(
          type,
        ) ==
        false) {
      return;
    }

    onSuccess();
  }

  @override
  List<Fix> getFixes() => [
        _Fix(
          priority: priority,
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
    context.registry.addConstructorDeclaration(
      (
        ConstructorDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        for (final FormalParameter parameter in node.parameters.parameters) {
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
            message: "pedant: Delete '${declaredElement.displayName}'",
            priority: priority,
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
    context.registry.addFieldDeclaration(
      (
        FieldDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        for (final VariableDeclaration variable in node.fields.variables) {
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
            message: "pedant: Delete '${declaredElement.displayName}'",
            priority: priority,
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
