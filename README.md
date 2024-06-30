# Pedant
Строгий статический анализатор и скрипт для форматирования Dart кода.\
Призван решать проблемы в проекте на этапах проектирования и поддержки.

Анализатор:
 - строгие архитектурные правила;
 - строгие стилистические правила;
 - не строгие правила подходов.

Скрипт:
 - aвтоматические решение обнаруженных ошибок линтера;
 - сортировка в алфавитном порядке полей .arb файлов;
 - сортировка в алфавитном порядке деклараций импоротов, экспортов и частей;
 - сортировка в алфавитном порядке ключей dependencies, dev_dependencies, dependency_overrides в pubspec.yaml;
 - форматирование Dart кода.


## Get started

### Installing
1) Добавьте два пакета в pubspec.yaml файл в раздел dev_dependencies:
```yaml
dev_dependencies:
  custom_lint: ^latest_version
  pedant: ^latest_version
```

2) Добавьте в файл analysis_options.yaml включение кастомного анализатора:
```yaml
custom_lint:
  rules:
    - pedant:
```

Желательно после подключения анализатора перезапустить IDE.

### Config
Полная конфигурация правил может выглядеть так:

### CLI
Скрипт спроектирован с точки зрения максимального охвата и наведения порядка в проекте.\
Запустите скрипт:
```shell
dart run pedant
```

Аргументы:
```shell
 --no-fix - отключение решения проанализированных проблем линтера;\
 --no-sort-arb-files - отключение сортировки .arb файлов;\
 --no-sort-dart-import-declarations - отключение сортировки деклараций импортов .dart файлов;\
 --no-sort-pubspec-dependencies - отключение сортировки зависимостей в pubspec.yaml файле;\
 --no-dart-format - отключение итогового форматирования на этапе завершения скрипта;
```

## Rules
### Add
#### add_bloc_cubit_part
Класс состояния и события Bloc/Cubit должны находится либо в одном файле, либо в одной зоне видимости через part/part of.

```dart
// BAD:

// GOOD:
```

#### add_bloc_cubit_state_postfix
Класс состояния Bloc/Cubit должно иметь постфикс State.

```dart
// BAD:

// GOOD:
```

#### add_bloc_cubit_state_sealed
Класс состояния Bloc/Cubit должно быть объявлены ключевым словом sealed.

```dart
// BAD:

// GOOD:
```

#### add_bloc_event_postfix
Класс события Bloc должно иметь постфикс Event.

```dart
// BAD:

// GOOD:
```

#### add_bloc_event_sealed
Класс события Bloc должно быть объявлены ключевым словом sealed.

```dart
// BAD:

// GOOD:
```

#### add_bloc_postfix
Класс Bloc должен иметь постфикс Bloc.

```dart
// BAD:

// GOOD:
```

#### add_class_postfix_by_keyword_list
Класс, который содержат ключевые слова из списка, должнен иметь соответствующий постфикс.

```dart
// BAD:

// GOOD:
```

#### add_class_postfix_by_path_list
Класс, который находится по пути из списка, должен иметь соответствующий постфикс.

```dart
// BAD:

// GOOD:
```

#### add_class_prefix_by_keyword_list
Класс, который содержит ключевые слова из списка, должен иметь соответствующий префикс.

```dart
// BAD:

// GOOD:
```

#### add_class_prefix_by_path_list
Класс, который находится по пути из списка, должен иметь соответствующий префикс.

```dart
// BAD:

// GOOD:
```

#### add_comma
В конце списка параметров должна быть запятая.

```dart
// BAD:

// GOOD:
```

#### add_const_constructor
Класс, имеющий все поля final поля должен иметь const конструктор.

```dart
// BAD:

// GOOD:
```

#### add_const
Глобальные переменные, статические поля, переменные в функциях и объекты, имеющие ключевое слово final и способные быть константами, должны иметь ключевое слово const.

```dart
// BAD:

// GOOD:
```

#### add_controller_postfix
Класс ChangeNotifier/ValueNotifier должен иметь постфикс Controller. 

