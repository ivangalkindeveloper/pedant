import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';

class AddBlocStateSealedRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocStateSealed == false) {
      return;
    }

    ruleList.add(
      AddBlocStateSealedRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocStateSealedRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_state_sealed",
            problemMessage: "Add BLoC State class sealed keyword",
            correctionMessage:
                "Please add 'sealed' keyword base State class of this BLoC.",
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
          print(typeArguments);
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
          if (stateElement.isSealed == true) {
            return;
          }

          reporter.atElement(
            stateElement,
            this.code,
          );
        },
      );
}
