import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
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
      context.registry.addClassDeclaration(
        (
          ClassDeclaration classDeclaration,
        ) {
          final ClassElement? classElement = classDeclaration.declaredElement;
          if (classElement == null) {
            return;
          }

          final List<ConstructorElement> constructors =
              classElement.constructors;
          if (constructors.isEmpty) {
            return;
          }

          bool hasDefaultConstructorDeclaration = false;

          classDeclaration.visitChildren(
            TreeVisitor(
              onConstructorDeclaration: (
                ConstructorDeclaration constructorDeclaration,
              ) {
                final ConstructorElement? constructorElement =
                    constructorDeclaration.declaredElement;
                if (constructorElement == null) {
                  return;
                }

                hasDefaultConstructorDeclaration =
                    constructors.first == constructorElement;
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
  ) {
    context.registry.addClassDeclaration(
      (
        ClassDeclaration node,
      ) {
        if (analysisError.sourceRange.intersects(
              node.sourceRange,
            ) ==
            false) {
          return;
        }

        final ClassElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
          message: "Pedant: Add '${declaredElement.displayName}' constructor",
          priority: this.priority,
        );
        changeBuilder.addDartFileEdit(
          (
            DartFileEditBuilder builder,
          ) =>
              builder.addInsertion(
            declaredElement.nameOffset + declaredElement.nameLength + 2,
            (
              DartEditBuilder builder,
            ) =>
                builder.writeConstructorDeclaration(
              declaredElement.name,
              isConst: true,
            ),
          ),
        );
      },
    );
  }
}
