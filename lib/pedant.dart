import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/rule/delete_implementation_suffix_rule.dart';
import 'package:pedant/src/rule/delete_model_suffix_rule.dart';
import 'package:pedant/src/rule/delete_new_rule.dart';
import 'package:pedant/src/rule/delete_package_rule.dart';
import 'package:pedant/src/rule/delete_print_rule.dart';
import 'package:pedant/src/rule/delete_type_rule.dart.dart';

PluginBase createPlugin() => _PedantBase();

class _PedantBase extends PluginBase {
  _PedantBase();

  @override
  List<LintRule> getLintRules(
    CustomLintConfigs configs,
  ) {
    final Config config = Config();
    final List<LintRule> ruleList = [];

    DeleteImplementationSuffixRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteModelSuffixRule.combine(
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
    DeletePrintRule.combine(
      config: config,
      ruleList: ruleList,
    );
    DeleteTypeRule.combine(
      config: config,
      ruleList: ruleList,
    );

    return ruleList;
  }
}
