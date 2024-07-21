import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

class AddCommaRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConstConstructor == false) {
      return;
    }

    ruleList.add(
      AddCommaRule(
        priority: config.priority,
      ),
    );
  }

  const AddCommaRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_comma",
            problemMessage: "Pedant: Add comma.",
            correctionMessage: "Please add comma to this place.",
            errorSeverity: ErrorSeverity.WARNING,
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
      ) {
        final NodeList<Expression> arguments =
            instanceCreationExpression.argumentList.arguments;
        if (arguments.isEmpty) {
          return;
        }

        final Expression lastArgument = arguments.last;
        final Token endToken = lastArgument.endToken;

        _validateAndReport(
          reporter: reporter,
          token: endToken.next,
        );
      },
    );

    context.registry.addFormalParameterList(
      (
        FormalParameterList formalParameterList,
      ) {
        final NodeList<FormalParameter> parameters =
            formalParameterList.parameters;
        if (parameters.isEmpty) {
          return;
        }

        final FormalParameter lastParameter = parameters.last;
        final Token endToken = lastParameter.endToken;

        _validateAndReport(
          reporter: reporter,
          token: endToken.next,
        );
      },
    );

    context.registry.addMethodInvocation(
      (
        MethodInvocation methodInvocation,
      ) {
        final NodeList<Expression> arguments =
            methodInvocation.argumentList.arguments;
        if (methodInvocation.argumentList.arguments.isEmpty) {
          return;
        }

        final Expression lastArgument = arguments.last;
        final Token endToken = lastArgument.endToken;

        _validateAndReport(
          reporter: reporter,
          token: endToken.next,
        );
      },
    );

    context.registry.addSuperConstructorInvocation(
      (
        SuperConstructorInvocation superConstructorInvocation,
      ) {
        final NodeList<Expression> arguments =
            superConstructorInvocation.argumentList.arguments;
        if (arguments.isEmpty) {
          return;
        }

        final Expression lastArgument = arguments.last;
        final Token endToken = lastArgument.endToken;

        _validateAndReport(
          reporter: reporter,
          token: endToken.next,
        );
      },
    );
  }

  void _validateAndReport({
    required ErrorReporter reporter,
    required Token? token,
  }) {
    if (token == null) {
      return;
    }
    if (token.type == TokenType.COMMA) {
      return;
    }

    reporter.atToken(
      token,
      this.code,
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
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
      message: "Pedant: Add comma",
      priority: this.priority,
    );
    changeBuilder.addDartFileEdit(
      (
        DartFileEditBuilder builder,
      ) {
        builder.addSimpleInsertion(
          analysisError.sourceRange.offset,
          ",",
        );
        builder.format(
          SourceRange(
            0,
            resolver.source.contents.data.length,
          ),
        );
      },
    );
  }
}
