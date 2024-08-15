import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addMixin(
    void Function(
      MixinDeclaration extensionDeclaration,
      MixinElement extensionElement,
    ) execute,
  ) =>
      this.registry.addMixinDeclaration(
        (
          MixinDeclaration extensionDeclaration,
        ) {
          final MixinElement? extensionElement =
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

  void addMixinIntersects(
    error.AnalysisError analysisError,
    void Function(
      MixinDeclaration extensionDeclaration,
      MixinElement extensionElement,
    ) execute,
  ) =>
      this.registry.addMixinDeclaration(
        (
          MixinDeclaration extensionDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                extensionDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final MixinElement? extensionElement =
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
