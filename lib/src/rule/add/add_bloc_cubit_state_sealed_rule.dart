import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';

class AddBlocCubitStateSealedRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocCubitStateSealed == false) {
      return;
    }

    ruleList.add(
      AddBlocCubitStateSealedRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocCubitStateSealedRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_cubit_state_sealed",
            problemMessage:
                "Pedant: Add Bloc or Cubit State class sealed keyword.",
            correctionMessage:
                "Please add 'sealed' keyword to base State class of this Bloc or Cubit.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addBlocState(
      (
        ClassElement blocElement,
        ClassElement stateElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: blocElement,
        stateElement: stateElement,
      ),
    );
    context.addCubitState(
      (
        ClassElement cubitElement,
        ClassElement stateElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: cubitElement,
        stateElement: stateElement,
      ),
    );
  }

  void _validate({
    required ErrorReporter reporter,
    required ClassElement classElement,
    required ClassElement stateElement,
  }) {
    if (stateElement.isSealed == true) {
      return;
    }

    reporter.atElement(
      classElement,
      this.code,
    );
  }
}
