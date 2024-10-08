import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_function.dart';
import 'package:pedant/src/utility/extension/add_method.dart';
import 'package:pedant/src/utility/type_checker/state_type_checker.dart';
import 'package:pedant/src/utility/type_checker/widget_type_checker.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

class DeleteWidgetMethodRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteWidgetMethod == false) {
      return;
    }

    ruleList.add(
      DeleteWidgetMethodRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteWidgetMethodRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_widget_method",
            problemMessage:
                "Pedant: Delete method returning a Widget in StatelessWidget, StatefulWidget or State.",
            correctionMessage:
                "Please celete this method returning a Widget in StatelessWidget, StatefulWidget or State.",
            errorSeverity: error.ErrorSeverity.ERROR,
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
        ) {
          if (widgetTypeChecker.isAssignableFrom(
                    classElement,
                  ) ==
                  false &&
              stateTypeChecker.isAssignableFrom(
                    classElement,
                  ) ==
                  false) {
            return;
          }

          classDeclaration.visitChildren(
            AstTreeVisitor(
              onMethodDeclaration: (
                MethodDeclaration methodDeclaration,
              ) {
                final ExecutableElement? executableElement =
                    methodDeclaration.declaredElement;
                if (executableElement == null) {
                  return;
                }
                if (executableElement.name == "build") {
                  return;
                }

                final Element? returnElement =
                    executableElement.returnType.element;
                if (returnElement == null) {
                  return;
                }
                if (widgetTypeChecker.isAssignableFrom(
                      returnElement,
                    ) ==
                    false) {
                  return;
                }

                reporter.atNode(
                  methodDeclaration,
                  this.code,
                );
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) {
    void createChangeBuilder({
      required String name,
    }) {
      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: "Pedant: Delete '$name'",
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
    }

    context.addFunctionIntersects(
      analysisError,
      (
        FunctionDeclaration functionDeclaration,
        ExecutableElement executableElement,
      ) =>
          createChangeBuilder(
        name: executableElement.name,
      ),
    );
    context.addMethodIntersects(
      analysisError,
      (
        MethodDeclaration methodDeclaration,
        ExecutableElement executableElement,
      ) =>
          createChangeBuilder(
        name: executableElement.name,
      ),
    );
  }
}
