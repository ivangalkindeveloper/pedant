import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addMethod(
    void Function(
      MethodDeclaration methodDeclaration,
      ExecutableElement executableElement,
    ) execute,
  ) =>
      this.registry.addMethodDeclaration(
        (
          MethodDeclaration methodDeclaration,
        ) {
          final ExecutableElement? executableElement =
              methodDeclaration.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            methodDeclaration,
            executableElement,
          );
        },
      );

  void addMethodIntersects(
    error.AnalysisError analysisError,
    void Function(
      MethodDeclaration methodDeclaration,
      ExecutableElement executableElement,
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

          final ExecutableElement? executableElement =
              methodDeclaration.declaredElement;
          if (executableElement == null) {
            return;
          }

          execute(
            methodDeclaration,
            executableElement,
          );
        },
      );
}
