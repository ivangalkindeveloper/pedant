import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/rule/add/add_bloc_event_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_event_sealed_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_state_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_state_sealed_rule.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_keyword_rule.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_path_rule.dart';
import 'package:pedant/src/rule/add/add_const_constructor_rule.dart';
import 'package:pedant/src/rule/add/add_const_variable_rule.dart';
import 'package:pedant/src/rule/add/add_constructor_rule.dart';
import 'package:pedant/src/rule/add/add_cubit_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_extension_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_if_bracets_rule.dart';
import 'package:pedant/src/rule/add/add_mixin_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_override_rule.dart';
import 'package:pedant/src/rule/add/add_this_rule.dart';
import 'package:pedant/src/rule/add/add_type_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_dependent_bloc_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_dependent_flutter_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_public_property_rule.dart';
import 'package:pedant/src/rule/delete/delete_class_prefix_postfix_rule.dart';
import 'package:pedant/src/rule/delete/delete_function_rule.dart';
import 'package:pedant/src/rule/delete/delete_new_rule.dart';
import 'package:pedant/src/rule/delete/delete_package_rule.dart';
import 'package:pedant/src/rule/delete/delete_type_rule.dart.dart';
import 'package:pedant/src/rule/edit/edit_arrow_function_rule.dart';
import 'package:pedant/src/rule/edit/edit_constructor_named_parameter_rule.dart';
import 'package:pedant/src/rule/edit/edit_multiple_variable_rule.dart';
import 'package:pedant/src/rule/edit/edit_private_in_function_rule.dart';
import 'package:pedant/src/rule/edit/edit_relative_import_rule.dart';
import 'package:pedant/src/utility/get_config.dart';

// import 'package:pedant/src/rule/test_rule.dart';

PluginBase createPlugin() => _PedantBase();

class _PedantBase extends PluginBase {
  _PedantBase();

  @override
  List<LintRule> getLintRules(
    CustomLintConfigs configs,
  ) {
    final Config config = getConfig(
      rules: configs.rules,
    );
    final List<LintRule> ruleList = [];

    AddBlocEventSealedRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocEventPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocStatePostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocStateSealedRule.combine(
      config: config,
      ruleList: ruleList,
    );
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
    AddCubitPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddExtensionPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddIfBracesRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddMixinPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddOverrideRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddThisRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddTypeRule.combine(
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
    EditArrowFunctionRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditConstructorNamedParameterRule.combine(
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
