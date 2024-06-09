import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_function_list.dart';
import 'package:pedant/src/utility/extension/add_function_expression_invocation.dart';
import 'package:pedant/src/utility/extension/add_method_invocation.dart';

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
            errorSeverity: ErrorSeverity.WARNING,
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
      ) =>
          _validateAndReport(
        name: node.methodName.name,
        onSuccess: () => reporter.atNode(
          node,
          this.code,
        ),
      ),
    );
    context.registry.addFunctionExpressionInvocation(
      (
        FunctionExpressionInvocation node,
      ) =>
          _validateAndReport(
        name: node.function.toString(),
        onSuccess: () => reporter.atNode(
          node,
          this.code,
        ),
      ),
    );
  }

  void _validateAndReport({
    required String name,
    required void Function() onSuccess,
  }) {
    if (deleteListItem.nameList.contains(name) == false) {
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
    context.addMethodInvocationIntersects(
      analysisError,
      (
        MethodInvocation methodInvocation,
      ) {
        final String name = methodInvocation.methodName.name;
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '$name'",
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
    context.addFunctionInvocationIntersects(
      analysisError,
      (
        FunctionExpressionInvocation functionExpressionInvocation,
      ) {
        final String function =
            functionExpressionInvocation.function.toString();
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '$function'",
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
