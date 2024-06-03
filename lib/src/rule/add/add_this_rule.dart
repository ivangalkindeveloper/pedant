import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

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
            problemMessage: "Add this keyword",
            correctionMessage: "Please add 'this' keyword to this link.",
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
    // context.registry.addConstructorDeclaration(
    //   (
    //     ConstructorDeclaration node,
    //   ) {
    //     node.print("addSimpleIdentifier: ${node}");
    //   },
    // );
    context.registry.addClassDeclaration(
      (
        ClassDeclaration node,
      ) {
        node.visitChildren(
          _Visitor(),
        );

        final ClassElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        node.visitChildren(
          TreeVisitor(
            onSimpleIdentifier: (
              SimpleIdentifier node,
            ) {
              print(node);
            },
          ),
        );
      },
    );
  }
}

class _Visitor extends RecursiveAstVisitor {
  @override
  void visitBlockFunctionBody(BlockFunctionBody node) => print(
        "visitBlockFunctionBody: $node",
      );

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) => print(
        "visitExpressionFunctionBody: $node",
      );

  @override
  void visitNativeFunctionBody(NativeFunctionBody node) => print(
        "visitNativeFunctionBody: $node",
      );
}
