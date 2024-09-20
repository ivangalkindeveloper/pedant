import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_type_list.dart';
import 'package:pedant/src/utility/extension/add_instance_creation_expression.dart';
import 'package:pedant/src/utility/extension/add_variable.dart';

class DeleteTypeRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<DeleteListItem> deleteTypeList =
        config.deleteTypeList ?? defaultDeleteTypeList;
    for (final DeleteListItem deleteListItem in deleteTypeList) {
      ruleList.add(
        DeleteTypeRule(
          deleteListItem: deleteListItem,
          priority: config.priority,
        ),
      );
    }
  }

  DeleteTypeRule({
    required this.deleteListItem,
    required this.priority,
  }) : super(
          code: LintCode(
            name: "delete_type",
            problemMessage:
                "Pedant: Delete type: ${deleteListItem.nameList.join(", ")}.",
            correctionMessage:
                "Please delete this type from code snippet.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}.",
            errorSeverity: error.ErrorSeverity.ERROR,
          ),
        );

  final DeleteListItem deleteListItem;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addVariable(
      (
        VariableDeclaration variableDeclaration,
        VariableElement variableElement,
      ) {
        final String displayString = variableElement.type.getDisplayString();
        _validate(
          name: displayString,
          onSuccess: () => reporter.atNode(
            variableDeclaration,
            this.code,
          ),
        );
      },
    );
    context.registry.addInstanceCreationExpression(
      (
        InstanceCreationExpression instanceCreationExpression,
      ) {
        if (instanceCreationExpression.parent is VariableDeclaration) {
          return;
        }

        final DartType? staticType = instanceCreationExpression.staticType;
        if (staticType == null) {
          return;
        }

        final String displayString = staticType.getDisplayString();
        _validate(
          name: displayString,
          onSuccess: () => reporter.atNode(
            instanceCreationExpression,
            this.code,
          ),
        );
      },
    );
  }

  void _validate({
    required String name,
    required void Function() onSuccess,
  }) {
    for (final String typeName in deleteListItem.nameList) {
      if (typeName == name) {
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) {
    context.addVariableIntersects(
      analysisError,
      (
        VariableDeclaration variableDeclaration,
        VariableElement variableElement,
      ) {
        if (analysisError.offset != variableDeclaration.offset) {
          return;
        }

        final String displayString = variableElement.type.getDisplayString();
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '$displayString'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) {
            final int implicitTypeLength =
                variableElement.type.getDisplayString().length + 1;
            if (variableElement.hasImplicitType == false) {
              builder.addDeletion(
                SourceRange(
                  variableElement.nameOffset - implicitTypeLength,
                  implicitTypeLength,
                ),
              );
            }

            final Expression? initializer = variableDeclaration.initializer;
            if (initializer != null) {
              builder.addDeletion(
                initializer.sourceRange,
              );
            }
          },
        );
      },
    );
    context.addInstanceCreationExpressionIntersects(
      analysisError,
      (
        InstanceCreationExpression instanceCreationExpression,
      ) {
        if (analysisError.offset != instanceCreationExpression.offset) {
          return;
        }

        final DartType? staticType = instanceCreationExpression.staticType;
        if (staticType == null) {
          return;
        }

        final String displayString = staticType.getDisplayString();
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '$displayString'",
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
