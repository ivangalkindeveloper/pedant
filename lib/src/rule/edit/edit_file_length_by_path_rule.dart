import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/length_item.dart';

class EditFileLengthByPathRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<LengthItem>? editFileLengthByPathList =
        config.editFileLengthByPathList;
    if (editFileLengthByPathList == null) {
      return;
    }

    for (final LengthItem lengthItem in editFileLengthByPathList) {
      ruleList.add(
        EditFileLengthByPathRule(
          lengthItem: lengthItem,
          priority: config.priority,
        ),
      );
    }
  }

  const EditFileLengthByPathRule({
    required this.lengthItem,
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "edit_file_length_by_path",
            problemMessage: "Pedant: Edit file length.",
            correctionMessage: "Please edit this file for less length of code.",
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  final LengthItem lengthItem;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (this._validatePath(
          resolver: resolver,
        ) ==
        false) {
      return;
    }

    if (resolver.lineInfo.lineCount <= this.lengthItem.length) {
      return;
    }

    reporter.atOffset(
      offset: 0,
      length: resolver.source.contents.data.length,
      errorCode: this.code,
    );
  }

  bool _validatePath({
    required CustomLintResolver resolver,
  }) {
    final String? path = this.lengthItem.path;
    if (path == null) {
      return true;
    }

    return resolver.path.contains(
      path,
    );
  }
}
