import 'package:pedant/src/core/black_list/black_list_item.dart';

const List<BlackListItem> packageBlackList = [
  ..._commonPackageBlackList,
  ..._databasePackageBlackList,
  ..._stateManagementPackageBlackList,
];

const List<BlackListItem> _commonPackageBlackList = [
  BlackListItem(
    name: "get_it",
    description:
        "The package contains a global generic structure, built on the service locator approach.\n"
        "This approach does not make sense, since it can lead to an unnecessary increase in the connectivity of modules and classes,\n"
        "if you use it as a structure for primary initialization, and then create instances of classes from this structure, this does not make sense.",
  ),
  BlackListItem(
    name: "hydrated_bloc",
    description:
        "Globally stored BLoC states result in unexpected errors and incompatible states.\n"
        "Please manage and design the the BLoCs yourself and control the change of his states.",
  ),
  BlackListItem(
    name: "flutter_hooks",
    description:
        "The build function must be clean and not affect the states of the modules.\n"
        "This is also true for initializations of different controllers or other resources,\n"
        "which can lead to memory leaks. Using this package may cause problems with memory leaks.",
  ),
  BlackListItem(
    name: "freezed",
    description:
        "With the advent of Dart sealed classes, the fried package became unnecessary.\n"
        "Please use sealed classes instead of code generation.",
  ),
  BlackListItem(
    name: "fpdart",
    description: "The package provides an Eather object.\n"
        "Error handling should be located in one specific place, for example a controller or BLoC, and in a single form - try catch operator.\n"
        "This object complicates the code and its error handling, additional code is also needed to provide error data, for example an error stacktrace.\n"
        "This object has no practical meaning.",
  ),
];

const String _databaseDescription =
    "All noSQL packages are not a reliable and scalability way to store data.\n"
    "Please use SQL database packages - sqflite, drift.";
const List<BlackListItem> _databasePackageBlackList = [
  BlackListItem(
    name: "hive",
    description: _databaseDescription,
  ),
  BlackListItem(
    name: "isar",
    description: _databaseDescription,
  ),
  BlackListItem(
    name: "objectbox",
    description: _databaseDescription,
  ),
];

const List<BlackListItem> _stateManagementPackageBlackList = [
  BlackListItem(
    name: "get",
    description:
        "Global package for state management, built on the service locator approach.\n"
        "The package has a huge bunch of problems and bugs, it tries to perform state changes, routing and much more.",
  ),
  BlackListItem(
    name: "riverpod",
    description:
        "Management of states using global variables, as a result - not the best control using global resources.",
  ),
];
