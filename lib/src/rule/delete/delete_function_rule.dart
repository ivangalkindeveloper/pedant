import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/default/default_delete_function_list.dart';
import 'package:pedant/src/utility/extension/add_function_expression_invocation.dart';
import 'package:pedant/src/utility/extension/add_method_invocation.dart';

class DeleteFunctionRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<String> deleteFunctionList =
        config.deleteFunctionList ?? defaultDeleteFunctionList;
    ruleList.add(
      DeleteFunctionRule(
        list: deleteFunctionList,
        priority: config.priority,
      ),
    );
  }

  DeleteFunctionRule({
    required this.list,
    required this.priority,
  }) : super(
          code: LintCode(
            name: "delete_function",
            problemMessage: "Pedant: Delete function: ${list.join(", ")}.",
            correctionMessage: "Please delete this function from code snippet.",
            errorSeverity: error.ErrorSeverity.WARNING,
          ),
        );

  final List<String> list;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation(
      (
        MethodInvocation methodInvocation,
      ) =>
          _validate(
        name: methodInvocation.methodName.name,
        onSuccess: () {
          final int length = methodInvocation.length;

          reporter.atOffset(
            offset: methodInvocation.offset,
            length: methodInvocation.endToken.next?.type == TokenType.SEMICOLON
                ? length + 1
                : length,
            errorCode: this.code,
          );
        },
      ),
    );
    context.registry.addFunctionExpressionInvocation(
      (
        FunctionExpressionInvocation functionExpressionInvocation,
      ) =>
          _validate(
        name: functionExpressionInvocation.function.toString(),
        onSuccess: () {
          final int length = functionExpressionInvocation.length;

          reporter.atOffset(
            offset: functionExpressionInvocation.offset,
            length: functionExpressionInvocation.endToken.next?.type ==
                    TokenType.SEMICOLON
                ? length + 1
                : length,
            errorCode: this.code,
          );
        },
      ),
    );
  }

  void _validate({
    required String name,
    required void Function() onSuccess,
  }) {
    if (this.list.contains(
              name,
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) {
    void createChangeBuilder({
      required String name,
    }) {
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
    }

    context.addMethodInvocationIntersects(
      analysisError,
      (
        MethodInvocation methodInvocation,
      ) {
        if (methodInvocation.offset != analysisError.offset) {
          return;
        }

        createChangeBuilder(
          name: methodInvocation.methodName.name,
        );
      },
    );
    context.addFunctionInvocationIntersects(
      analysisError,
      (
        FunctionExpressionInvocation functionExpressionInvocation,
      ) {
        if (functionExpressionInvocation.offset != analysisError.offset) {
          return;
        }

        createChangeBuilder(
          name: functionExpressionInvocation.function.toString(),
        );
      },
    );
  }
}
