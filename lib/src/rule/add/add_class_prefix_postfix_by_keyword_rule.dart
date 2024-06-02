import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/core/data/keyword_list_name_item.dart';
import 'package:pedant/src/core/data/pre_post_fix_type.dart';
import 'package:pedant/src/core/default/default_add_prefix_by_keyword_list.dart';

class AddClassPrefixPostfixByKeywordRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    final List<KeywordListNameItem> addClassPrefixByKeywordList =
        config.addClassPrefixByKeywordList ??
            defaultAddClassPrefixByKeywordList;
    for (final KeywordListNameItem keywordListNameItem
        in addClassPrefixByKeywordList) {
      ruleList.add(
        AddClassPrefixPostfixByKeywordRule(
          code: LintCode(
            name: "add_prefix_by_keyword",
            problemMessage:
                "Сlass name must starts with an prefix: ${keywordListNameItem.name}.",
            correctionMessage: "Please add prefix in class.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
          keywordListNameItem: keywordListNameItem,
          type: PrePostFixType.prefix,
          priority: config.priority,
        ),
      );
    }

    final List<KeywordListNameItem>? addClassPostfixByKeywordList =
        config.addClassPostfixByKeywordList;
    if (addClassPostfixByKeywordList != null) {
      for (final KeywordListNameItem keywordListNameItem
          in addClassPostfixByKeywordList) {
        ruleList.add(
          AddClassPrefixPostfixByKeywordRule(
            code: LintCode(
              name: "add_postfix_by_keyword",
              problemMessage:
                  "Сlass name must ends with an postfix: ${keywordListNameItem.name}.",
              correctionMessage: "Please add postfix in class.",
              errorSeverity: ErrorSeverity.ERROR,
            ),
            keywordListNameItem: keywordListNameItem,
            type: PrePostFixType.postfix,
            priority: config.priority,
          ),
        );
      }
    }
  }

  const AddClassPrefixPostfixByKeywordRule({
    required super.code,
    required this.keywordListNameItem,
    required this.type,
    required this.priority,
  });

  final KeywordListNameItem keywordListNameItem;
  final PrePostFixType type;
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
          bool isMatch = false;
          final List<Token> tokenList = [
            node.abstractKeyword,
            node.augmentKeyword,
            node.baseKeyword,
            node.finalKeyword,
            node.interfaceKeyword,
            node.macroKeyword,
            node.mixinKeyword,
            node.sealedKeyword,
          ].whereType<Token>().toList();

          if (tokenList.isEmpty) {
            return;
          }

          for (final Token token in tokenList) {
            if (this
                .keywordListNameItem
                .keywordList
                .contains(token.toString())) {
              isMatch = true;
            }
          }

          if (isMatch == false) {
            return;
          }

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
    switch (this.type) {
      case PrePostFixType.prefix:
        if (name.startsWith(
          this.keywordListNameItem.name,
        )) {
          return;
        }

      case PrePostFixType.postfix:
        if (name.endsWith(
          this.keywordListNameItem.name,
        )) {
          return;
        }
    }

    onSuccess();
  }

  @override
  List<Fix> getFixes() => [
        _Fix(
          type: this.type,
          priority: this.priority,
        ),
      ];
}

class _Fix extends DartFix {
  _Fix({
    required this.type,
    required this.priority,
  });

  final PrePostFixType type;
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
    final String part = analysisError.message.split(":")[1].trim().replaceAll(
          ".",
          "",
        );

    switch (this.type) {
      case PrePostFixType.prefix:
        return "$part$name";

      case PrePostFixType.postfix:
        return "$name$part";
    }
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
