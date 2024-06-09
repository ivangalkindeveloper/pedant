import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_field.dart';
import 'package:pedant/src/utility/extension/add_method.dart';

class AddOverrideRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addOverride == false) {
      return;
    }

    ruleList.add(
      AddOverrideRule(
        priority: config.priority,
      ),
    );
  }

  const AddOverrideRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_override",
            problemMessage: "Add override annotation",
            correctionMessage:
                "Please add @override annotation to this field of method.",
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
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          for (final FieldElement field in classElement.fields) {
            if (field.hasOverride) {
              continue;
            }

            final PropertyAccessorElement? inheritedGetter =
                classElement.lookUpInheritedConcreteGetter(
              field.name,
              classElement.library,
            );

            if (inheritedGetter != null) {
              reporter.atElement(
                field,
                this.code,
              );
              continue;
            }

            final PropertyAccessorElement? inheritedSetter =
                classElement.lookUpInheritedConcreteSetter(
              field.name,
              classElement.library,
            );

            if (inheritedSetter == null) {
              continue;
            }

            reporter.atElement(
              field,
              this.code,
            );
          }

          for (final MethodElement method in classElement.methods) {
            if (method.hasOverride) {
              continue;
            }

            final MethodElement? inheritedMethod =
                classElement.lookUpInheritedConcreteMethod(
              method.name,
              classElement.library,
            );

            if (inheritedMethod == null) {
              continue;
            }

            reporter.atElement(
              method,
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
  ) {
    context.addFieldIntersects(
      analysisError,
      (
        FieldDeclaration fieldDeclaration,
        Element fieldElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            fieldDeclaration.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
    context.addMethodIntersects(
      analysisError,
      (
        MethodDeclaration methodDeclaration,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            methodDeclaration.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
  }
}
