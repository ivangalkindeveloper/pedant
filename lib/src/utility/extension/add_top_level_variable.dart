import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addTopLevelVariable(
    void Function(
      TopLevelVariableDeclaration topLevelVariableDeclaration,
      Element element,
    ) execute,
  ) =>
      this.registry.addTopLevelVariableDeclaration(
        (
          TopLevelVariableDeclaration topLevelVariableDeclaration,
        ) {
          final Element? element = topLevelVariableDeclaration.declaredElement;
          if (element == null) {
            return;
          }

          execute(
            topLevelVariableDeclaration,
            element,
          );
        },
      );

  void addTopLevelVariableIntersects(
    error.AnalysisError analysisError,
    void Function(
      TopLevelVariableDeclaration topLevelVariableDeclaration,
      Element element,
    ) execute,
  ) =>
      this.registry.addTopLevelVariableDeclaration(
        (
          TopLevelVariableDeclaration topLevelVariableDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                topLevelVariableDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final Element? element = topLevelVariableDeclaration.declaredElement;
          if (element == null) {
            return;
          }

          execute(
            topLevelVariableDeclaration,
            element,
          );
        },
      );
}
