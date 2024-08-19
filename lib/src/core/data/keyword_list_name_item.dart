import 'package:yaml/yaml.dart';

class KeywordListNameItem {
  const KeywordListNameItem({
    required this.name,
    required this.keywordList,
  });

  final String name;
  final List<String> keywordList;

  factory KeywordListNameItem.fromYaml(
    YamlMap map,
  ) =>
      KeywordListNameItem(
        name: map['name'],
        keywordList: List<String>.from(
          (map['keywordList'] as YamlList),
        ),
      );
}
