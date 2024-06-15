import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_function_body.dart';

class EditArrowFunctionRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addExtensionPostfix == false) {
      return;
    }

    ruleList.add(
      EditArrowFunctionRule(
        priority: config.priority,
      ),
    );
  }

  const EditArrowFunctionRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_arrow_function",
            problemMessage: "Edit to arrow function",
            correctionMessage: "Please edit this function to arrow function.",
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
      context.registry.addFunctionBody(
        (
          FunctionBody functionBody,
        ) {
          if (functionBody.parent is ConstructorDeclaration) {
            return;
          }

          final TokenType beginTokenType = functionBody.beginToken.type;
          final TokenType? nextBeginTokenType =
              functionBody.beginToken.next?.type;
          final TokenType endTokenType = functionBody.endToken.type;
          if (beginTokenType != TokenType.OPEN_CURLY_BRACKET ||
              nextBeginTokenType == TokenType.CLOSE_CURLY_BRACKET ||
              endTokenType != TokenType.CLOSE_CURLY_BRACKET) {
            return;
          }

          final SyntacticEntity? entity =
              functionBody.childEntities.firstOrNull;
          if (entity == null) {
            return;
          }

          final List<String> entitySplit = entity.toString().split(
                "; ",
              );
          final TokenType? nextTokenType = functionBody.beginToken.next?.type;
          if (nextTokenType != Keyword.RETURN && entitySplit.length > 1) {
            return;
          }

          reporter.atNode(
            functionBody,
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
      context.addFunctionBodyIntersects(
        analysisError,
        (
          FunctionBody functionBody,
        ) {
          final String nodeString = functionBody.toString();
          final String cleanNode = nodeString
              .substring(
                1,
                nodeString.length - 1,
              )
              .replaceAll(
                "return ",
                "",
              );
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Edit to arrow function",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addSimpleReplacement(
              analysisError.sourceRange,
              "=> $cleanNode",
            ),
          );
        },
      );
}
