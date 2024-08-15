import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFieldFormalParameter(
    void Function(
      FieldFormalParameter fieldFormalParameter,
      ParameterElement fieldElement,
    ) execute,
  ) =>
      this.registry.addFieldFormalParameter(
        (
          FieldFormalParameter fieldFormalParameter,
        ) {
          final ParameterElement? parameterElement =
              fieldFormalParameter.declaredElement;
          if (parameterElement == null) {
            return;
          }

          execute(
            fieldFormalParameter,
            parameterElement,
          );
        },
      );

  void addFieldFormalParameterIntersects(
    error.AnalysisError analysisError,
    void Function(
      FieldFormalParameter fieldFormalParameter,
      ParameterElement fieldElement,
    ) execute,
  ) =>
      this.registry.addFieldFormalParameter(
        (
          FieldFormalParameter fieldFormalParameter,
        ) {
          if (analysisError.sourceRange.intersects(
                fieldFormalParameter.sourceRange,
              ) ==
              false) {
            return;
          }

          final ParameterElement? parameterElement =
              fieldFormalParameter.declaredElement;
          if (parameterElement == null) {
            return;
          }

          execute(
            fieldFormalParameter,
            parameterElement,
          );
        },
      );
}
