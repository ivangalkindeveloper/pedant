import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class AddExtensionPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addExtensionPostfix == false) {
      return;
    }

    ruleList.add(
      AddExtensionPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddExtensionPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_extension_postfix",
            problemMessage: "Add extension postfix",
            correctionMessage:
                "Please add postfix 'Extension' to this extension.",
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
      context.registry.addExtensionDeclaration(
        (
          ExtensionDeclaration node,
        ) {
          final ExtensionElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          _validate(
            name: declaredElement.displayName,
            onSuccess: () => reporter.atElement(
              declaredElement,
              this.code,
            ),
          );
        },
      );

  void _validate({
    required String name,
    required void Function() onSuccess,
  }) {
    if (name.endsWith(
      "Extension",
    )) {
      return;
    }

    onSuccess();
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
  ) =>
      context.registry.addExtensionDeclaration(
        (
          ExtensionDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final ExtensionElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          final String displayName = declaredElement.displayName;
          final String validName = "${displayName}Extension";
          final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
            message: "Pedant: Rename to '$validName'",
            priority: this.priority,
          );
          changeBuilder.addDartFileEdit(
            (
              DartFileEditBuilder builder,
            ) =>
                builder.addSimpleReplacement(
              analysisError.sourceRange,
              validName,
            ),
          );
        },
      );
}
