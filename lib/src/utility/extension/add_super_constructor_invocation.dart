import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addSuperConstructorInvocationIntersects(
    error.AnalysisError analysisError,
    void Function(
      SuperConstructorInvocation superConstructorInvocation,
    ) execute,
  ) =>
      this.registry.addSuperConstructorInvocation(
        (
          SuperConstructorInvocation superConstructorInvocation,
        ) {
          if (analysisError.sourceRange.intersects(
                superConstructorInvocation.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            superConstructorInvocation,
          );
        },
      );
}
