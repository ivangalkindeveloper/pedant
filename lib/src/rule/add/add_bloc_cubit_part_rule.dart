import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';

class AddBlocCubitPartRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocCubitPart == false) {
      return;
    }

    ruleList.add(
      AddBlocCubitPartRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocCubitPartRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_cubit_part",
            problemMessage:
                "Add Bloc or Cubit Event and State classes via part/part of",
            correctionMessage:
                "Please add Event and State classes to this Bloc State via part/part of.",
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
