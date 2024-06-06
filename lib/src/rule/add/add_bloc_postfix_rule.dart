import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

class AddBlocPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocPostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_postfix",
            problemMessage: "Add BLoC postfix",
            correctionMessage: "Please add postfix 'Bloc' to this BLoC.",
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

          if (blocTypeChecker.isAssignableFromType(
                declaredElement.thisType,
              ) ==
              false) {
            return;
          }

          if (declaredElement.displayName.endsWith(
            "Bloc",
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
          final String validName = "${displayName}Bloc";
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
