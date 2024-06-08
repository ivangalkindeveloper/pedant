import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

class AddBlocStatePostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocStatePostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocStatePostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocStatePostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_state_postfix",
            problemMessage: "Add BLoC State postfix",
            correctionMessage: "Please add postfix 'State' to this BLoC State.",
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

          final DartType stateType = typeArguments[1];
          if (stateType.element is! ClassElement) {
            return;
          }

          final ClassElement stateElement = stateType.element as ClassElement;
          final String blocPackagePath =
              blocElement.source.fullName.split("lib").first;
          final String statePackagePath =
              stateElement.source.fullName.split("lib").first;
          if (blocPackagePath != statePackagePath) {
            return;
          }
          if (stateElement.displayName.endsWith(
            "State",
          )) {
            return;
          }

          reporter.atElement(
            stateElement,
            this.code,
          );
        },
      );
}
