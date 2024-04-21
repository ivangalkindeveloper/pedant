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
  }
}
