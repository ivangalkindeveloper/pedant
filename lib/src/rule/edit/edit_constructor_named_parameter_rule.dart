import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_constructor.dart';

class EditConstructorNamedParameterRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.editContructorNamedParameter == false) {
      return;
    }

    ruleList.add(
      EditConstructorNamedParameterRule(
        priority: config.priority,
      ),
    );
  }

  const EditConstructorNamedParameterRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_constructor_named_parameter",
            problemMessage: "Edit constructor parameters to maned",
            correctionMessage:
                "Please edit all parameters of this constructor to named.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

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
          for (final ParameterElement parameterElement
              in constructorElement.parameters) {
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
      context.addConstructorIntersects(
        analysisError,
        (
          ConstructorDeclaration constructorDeclaration,
          ConstructorElement constructorElement,
        ) {
          final int parametersLength = constructorElement.parameters.length;
          for (int index = 0; index < parametersLength; index++) {
            final ParameterElement parameterElement =
                constructorElement.parameters[index];

            if (analysisError.offset != parameterElement.nameOffset) {
              continue;
            }

            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message:
                  "Pedant: Edit '${parameterElement.displayName}' to named parameter",
              priority: this.priority,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) {
                final SourceRange sourceRange = analysisError.sourceRange;
                final int offset = analysisError.sourceRange.offset;

                // Add bracet of ends parameters
                if (index == 0) {
                  builder.addSimpleInsertion(
                    constructorElement.nameOffset +
                        constructorElement.nameLength +
                        1,
                    "{",
                  );
                }
                if (index == (parametersLength - 1)) {
                  builder.addSimpleInsertion(
                    constructorDeclaration.endToken.offset - 1,
                    "}",
                  );
                }

                // Delete bracet of next named parameter
                final bool isNextPrameterNamed = index != (parametersLength - 1)
                    ? constructorElement.parameters[index + 1].isNamed
                    : false;
                if (isNextPrameterNamed) {
                  builder.addDeletion(
                    SourceRange(
                      offset + parameterElement.nameLength + 2,
                      1,
                    ),
                  );
                }

                // Delete all type and formal keywords
                if (parameterElement.isInitializingFormal == true) {
                  builder.addDeletion(
                    SourceRange(
                      offset - 5,
                      5,
                    ),
                  );
                } else {
                  final int typeLength =
                      (parameterElement.type.getDisplayString().length + 1);
                  builder.addDeletion(
                    SourceRange(
                      offset - typeLength,
                      typeLength,
                    ),
                  );
                }

                // Write new string
                builder.addReplacement(
                  sourceRange,
                  (
                    DartEditBuilder builder,
                  ) {
                    if (parameterElement.type.nullabilitySuffix !=
                        NullabilitySuffix.question) {
                      builder.write(
                        "required ",
                      );
                    }
                    if (parameterElement.isInitializingFormal == true) {
                      builder.write(
                        "this.",
                      );
                    } else {
                      builder.write(
                        "${parameterElement.getDisplayString()} ",
                      );
                    }

                    builder.write(
                      parameterElement.name,
                    );
                  },
                );
              },
            );
          }
        },
      );
}
