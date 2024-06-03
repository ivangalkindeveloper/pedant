import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          for (final FieldElement field in declaredElement.fields) {
            if (field.hasOverride) {
              continue;
            }

            final PropertyAccessorElement? inheritedGetter =
                declaredElement.lookUpInheritedConcreteGetter(
              field.name,
              declaredElement.library,
            );

            if (inheritedGetter != null) {
              reporter.atElement(
                field,
                this.code,
              );
              continue;
            }

            final PropertyAccessorElement? inheritedSetter =
                declaredElement.lookUpInheritedConcreteSetter(
              field.name,
              declaredElement.library,
            );

            if (inheritedSetter == null) {
              continue;
            }

            reporter.atElement(
              field,
              this.code,
            );
          }

          for (final MethodElement method in declaredElement.methods) {
            if (method.hasOverride) {
              continue;
            }

            final MethodElement? inheritedMethod =
                declaredElement.lookUpInheritedConcreteMethod(
              method.name,
              declaredElement.library,
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
    context.registry.addFieldDeclaration(
      (
        FieldDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            node.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
    context.registry.addMethodDeclaration(
      (
        MethodDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add @override annotation",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleInsertion(
            node.sourceRange.offset,
            "@override\n  ",
          ),
        );
      },
    );
  }
}
