import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/validate/validate_const_initializer.dart';

class AddConstRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConst == false) {
      return;
    }

    ruleList.add(
      AddConstRule(
        priority: config.priority,
      ),
    );
  }

  const AddConstRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_const",
            problemMessage: "Pedant: Add const to this declaration.",
            correctionMessage:
                "Please add const keyword instead of final keyword to this variable, static field or instance declaration.",
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
    // Validate instance creation
    context.registry.addInstanceCreationExpression(
      (
        InstanceCreationExpression instanceCreationExpression,
      ) =>
          validateConstInstance(
        instanceCreationExpression: instanceCreationExpression,
        onSuccess: () => reporter.atNode(
          instanceCreationExpression,
          this.code,
        ),
      ),
    );

    // Validate top level variable
    context.registry.addTopLevelVariableDeclaration(
      (
        TopLevelVariableDeclaration topLevelVariableDeclaration,
      ) =>
          validateConstVariableList(
        variableList: topLevelVariableDeclaration.variables,
        onSuccess: () => reporter.atNode(
          topLevelVariableDeclaration,
          this.code,
        ),
      ),
    );

    // Validate static field
    context.registry.addFieldDeclaration(
      (
        FieldDeclaration fieldDeclaration,
      ) {
        if (fieldDeclaration.isStatic == false) {
          return;
        }

        validateConstVariableList(
          variableList: fieldDeclaration.fields,
          onSuccess: () => reporter.atNode(
            fieldDeclaration,
            this.code,
          ),
        );
      },
    );

    context.registry.addVariableDeclarationStatement(
      (
        VariableDeclarationStatement variableDeclarationStatement,
      ) =>
          validateConstVariableList(
        variableList: variableDeclarationStatement.variables,
        onSuccess: () => reporter.atNode(
          variableDeclarationStatement,
          this.code,
        ),
      ),
    );
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) {
    void createTopLevelAndStatementBuilder({
      required Token token,
    }) {
      if (token.type != Keyword.FINAL) {
        return;
      }

      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: "Pedant: Add const",
        priority: this.priority,
      );
      changeBuilder.addDartFileEdit(
        (
          DartFileEditBuilder builder,
        ) =>
            builder.addReplacement(
          token.sourceRange,
          (
            DartEditBuilder builder,
          ) =>
              builder.write(
            "const",
          ),
        ),
      );
    }

    context.registry.addInstanceCreationExpression(
      (
        InstanceCreationExpression instanceCreationExpression,
      ) {
        if (analysisError.sourceRange !=
            instanceCreationExpression.sourceRange) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add const",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addInsertion(
            instanceCreationExpression.offset,
            (
              DartEditBuilder builder,
            ) =>
                builder.write(
              "const ",
            ),
          ),
        );
      },
    );

    context.registry.addTopLevelVariableDeclaration(
      (
        TopLevelVariableDeclaration topLevelVariableDeclaration,
      ) {
        if (analysisError.sourceRange !=
            topLevelVariableDeclaration.sourceRange) {
          return;
        }

        createTopLevelAndStatementBuilder(
          token: topLevelVariableDeclaration.beginToken,
        );
      },
    );

    context.registry.addFieldDeclaration(
      (
        FieldDeclaration fieldDeclaration,
      ) {
        if (analysisError.sourceRange != fieldDeclaration.sourceRange) {
          return;
        }

        final Token? finalToken = fieldDeclaration.beginToken.next;
        if (finalToken == null) {
          return;
        }

        if (finalToken.type != Keyword.FINAL) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add const",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addReplacement(
            finalToken.sourceRange,
            (
              DartEditBuilder builder,
            ) =>
                builder.write(
              "const",
            ),
          ),
        );
      },
    );

    context.registry.addVariableDeclarationStatement(
      (
        VariableDeclarationStatement variableDeclarationStatement,
      ) {
        if (analysisError.sourceRange !=
            variableDeclarationStatement.sourceRange) {
          return;
        }

        createTopLevelAndStatementBuilder(
          token: variableDeclarationStatement.beginToken,
        );
      },
    );
  }
}
