import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/black_list/black_list_item.dart';
import 'package:pedant/src/core/black_list/type_black_list.dart';
import 'package:pedant/src/core/config/config.dart';

class DeleteTypeRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (!config.deleteType) {
      return;
    }

    if (config.packageBlackList.isEmpty) {
      for (final BlackListItem item in typeBlackList) {
        ruleList.add(
          DeleteTypeRule(
            typeName: item.name,
            description: item.description,
          ),
        );
      }
    }
  }

  DeleteTypeRule({
    required this.typeName,
    this.description,
  }) : super(
          code: LintCode(
            name: "delete_type",
            problemMessage: "Dont use unrecommended type: $typeName.\n"
                "Please delete this type from code snippet.",
            correctionMessage: description,
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final String typeName;
  final String? description;

  @override
  List<String> get filesToAnalyze => const [
        '**.dart',
      ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTypeAnnotation(
      (
        TypeAnnotation node,
      ) {
        final DartType? type = node.type;
        if (type == null) {
          return;
        }

        final String typeDisplay = type.getDisplayString(
          withNullability: false,
        );
        if (typeDisplay == this.typeName) {
          reporter.reportErrorForNode(
            this.code,
            node,
          );
        }
      },
    );
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
}
