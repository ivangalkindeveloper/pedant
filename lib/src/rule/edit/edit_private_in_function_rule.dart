import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

class EditPrivateInFunctionRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editPrivateInFunction == false) {
      return;
    }

    ruleList.add(
      EditPrivateInFunctionRule(
        priority: config.priority,
      ),
    );
  }

  const EditPrivateInFunctionRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_private_in_function",
            problemMessage:
                "Edit declaration of private variable inside function.",
            correctionMessage:
                "Please change this variable on public inside function.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addFunctionBody(
        (
          FunctionBody node,
        ) =>
            node.visitChildren(
          TreeVisitor(
            onVariableDeclaration: (
              VariableDeclaration node,
            ) {
              final VariableElement? declaredElement = node.declaredElement;
              if (declaredElement == null) {
                return;
              }

              if (declaredElement.isPrivate == false) {
                return;
              }

              reporter.atElement(
                declaredElement,
                this.code,
              );
            },
          ),
        ),
      );

  @override
  List<Fix> getFixes() => [
        _Fix(
          priority: this.priority,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.priority,
  });

  final int priority;

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

          final String validName = declaredElement.displayName.replaceFirst(
            "_",
            "",
          );
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Rename to '$validName'",
            priority: this.priority,
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
