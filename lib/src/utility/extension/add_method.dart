import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addMethodIntersects(
    AnalysisError analysisError,
    void Function(
      MethodDeclaration methodDeclaration,
    ) execute,
  ) =>
      this.registry.addMethodDeclaration(
        (
          MethodDeclaration methodDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                methodDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            methodDeclaration,
          );
        },
      );
}
