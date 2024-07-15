import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_variable.dart';

class EditVariableNameByTypeRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editVariableNameByType == false) {
      return;
    }

    ruleList.add(
      EditVariableNameByTypeRule(
        priority: config.priority,
      ),
    );
  }

  const EditVariableNameByTypeRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_variable_name_by_type",
            problemMessage: "Pedant: Edit variable name relative to its type.",
            correctionMessage:
                "Please edit the variable name to include part of the name of its typing.",
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
      context.addVariable(
        (
          VariableDeclaration variableDeclaration,
          VariableElement variableElement,
        ) {
          final String? identifier =
              variableElement.type.element?.library?.identifier;
          if (identifier == null) {
            return;
          }
          if (identifier == "dart:core") {
            return;
          }

          final List<String> typeSplit = variableElement.type
              .getDisplayString()
              .split(
                RegExp(r'(?=[A-Z])'),
              )
              .map(
                (
                  String value,
                ) =>
                    value.toLowerCase(),
              )
              .toList();
          final List<String> variableSplit = variableElement.name
              .split(
                RegExp(r'(?=[A-Z])'),
              )
              .map(
                (
                  String value,
                ) =>
                    value.toLowerCase(),
              )
              .toList();

          for (final String variableSplitPart in variableSplit) {
            if (typeSplit.contains(variableSplitPart)) {
              return;
            }
          }

          reporter.atElement(
            variableElement,
            this.code,
          );
        },
      );
}
