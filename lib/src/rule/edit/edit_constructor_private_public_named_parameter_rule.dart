import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';
import 'package:pedant/src/utility/fix_named_parameters.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

class EditConstructorPrivatePublicNamedParameterRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editContructorPrivateNamedParameter == true) {
      ruleList.add(
        EditConstructorPrivatePublicNamedParameterRule(
          validate: (
            ConstructorElement constructor,
          ) =>
              constructor.displayName.startsWith("_") == true,
          code: const LintCode(
            name: "edit_constructor_private_named_parameter",
            problemMessage:
                "Pedant: Edit private constructor parameters to maned.",
            correctionMessage:
                "Please edit all parameters of this private constructor to named.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
          priority: config.priority,
        ),
      );
    }

    if (config.editContructorPublicNamedParameter == true) {
      ruleList.add(
        EditConstructorPrivatePublicNamedParameterRule(
          validate: (
            ConstructorElement constructor,
          ) =>
              constructor.displayName.startsWith("_") == false,
          code: const LintCode(
            name: "edit_constructor_public_named_parameter",
            problemMessage:
                "Pedant: Edit public constructor parameters to maned.",
            correctionMessage:
                "Please edit all parameters of this public constructor to named.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
          priority: config.priority,
        ),
      );
    }
  }

  const EditConstructorPrivatePublicNamedParameterRule({
    required this.validate,
    required this.code,
    required this.priority,
  }) : super(
          code: code,
        );

  final bool Function(ConstructorElement) validate;
  final LintCode code;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addConstructor(
        (
          ConstructorDeclaration constructorDeclaration,
          ConstructorElement constructorElement,
        ) {
          if (validate(constructorElement) == false) {
            return;
          }

          for (final ParameterElement parameterElement
              in constructorElement.parameters) {
            if (parameterElement.isSuperFormal == true &&
                parameterElement.isRequired == false) {
              continue;
            }
            if (parameterElement.isNamed == true) {
              continue;
            }

            reporter.atElement(
              parameterElement,
              this.code,
            );
          }
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
      context.addConstructorElementIntersects(
        analysisError,
        (
          ConstructorDeclaration constructorDeclaration,
          ConstructorElement constructorElement,
        ) =>
            constructorDeclaration.visitChildren(
          AstTreeVisitor(
            onFormalParameterList: (
              FormalParameterList formalParameterList,
            ) {
              final NodeList<ConstructorInitializer> initializers =
                  constructorDeclaration.initializers;
              SourceRange? superRange;
              for (final ConstructorInitializer initializer in initializers) {
                if (initializer.toString().contains("super") == true) {
                  superRange = initializer.sourceRange;
                }
              }

              return fixNamedParameters(
                priority: priority,
                resolver: resolver,
                reporter: reporter,
                analysisError: analysisError,
                parameterList: constructorElement.parameters,
                range: SourceRange(
                  formalParameterList.beginToken.offset + 1,
                  formalParameterList.length - 2,
                ),
                superRange: superRange,
              );
            },
          ),
        ),
      );
}
