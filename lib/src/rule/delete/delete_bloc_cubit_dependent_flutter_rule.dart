import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';
import 'package:pedant/src/utility/extension/add_field.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

// Bug: In example not all flutter properties will be deleted
class DeleteBlocCubitDependentFlutterRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteBlocCubitDependentFlutter == false) {
      return;
    }

    ruleList.add(
      DeleteBlocCubitDependentFlutterRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteBlocCubitDependentFlutterRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_bloc_cubit_dependent_flutter",
            problemMessage:
                "Delete Flutter resource dependency in current Bloc or Cubit.",
            correctionMessage:
                "Please delete this Flutter resource dependency.",
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
    context.addBloc(
      (
        ClassDeclaration blocDeclaration,
        ClassElement blocElement,
      ) =>
          _visitChildren(
        reporter: reporter,
        classDeclaration: blocDeclaration,
      ),
    );
    context.addCubit(
      (
        ClassDeclaration cubitDeclaration,
        ClassElement cubitElement,
      ) =>
          _visitChildren(
        reporter: reporter,
        classDeclaration: cubitDeclaration,
      ),
    );
  }

  void _visitChildren({
    required ErrorReporter reporter,
    required ClassDeclaration classDeclaration,
  }) =>
      classDeclaration.visitChildren(
        TreeVisitor(
          onConstructorDeclaration: (
            ConstructorDeclaration constructorDeclaration,
          ) {
            for (final FormalParameter parameter
                in constructorDeclaration.parameters.parameters) {
              final ParameterElement? parameterElement =
                  parameter.declaredElement;
              if (parameterElement == null) {
                continue;
              }

              this._validateAndReport(
                packageName: parameterElement.type.element?.library?.identifier,
                onSuccess: () => reporter.atElement(
                  parameterElement,
                  this.code,
                ),
              );
            }
          },
          onFieldDeclaration: (
            FieldDeclaration fieldDeclaration,
          ) {
            for (final VariableDeclaration variable
                in fieldDeclaration.fields.variables) {
              final VariableElement? parameterElement =
                  variable.declaredElement;
              if (parameterElement == null) {
                continue;
              }

              this._validateAndReport(
                packageName: parameterElement.type.element?.library?.identifier,
                onSuccess: () => reporter.atNode(
                  fieldDeclaration,
                  this.code,
                ),
              );
            }
          },
        ),
      );

  void _validateAndReport({
    required String? packageName,
    required void Function() onSuccess,
  }) {
    if (packageName == null) {
      return;
    }

    if (packageName.contains("package:flutter/") == false) {
      return;
    }

    onSuccess();
  }

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
  ) {
    context.addConstructorParameterIntersects(
      analysisError,
      (
        ConstructorDeclaration constructorDeclaration,
        FormalParameter formalParameter,
        ParameterElement parameterElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '${parameterElement.displayName}'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addDeletion(
            SourceRange(
              formalParameter.sourceRange.offset,
              formalParameter.endToken.next?.type == TokenType.COMMA
                  ? (formalParameter.sourceRange.length + 1)
                  : formalParameter.sourceRange.length,
            ),
          ),
        );
      },
    );
    context.addFieldVariableIntersects(
      analysisError,
      (
        FieldDeclaration fieldDeclaration,
        VariableElement variableElement,
      ) {
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Delete '${variableElement.displayName}'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addDeletion(
            analysisError.sourceRange,
          ),
        );
      },
    );
  }
}
