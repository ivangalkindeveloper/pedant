import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_instance_creation_expression.dart';

class DeleteNewRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteNew == false) {
      return;
    }

    ruleList.add(
      DeleteNewRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteNewRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_new",
            problemMessage:
                "Pedant: Keyword 'new' is useless in last version of Dart SDK.",
            correctionMessage: "Please delete 'new' operator.",
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
      context.registry.addInstanceCreationExpression(
        (
          InstanceCreationExpression node,
        ) {
          final Token? keyword = node.keyword;
          if (keyword == null) {
            return;
          }

          final TokenType tokenType = keyword.type;
          if (tokenType != Keyword.NEW) {
            return;
          }

          reporter.atToken(
            keyword,
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
      context.addInstanceCreationExpressionIntersects(
        analysisError,
        (
          InstanceCreationExpression instanceCreationExpression,
        ) {
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Delete 'new'",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addDeletion(
              SourceRange(
                analysisError.sourceRange.offset,
                analysisError.sourceRange.length + 1,
              ),
            ),
          );
        },
      );
}
