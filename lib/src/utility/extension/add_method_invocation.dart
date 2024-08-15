import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addMethodInvocationIntersects(
    error.AnalysisError analysisError,
    void Function(
      MethodInvocation methodInvocation,
    ) execute,
  ) =>
      this.registry.addMethodInvocation(
        (
          MethodInvocation methodInvocation,
        ) {
          if (analysisError.sourceRange.intersects(
                methodInvocation.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            methodInvocation,
          );
        },
      );
}
