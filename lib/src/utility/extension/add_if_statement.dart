import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addIfStatementIntersects(
    AnalysisError analysisError,
    void Function(
      IfStatement ifStatement,
    ) execute,
  ) =>
      this.registry.addIfStatement(
        (
          IfStatement ifStatement,
        ) {
          if (analysisError.sourceRange.intersects(
                ifStatement.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            ifStatement,
          );
        },
      );
}
