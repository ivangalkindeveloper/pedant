# Pedant
A strict static analyzer and script for formatting Dart code.\
Designed to solve problems in a project at the design and support stages.

Script:
 - automatic fix of detected linter errors;
 - sorting in alphabetical order of the fields of `.arb` files;
 - sorting in alphabetical order import, export and part declarations of `.dart` files;
 - converting relative import declarations of `.dart` files;
 - deleting unused import declarations of `.dart` files;
 - sorting in alphabetical order of `dependencies`, `dev_dependencies`, `dependency_overrides` keys in `pubspec.yaml`;
 - Dart code formatting.

Analyzer:
 - strict architectural rules;
 - strict stylistic rules;
 - not strict rules of approach.

## Getting started
- [Benefits](#benefits)
- [Installation and configuration](#installation-and-configuration)
  - [Installing](#installing)
  - [Configuration](#configuration)
- [Script](#script)
  - [Arguments](#arguments)
  - [Sorting arb files](#sorting-arb-files)
  - [Convert dart declarations](#convert-dart-declarations)
  - [Sorting pubspec dependencies](#sorting-pubspec-dependencies)
- [Linter](#linter)
  - [Add rules](#add-rules)
  - [Delete rules](#delete-rules)
  - [Edit rules](#edit-rules)
  - [Other](#other-rules)
- [Additional information](#additional-information)

## Benefits
The package allows you to maintain projects of any size in terms of code base and localizations in a clean and tidy manner, focusing on the fact that the linter rules were not violated and the script was run before merging the code base.

## Installation and configuration
### Installing
1) Add two packages to the `pubspec.yaml` file in the `dev_dependencies` section:
```yaml
dev_dependencies:
  custom_lint: ^latest_version
  pedant: ^latest_version
```
2) Add the inclusion of a custom analyzer to the `analysis_options.yaml` file:
```yaml
analyzer:
  plugins:
    - custom_lint

# For rules configuration add this inclusion
custom_lint:
  rules:
    - pedant:
```
It is advisable to restart the IDE after connecting the analyzer.

### Configuration
Current default configuration:
```yaml
custom_lint:
  rules:
    - pedant:
      add_bloc_cubit_event_state_file: true
      add_bloc_cubit_state_postfix: true
      add_bloc_cubit_state_sealed: true
      add_bloc_event_postfix: true
      add_bloc_event_sealed: true
      add_bloc_postfix: true
      add_class_postfix_by_keyword_list: null
      add_class_postfix_by_path_list: null
      add_class_prefix_by_keyword_list: null
      add_class_prefix_by_path_list: null
      add_comma: true
      add_const_constructor: true
      add_const: true
      add_constructor: true
      add_controller_postfix: true
      add_cubit_postfix: true
      add_extension_postfix: true
      add_if_braces: true
      add_mixin_postfix: true
      add_override: true
      add_this: true
      add_type: true
      delete_bloc_cubit_dependent_bloc_cubit: true
      delete_bloc_cubit_dependent_flutter: true
      delete_bloc_cubit_public_property: true
      delete_class_postfix_list:
        - Impl
        - Implementation
        - Model
      delete_class_prefix_list: null
      delete_function_list:
        - print
        - debugPrint
        - debugPrintThrottled
      delete_new: true
      # delete_package_list: - Check note
      # delete_type_list: - Check note
      delete_widget_method: true
      edit_arrow_function: true
      edit_constructor_private_named_parameter: true
      edit_constructor_public_named_parameter: true
      edit_file_length_by_path_list: null
      edit_function_private_named_parameter: true
      edit_function_public_named_parameter: true
      edit_multiple_variable: true
      edit_private_in_function: true
      edit_relative_import: true
      edit_variable_name_by_type: true
      priority: 100
```
Note:\
Default list of delete_package_list check [here](https://github.com/ivangalkindeveloper/pedant/blob/master/lib/src/core/default/default_delete_package_list.dart).\
Default list of delete_type_list check [here](https://github.com/ivangalkindeveloper/pedant/blob/master/lib/src/core/default/default_delete_type_list.dart).


## Script
The script is designed from the point of view of maximum coverage and bringing order to the project.\
Run the script:
```shell
dart run pedant
```
### Arguments
```shell
 --no-fix - disable fix of analyzed linter problems;
 --no-sort-arb - disable alphabetical sorting of .arb files;
 --no-convert-import - disable alphabetical sorting of declarations of imports, exports and parts and deleting unused imports of .dart files;
 --no-sort-pubspec - disable alphabetical sorting dependencшуы in the pubspec.yaml file;
 --no-format - disable final formatting at the script completion stage;
```
### Sorting arb files
All found files are sorted in alphabetical order.
### Convert dart declarations
The script sorts and converts Dart declarations of imports, exports and parts in the following and alphabetical order:
```dart
-- Lines before declarations --

1. Library declaration
library example;

2. Export declarations
export 'package:example/one.dart';
export 'package:example/two.dart';

3. Dart import declarations
import 'dart:async';
import 'dart:io';
4. Flutter import declarations
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
5. Package import declarations
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
6. Project import declarations
import 'package:example/one.dart';
import 'package:example/two.dart';

7. Part declarations
part 'one.dart';
part 'two.dart';

8. Part of declaration
part of 'one.dart';

-- Rest lines of the code --
```
Unused import declarations will be deleted.
Only files located in the `/bin/...` and `/lib/...` directories are sorted.
### Sorting pubspec dependencies
All dependencies in `dependencies`, `dev_dependencies` and `dependency_overrides` keys are sorted in alphabetical order in `pubspec.yaml`.

## Linter
Linter has next rules:
### Add rules
#### add_bloc_cubit_part
The Bloc/Cubit state and event class must be located either in the same file or in the same visibility area through `part`/`part of`.
```dart
// BAD:
import 'package:example/example_event.dart';
import 'package:example/example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ...
}

// GOOD:
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ...
}

sealed class ExampleEvent {
  ...
}

sealed class ExampleState {
  ...
}

// GOOD:
part of 'example_event.dart';
part of 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ...
}
```

#### add_bloc_cubit_state_postfix
The `Bloc`/`Cubit` state class must have a `State` postfix.
```dart
// BAD:
sealed class ExampleSt {
  ...
}

// GOOD:
sealed class ExampleState {
  ...
}
```

#### add_bloc_cubit_state_sealed
The `Bloc`/`Cubit` state class must be declared with the `sealed` keyword.
```dart
// BAD:
class ExampleState {
  ...
}

// GOOD:
sealed class ExampleState {
  ...
}
```

#### add_bloc_event_postfix
The `Bloc` event class must have the `Event` postfix.
```dart
// BAD:
sealed class ExampleEv {
  ...
}

// GOOD:
sealed class ExampleEvent {
  ...
}
```

#### add_bloc_event_sealed
The `Bloc` event class must be declared with the `sealed` keyword.
```dart
// BAD:
class ExampleEvent {
  ...
}

// GOOD:
sealed class ExampleEvent {
  ...
}
```

#### add_bloc_postfix
The `Bloc` class must have a `Bloc` postfix.
```dart
// BAD:
class ExampleBlc extends Bloc<ExampleEvent, ExampleState> {
  ...
}

// GOOD:
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ...
}
```

#### add_class_postfix_by_keyword_list
Classes that contain keywords from the list must have the appropriate postfix.\
Example:
```yaml
add_class_postfix_by_keyword_list:
  -
    keywordList:
      - base
    name: Base
```
```dart
// BAD:
base class Example {
  ...
}

// GOOD:
base class ExampleBase {
  ...
}
```

#### add_class_postfix_by_path_list
Classes that are located along the path from the list must have the appropriate postfix.
Example:
```yaml
add_class_postfix_by_path_list:
  -
    nameList:
      - Model
    path: lib/src
```
```dart
// BAD:
base class Example {
  ...
}

// GOOD:
base class ExampleModel {
  ...
}
```

#### add_class_prefix_by_keyword_list
Classes that contain keywords from the list must be prefixed accordingly.\
Example:
```yaml
add_class_prefix_by_keyword_list:
  -
    keywordList:
      - abstract
      - interface
      - sealed
    name: I
```
```dart
// BAD:
interface class Example {
  ...
}

// GOOD:
interface class IExample {
  ...
}
```

#### add_class_prefix_by_path_list
Classes that are located along the path from the list must have the appropriate prefix.
Example:
```yaml
add_class_prefix_by_keyword_list:
  -
    nameList:
      - Main
    path: lib/src
```
```dart
// BAD:
interface class Example {
  ...
}

// GOOD:
interface class MainExample {
  ...
}
```

#### add_comma
There must be a comma at the end of the parameter list.
```dart
// BAD:
(a, b) {}

void exampleFunction({required String argument}) {
  print("Hello World!");
}

// GOOD:
(
  a, 
  b,
) {}

void exampleFunction({
  required String argument,
}) {
  print(
    "Hello World!",
  );
}
```

#### add_const_constructor
A class that has all final fields must have a const constructor.
```dart
// BAD:
class Example {
  Example({
    required this.title,
  });

  final String title;
}


// GOOD:
class Example {
  const Example({
    required this.title,
  });

  final String title;
}
```

#### add_const
Global variables, static fields, variables in functions, and objects that have the final keyword and can be constants must have the `const` keyword.
```dart
// BAD:
final Example topLevel = Example(
  title: "Title",
);

class Example {
  static final String subTitle = "SubTitle";

  const Example({
    required this.title,
  });

  final String title;
}

void exampleFunction() {
  final Example function = Example(
    title: "Title",
  );
}

// GOOD:
const Example topLevel = Example(
  title: "Title",
);

class Example {
  static const String title = "SubTitle";

  const Example();
}

void exampleFunction() {
  const Example function = Example(
    title: "Title",
  );
}
```

#### add_constructor
All classes must have an explicit constructor.
```dart
// BAD:
class Example {}

// GOOD:
class Example {
  Example();
}
```

#### add_controller_postfix
The `ChangeNotifier`/`ValueNotifier` class must have a `Controller` postfix.

```dart
// BAD:
class ExampleNotifier extends ChangeNotifier {}

// GOOD:
class ExampleController extends ChangeNotifier {}
```

#### add_cubit_postfix
The `Cubit` class must have the `Cubit` postfix.
```dart
// BAD:
class ExampleCub extends Cubit<ExampleState> {
  ...
}

// GOOD:
class ExampleCubit extends Cubit<ExampleState> {
  ...
}
```

#### add_extension_postfix
The extension must have the `Extension` postfix.
```dart
// BAD:
extension ExampleX on Object {}

// GOOD:
extension ExampleExtension on Object {}
```

#### add_if_braces
The if expression must have parentheses.
```dart
// BAD:
if (list.isEmpty) return;

// GOOD:
if (list.isEmpty) {
  return;
}
```

#### add_mixin_postfix
A mixin must have a `Mixin` postfix.
```dart
// BAD:
mixin StringMix on Object {}

// GOOD:
mixin StringMixin on Object {}
```

#### add_override
Fields and methods of a class overridden from the base one must have the `@override` annotation.
```dart
// BAD:
class Example {
  String toString() => "";
}

// GOOD:
class Example {
  @override
  String toString() => "";
}

```

#### add_this
Within a class, access to internal fields and methods must begin with the `this` keyword.
```dart
// BAD:
class Example {
  ...

  final String title;

  @override
  String toString() => title;
}

// GOOD:
class Example {
  ...

  final String title;

  @override
  String toString() => this.title;
}
```

#### add_type
Variables and parameters of closures must have a type.
```dart
// BAD:
void exampleFunction(
  field,
) {
  final variable = "";
}

// GOOD:
void exampleFunction(
  dynamic field,
) {
  final String variable = "";
}
```


### Delete rules
#### delete_bloc_cubit_dependent_bloc_cubit
Need to remove the `Bloc`/`Cubit` dependency in the `Bloc`/`Cubit` class.
```dart
// BAD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc({
    required AnotherBloc anotherbloc,
  })  : this._anotherbloc = anotherbloc,
        super(
          const ExampleLoadingState(),
        );

  final AnotherBloc _anotherbloc;
}

// GOOD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc() : super(
    const ExampleLoadingState(),
  );
}
```

#### delete_bloc_cubit_dependent_flutter
Need to remove the `Flutter` resource dependency in the `Bloc`/`Cubit` class.
```dart
// BAD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc({
    required TextEditingController textController,
  })  : this._textController = textController,
        super(
          const ExampleLoadingState(),
        );

  final TextEditingController _textController;
}

// GOOD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc() : super(
    const ExampleLoadingState(),
  );
}
```

#### delete_bloc_cubit_public_property
Need to remove public properties in the `Bloc`/`Cubit` class.
```dart
// BAD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc({
    required this.publicProperty,
  })  :  super(
          const ExampleLoadingState(),
        );

  final String publicProperty;
}

// GOOD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc() : super(
    const ExampleLoadingState(),
  );
}
```

#### delete_class_postfix_list
Need to remove the class postfix included in the list.
```dart
// BAD:
class ExampleModel {
  const ExampleModel();
}

// GOOD:
class Example {
  const Example();
}
```

#### delete_class_prefix_list
Need to remove the class prefix included in the list.
```dart
// BAD:
class ModelExample {
  const ModelExample();
}

// GOOD:
class Example {
  const Example();
}
```

#### delete_function_list
Need to remove a function from the list.
```dart
// BAD:
void exampleFunction() {
  print(something);
}

// GOOD:
void exampleFunction() {}
```

#### delete_new
Need to remove the `new` keyword when creating the instance.
```dart
// BAD:
final ExampleClass example = new ExampleClass();

// GOOD:
final ExampleClass example = ExampleClass();
```

#### delete_package_list
Need to remove the package that is on the list.
```yaml
# BAD:
dependencies:
  bloc:
  get:
  get_it:
  fpdart:
  hive:

# GOOD:
dependencies:
  bloc:
```

#### delete_type_list
Need to remove a type from the list.
```dart
// BAD:
return Scaffold(
  body: Container(
    ... ,
  ),
);

// GOOD:
return Scaffold(
  body: Padding(
    padding: ... ,
    child: ColorBox(
      color: ... ,
    ),
  ),
);
```

#### delete_widget_method
Need to remove the function that returns `Widget` in `StatelessWidget`, `StatefulWidget` or `State`.
```dart
// BAD:
Widget _buildRow() => Row(
  ... ,
);

// GOOD:
List<String> _entityList() => [
  ... ,
];
```

### Edit rules
#### edit_arrow_function
Need to edit the arrow function.
```dart
// BAD:
int exampleFunction() {
  return 1 + 1;
}

// GOOD:
int exampleFunction() => 1 + 1;
```

#### edit_constructor_private_named_parameter
Need to edit all parameters of the private constructor into named ones.
```dart
// BAD:
class _ExampleClass {
  const _ExampleClass(
    this.property0,
    this.property1,
  );

  ...
}

// GOOD:
class _ExampleClass {
  const _ExampleClass({
    required this.property0,
    required this.property1,
  });

  ...
}
```

#### edit_constructor_public_named_parameter
Need to edit all parameters of the public constructor into named ones.
```dart
// BAD:
class ExampleClass {
  const ExampleClass(
    this.property0,
    this.property1,
  );

  ...
}

// GOOD:
class ExampleClass {
  const ExampleClass({
    required this.property0,
    required this.property1,
  });

  ...
}
```

#### edit_file_length_by_path_list
Need to edit the file located along the path to the allowable code length.

#### edit_function_private_named_parameter
Need to edit all parameters of a private function into named ones.
```dart
// BAD:
void _exampleFunction(
  String argument0,
  String argument1,
) {
  ...
}

// GOOD:
void _exampleFunction({
  required String argument0,
  required String argument1,
}) {
  ...
}
```

#### edit_function_public_named_parameter
Need to edit all parameters of a public function into named ones.
```dart
// BAD:
void exampleFunction(
  String argument0,
  String argument1,
) {
  ...
}

// GOOD:
void exampleFunction({
  required String argument0,
  required String argument1,
}) {
  ...
}
```

#### edit_multiple_variable
Need to edit the declaration of the list of variables into separate ones.
```dart
// BAD:
final String variable0, variable1, variable2 = "";

// GOOD:
final String variable0 = "";
final String variable1 = "";
final String variable2 = "";
```

#### edit_private_in_function
Need to edit a private variable to public in a function.
```dart
// BAD:
void exampleFunction() {
  final String _variable = "";
}

// GOOD:
void exampleFunction() {
  final String variable = "";
}
```

#### edit_relative_import
Need to edit relative import to absolute.
```dart
// BAD:
import '../src/example.dart';

// GOOD:
import 'package:example/src/example.dart';
```

#### edit_variable_name_by_type
You need to edit the variable name based on its type.
Exceptions - resources form Dart and Flutter SDK.
```dart
// BAD:
final ExampleClass a = ExampleClass();

// GOOD:
final ExampleClass example = ExampleClass();
```

### Other
#### Priority
The priority of displayed commands in the IDE.

## Additional information
For debugging analyzer, you'll have to update your `analysis_options.yaml` as followed:
```yaml
custom_lint:
  debug: true
```
A file `custom_lint.log` that records analyzer errors will automatically appear in the project.\
Be sure to attach the log from this file if errors occur.\
Feel free to open an issue if you find any bugs or errors or suggestions.