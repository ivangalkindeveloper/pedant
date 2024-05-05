import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_postfix_list.dart';

class DeletePostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<DeleteListItem> deletePostfixList =
        config.deletePostfixList ?? defaultDeletePostfixList;
    for (final DeleteListItem deleteListItem in deletePostfixList) {
      ruleList.add(
        DeletePostfixRule(
          deleteListItem: deleteListItem,
        ),
      );
    }
  }

  DeletePostfixRule({
    required this.deleteListItem,
  }) : super(
          code: LintCode(
            name: "delete_postfix",
            problemMessage:
                "Сlass, constructor or variable name must not contain an postfix: ${deleteListItem.nameList.join(", ")}.",
            correctionMessage:
                "Please delete postfix in class, constructor or variable.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final DeleteListItem deleteListItem;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration(
      (
        ClassDeclaration node,
      ) {
        final ClassElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        _checkAndReport(
          reporter: reporter,
          name: declaredElement.displayName,
          element: declaredElement,
        );

        for (final ConstructorElement constructorElement
            in declaredElement.constructors) {
          _checkAndReport(
            reporter: reporter,
            name: constructorElement.displayName,
            element: constructorElement,
          );
        }
      },
    );
    context.registry.addVariableDeclaration(
      (
        VariableDeclaration node,
      ) {
        final VariableElement? declaredElement = node.declaredElement;
        if (declaredElement == null) {
          return;
        }

        _checkAndReport(
          reporter: reporter,
          name: declaredElement.displayName,
          element: declaredElement,
        );
      },
    );
  }

  void _checkAndReport({
    required ErrorReporter reporter,
    required String name,
    required Element element,
  }) {
    bool isMatch = false;
    for (final String suffix in deleteListItem.nameList) {
      if (name.endsWith(suffix)) {
        isMatch = true;
      }
    }

    if (isMatch) {
      reporter.reportErrorForElement(
        this.code,
        element,
      );
    }
  }

  @override
  List<Fix> getFixes() => [
        _Fix(),
      ];
}

class _Fix extends DartFix {
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
        if (!analysisError.sourceRange.intersects(
          node.sourceRange,
        )) {
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
    context.registry.addVariableDeclaration(
      (
        VariableDeclaration node,
      ) {
        if (!analysisError.sourceRange.intersects(
          node.sourceRange,
        )) {
          return;
        }
        final VariableElement? declaredElement = node.declaredElement;
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
  }

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
      message: "Rename to '$validName'",
      priority: 0,
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
