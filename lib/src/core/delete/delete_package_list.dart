import 'package:pedant/src/core/delete/delete_list_item.dart';

const List<DeleteListItem> deletePackageList = [
  ..._commonDeletePackageList,
  ..._databaseDeletePackageList,
  ..._stateManagementDeletePackageList,
];

const List<DeleteListItem> _commonDeletePackageList = [
  DeleteListItem(
    nameList: [
      "get_it",
    ],
    description:
        "The package contains a global generic structure, built on the service locator approach.\n"
        "This approach does not make sense, since it can lead to an unnecessary increase in the connectivity of modules and classes,\n"
        "if you use it as a structure for primary initialization, and then create instances of classes from this structure, this does not make sense.",
  ),
  DeleteListItem(
    nameList: [
      "provider",
    ],
    description: "The package is an add-on for the InheritedWidget.\n"
        "Please use an InheritedWidget with a static of(context) method to access it, instead of using the whole package.",
  ),
  DeleteListItem(
    nameList: [
      "flutter_hooks",
      "flutter_hooks_bloc",
    ],
    description:
        "The build function must be clean and not affect the states of the modules.\n"
        "This is also true for initializations of different controllers or other resources,\n"
        "which can lead to memory leaks. Using this package may cause problems with memory leaks.",
  ),
  DeleteListItem(
    nameList: [
      "freezed",
      "freezed_annotation",
    ],
    description:
        "With the advent of Dart sealed classes, the fried package became unnecessary.\n"
        "Please use sealed classes instead of code generation.",
  ),
  DeleteListItem(
    nameList: [
      "fpdart",
      "freezed_result",
    ],
    description: "The package provides an Eather object.\n"
        "Error handling should be located in one specific place, for example a controller or BLoC, and in a single form - try catch operator.\n"
        "This object complicates the code and its error handling, additional code is also needed to provide error data, for example an error stacktrace.\n"
        "This object has no practical meaning.",
  ),
];

const String _databaseDescription =
    "All noSQL packages are not a reliable and scalability way to store data.\n"
    "Please use SQL database packages - sqflite, drift.";
const List<DeleteListItem> _databaseDeletePackageList = [
  DeleteListItem(
    nameList: [
      "hive",
      "hive_generator",
      "hive_generator_plus",
      "hive_flutter",
      "hive_test",
      "hive_local_storage",
      "hive_listener",
      "json_hive_generator",
    ],
    description: _databaseDescription,
  ),
  DeleteListItem(
    nameList: [
      "isar",
      "isar_generator",
      "isar_flutter_libs",
      "dio_cache_interceptor_isar_store",
      "isar_key_value",
      "stash_isar",
      "sentry_isar",
    ],
    description: _databaseDescription,
  ),
  DeleteListItem(
    nameList: [
      "objectbox",
      "objectbox_generator",
      "objectbox_flutter_libs",
      "objectbox_sync_flutter_libs",
      "dio_cache_interceptor_objectbox_store",
      "stash_objectbox",
      "foodb_objectbox_adapter",
    ],
    description: _databaseDescription,
  ),
  DeleteListItem(
    nameList: [
      "get_storage",
      "get_secure_storage",
      "get_storage_pro",
    ],
    description: _databaseDescription,
  ),
];

const List<DeleteListItem> _stateManagementDeletePackageList = [
  DeleteListItem(
    nameList: [
      "hydrated_bloc",
    ],
    description:
        "Globally stored BLoC states result in unexpected errors and incompatible states.\n"
        "Please manage and design the the BLoCs yourself and control the change of his states.",
  ),
  DeleteListItem(
    nameList: [
      "get",
    ],
    description:
        "Global package for state management, built on the service locator approach.\n"
        "The package has a huge bunch of problems and bugs, it tries to perform state changes, routing and much more.",
  ),
  DeleteListItem(
    nameList: [
      "riverpod",
      "flutter_riverpod",
      "hooks_riverpod",
      "riverpod_generator",
      "flame_riverpod",
      "riverpod_context",
      "riverpod_lint",
      "shared_preferences_riverpod",
      "riverpod_test",
      "riverpod_infinite_scroll",
      "riverpod_annotation",
      "riverpod_repo",
      "riverpod_navigator",
      "riverpod_mutations",
      "hydrated_riverpod",
      "riverpod_infinite_scroll_pagination",
      "riverpod_navigator_core",
      "riverpod_mutations_generator",
      "flutter_riverpod_restorable",
      "jaspr_riverpod",
      "riverpod_analyzer_utils",
      "mvvm_riverpod",
      "riverpod_extension",
      "riverpod_messages",
      "riverpod_persistent_state",
      "riverpod_testing_library",
      "riverpod_state",
      "riverpod_builder",
      "riverpod_navigation",
      "riverpod_mutations_annotation",
      "replay_riverpod",
      "bloc_riverpod",
      "riverpod_mvvm",
      "notified_preferences_riverpod",
      "offset_iterator_riverpod",
      "args_riverpod",
      "maac_mvvm_with_riverpod",
      "rdev_riverpod_firebase_auth_user",
      "riverpod_async_value_widget",
      "riverpod_tachyon_plugin",
      "bond_form_riverpod",
      "riverpod_hover_consumer",
      "flutter_riverform",
      "rdev_riverpod_firebase_user",
      "riverpod_feature_generator",
      "utopia_hooks_riverpod",
      "rdev_riverpod_versioning",
    ],
    description:
        "Management of states using global variables, as a result - not the best control using global resources.",
  ),
];
