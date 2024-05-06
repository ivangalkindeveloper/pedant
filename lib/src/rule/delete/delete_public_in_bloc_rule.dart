import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

//TODO Fix together Bloc constructor
class DeletePublicInBlocRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deletePublicInBloc == false) {
      return;
    }

    ruleList.add(
      const DeletePublicInBlocRule(),
    );
  }

  const DeletePublicInBlocRule()
      : super(
          code: const LintCode(
            name: "delete_public_in_bloc",
            problemMessage: "Delete public properties in Bloc.",
            correctionMessage:
                "Please change access to public preperties of Bloc or delete it.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFromType(
                declaredElement.thisType,
              ) ==
              false) {
            return;
          }

          node.visitChildren(
            TreeVisitor(
              onVariableDeclaration: (
                VariableDeclaration node,
              ) {
                final VariableElement? declaredElement = node.declaredElement;
                if (declaredElement == null) {
                  return;
                }

                if (declaredElement.isPrivate) {
                  return;
                }

                reporter.reportErrorForElement(
                  this.code,
                  declaredElement,
                );
              },
            ),
          );
        },
      );

  @override
  List<Fix> getFixes() => [
        _Fix(),
      ];
}

class _Fix extends DartFix {
  _Fix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) =>
      context.registry.addVariableDeclaration(
        (
          VariableDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final VariableElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          final String validName = "_${declaredElement.displayName}";
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Rename to '$validName'",
            priority: 0,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addSimpleReplacement(
              analysisError.sourceRange,
              validName,
            ),
          );
        },
      );
}
