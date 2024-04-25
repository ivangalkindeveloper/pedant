import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_suffix_list.dart';

class DeleteSuffixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteSuffix) {
      return;
    }

    final List<DeleteListItem> deleteList = config.deleteTypeList.isNotEmpty
        ? config.deleteSuffixList
        : defaultDeleteSuffixList;
    for (final DeleteListItem deleteListItem in deleteList) {
      ruleList.add(
        DeleteSuffixRule(
          deleteListItem: deleteListItem,
        ),
      );
    }
  }

  DeleteSuffixRule({
    required this.deleteListItem,
  }) : super(
          code: LintCode(
            name: "delete_suffix",
            problemMessage:
                "Сlass or variable name must not contain an ${deleteListItem.nameList.join("/")} suffix.",
            correctionMessage:
                "Please delete ${deleteListItem.nameList.join("/ ")} suffix in class or variable.",
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
      },
    );
    context.registry.addConstructorDeclaration(
      (
        ConstructorDeclaration node,
      ) {
        final ConstructorElement? declaredElement = node.declaredElement;
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
    context.registry.addConstructorName((
      ConstructorName node,
    ) {
      final ConstructorElement? staticElement = node.staticElement;
      if (staticElement == null) {
        return;
      }

      _checkAndReport(
        reporter: reporter,
        name: staticElement.displayName,
        element: staticElement,
      );
    });
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
  ) =>
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          if (analysisError.sourceRange.intersects(
            node.sourceRange,
          )) {
            final String validName = node.name.lexeme
                .replaceAll("Impl", "")
                .replaceAll("Implementation", "");
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Raname to '$validName'",
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
        },
      );
}
