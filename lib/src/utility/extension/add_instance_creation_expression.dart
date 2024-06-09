import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addInstanceCreationExpressionIntersects(
    AnalysisError analysisError,
    void Function(
      InstanceCreationExpression instanceCreationExpression,
    ) execute,
  ) =>
      this.registry.addInstanceCreationExpression(
        (
          InstanceCreationExpression instanceCreationExpression,
        ) {
          if (analysisError.sourceRange.intersects(
                instanceCreationExpression.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            instanceCreationExpression,
          );
        },
      );
}
