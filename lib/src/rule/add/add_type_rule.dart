import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/extension/add_function_expression.dart';
import 'package:pedant/src/utility/extension/add_variable.dart';

class AddTypeRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addType == false) {
      return;
    }

    ruleList.add(
      AddTypeRule(
        priority: config.priority,
      ),
    );
  }

  const AddTypeRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_type",
            problemMessage: "Pedant: Add variable, field of argument type.",
            correctionMessage:
                "Please add type to this variable, field or argument.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addConstructor(
      (
        ConstructorDeclaration constructorDeclaration,
        ConstructorElement constructorElement,
      ) {
        for (final ParameterElement parameterElement
            in constructorElement.parameters) {
          if (parameterElement.isSuperFormal == true) {
            continue;
          }
          if (parameterElement.isInitializingFormal == true) {
            continue;
          }
          if (parameterElement.hasImplicitType == false) {
            continue;
          }

          reporter.atElement(
            parameterElement,
            this.code,
          );
        }
      },
    );

    context.addFunctionExpression(
      (
        FunctionExpression functionExpression,
        ExecutableElement executableElement,
      ) {
        for (final ParameterElement parameterElement
            in executableElement.parameters) {
          if (parameterElement.hasImplicitType == false) {
            continue;
          }

          reporter.atElement(
            parameterElement,
            this.code,
          );
        }
      },
    );

    context.addVariable(
      (
        VariableDeclaration variableDeclaration,
        VariableElement variableElement,
      ) {
        if (variableElement.hasImplicitType == false) {
          return;
        }

        reporter.atElement(
          variableElement,
          this.code,
        );
      },
    );
  }

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
  ) {
    void createChangeBuilder({
      required DartType type,
    }) {
      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: "Pedant: Add type",
        priority: this.priority,
      );
      changeBuilder.addDartFileEdit(
        (
          DartFileEditBuilder builder,
        ) =>
            builder.addSimpleInsertion(
          analysisError.sourceRange.offset,
          "${type.getDisplayString()} ",
        ),
      );
    }

    context.addConstructorElementIntersects(
      analysisError,
      (
        ConstructorDeclaration constructorDeclaration,
        ConstructorElement constructorElement,
      ) {
        final List<ParameterElement> parameters = constructorElement.parameters;
        for (final ParameterElement parameterElement in parameters) {
          if (analysisError.offset != parameterElement.nameOffset) {
            continue;
          }

          createChangeBuilder(
            type: parameterElement.type,
          );
        }
      },
    );

    context.addFunctionExpressionIntersects(
      analysisError,
      (
        FunctionExpression functionExpression,
        ExecutableElement executableElement,
      ) {
        final List<ParameterElement> parameters = executableElement.parameters;
        for (final ParameterElement parameterElement in parameters) {
          if (analysisError.offset != parameterElement.nameOffset) {
            continue;
          }

          createChangeBuilder(
            type: parameterElement.type,
          );
        }
      },
    );

    context.addVariableIntersects(analysisError, (
      VariableDeclaration variableDeclaration,
      VariableElement variableElement,
    ) {
      if (analysisError.offset != variableElement.nameOffset) {
        return;
      }

      createChangeBuilder(
        type: variableElement.type,
      );
    });
  }
}
