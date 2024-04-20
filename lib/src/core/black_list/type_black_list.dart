import 'package:pedant/src/core/black_list/black_list_item.dart';

const List<BlackListItem> typeBlackList = [
  BlackListItem(
    name: "Container",
    description: "An overloaded widget that combines others widget. "
        "Please use the required widgets explicitly - Padding, SizedBox, ColoredBox, DecoratedBox, ClipRRect and etc.",
  ),
  BlackListItem(
    name: "Eather",
    description:
        "See the description of the 'fpdart' package error in pubspec.yaml.",
  ),
];
