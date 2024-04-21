import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_function_list.dart';

class DeleteFunctionRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteFunction) {
      return;
    }

    final List<DeleteListItem> list = config.deletePackageList.isNotEmpty
        ? config.deletePackageList
        : defaultDeleteFunctionList;
    for (final DeleteListItem deleteListItem in list) {
      ruleList.add(
        DeleteFunctionRule(
          deleteListItem: deleteListItem,
        ),
      );
    }
  }

  DeleteFunctionRule({
    required this.deleteListItem,
  }) : super(
          code: LintCode(
            name: "delete_function",
            problemMessage:
                "Delete function: ${deleteListItem.nameList.join("/")}.",
            correctionMessage:
                "Please delete this function from code snippet.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final DeleteListItem deleteListItem;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addFunctionExpression(
        (
          FunctionExpression node,
        ) {
          final ExecutableElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          final String? displayName = declaredElement.displayName;
          if (!deleteListItem.nameList.contains(displayName)) {
            return;
          }

          reporter.reportErrorForNode(
            this.code,
            node,
          );
        },
      );

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
      context.registry.addCommentReference(
        (
          CommentReference node,
        ) {
          if (analysisError.sourceRange.intersects(
            node.sourceRange,
          )) {
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Delete 'new'",
              priority: 0,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) =>
                  builder.addDeletion(
                analysisError.sourceRange,
              ),
            );
          }
        },
      );
}
