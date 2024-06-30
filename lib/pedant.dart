import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/rule/add/add_bloc_cubit_event_state_file_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_cubit_state_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_cubit_state_sealed_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_event_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_bloc_event_sealed_rule.dart';
import 'package:pedant/src/rule/add/add_class_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_keyword_rule.dart';
import 'package:pedant/src/rule/add/add_class_prefix_postfix_by_path_rule.dart';
import 'package:pedant/src/rule/add/add_comma_rule.dart';
import 'package:pedant/src/rule/add/add_const_constructor_rule.dart';
import 'package:pedant/src/rule/add/add_const_rule.dart';
import 'package:pedant/src/rule/add/add_constructor_rule.dart';
import 'package:pedant/src/rule/add/add_extension_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_if_bracets_rule.dart';
import 'package:pedant/src/rule/add/add_mixin_postfix_rule.dart';
import 'package:pedant/src/rule/add/add_override_rule.dart';
import 'package:pedant/src/rule/add/add_static.dart';
import 'package:pedant/src/rule/add/add_this_rule.dart';
import 'package:pedant/src/rule/add/add_type_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_cubit_dependent_bloc_cubit_flutter_rule.dart';
import 'package:pedant/src/rule/delete/delete_bloc_cubit_public_property_rule.dart';
import 'package:pedant/src/rule/delete/delete_class_prefix_postfix_rule.dart';
import 'package:pedant/src/rule/delete/delete_function_rule.dart';
import 'package:pedant/src/rule/delete/delete_new_rule.dart';
import 'package:pedant/src/rule/delete/delete_package_rule.dart';
import 'package:pedant/src/rule/delete/delete_type_rule.dart.dart';
import 'package:pedant/src/rule/delete/delete_widget_function_method_rule.dart';
import 'package:pedant/src/rule/edit/edit_arrow_function_rule.dart';
import 'package:pedant/src/rule/edit/edit_constructor_private_public_named_parameter_rule.dart';
import 'package:pedant/src/rule/edit/edit_file_length_by_path_rule.dart';
import 'package:pedant/src/rule/edit/edit_function_private_public_named_parameter_rule.dart';
import 'package:pedant/src/rule/edit/edit_multiple_variable_rule.dart';
import 'package:pedant/src/rule/edit/edit_private_in_function_rule.dart';
import 'package:pedant/src/rule/edit/edit_relative_import_rule.dart';
import 'package:pedant/src/rule/edit/edit_variable_name_by_type_rule.dart';
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

    AddBlocCubitEventStateFileRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocCubitStatePostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocCubitStateSealedRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocEventPostfixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddBlocEventSealedRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddClassPostfixRule.combine(
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
    AddCommaRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstConstructorRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstRule.combine(
      config: config,
      ruleList: ruleList,
    );
    AddConstructorRule.combine(
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
    AddStaticRule.combine(
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
    DeleteBlocCubitDependentBlocCubitFlutterRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteBlocCubitPublicPropertyRule.combine(
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
    DeleteWidgetFunctionMethodRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditArrowFunctionRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditConstructorPrivatePublicNamedParameterRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditFileLengthByPathRule.combine(
      config: config,
      ruleList: ruleList,
    );
    EditFunctionPrivatePublicNamedParameterRule.combine(
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
    EditVariableNameByTypeRule.combine(
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
