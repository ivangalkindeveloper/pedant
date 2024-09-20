import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/default/default_delete_class_postfix_list.dart';
import 'package:pedant/src/utility/extension/add_class.dart';

class DeleteClassPrefixPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<String>? deleteClassPrefixList = config.deleteClassPrefixList;
    if (deleteClassPrefixList != null) {
      ruleList.add(
        DeleteClassPrefixPostfixRule(
          code: LintCode(
            name: "delete_class_prefix",
            problemMessage:
                "Pedant: Сlass name must not contain an prefix: ${deleteClassPrefixList.join(", ")}.",
            correctionMessage: "Please delete prefix in class.",
            errorSeverity: error.ErrorSeverity.ERROR,
          ),
          list: deleteClassPrefixList,
          validaton: ({
            required String name,
            required String matchName,
          }) =>
              name.startsWith(
            matchName,
          ),
          priority: config.priority,
        ),
      );
    }

    final List<String> deleteClassPostfixList =
        config.deleteClassPostfixList ?? defaultDeleteClassPostfixList;
    ruleList.add(
      DeleteClassPrefixPostfixRule(
        code: LintCode(
          name: "delete_class_postfix",
          problemMessage:
              "Pedant: Сlass name must not contain an postfix: ${deleteClassPostfixList.join(", ")}.",
          correctionMessage: "Please delete postfix in class.",
          errorSeverity: error.ErrorSeverity.ERROR,
        ),
        list: deleteClassPostfixList,
        validaton: ({
          required String name,
          required String matchName,
        }) =>
            name.endsWith(
          matchName,
        ),
        priority: config.priority,
      ),
    );
  }

  const DeleteClassPrefixPostfixRule({
    required super.code,
    required this.list,
    required this.validaton,
    required this.priority,
  });

  final List<String> list;
  final bool Function({
    required String name,
    required String matchName,
  }) validaton;
  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addClass(
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          _validate(
            name: classElement.displayName,
            onSuccess: () => reporter.atElement(
              classElement,
              this.code,
            ),
          );

          for (final ConstructorElement constructorElement
              in classElement.constructors) {
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
    for (final String matchName in this.list) {
      if (this.validaton(
        name: name,
        matchName: matchName,
      )) {
        return onSuccess();
      }
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
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) =>
      context.addClassIntersects(
        analysisError,
        (
          ClassDeclaration classDeclaration,
          ClassElement classElement,
        ) {
          final String validName = this._getValidName(
            analysisError: analysisError,
            name: classElement.displayName,
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
        },
      );

  String _getValidName({
    required error.AnalysisError analysisError,
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
}
