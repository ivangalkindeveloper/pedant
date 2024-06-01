import 'package:yaml/yaml.dart';

class KeywordListNameItem {
  const KeywordListNameItem({
    required this.keywordList,
    required this.name,
  });

  final List<String> keywordList;
  final String name;

  factory KeywordListNameItem.fromYaml(
    YamlMap map,
  ) =>
      KeywordListNameItem(
        keywordList: List<String>.from(
          (map['keywordList'] as YamlList),
        ),
        name: map['name'],
      );
}
