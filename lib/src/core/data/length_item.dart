import 'package:yaml/yaml.dart';

class LengthItem {
  const LengthItem({
    this.path,
    required this.length,
  });

  final String? path;
  final int length;

  factory LengthItem.fromYaml(
    YamlMap map,
  ) =>
      LengthItem(
        path: map['path'],
        length: map['length'],
      );
}
