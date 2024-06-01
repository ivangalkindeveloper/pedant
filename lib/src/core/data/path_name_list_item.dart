import 'package:yaml/yaml.dart';

class PathNameListItem {
  const PathNameListItem({
    required this.path,
    required this.nameList,
  });

  final String path;
  final List<String> nameList;

  factory PathNameListItem.fromYaml(
    YamlMap map,
  ) =>
      PathNameListItem(
        path: map['path'],
        nameList: List<String>.from(
          (map['nameList'] as YamlList),
        ),
      );
}
