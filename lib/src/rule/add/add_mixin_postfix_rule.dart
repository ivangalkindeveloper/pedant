import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_mixin.dart';

class AddMixinPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addExtensionPostfix == false) {
      return;
    }

    ruleList.add(
      AddMixinPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddMixinPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_mixin_postfix",
            problemMessage: "Add mixin postfix",
            correctionMessage: "Please add postfix 'Mixin' to this mixin.",
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
      context.addMixin(
        (
          MixinDeclaration extensionDeclaration,
          MixinElement extensionElement,
        ) {
          if (extensionElement.displayName.endsWith(
                "Mixin",
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
      context.addMixinIntersects(
        analysisError,
        (
          MixinDeclaration extensionDeclaration,
          MixinElement extensionElement,
        ) {
          final String displayName = extensionElement.displayName;
          final String validName = "${displayName}Mixin";
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
