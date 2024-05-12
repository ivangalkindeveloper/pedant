import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_function_list.dart';

class DeleteFunctionRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<DeleteListItem> deleteFunctionList =
        config.deleteFunctionList ?? defaultDeleteFunctionList;
    for (final DeleteListItem deleteListItem in deleteFunctionList) {
      ruleList.add(
        DeleteFunctionRule(
          deleteListItem: deleteListItem,
          priority: config.priority,
        ),
      );
    }
  }

  DeleteFunctionRule({
    required this.deleteListItem,
    required this.priority,
  }) : super(
          code: LintCode(
            name: "delete_function",
            problemMessage:
                "Delete function: ${deleteListItem.nameList.join(", ")}.",
            correctionMessage:
                "Please delete this function from code snippet.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}",
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
  ) {
    context.registry.addMethodInvocation(
      (
        MethodInvocation node,
      ) {
        final String name = node.methodName.name;
        _validateAndReport(
          reporter: reporter,
          name: name,
          offset: node.offset,
          length: node.length + 1,
        );
      },
    );
    context.registry.addFunctionExpressionInvocation(
      (
        FunctionExpressionInvocation node,
      ) {
        final String function = node.function.toString();
        _validateAndReport(
          reporter: reporter,
          name: function,
          offset: node.offset,
          length: node.length + 1,
        );
      },
    );
  }

  void _validateAndReport({
    required ErrorReporter reporter,
    required String name,
    required int offset,
    required int length,
  }) {
    if (deleteListItem.nameList.contains(name) == false) {
      return;
    }

    reporter.reportErrorForOffset(
      this.code,
      offset,
      length,
    );
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
    context.registry.addMethodInvocation(
      (
        MethodInvocation node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final String name = node.methodName.name;
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "pedant: Delete '$name'",
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
      },
    );
    context.registry.addFunctionExpressionInvocation(
      (
        FunctionExpressionInvocation node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final String function = node.function.toString();
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "pedant: Delete '$function'",
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
      },
    );
  }
}
