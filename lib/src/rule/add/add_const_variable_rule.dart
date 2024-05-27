// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/ast/token.dart';
// import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
// import 'package:pedant/src/utility/tree_visitor.dart';

class AddConstVariableRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addConstVariable == false) {
      return;
    }

    ruleList.add(
      AddConstVariableRule(
        priority: config.priority,
      ),
    );
  }

  const AddConstVariableRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_const_variable",
            problemMessage: "Add const variable",
            correctionMessage: "Please add const keyword to this variable.",
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
    // context.registry.addVariableDeclaration(
    //   (
    //     VariableDeclaration node,
    //   ) {
    //     final VariableElement? declaredElement = node.declaredElement;
    //     if (declaredElement == null) {
    //       return;
    //     }

    //     if (declaredElement.isConst) {
    //       return;
    //     }

    //     print(node);
    //     print(node.initializer?.);

    //     node.visitChildren(
    //       TreeVisitor(
    //         onInstanceCreationExpression: (
    //           InstanceCreationExpression node,
    //         ) {
    //           print(node);
    //           print(node.argumentList.arguments);
    //           for (final argument in node.argumentList.arguments) {
    //             print(argument);
    //           }
    //           print("");
    //         },
    //       ),
    //     );
    //   },
    // );
  }

  // void _validateAndReport({
  //   required VariableDeclarationList node,
  //   required void Function() onSuccess,
  // }) {
  //   if (node.isConst == true) {
  //     return;
  //   }

  //   if (node.isFinal == false) {
  //     return;
  //   }

  //   for (final variable in node.variables) {
  //     if (variable.isConst == true) {
  //       continue;
  //     }

  //     final Expression? initializer = variable.initializer;
  //     print("Initializer: ${initializer.toString()}");
  //     if (initializer == null) {
  //       continue;
  //     }

  //     print("initializer.inConstantContext: ${initializer.inConstantContext}");
  //     if (initializer.inConstantContext) {
  //       continue;
  //     }

  //     onSuccess();
  //   }
  // }
}
