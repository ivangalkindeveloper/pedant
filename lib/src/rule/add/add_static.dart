import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class AddStaticRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addStatic == false) {
      return;
    }

    ruleList.add(
      AddStaticRule(
        priority: config.priority,
      ),
    );
  }

  const AddStaticRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_static",
            problemMessage: "Add static to this final field declaration",
            correctionMessage:
                "Please add static keyword tos this final initialized field declaration.",
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
      context.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          if (fieldDeclaration.isStatic == true) {
            return;
          }

          final VariableDeclarationList fields = fieldDeclaration.fields;

          if (fields.isFinal == false) {
            return;
          }

          for (final VariableDeclaration variableDeclaration
              in fields.variables) {
            final Expression? initializer = variableDeclaration.initializer;
            if (initializer == null) {
              return;
            }
          }

          reporter.atNode(
            fieldDeclaration,
            this.code,
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
  ) =>
      context.registry.addFieldDeclaration(
        (
          FieldDeclaration fieldDeclaration,
        ) {
          if (analysisError.sourceRange.intersects(
                fieldDeclaration.sourceRange,
              ) ==
              false) {
            return;
          }

          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Add static",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addInsertion(
              fieldDeclaration.sourceRange.offset,
              (
                DartEditBuilder builder,
              ) =>
                  builder.write(
                "static ",
              ),
            ),
          );
        },
      );
}
