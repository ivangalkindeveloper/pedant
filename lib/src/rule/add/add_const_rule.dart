import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

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
    context.registry.addInstanceCreationExpression(
      (
        InstanceCreationExpression instanceCreationExpression,
      ) =>
          this._validateInstance(
        instanceCreationExpression: instanceCreationExpression,
        onSuccess: () => reporter.atNode(
          instanceCreationExpression,
          this.code,
        ),
      ),
    );

    context.registry.addTopLevelVariableDeclaration(
      (
        TopLevelVariableDeclaration topLevelVariableDeclaration,
      ) =>
          this._validateVariableList(
        variableList: topLevelVariableDeclaration.variables,
        onSuccess: () => reporter.atNode(
          topLevelVariableDeclaration,
          this.code,
        ),
      ),
    );

    context.registry.addFieldDeclaration(
      (
        FieldDeclaration fieldDeclaration,
      ) {
        if (fieldDeclaration.isStatic == false) {
          return;
        }

        this._validateVariableList(
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
          this._validateVariableList(
        variableList: variableDeclarationStatement.variables,
        onSuccess: () => reporter.atNode(
          variableDeclarationStatement,
          this.code,
        ),
      ),
    );
  }

  void _validateVariableList({
    required VariableDeclarationList variableList,
    required void Function() onSuccess,
  }) {
    if (variableList.isConst == true) {
      return;
    }

    if (variableList.isLate == true) {
      return;
    }

    if (variableList.isFinal == false) {
      return;
    }

    for (final VariableDeclaration variableDeclaration
        in variableList.variables) {
      final Expression? initializer = variableDeclaration.initializer;

      if (initializer == null) {
        return;
      }

      this._checkExpressionChildren(
        expression: initializer,
        onSuccess: () {
          if (initializer is InstanceCreationExpression) {
            this._validateInstance(
              instanceCreationExpression: initializer,
              onSuccess: onSuccess,
            );
            return;
          }

          onSuccess();
        },
      );
    }
  }

  void _validateInstance({
    required InstanceCreationExpression instanceCreationExpression,
    required void Function() onSuccess,
  }) {
    if (instanceCreationExpression.isConst == true) {
      return;
    }

    if (instanceCreationExpression.inConstantContext == true) {
      return;
    }

    final ConstructorElement? staticElement =
        instanceCreationExpression.constructorName.staticElement;
    if (staticElement == null) {
      return;
    }

    if (staticElement.isConst == false) {
      return;
    }

    this._checkExpressionChildren(
      expression: instanceCreationExpression,
      onSuccess: onSuccess,
    );
  }

  void _checkExpressionChildren({
    required Expression expression,
    required void Function() onSuccess,
  }) {
    bool isConstInstanceCreationExpression = true;

    expression.visitChildren(
      TreeVisitor(
        onInstanceCreationExpression: (
          InstanceCreationExpression instanceCreationExpression,
        ) {
          final ConstructorElement? childrenStaticElement =
              instanceCreationExpression.constructorName.staticElement;

          if (childrenStaticElement == null) {
            isConstInstanceCreationExpression = false;
            return;
          }

          if (childrenStaticElement.isConst == false) {
            isConstInstanceCreationExpression = false;
            return;
          }
        },
        onSimpleIdentifier: (
          SimpleIdentifier simpleIdentifier,
        ) {
          final Element? staticElement = simpleIdentifier.staticElement;
          if (staticElement == null) {
            return;
          }

          if (staticElement is! PropertyAccessorElement) {
            return;
          }

          final PropertyInducingElement? variable2 = staticElement.variable2;
          if (variable2 == null) {
            isConstInstanceCreationExpression = false;
            return;
          }

          if (variable2.isConst == false) {
            isConstInstanceCreationExpression = false;
            return;
          }
        },
      ),
    );

    if (isConstInstanceCreationExpression == false) {
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
