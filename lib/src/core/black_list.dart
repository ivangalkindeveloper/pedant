const Map<String, String?> commonPackageBlackList = {
  "get_it": "The package contains a global generic structure, built on the service locator approach. "
      "This approach does not make sense, since it can lead to an unnecessary increase in the connectivity of modules and classes, "
      "if you use it as a structure for primary initialization, and then create instances of classes from this structure, this does not make sense.",
  "hydrated_bloc":
      "Globally stored BLoC states result in unexpected errors and incompatible states. "
          "Please manage and design the the BLoCs yourself and control the change of his states.",
  "flutter_hooks":
      "The build function must be clean and not affect the states of the modules. "
          "This is also true for initializations of different controllers or other resources, "
          "which can lead to memory leaks. Using this package may cause problems with memory leaks.",
  "freezed":
      "With the advent of Dart sealed classes, the fried package became unnecessary. "
          "Please use sealed classes instead of code generation.",
};

const String _databaseDescription =
    "All noSQL packages are not a reliable and scalability way to store data. "
    "Please use SQL database packages - sqflite, drift.";
const Map<String, String?> databasePackageBlackList = {
  "hive": _databaseDescription,
  "isar": _databaseDescription,
  "objectbox": _databaseDescription,
};

const Map<String, String?> stateManagementPackageBlackList = {
  "get": "Global package for state management, built on the service locator approach. "
      "The package has a huge bunch of problems and bugs, it tries to perform state changes, routing and much more.",
  "riverpod":
      "Management of states using global variables, as a result - not the best control using global resources.",
};

const Map<String, String?> typeBlackList = {
  "Container": "An overloaded widget that combines others widget. "
      "Please use the required widgets explicitly - Padding, SizedBox, ColoredBox, DecoratedBox, ClipRRect and etc.",
};
