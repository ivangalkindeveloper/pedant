import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class TestRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) =>
      ruleList.add(
        TestRule(),
      );

  const TestRule()
      : super(
          code: const LintCode(
            name: "test",
            problemMessage: "Test.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  List<String> get filesToAnalyze => const [
        "**.dart",
      ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // context.registry.addBlock((node) {
    //   print("addBlock");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addBlockFunctionBody((node) {
    //   print("addBlockFunctionBody");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addCombinator((node) {
    //   print("addCombinator");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addComment((node) {
    //   print("addCombinator");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addCommentReference((node) {
    //   print("addCommentReference");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addCompilationUnit((node) {
    //   print("addCompilationUnit");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addCompilationUnitMember((node) {
    //   print("addCompilationUnitMember");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConditionalExpression((node) {
    //   print("addConditionalExpression");
    //   print(node.toString());
    //   print("");
    // });

    // context.registry.addConstructorDeclaration((node) {
    //   print("addConstructorDeclaration");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConstructorFieldInitializer((node) {
    //   print("addConstructorFieldInitializer");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConstructorInitializer((node) {
    //   print("addConstructorInitializer");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConstructorName((node) {
    //   print("addConstructorName");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConstructorReference((node) {
    //   print("addConstructorReference");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addConstructorSelector((node) {
    //   print("addConstructorSelector");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addRedirectingConstructorInvocation((node) {
    //   print("addRedirectingConstructorInvocation");
    //   print(node.toString());
    //   print("");
    // });

    // context.registry.addClassDeclaration((node) {
    //   print("addClassDeclaration");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addClassMember((node) {
    //   print("addClassMember");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addClassTypeAlias((node) {
    //   print("addClassTypeAlias");
    //   print(node.toString());
    //   print("");
    // });

    // context.registry.addFunctionBody((node) {
    //   print("addFunctionBody");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionDeclaration((node) {
    //   print("addFunctionDeclaration");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionDeclarationStatement((node) {
    //   print("addFunctionDeclarationStatement");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionExpression((node) {
    //   print("addFunctionExpression");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionExpressionInvocation((node) {
    //   print("addFunctionExpressionInvocation");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionReference((node) {
    //   print("addFunctionReference");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionTypeAlias((node) {
    //   print("addFunctionTypeAlias");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionTypeAlias((node) {
    //   print("addFunctionTypeAlias");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addFunctionTypedFormalParameter((node) {
    //   print("addFunctionTypedFormalParameter");
    //   print(node.toString());
    //   print("");
    // });

    // context.registry.addMethodDeclaration((node) {
    //   print("addMethodDeclaration");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addMethodInvocation((node) {
    //   print("addMethodInvocation");
    //   print(node.toString());
    //   print("");
    // });

    // context.registry.addVariableDeclaration((node) {
    //   print("addVariableDeclaration");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addVariableDeclarationList((node) {
    //   print("addVariableDeclarationList");
    //   print(node.toString());
    //   print("");
    // });
    // context.registry.addVariableDeclarationStatement((node) {
    //   print("addVariableDeclarationStatement");
    //   print(node.toString());
    //   print("");
    // });
  }
}
