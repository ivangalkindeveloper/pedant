import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_variable.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

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
                "Pedant: Edit declaration of private variable inside function.",
            correctionMessage:
                "Please change this variable on public inside function.",
            errorSeverity: error.ErrorSeverity.WARNING,
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
          AstTreeVisitor(
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) =>
      context.addVariableIntersects(
        analysisError,
        (
          VariableDeclaration variableDeclaration,
          VariableElement variableElement,
        ) {
          final String validName = variableElement.displayName.replaceFirst(
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
