import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addField(
    void Function(
      FieldDeclaration fieldDeclaration,
      Element fieldElement,
    ) execute,
  ) =>
      this.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          final Element? fieldElement = fieldDeclaration.declaredElement;
          if (fieldElement == null) {
            return;
          }

          execute(
            fieldDeclaration,
            fieldElement,
          );
        },
      );

  void addFieldIntersects(
    AnalysisError analysisError,
    void Function(
      FieldDeclaration fieldDeclaration,
      Element fieldElement,
    ) execute,
  ) =>
      this.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                fieldDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final Element? fieldElement = fieldDeclaration.declaredElement;
          if (fieldElement == null) {
            return;
          }

          execute(
            fieldDeclaration,
            fieldElement,
          );
        },
      );
}
