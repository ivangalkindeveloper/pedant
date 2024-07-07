# Pedant
A strict static analyzer and script for formatting Dart code.\
Designed to solve problems in a project at the design and support stages.

Analyzer:
 - strict architectural rules;
 - strict stylistic rules;
 - not strict rules of approach.

Script:
 - automatic fix of detected linter errors;
 - sorting in alphabetical order of the fields of .arb files;
 - sorting in alphabetical order of declarations of imports, exports and parts;
 - sorting in alphabetical order of dependencies, dev_dependencies, dependency_overrides keys in pubspec.yaml;
 - code formatting.


## Get started
### Installing
1) Add two packages to the pubspec.yaml file in the dev_dependencies section:
```yaml
dev_dependencies:
  custom_lint: ^latest_version
  pedant: ^latest_version
```
2) Add the inclusion of a custom analyzer to the analysis_options.yaml file:
```yaml
custom_lint:
  rules:
    - pedant:
```
It is advisable to restart the IDE after connecting the analyzer.

### Config
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
      add_class_postfix_by_keyword_list:
        -
          keywordList:
            - base
          name: Base
      add_class_postfix_by_path_list: null
      add_class_prefix_by_keyword_list:
        -
          keywordList:
            - abstract
            - interface
            - sealed
          name: I
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
      add_static: true
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
      delete_widget_function_method: true
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

### CLI
The script is designed from the point of view of maximum coverage and bringing order to the project.\
Run the script:
```shell
dart run pedant
```
Arguments:
```shell
 --no-fix - disabling fix of analyzed linter problems;
 --no-sort-arb-files - disable alphabetical sorting of .arb files;
 --no-sort-dart-import-declarations - disable alphabetical sorting of declarations of imports of .dart files;
 --no-sort-pubspec-dependencies - disable alphabetical sorting dependencшуы in the pubspec.yaml file;
 --no-dart-format - disabling final formatting at the script completion stage;
```


## Rules
### Add
#### add_bloc_cubit_part
The Bloc/Cubit state and event class must be located either in the same file or in the same visibility area through part/part of.

```dart
// BAD:
import 'package:example/example_event.dart';
import 'package:example/example_state.dart';

class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ...
}

// GOOD:
import 'package:example/example_event.dart';
import 'package:example/example_state.dart';

class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ...
}

sealed class IExampleEvent {
  ...
}

sealed class IExampleState {
  ...
}

// GOOD:
part of 'example_event.dart';
part of 'example_state.dart';

class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ...
}
```

#### add_bloc_cubit_state_postfix
The Bloc/Cubit state class must have a State postfix.

```dart
// BAD:
sealed class IExampleSt {
  ...
}

// GOOD:
sealed class IExampleState {
  ...
}
```

#### add_bloc_cubit_state_sealed
The Bloc/Cubit state class must be declared with the 'sealed' keyword.

```dart
// BAD:
class ExampleState {
  ...
}

// GOOD:
sealed class IExampleState {
  ...
}
```

#### add_bloc_event_postfix
The Bloc event class must have the Event postfix.

```dart
// BAD:
sealed class IExampleEv {
  ...
}

// GOOD:
sealed class IExampleEvent {
  ...
}
```

#### add_bloc_event_sealed
The Bloc event class must be declared with the 'sealed' keyword.

```dart
// BAD:
class ExampleEvent {
  ...
}

// GOOD:
sealed class IExampleEvent {
  ...
}
```

#### add_bloc_postfix
The Bloc class must have a Bloc postfix.

```dart
// BAD:
class ExampleBlc extends Bloc<IExampleEvent, IExampleState> {
  ...
}

// GOOD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ...
}
```

#### add_class_postfix_by_keyword_list
Classes that contain keywords from the list must have the appropriate postfix.

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

#### add_class_prefix_by_keyword_list
Classes that contain keywords from the list must be prefixed accordingly.

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

#### add_comma
There must be a comma at the end of the parameter list.

```dart
// BAD:
(a, b) {}

named({required String argument}) {
  print("Hello World!");
}

// GOOD:
(
  a, 
  b,
) {}

named({
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
Global variables, static fields, variables in functions, and objects that have the final keyword and can be constants must have the 'const' keyword.

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

void doSomething() {
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

void doSomething() {
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
The ChangeNotifier/ValueNotifier class must have a Controller postfix.

```dart
// BAD:
class ExampleNotifier extends ChangeNotifier {}

