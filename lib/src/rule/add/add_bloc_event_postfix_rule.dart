import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

class AddBlocEventPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocEventPostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocEventPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocEventPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_event_postfix",
            problemMessage: "Add BLoC Event postfix",
            correctionMessage: "Please add postfix 'Event' to this BLoC Event.",
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
          final ClassElement? blocElement = node.declaredElement;
          if (blocElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFrom(
                blocElement,
              ) ==
              false) {
            return;
          }

          final InterfaceType? supertype = blocElement.supertype;
          if (supertype == null) {
            return;
          }

          final List<DartType> typeArguments = supertype.typeArguments;
          if (typeArguments.length != 2) {
            return;
          }

          final DartType eventType = typeArguments.first;
          if (eventType.element is! ClassElement) {
            return;
          }

          final ClassElement eventElement = eventType.element as ClassElement;
          final String blocPackagePath =
              blocElement.source.fullName.split("lib").first;
          final String eventPackagePath =
              eventElement.source.fullName.split("lib").first;
          if (blocPackagePath != eventPackagePath) {
            return;
          }
          if (eventElement.displayName.endsWith(
            "Event",
          )) {
            return;
          }

          reporter.atElement(
            eventElement,
            this.code,
          );
        },
      );
}
