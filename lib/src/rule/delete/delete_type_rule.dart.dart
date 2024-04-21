import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/default/default_delete_type_list.dart';
import 'package:pedant/src/core/config/config.dart';

class DeleteTypeRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteType) {
      return;
    }

    final List<DeleteListItem> deleteList = config.deleteTypeList.isNotEmpty
        ? config.deleteTypeList
        : defaultDeleteTypeList;
    for (final DeleteListItem deleteListItem in deleteList) {
      ruleList.add(
        DeleteTypeRule(
          deleteListItem: deleteListItem,
        ),
      );
    }
  }

  DeleteTypeRule({
    required this.deleteListItem,
  }) : super(
          code: LintCode(
            name: "delete_type",
            problemMessage:
                "Delete type: ${deleteListItem.nameList.join("/")}.",
            correctionMessage:
                "Please delete this type from code snippet.${deleteListItem.description != null ? "\n${deleteListItem.description}" : ""}",
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
      context.registry.addTypeAnnotation(
        (
          TypeAnnotation node,
        ) {
          final DartType? type = node.type;
          if (type == null) {
            return;
          }

          final String displayString = type.getDisplayString(
            withNullability: false,
          );
          bool isMatch = false;
          for (final String typeName in deleteListItem.nameList) {
            if (typeName == displayString) {
              isMatch = true;
            }
          }

          if (isMatch) {
            reporter.reportErrorForNode(
              this.code,
              node,
            );
          }
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
      context.registry.addTypeAnnotation(
        (
          TypeAnnotation node,
        ) {
          if (analysisError.sourceRange.intersects(
            node.sourceRange,
          )) {
            final String? typeName = node.type?.getDisplayString(
              withNullability: false,
            );
            final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
              message: "Delete '$typeName'",
              priority: 0,
            );
            changeBuilder.addDartFileEdit(
              (
                DartFileEditBuilder builder,
              ) =>
                  builder.addDeletion(
                SourceRange(
                  node.offset,
                  node.length,
                ),
              ),
            );
          }
        },
      );
}
