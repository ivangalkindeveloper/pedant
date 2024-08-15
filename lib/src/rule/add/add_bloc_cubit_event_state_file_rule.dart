import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';

class AddBlocCubitEventStateFileRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocCubitEventStateFile == false) {
      return;
    }

    ruleList.add(
      AddBlocCubitEventStateFileRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocCubitEventStateFileRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_cubit_event_state_file",
            problemMessage:
                "Pedant: Add Bloc or Cubit Event and State classes in this file or via part/part of.",
            correctionMessage:
                "Please add Event and State classes to this same Bloc or Cubit file or via part/part of.",
            errorSeverity: error.ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addBlocEvent(
      (
        ClassElement blocElement,
        ClassElement eventElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: blocElement,
        typeClassElement: eventElement,
      ),
    );
    context.addBlocState(
      (
        ClassElement blocElement,
        ClassElement stateElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: blocElement,
        typeClassElement: stateElement,
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
        typeClassElement: stateElement,
      ),
    );
  }

  void _validate({
    required ErrorReporter reporter,
    required ClassElement classElement,
    required ClassElement typeClassElement,
  }) {
    if (classElement.librarySource == typeClassElement.librarySource) {
      return;
    }

    reporter.atElement(
      classElement,
      this.code,
    );
  }
}
