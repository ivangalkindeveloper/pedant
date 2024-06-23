import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addSimpleIdentifierIntersects(
    AnalysisError analysisError,
    void Function(
      SimpleIdentifier simpleIdentifier,
    ) execute,
  ) =>
      this.registry.addSimpleIdentifier(
        (
          SimpleIdentifier simpleIdentifier,
        ) {
          if (analysisError.sourceRange.intersects(
                simpleIdentifier.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            simpleIdentifier,
          );
        },
      );
}