// GOOD:
class ExampleController extends ChangeNotifier {}
```

#### add_cubit_postfix
The Cubit class must have the Cubit postfix.

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
The extension must have the Extension postfix.

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
A mixin must have a Mixin postfix.

```dart
// BAD:
mixin StringMix on Object {}

// GOOD:
mixin StringMixin on Object {}
```

#### add_override
Fields and methods of a class overridden from the base one must have the @override annotation.

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

#### add_static
A class field that has an initialization must begin with the 'static' keyword.

```dart
// BAD:
class Example {
  final String title = "Title";
}

// GOOD:
class Example {
  static final String title = "Title";
}
```

#### add_this
Within a class, access to internal fields and methods must begin with the this keyword.

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
void doSomething(
  field,
) {
  final variable = "";
}

// GOOD:
void doSomething(
  dynamic field,
) {
  final String variable = "";
}
```


### Delete
#### delete_bloc_cubit_dependent_bloc_cubit
Need to remove the Bloc/Cubit dependency in the Bloc/Cubit class.

```dart
// BAD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc({
    required AnotherBloc anotherbloc,
  })  : this._anotherbloc = anotherbloc,
        super(
          const ExampleLoadingState(),
        );

  final AnotherBloc _anotherbloc = AnotherBloc();
}

// GOOD:
class ExampleBloc extends Bloc<IExampleEvent, IExampleState> {
  ExampleBloc({
  }) : super(
          const ExampleLoadingState(),
        );
}
```

#### delete_bloc_cubit_dependent_flutter
Need to remove the Flutter resource dependency in the Bloc/Cubit class.

```dart
// BAD:

// GOOD:
```

#### delete_bloc_cubit_public_property
Need to remove public properties in the Bloc/Cubit class.

```dart
// BAD:

// GOOD:
```

#### delete_class_postfix_list
Need to remove the class postfix included in the list.

```dart
// BAD:

// GOOD:
```

#### delete_class_prefix_list
Need to remove the class prefix included in the list.

```dart
// BAD:

// GOOD:
```

#### delete_function_list
Need to remove a function from the list.

```dart
// BAD:

// GOOD:
```

#### delete_new
Need to remove the 'new' keyword when creating the instance.

```dart
// BAD:

// GOOD:
```

#### delete_package_list
Need to remove the package that is on the list.

```dart
// BAD:

// GOOD:
```

#### delete_type_list
Need to remove a type from the list.

```dart
// BAD:

// GOOD:
```

#### delete_widget_function_method
Need to remove the function that returns Widget.

```dart
// BAD:

// GOOD:
```

### Edit
#### edit_arrow_function
Need to edit the arrow function.

```dart
// BAD:

// GOOD:
```

#### edit_constructor_private_named_parameter
Need to edit all parameters of the private constructor into named ones.

```dart
// BAD:

// GOOD:
```

#### edit_constructor_public_named_parameter
Need to edit all parameters of the public constructor into named ones.

```dart
// BAD:

// GOOD:
```

#### edit_file_length_by_path_list
Need to edit the file located along the path to the allowable code length.

```dart
// BAD:

// GOOD:
```

#### edit_function_private_named_parameter
Need to edit all parameters of a private function into named ones.

```dart
// BAD:

// GOOD:
```

#### edit_function_public_named_parameter
Need to edit all parameters of a public function into named ones.

```dart
// BAD:

// GOOD:
```

#### edit_multiple_variable
Need to edit the declaration of the list of variables into separate ones.

```dart
// BAD:

// GOOD:
```

#### edit_private_in_function
Need to edit a private variable to public in a function.

```dart
// BAD:

// GOOD:
```

#### edit_relative_import
Need to edit relative import to absolute.

```dart
// BAD:

// GOOD:
```

#### edit_variable_name_by_type
You need to edit the variable name based on its type.

```dart
// BAD:

// GOOD:
```

### Other
#### Priority
The priority of displayed commands in the IDE.
