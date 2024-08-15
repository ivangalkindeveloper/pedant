import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addConstructorFieldInitializerIntersects(
    error.AnalysisError analysisError,
    void Function(
      ConstructorFieldInitializer constructorFieldInitializer,
    ) execute,
  ) =>
      this.registry.addConstructorFieldInitializer(
        (
          ConstructorFieldInitializer constructorFieldInitializer,
        ) {
          if (analysisError.sourceRange.intersects(
                constructorFieldInitializer.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            constructorFieldInitializer,
          );
        },
      );
}
