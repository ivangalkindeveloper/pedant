import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addVariableListIntersects(
    AnalysisError analysisError,
    void Function(
      VariableDeclarationList variableDeclarationList,
    ) execute,
  ) =>
      this.registry.addVariableDeclarationList(
        (
          VariableDeclarationList variableDeclarationList,
        ) {
          if (analysisError.sourceRange.intersects(
                variableDeclarationList.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            variableDeclarationList,
          );
        },
      );
}
