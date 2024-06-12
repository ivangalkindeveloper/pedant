import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

extension CustomLintContextExtension on CustomLintContext {
  void addFormalParameterListIntersects(
    AnalysisError analysisError,
    void Function(
      FormalParameterList formalParameterList,
    ) execute,
  ) =>
      this.registry.addFormalParameterList(
        (
          FormalParameterList formalParameterList,
        ) {
          if (analysisError.sourceRange.intersects(
                formalParameterList.sourceRange,
              ) ==
              false) {
            return;
          }

          execute(
            formalParameterList,
          );
        },
      );
}
