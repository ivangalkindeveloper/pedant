import 'package:yaml/yaml.dart';

class DeleteListItem {
  const DeleteListItem({
    required this.nameList,
    this.description,
  });

  final List<String> nameList;
  final String? description;

  factory DeleteListItem.fromYaml(
    YamlMap map,
  ) =>
      DeleteListItem(
        nameList: List<String>.from(
          (map['nameList'] as YamlList),
        ),
        description: map['description'],
      );
}
