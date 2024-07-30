import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_simple_identifier.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

class AddThisRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addOverride == false) {
      return;
    }

    ruleList.add(
      AddThisRule(
        priority: config.priority,
      ),
    );
  }

  const AddThisRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_this",
            problemMessage: "Pedant: Add 'this' keyword.",
            correctionMessage:
                "Please add 'this' keyword to this class field or method.",
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
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) =>
            classDeclaration.visitChildren(
          AstTreeVisitor(
            onSimpleIdentifier: (
              SimpleIdentifier simpleIdentifier,
            ) {
              if (simpleIdentifier.beginToken.previous?.previous?.type ==
                  Keyword.THIS) {
                return;
              }

              final FieldElement? fieldElement = classElement.getField(
                simpleIdentifier.name,
              );
              if (fieldElement == null) {
                return;
              }
              if (fieldElement.isStatic == true) {
                return;
              }
              if (fieldElement.enclosingElement == classElement) {
                return;
              }

              reporter.atNode(
                simpleIdentifier,
                this.code,
              );
            },
            onMethodInvocation: (
              MethodInvocation methodInvocation,
            ) {
              if (methodInvocation.beginToken.type == Keyword.THIS) {
                return;
              }

              final MethodElement? methodElement = classElement.getMethod(
                methodInvocation.methodName.name,
              );
              if (methodElement == null) {
                return;
              }
              if (methodElement.isStatic == true) {
                return;
              }
              if (methodElement.enclosingElement == classElement) {
                return;
              }

              reporter.atNode(
                methodInvocation,
                this.code,
              );
            },
          ),
        ),
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
    void createChangeBuilder() {
      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: "Pedant: Add 'this'",
        priority: this.priority,
      );
      changeBuilder.addDartFileEdit(
        (
          DartFileEditBuilder builder,
        ) =>
            builder.addSimpleInsertion(
          analysisError.sourceRange.offset,
          "this.",
        ),
      );
    }

    context.addClassIntersects(
      analysisError,
      (
        ClassDeclaration classDeclaration,
        ClassElement classElement,
      ) =>
          createChangeBuilder(),
    );
    context.addSimpleIdentifierIntersects(
      analysisError,
      (
        SimpleIdentifier simpleIdentifier,
      ) =>
          createChangeBuilder(),
    );
  }
}
