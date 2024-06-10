import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_class.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

class AddConstructorRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConstructor == false) {
      return;
    }

    ruleList.add(
      AddConstructorRule(
        priority: config.priority,
      ),
    );
  }

  const AddConstructorRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_constructor",
            problemMessage: "Add class constructor",
            correctionMessage:
                "Please add default constructor declaration to this class.",
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
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          bool hasDefaultConstructorDeclaration = false;

          classDeclaration.visitChildren(
            TreeVisitor(
              onConstructorDeclaration: (
                ConstructorDeclaration constructorDeclaration,
              ) {
                final ConstructorElement? constructorElement =
                    constructorDeclaration.declaredElement;
                hasDefaultConstructorDeclaration = constructorElement != null;
              },
            ),
          );

          if (hasDefaultConstructorDeclaration == true) {
            return;
          }

          reporter.atNode(
            classDeclaration,
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
      context.addClassIntersects(
        analysisError,
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Add '${classElement.displayName}' constructor",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addInsertion(
              classDeclaration.leftBracket.offset + 1,
              (
                DartEditBuilder builder,
              ) {
                builder.write("\n  ");
                builder.writeConstructorDeclaration(
                  classElement.name,
                );
                builder.write("\n");
              },
            ),
          );
        },
      );
}
