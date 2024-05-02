import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/rule/delete/delete_function_rule.dart';
import 'package:pedant/src/rule/delete/delete_new_rule.dart';
import 'package:pedant/src/rule/delete/delete_package_rule.dart';
import 'package:pedant/src/rule/test_rule.dart';

// import 'package:pedant/src/rule/delete/delete_postfix_rule.dart';
// import 'package:pedant/src/rule/delete/delete_type_rule.dart.dart';

PluginBase createPlugin() => _PedantBase();

class _PedantBase extends PluginBase {
  _PedantBase();

  @override
  List<LintRule> getLintRules(
    CustomLintConfigs configs,
  ) {
    const Config config = Config();
    final List<LintRule> ruleList = [];

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
    // DeletePostfixRule.combine(
    //   config: config,
    //   ruleList: ruleList,
    // );
    // DeleteTypeRule.combine(
    //   config: config,
    //   ruleList: ruleList,
    // );
    // TestRule.combine(
    //   config: config,
    //   ruleList: ruleList,
    // );

    return ruleList;
  }
}
