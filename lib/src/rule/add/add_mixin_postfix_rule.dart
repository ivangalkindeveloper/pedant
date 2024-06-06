import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

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
      context.registry.addMixinDeclaration(
        (
          MixinDeclaration node,
        ) {
          final MixinElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (declaredElement.displayName.endsWith(
            "Mixin",
          )) {
            return;
          }

          reporter.atElement(
            declaredElement,
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
      context.registry.addMixinDeclaration(
        (
          MixinDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
                node.sourceRange,
              ) ==
              false) {
            return;
          }

          final MixinElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          final String displayName = declaredElement.displayName;
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
