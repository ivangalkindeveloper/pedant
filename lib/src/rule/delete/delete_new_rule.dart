import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

class DeleteNewRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteNew == false) {
      return;
    }

    ruleList.add(
      DeleteNewRule(),
    );
  }

  DeleteNewRule()
      : super(
          code: const LintCode(
            name: "delete_new",
            problemMessage: "Operator 'new' is useless in last version of SDK.",
            correctionMessage: "Please delete 'new' operator.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

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

          final String keywordName = keyword.toString();
          if (keywordName != "new") {
            return;
          }

          reporter.reportErrorForToken(
            this.code,
            node.keyword!,
          );
        },
      );

  @override
  List<Fix> getFixes() => [
        _Fix(),
      ];
}

class _Fix extends DartFix {
  _Fix();

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
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Delete 'new'",
            priority: 0,
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
