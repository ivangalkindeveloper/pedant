import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/type_checker/change_notifier_type_checker.dart';
import 'package:pedant/src/utility/type_checker/value_notifier_type_checker.dart';

class AddControllerPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addControllerPostfix == false) {
      return;
    }

    ruleList.add(
      AddControllerPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddControllerPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_controller_postfix",
            problemMessage: "Add Controller postfix",
            correctionMessage:
                "Please add postfix 'Controller' to this ChangeNotifier or ValueNotifier.",
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
          if (changeNotifierTypeChecker.isAssignableFrom(
                    classElement,
                  ) ==
                  false &&
              valueNotifierTypeChecker.isAssignableFrom(
                    classElement,
                  ) ==
                  false) {
            return;
          }

          if (classElement.displayName.endsWith(
                "Controller",
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
          final String validName = "${displayName}Controller";
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
