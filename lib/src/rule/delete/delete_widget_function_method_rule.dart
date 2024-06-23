import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/extension/add_function.dart';
import 'package:pedant/src/utility/extension/add_method.dart';
import 'package:pedant/src/utility/tree_visitor.dart';
import 'package:pedant/src/utility/type_checker/widget_type_checker.dart';

class DeleteWidgetFunctionMethodRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteWidgetFunctionMethod == false) {
      return;
    }

    ruleList.add(
      DeleteWidgetFunctionMethodRule(
        priority: config.priority,
      ),
    );
  }

  const DeleteWidgetFunctionMethodRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "delete_widget_function_method",
            problemMessage: "Delete function or method returning a Widget",
            correctionMessage:
                "Please celete this function or method returning a Widget.",
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
    context.addFunction(
      (
        FunctionDeclaration functionDeclaration,
        ExecutableElement executableElement,
      ) {
        final Element? element = executableElement.returnType.element;
        if (element == null) {
          return;
        }

        if (widgetTypeChecker.isAssignableFrom(
              element,
            ) ==
            false) {
          return;
        }

        reporter.atNode(
          functionDeclaration,
          this.code,
        );
      },
    );
    context.addClass(
      (
        ClassDeclaration classDeclaration,
        ClassElement classElement,
      ) =>
          classDeclaration.visitChildren(
        TreeVisitor(
          onMethodDeclaration: (
            MethodDeclaration methodDeclaration,
          ) {
            final ExecutableElement? executableElement =
                methodDeclaration.declaredElement;
            if (executableElement == null) {
              return;
            }

            final Element? returnElement = executableElement.returnType.element;
            if (returnElement == null) {
              return;
            }

            if (widgetTypeChecker.isAssignableFrom(
                  returnElement,
                ) ==
                false) {
              return;
            }

            if (widgetTypeChecker.isAssignableFrom(
                      classElement,
                    ) ==
                    true &&
                executableElement.name == "build") {
              return;
            }

            reporter.atNode(
              methodDeclaration,
              this.code,
            );
          },
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
    AnalysisError analysisError,
    List<AnalysisError> others,
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
