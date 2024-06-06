import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

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
            problemMessage: "Add variable, field of parameter type",
            correctionMessage:
                "Please add type to this variable, field or parameter.",
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
    context.registry.addConstructorDeclaration(
      (
        ConstructorDeclaration node,
      ) {
        final ConstructorElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        for (final ParameterElement parameterElement
            in declaredElement.parameters) {
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
    context.registry.addFunctionExpression(
      (
        FunctionExpression node,
      ) {
        final ExecutableElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        for (final ParameterElement parameterElement
            in declaredElement.parameters) {
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
    context.registry.addVariableDeclaration(
      (
        VariableDeclaration node,
      ) {
        final VariableElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        if (declaredElement.hasImplicitType == false) {
          return;
        }

        reporter.atElement(
          declaredElement,
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
    context.registry.addConstructorDeclaration(
      (
        ConstructorDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ConstructorElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        for (final ParameterElement parameterElement
            in declaredElement.parameters) {
          if (analysisError.offset != parameterElement.nameOffset) {
            continue;
          }

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
              "${parameterElement.type.getDisplayString()} ",
            ),
          );
        }
      },
    );
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
            "${declaredElement.type.getDisplayString()} ",
          ),
        );
      },
    );
    context.registry.addFunctionExpression(
      (
        FunctionExpression node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ExecutableElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        for (final ParameterElement parameterElement
            in declaredElement.parameters) {
          if (analysisError.offset != parameterElement.nameOffset) {
            continue;
          }

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
              "${parameterElement.type.getDisplayString()} ",
            ),
          );
        }
      },
    );
  }
}
