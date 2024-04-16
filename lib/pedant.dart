import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/black_list.dart';
import 'package:pedant/src/rule/using_unrecommended_package_rule.dart';

PluginBase createPlugin() => _PedantBase();

class _PedantBase extends PluginBase {
  _PedantBase();

  @override
  List<LintRule> getLintRules(
    CustomLintConfigs configs,
  ) =>
      stateManagementPackageBlackList.entries
          .map((MapEntry entry) => UsingUnrecommendedPackageRule(
                packageName: entry.key,
                description: entry.value,
              ))
          .toList();
}
