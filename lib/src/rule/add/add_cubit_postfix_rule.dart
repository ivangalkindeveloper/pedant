import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/type_checker/cubit_type_checkot.dart';
import 'package:pedant/src/utility/extension/add_class.dart';

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
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          if (cubitTypeChecker.isAssignableFrom(
                classElement,
              ) ==
              false) {
            return;
          }

          if (classElement.displayName.endsWith(
                "Cubit",
              ) ==
              true) {
            return;
          }

          reporter.atElement(
            classElement,
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
      context.addClassIntersects(
        analysisError,
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
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

              for (final ConstructorElement counstructorElement
                  in classElement.constructors) {
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
