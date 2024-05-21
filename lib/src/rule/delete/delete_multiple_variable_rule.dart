import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

class DeleteMultipleVariableRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteMultipleVariable == false) {
      return;
    }

    ruleList.add(
      DeleteMultipleVariableRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteMultipleVariableRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_multiple_variable",
            problemMessage: "Delete multiple variable declarations.",
            correctionMessage: "Please delete multiple variable declarations.",
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
      context.registry.addVariableDeclarationList(
        (
          VariableDeclarationList node,
        ) {
          final NodeList<VariableDeclaration> variables = node.variables;
          if (variables.length == 1) {
            return;
          }

          reporter.atNode(
            node,
            this.code,
          );
        },
      );

  @override
  List<Fix> getFixes() => [
        _Fix(
          priority: priority,
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
      context.registry.addVariableDeclarationList(
        (
          VariableDeclarationList node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Split variable declarations",
            priority: priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) {
              final String contentData = resolver.source.contents.data;
              if (contentData[node.sourceRange.end] == ";") {
                builder.addDeletion(
                  SourceRange(
                    node.sourceRange.end,
                    1,
                  ),
                );
              }

              builder.addReplacement(
                node.sourceRange,
                (
                  DartEditBuilder builder,
                ) {
                  for (final VariableDeclaration variable in node.variables) {
                    final VariableElement? declaredElement =
                        variable.declaredElement;
                    if (declaredElement == null) {
                      continue;
                    }

                    builder.writeLocalVariableDeclaration(
                      declaredElement.name,
                      initializerWriter: variable.initializer != null
                          ? () => builder.write(
                                variable.initializer!.toSource(),
                              )
                          : null,
                      isConst: declaredElement.isConst,
                      isFinal: declaredElement.isFinal,
                      type: declaredElement.type,
                    );
                  }
                },
              );
            },
          );
        },
      );
}
