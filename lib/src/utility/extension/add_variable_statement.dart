import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addVariableStatementIntersects(
    AnalysisError analysisError,
    void Function(
      VariableDeclarationStatement variableDeclarationStatement,
    ) execute,
  ) =>
      this.registry.addVariableDeclarationStatement(
        (
          VariableDeclarationStatement variableDeclarationStatement,
        ) {
          if (analysisError.sourceRange.intersects(
                variableDeclarationStatement.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            variableDeclarationStatement,
          );
        },
      );
}
