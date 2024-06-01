import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';

Config getConfig({
  required Map<String, LintOptions> rules,
}) {
  if (rules.isEmpty) {
    return const Config();
  }

  try {
    return Config.fromYaml(
      map: rules.entries.first.value.json,
    );
  } catch (error, stackTrace) {
    print(error);
    print(stackTrace);
    return const Config();
  }
}