```dart
// BAD:

// GOOD:
```

#### add_cubit_postfix
Класс Cubit должен иметь постфикс Cubit.

```dart
// BAD:

// GOOD:
```

#### add_extension_postfix
Расширение должно иметь постфикс Extension.

```dart
// BAD:

// GOOD:
```

#### add_if_braces
Выражение if должно иметь скобочки.

```dart
// BAD:

// GOOD:
```

#### add_mixin_postfix
Миксин должен иметь постфикс Mixin.

```dart
// BAD:

// GOOD:
```

#### add_override
Поля и методы класса, переопределенные от базового, должны иметь аннотацию @override.

```dart
// BAD:

// GOOD:
```

#### add_static
Поле класса, имеющую инициализацию, должно начинаться с ключевого слова static.

```dart
// BAD:

// GOOD:
```

#### add_this
В пределах класса, доступ к внутренним полям и методам должен начинатся с ключевого слова this.

```dart
// BAD:

// GOOD:
```

#### add_type
Переменные и параметры замыканий должны иметь тип.

```dart
// BAD:

// GOOD:
```


### Delete
#### delete_bloc_cubit_dependent_bloc_cubit
Необходимо удалить Bloc/Cubit зависимосить в классе Bloc/Cubit.

```dart
// BAD:

// GOOD:
```

#### delete_bloc_cubit_dependent_flutter
Необходимо удалить зависимосить Flutter ресурсов в классе Bloc/Cubit.

```dart
// BAD:

// GOOD:
```

#### delete_bloc_cubit_public_property
Необходимо удалить публичные свойства в классе Bloc/Cubit.

```dart
// BAD:

// GOOD:
```

#### delete_class_postfix_list
Необходимо удалить постфикс класса, входящий в список.

```dart
// BAD:

// GOOD:
```

#### delete_class_prefix_list
Необходимо удалить префикс класса, входящий в список.

```dart
// BAD:

// GOOD:
```

#### delete_function_list
Необходимо удалить функцию, входящий в список.

```dart
// BAD:

// GOOD:
```

#### delete_new
Необходимо удалить ключевое слово new при создании экземляра.

```dart
// BAD:

// GOOD:
```

#### delete_package_list
Необходимо удалить пакет, входящий в список.

```dart
// BAD:

// GOOD:
```

#### delete_type_list
Необходимо удалить тип, входящий в список.

```dart
// BAD:

// GOOD:
```

#### delete_widget_function_method
Необходимо удалить функцию, которая возвращает Widget.

```dart
// BAD:

// GOOD:
```

### Edit
#### edit_arrow_function
Необходимо отредактировать функцию в стрелочную.

```dart
// BAD:

// GOOD:
```

#### edit_constructor_private_named_parameter
Необходимо отредактировать все параметры приватного конструктора в именованные.

```dart
// BAD:

// GOOD:
```

#### edit_constructor_public_named_parameter
Необходимо отредактировать все параметры публичного конструктора в именованные.

```dart
// BAD:

// GOOD:
```

#### edit_file_length_by_path_list
Необходимо отредактировать файл, находящийся по пути, на допустимую длину кода.

```dart
// BAD:

// GOOD:
```

#### edit_function_private_named_parameter
Необходимо отредактировать все параметры приватной функции в именованные.

```dart
// BAD:

// GOOD:
```

#### edit_function_public_named_parameter
Необходимо отредактировать все параметры публичной функции в именованные.

```dart
// BAD:

// GOOD:
```

#### edit_multiple_variable
Необходимо отредактировать объявление списка переменных в раздельные.

```dart
// BAD:

// GOOD:
```

#### edit_private_in_function
Необходимо отредактировать приватную переменную в функции.

```dart
// BAD:

// GOOD:
```

#### edit_relative_import
Необходимо отредактировать относительный импорт в абсолютный.

```dart
// BAD:

// GOOD:
```

#### edit_variable_name_by_type
Необходимо отредактировать имя переменной по ее типу.

```dart
// BAD:

// GOOD:
```

### Other
#### Priority
Приоритет отображаемых команд в IDE.