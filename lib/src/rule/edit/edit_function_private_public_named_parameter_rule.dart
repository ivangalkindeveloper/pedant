import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_function.dart';
import 'package:pedant/src/utility/fix_named_parameters.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

class EditFunctionPrivatePublicNamedParameterRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editFunctionPrivateNamedParameter == true) {
      ruleList.add(
        EditFunctionPrivatePublicNamedParameterRule(
          validate: (
            ExecutableElement executableElement,
          ) =>
              executableElement.isPrivate == true,
          code: const LintCode(
            name: "edit_function_private_named_parameter",
            problemMessage:
                "Pedant: Edit private function parameters to named.",
            correctionMessage:
                "Please edit all parameters of this private function to named.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
          priority: config.priority,
        ),
      );
    }

    if (config.editFunctionPublicNamedParameter == true) {
      ruleList.add(
        EditFunctionPrivatePublicNamedParameterRule(
          validate: (
            ExecutableElement executableElement,
          ) =>
              executableElement.isPublic == true,
          code: const LintCode(
            name: "edit_function_public_named_parameter",
            problemMessage: "Pedant: Edit public function parameters to named.",
            correctionMessage:
                "Please edit all parameters of this public function to named.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
          priority: config.priority,
        ),
      );
    }
  }

  const EditFunctionPrivatePublicNamedParameterRule({
    required this.validate,
    required this.code,
    required this.priority,
  }) : super(
          code: code,
        );

  final bool Function(ExecutableElement) validate;
  final LintCode code;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addFunction(
        (
          FunctionDeclaration functionDeclaration,
          ExecutableElement executableElement,
        ) {
          if (validate(executableElement) == false) {
            return;
          }

          for (final ParameterElement parameterElement
              in executableElement.parameters) {
            if (parameterElement.isRequired == false) {
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
      context.addFunctionIntersects(
        analysisError,
        (
          FunctionDeclaration functionDeclaration,
          ExecutableElement executableElement,
        ) =>
            functionDeclaration.visitChildren(
          TreeVisitor(
            onFormalParameterList: (
              FormalParameterList formalParameterList,
            ) =>
                fixNamedParameters(
              reporter: reporter,
              analysisError: analysisError,
              priority: priority,
              parameterList: executableElement.parameters,
              range: SourceRange(
                formalParameterList.beginToken.offset + 1,
                formalParameterList.length - 2,
              ),
            ),
          ),
        ),
      );
}
