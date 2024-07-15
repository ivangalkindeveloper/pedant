import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_extension.dart';

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
            problemMessage: "Pedant: Add extension postfix.",
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
      context.addExtension(
        (
          ExtensionDeclaration extensionDeclaration,
          ExtensionElement extensionElement,
        ) {
          if (extensionElement.displayName.endsWith(
                "Extension",
              ) ==
              true) {
            return;
          }

          reporter.atElement(
            extensionElement,
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
      context.addExtensionIntersects(
        analysisError,
        (
          ExtensionDeclaration extensionDeclaration,
          ExtensionElement extensionElement,
        ) {
          final String displayName = extensionElement.displayName;
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
