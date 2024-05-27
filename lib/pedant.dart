import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_keyword_rule.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_path_rule.dart';
import 'package:pedant/src/rule/add/add_const_constructor_rule.dart';
import 'package:pedant/src/rule/add/add_const_variable_rule.dart';
import 'package:pedant/src/rule/add/add_constructor_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_dependent_bloc_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_dependent_flutter_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_public_property_rule.dart';
import 'package:pedant/src/rule/delete/delete_class_prefix_postfix_rule.dart';
import 'package:pedant/src/rule/delete/delete_function_rule.dart';
import 'package:pedant/src/rule/delete/delete_new_rule.dart';
import 'package:pedant/src/rule/delete/delete_package_rule.dart';
import 'package:pedant/src/rule/delete/delete_type_rule.dart.dart';
import 'package:pedant/src/rule/edit/edit_multiple_variable_rule.dart';
import 'package:pedant/src/rule/edit/edit_private_in_function_rule.dart';
import 'package:pedant/src/rule/edit/edit_relative_import_rule.dart';

// import 'package:pedant/src/rule/test_rule.dart';

PluginBase createPlugin() => _PedantBase();

class _PedantBase extends PluginBase {
  _PedantBase();

  @override
  List<LintRule> getLintRules(
    CustomLintConfigs configs,
  ) {
    const Config config = Config();
    final List<LintRule> ruleList = [];

    AddClassPrefixPostfixByKeywordRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddClassPrefixPostfixByPathRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstConstructorRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstVariableRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstructorRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteBlocDependentFlutterRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteBlocDependentBlocRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteBlocPublicPropertyRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteClassPrefixPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteFunctionRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteNewRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeletePackageRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteTypeRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditMultipleVariableRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditPrivateInFunctionRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditRelativeImportRule.combine(
      config: config,
      ruleList: ruleList,
    );
    // TestRule.combine(
    //   config: config,
    //   ruleList: ruleList,
    // );

    return ruleList;
  }
}
