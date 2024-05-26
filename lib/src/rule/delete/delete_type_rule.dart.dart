import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_type_list.dart';

//TODO Report and fix with specific type
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
                "Delete type: ${deleteListItem.nameList.join(", ")}.",
            correctionMessage:
                "Please delete this type from code snippet.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final DeleteListItem deleteListItem;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addInstanceCreationExpression(
        (
          InstanceCreationExpression node,
        ) {
          final DartType? type = node.staticType;
          if (type == null) {
            return;
          }

          final String displayString = type.getDisplayString();
          _validate(
            name: displayString,
            onSuccess: () => reporter.atNode(
              node,
              this.code,
            ),
          );
        },
      );

  void _validate({
    required String name,
    required void Function() onSuccess,
  }) {
    bool isMatch = false;
    for (final String typeName in deleteListItem.nameList) {
      if (typeName == name) {
        isMatch = true;
      }
    }

    if (isMatch) {
      onSuccess();
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
  ) =>
      context.registry.addInstanceCreationExpression(
        (
          InstanceCreationExpression node,
        ) {
          if (analysisError.sourceRange.covers(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final DartType? type = node.staticType;
          if (type == null) {
            return;
          }

          final String displayString = type.getDisplayString();
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
