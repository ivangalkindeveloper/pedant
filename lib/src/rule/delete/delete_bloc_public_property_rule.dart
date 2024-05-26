import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

class DeleteBlocPublicPropertyRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteBlocPublicProperty == false) {
      return;
    }

    ruleList.add(
      DeleteBlocPublicPropertyRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteBlocPublicPropertyRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_bloc_public_property",
            problemMessage: "Delete public properties in Bloc.",
            correctionMessage:
                "Please change access to public preperties of Bloc or delete it.",
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

          node.visitChildren(
            TreeVisitor(
              onConstructorDeclaration: (
                ConstructorDeclaration node,
              ) {
                final ConstructorElement? declaredElement =
                    node.declaredElement;
                if (declaredElement == null) {
                  return;
                }

                for (final ParameterElement parameter
                    in declaredElement.parameters) {
                  if (parameter.isPrivate) {
                    continue;
                  }

                  if (parameter.isInitializingFormal == false) {
                    continue;
                  }

                  reporter.atElement(
                    parameter,
                    this.code,
                  );
                }
              },
              onFieldDeclaration: (
                FieldDeclaration node,
              ) {
                for (final VariableDeclaration variable
                    in node.fields.variables) {
                  final declaredElement = variable.declaredElement;
                  if (declaredElement == null) {
                    continue;
                  }

                  if (declaredElement.isPrivate) {
                    continue;
                  }

                  reporter.atElement(
                    declaredElement,
                    this.code,
                  );
                }
              },
            ),
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
  ) {
    context.registry.addFieldFormalParameter(
      (
        FieldFormalParameter node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ParameterElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        final String validName =
            "${declaredElement.type.getDisplayString()} ${declaredElement.displayName}";
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Rename to '$validName'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleReplacement(
            SourceRange(
              analysisError.offset - 5,
              analysisError.sourceRange.length + 5,
            ),
            validName,
          ),
        );
      },
    );
    context.registry.addVariableDeclaration(
      (
        VariableDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final VariableElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        final String validName = "_${declaredElement.displayName}";
        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Rename to '$validName'",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addSimpleReplacement(
            analysisError.sourceRange,
            validName,
          ),
        );
      },
    );
  }
}
