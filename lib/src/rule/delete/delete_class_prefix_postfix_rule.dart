import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_class_postfix_list.dart';

class DeleteClassPrefixPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<DeleteListItem>? deleteClassPrefixList =
        config.deleteClassPrefixList;
    if (deleteClassPrefixList != null) {
      for (final DeleteListItem deleteListItem in deleteClassPrefixList) {
        ruleList.add(
          DeleteClassPrefixPostfixRule(
            code: LintCode(
              name: "delete_class_prefix",
              problemMessage:
                  "Сlass name must not contain an prefix: ${deleteListItem.nameList.join(", ")}.",
              correctionMessage: "Please delete prefix in class.",
              errorSeverity: ErrorSeverity.ERROR,
            ),
            deleteListItem: deleteListItem,
            validaton: (
              final String name,
              final String prefix,
            ) =>
                name.startsWith(
              prefix,
            ),
            priority: config.priority,
          ),
        );
      }
    }

    final List<DeleteListItem> deleteClassPostfixList =
        config.deleteClassPostfixList ?? defaultDeleteClassPostfixList;
    for (final DeleteListItem deleteListItem in deleteClassPostfixList) {
      ruleList.add(
        DeleteClassPrefixPostfixRule(
          code: LintCode(
            name: "delete_class_postfix",
            problemMessage:
                "Сlass name must not contain an postfix: ${deleteListItem.nameList.join(", ")}.",
            correctionMessage: "Please delete postfix in class.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
          deleteListItem: deleteListItem,
          validaton: (
            final String name,
            final String postfix,
          ) =>
              name.endsWith(
            postfix,
          ),
          priority: config.priority,
        ),
      );
    }
  }

  const DeleteClassPrefixPostfixRule({
    required super.code,
    required this.deleteListItem,
    required this.validaton,
    required this.priority,
  });

  final DeleteListItem deleteListItem;
  final bool Function(String, String) validaton;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
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

          for (final ConstructorElement constructorElement
              in declaredElement.constructors) {
            _validate(
              name: constructorElement.displayName,
              onSuccess: () => reporter.atElement(
                constructorElement,
                this.code,
              ),
            );
          }
        },
      );

  void _validate({
    required String name,
    required void Function() onSuccess,
  }) {
    bool isMatch = false;
    for (final String matchName in deleteListItem.nameList) {
      if (this.validaton(
        name,
        matchName,
      )) {
        isMatch = true;
      }
    }

    if (isMatch) {
      onSuccess();
    }
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

          this._createChangeBuilder(
            reporter: reporter,
            analysisError: analysisError,
            name: declaredElement.displayName,
          );
        },
      );

  String _getValidName({
    required AnalysisError analysisError,
    required String name,
  }) {
    final List<String> postfixList = analysisError.message
        .split(":")[1]
        .trim()
        .replaceAll(
          ".",
          "",
        )
        .split(", ");
    postfixList.sort(
      (
        String a,
        String b,
      ) =>
          b.length.compareTo(
        a.length,
      ),
    );
    String validName = name;
    for (final String postfix in postfixList) {
      validName = validName.replaceAll(
        postfix,
        "",
      );
    }

    return validName;
  }

  void _createChangeBuilder({
    required ChangeReporter reporter,
    required AnalysisError analysisError,
    required String name,
  }) {
    final String validName = this._getValidName(
      analysisError: analysisError,
      name: name,
    );
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
  }
}
