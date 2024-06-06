import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

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
          IfStatement node,
        ) {
          final Statement thenStatement = node.thenStatement;
          final String beginLexeme = thenStatement.beginToken.lexeme;
          if (beginLexeme == "{") {
            return;
          }

          reporter.atNode(
            node,
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
      context.registry.addIfStatement(
        (
          IfStatement node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final Statement thenStatement = node.thenStatement;
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