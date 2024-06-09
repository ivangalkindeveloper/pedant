import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';

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
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          for (final FieldElement field in classElement.fields) {
            if (field.isLate == true) {
              return;
            }
            if (field.isFinal == false) {
              return;
            }
          }

          for (final ConstructorElement constructorElement
              in classElement.constructors) {
            final ConstructorElement? superConstructor =
                constructorElement.superConstructor;
            if (superConstructor?.isConst == false) {
              continue;
            }

            if (constructorElement.isConst == true) {
              continue;
            }

            if (constructorElement.isFactory == true) {
              return;
            }

            reporter.atElement(
              constructorElement,
              this.code,
            );
          }
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
  ) =>
      context.addClassIntersects(
        analysisError,
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message:
                "Pedant: Add const to '${classElement.displayName}' constructor",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addInsertion(
              classElement.nameOffset,
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
