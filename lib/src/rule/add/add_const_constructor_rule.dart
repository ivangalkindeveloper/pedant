import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

class AddConstConstructorRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConstConstructor == false) {
      return;
    }

    ruleList.add(
      AddConstConstructorRule(
        priority: config.priority,
      ),
    );
  }

  const AddConstConstructorRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_const_constructor",
            problemMessage: "Add const constructor",
            correctionMessage:
                "Please add const keyword to default constructor of this class.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addConstructorDeclaration(
        (
          ConstructorDeclaration node,
        ) {
          final ConstructorElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (declaredElement.isConst == true) {
            return;
          }

          for (final parameter in declaredElement.parameters) {
            if (parameter.isFinal == false) {
              return;
            }
          }

          reporter.atElement(
            declaredElement,
            this.code,
          );
        },
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

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message:
              "Pedant: Add const to '${declaredElement.displayName}' constructor",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addInsertion(
            node.offset,
            (
              DartEditBuilder builder,
            ) =>
                builder.write(
              "const ",
            ),
          ),
        );
      },
    );
  }
}
