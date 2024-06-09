import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_if_statement.dart';

class AddIfBracesRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addIfBraces == false) {
      return;
    }

    ruleList.add(
      AddIfBracesRule(
        priority: config.priority,
      ),
    );
  }

  const AddIfBracesRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_if_braces",
            problemMessage: "Add 'if' statement braces",
            correctionMessage:
                "Please add braces to then block of this 'if' statement declaration.",
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
      context.registry.addIfStatement(
        (
          IfStatement ifStatement,
        ) {
          final Statement thenStatement = ifStatement.thenStatement;
          final TokenType beginTokenType = thenStatement.beginToken.type;
          if (beginTokenType == TokenType.OPEN_CURLY_BRACKET) {
            return;
          }

          reporter.atNode(
            ifStatement,
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
      context.addIfStatementIntersects(
        analysisError,
        (
          IfStatement ifStatement,
        ) {
          final Statement thenStatement = ifStatement.thenStatement;
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Add braces",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addSimpleReplacement(
              thenStatement.sourceRange,
              "{${thenStatement.toString()}}",
            ),
          );
        },
      );
}
