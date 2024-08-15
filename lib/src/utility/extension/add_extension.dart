import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addExtension(
    void Function(
      ExtensionDeclaration extensionDeclaration,
      ExtensionElement extensionElement,
    ) execute,
  ) =>
      this.registry.addExtensionDeclaration(
        (
          ExtensionDeclaration extensionDeclaration,
        ) {
          final ExtensionElement? extensionElement =
              extensionDeclaration.declaredElement;
          if (extensionElement == null) {
            return;
          }

          execute(
            extensionDeclaration,
            extensionElement,
          );
        },
      );

  void addExtensionIntersects(
    error.AnalysisError analysisError,
    void Function(
      ExtensionDeclaration extensionDeclaration,
      ExtensionElement extensionElement,
    ) execute,
  ) =>
      this.registry.addExtensionDeclaration(
        (
          ExtensionDeclaration extensionDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                extensionDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final ExtensionElement? extensionElement =
              extensionDeclaration.declaredElement;
          if (extensionElement == null) {
            return;
          }

          execute(
            extensionDeclaration,
            extensionElement,
          );
        },
      );
}
