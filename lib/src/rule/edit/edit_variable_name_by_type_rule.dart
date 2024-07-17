import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_variable.dart';
import 'package:pedant/src/utility/type_checker/edge_insets_type_checker.dart';
import 'package:pedant/src/utility/type_checker/widget_type_checker.dart';

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
          final Element? classElement = variableElement.type.element;
          if (classElement == null) {
            return;
          }

          final String? identifier = classElement.library?.identifier;
          if (identifier == null) {
            return;
          }
          if (identifier == "dart:core") {
            return;
          }

          // Widget - child
          if (widgetTypeChecker.isAssignableFrom(
                classElement,
              ) ==
              true) {
            return;
          }
          // EdgeIsets - padding
          if (edgeInsetsTypeChecker.isAssignableFrom(
                classElement,
              ) ==
              true) {
            return;
          }

          final String? typeName = classElement.name;
          if (typeName == null) {
            return;
          }

          final List<String> typeSplit = typeName
              .replaceAll(
                RegExp(r'[^A-Za-z]'),
                "",
              )
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
              .replaceAll(
                RegExp(r'[^A-Za-z]'),
                "",
              )
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
