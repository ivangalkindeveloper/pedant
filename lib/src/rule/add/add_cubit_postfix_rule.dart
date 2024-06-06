import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/cubit_type_checkot.dart';

class AddCubitPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addCubitPostfix == false) {
      return;
    }

    ruleList.add(
      AddCubitPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddCubitPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_cubit_postfix",
            problemMessage: "Add Cubit postfix",
            correctionMessage: "Please add postfix 'Cubit' to this Cubit.",
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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (cubitTypeChecker.isAssignableFromType(
                declaredElement.thisType,
              ) ==
              false) {
            return;
          }

          if (declaredElement.displayName.endsWith(
            "Cubit",
          )) {
            return;
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
  ) =>
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final ClassElement? classElement = node.declaredElement;
          if (classElement == null) {
            return;
          }

          final String displayName = classElement.displayName;
          final String validName = "${displayName}Cubit";
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Rename to '$validName'",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) {
              builder.addSimpleReplacement(
                analysisError.sourceRange,
                validName,
              );

              for (final counstructorElement in classElement.constructors) {
                builder.addSimpleReplacement(
                  SourceRange(
                    counstructorElement.nameOffset,
                    counstructorElement.nameLength,
                  ),
                  validName,
                );
              }
            },
          );
        },
      );
}
