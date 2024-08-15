import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';
import 'package:pedant/src/core/data/pre_post_fix_type.dart';
import 'package:pedant/src/utility/extension/add_class.dart';

class AddClassPrefixPostfixByPathRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<PathNameListItem>? addClassPrefixByPathList =
        config.addClassPrefixByPathList;
    if (addClassPrefixByPathList != null) {
      for (final PathNameListItem pathNameListItem
          in addClassPrefixByPathList) {
        ruleList.add(
          AddClassPrefixPostfixByPathRule(
            code: LintCode(
              name: "add_prefix_by_path",
              problemMessage:
                  "Pedant: Сlass name must starts with an prefix: ${pathNameListItem.nameList.join(", ")}.",
              correctionMessage: "Please add prefix in class.",
              errorSeverity: error.ErrorSeverity.ERROR,
            ),
            pathNameListItem: pathNameListItem,
            type: PrePostFixType.prefix,
            priority: config.priority,
          ),
        );
      }
    }

    final List<PathNameListItem>? addClassPostfixByPathList =
        config.addClassPostfixByPathList;
    if (addClassPostfixByPathList != null) {
      for (final PathNameListItem pathNameListItem
          in addClassPostfixByPathList) {
        ruleList.add(
          AddClassPrefixPostfixByPathRule(
            code: LintCode(
              name: "add_postfix_by_path",
              problemMessage:
                  "Сlass name must ends with an postfix: ${pathNameListItem.nameList.join(", ")}.",
              correctionMessage: "Please add postfix in class.",
              errorSeverity: error.ErrorSeverity.ERROR,
            ),
            pathNameListItem: pathNameListItem,
            type: PrePostFixType.postfix,
            priority: config.priority,
          ),
        );
      }
    }
  }

  const AddClassPrefixPostfixByPathRule({
    required super.code,
    required this.pathNameListItem,
    required this.type,
    required this.priority,
  });

  final PathNameListItem pathNameListItem;
  final PrePostFixType type;
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
          if (resolver.path.contains(this.pathNameListItem.path) == false) {
            return;
          }

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
    for (final String matchName in pathNameListItem.nameList) {
      switch (this.type) {
        case PrePostFixType.prefix:
          if (name.startsWith(
            matchName,
          )) {
            return;
          }

        case PrePostFixType.postfix:
          if (name.endsWith(
            matchName,
          )) {
            return;
          }
      }
    }

    onSuccess();
  }
}
