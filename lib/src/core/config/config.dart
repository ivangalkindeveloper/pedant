import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/keyword_list_name_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';

// AddFinal
// EditVariableName

class Config {
  const Config({
    this.addBlocCubitPart = true,
    this.addBlocCubitStatePostfix = true,
    this.addBlocCubitStateSealed = true,
    this.addBlocEventPostfix = true,
    this.addBlocEventSealed = true,
    this.addBlocPostfix = true,
    //
    this.addClassPostfixByKeywordList,
    this.addClassPostfixByPathList,
    this.addClassPrefixByKeywordList,
    this.addClassPrefixByPathList,
    this.addComma = true,
    this.addConstConstructor = true,
    this.addConstVariable = true,
    this.addConstructor = true,
    this.addControllerPostfix = true,
    this.addCubitPostfix = true,
    this.addExtensionPostfix = true,
    this.addIfBraces = true,
    this.addMixinPostfix = true,
    this.addOverride = true,
    this.addThis = true,
    this.addType = true,
    //
    this.deleteBlocCubitDependentBlocCubit = true,
    this.deleteBlocCubitDependentFlutter = true,
    this.deleteBlocCubitPublicProperty = true,
    this.deleteClassPostfixList,
    this.deleteClassPrefixList,
    this.deleteFunctionList,
    this.deleteNew = true,
    this.deletePackageList,
    this.deleteTypeList,
    this.deleteWidgetFunction = true,
    //
    this.editArrowFunction = true,
    this.editContructorPrivateNamedParameter = true,
    this.editContructorPublicNamedParameter = true,
    this.editFunctionPrivateNamedParameter = true,
    this.editFunctionPublicNamedParameter = true,
    this.editMultipleVariable = true,
    this.editPrivateInFunction = true,
    this.editRelativeImport = true,
    this.editFileLengthByPathList,
    //
    this.priority = 100,
  });

  final bool addBlocCubitPart; //
  final bool addBlocCubitStatePostfix; //
  final bool addBlocCubitStateSealed; //
  final bool addBlocEventPostfix; //
  final bool addBlocEventSealed; //
  final bool addBlocPostfix; //
  //
  final List<KeywordListNameItem>? addClassPostfixByKeywordList; //
  final List<PathNameListItem>? addClassPostfixByPathList; //
  final List<KeywordListNameItem>? addClassPrefixByKeywordList; //
  final List<PathNameListItem>? addClassPrefixByPathList; //
  final bool addComma; //
  final bool addConstConstructor; //
  final bool addConstVariable;
  final bool addConstructor; //
  final bool addControllerPostfix; //
  final bool addCubitPostfix; //
  final bool addExtensionPostfix; //
  final bool addIfBraces; //
  final bool addMixinPostfix; //
  final bool addOverride; //
  final bool addThis; //
  final bool addType; //
  //
  final bool deleteBlocCubitDependentBlocCubit; //
  final bool deleteBlocCubitDependentFlutter; //
  final bool deleteBlocCubitPublicProperty; //
  final List<DeleteListItem>? deleteClassPostfixList; //
  final List<DeleteListItem>? deleteClassPrefixList; //
  final List<DeleteListItem>? deleteFunctionList; //
  final bool deleteNew; //
  final List<DeleteListItem>? deletePackageList; //
  final List<DeleteListItem>? deleteTypeList; //
  final bool deleteWidgetFunction; //
  //
  final bool editArrowFunction; //
  final bool editContructorPrivateNamedParameter; //
  final bool editContructorPublicNamedParameter; //
  final bool editFunctionPrivateNamedParameter; //
  final bool editFunctionPublicNamedParameter; //
  final bool editMultipleVariable; //
  final bool editPrivateInFunction; //
  final bool editRelativeImport; //
  final List<LengthItem>? editFileLengthByPathList; //
  //
  final int priority;

  factory Config.fromYaml({
    required Map<String, dynamic> map,
  }) =>
      Config(
        addBlocCubitPart: map["add_bloc_cubit_part"] ?? true,
        addBlocCubitStatePostfix: map["add_bloc_cubit_state_postfix"] ?? true,
        addBlocCubitStateSealed: map["add_bloc_cubit_state_sealed"] ?? true,
        addBlocEventPostfix: map["add_bloc_event_postfix"] ?? true,
        addBlocEventSealed: map["add_bloc_event_sealed"] ?? true,
        addBlocPostfix: map["add_bloc_postfix"] ?? true,
        //
        addClassPostfixByKeywordList:
            (map["add_class_postfix_by_keyword_list"] as List?)
                ?.map(
                  (e) => KeywordListNameItem.fromYaml(e),
                )
                .toList(),
        addClassPostfixByPathList:
            (map["add_class_postfix_by_path_list"] as List?)
                ?.map(
                  (e) => PathNameListItem.fromYaml(e),
                )
                .toList(),
        addClassPrefixByKeywordList:
            (map["add_class_prefix_by_keyword_list"] as List?)
                ?.map(
                  (e) => KeywordListNameItem.fromYaml(e),
                )
                .toList(),
        addClassPrefixByPathList:
            (map["add_class_prefix_by_path_list"] as List?)
                ?.map(
                  (e) => PathNameListItem.fromYaml(e),
                )
                .toList(),
        addComma: map["add_comma"] ?? true,
        addConstConstructor: map["add_const_constructor"] ?? true,
        addConstVariable: map["add_const_variable"] ?? true,
        addConstructor: map["add_constructor"] ?? true,
        addControllerPostfix: map["add_controller_postfix"] ?? true,
        addCubitPostfix: map["add_cubit_postfix"] ?? true,
        addExtensionPostfix: map["add_extension_postfix"] ?? true,
        addIfBraces: map["add_if_braces"] ?? true,
        addMixinPostfix: map["add_mixin_postfix"] ?? true,
        addOverride: map["add_override"] ?? true,
        addThis: map["add_this"] ?? true,
        addType: map["add_type"] ?? true,
        //
        deleteBlocCubitDependentBlocCubit:
            map["delete_bloc_cubit_dependent_bloc_cubit"] ?? true,
        deleteBlocCubitDependentFlutter:
            map["delete_bloc_cubit_dependent_flutter"] ?? true,
        deleteBlocCubitPublicProperty:
            map["delete_bloc_cubit_public_property"] ?? true,
        deleteClassPostfixList: (map["delete_class_postfix_list"] as List?)
            ?.map(
              (e) => DeleteListItem.fromYaml(e),
            )
            .toList(),
        deleteClassPrefixList: (map["delete_class_prefix_list"] as List?)
            ?.map(
              (e) => DeleteListItem.fromYaml(e),
            )
            .toList(),
        deleteFunctionList: (map["delete_function_list"] as List?)
            ?.map(
              (e) => DeleteListItem.fromYaml(e),
            )
            .toList(),
        deleteNew: map["delete_new"] ?? true,
        deletePackageList: (map["delete_package_list"] as List?)
            ?.map(
              (e) => DeleteListItem.fromYaml(e),
            )
            .toList(),
        deleteTypeList: (map["delete_type_list"] as List?)
            ?.map(
              (e) => DeleteListItem.fromYaml(e),
            )
            .toList(),
        deleteWidgetFunction: map["delete_widget_function"] ?? true,
        //
        editArrowFunction: map["edit_arrow_function"] ?? true,
        editContructorPrivateNamedParameter:
            map["edit_constructor_private_named_parameter"] ?? true,
        editContructorPublicNamedParameter:
            map["edit_constructor_public_named_parameter"] ?? true,
        editFunctionPrivateNamedParameter:
            map["edit_function_private_named_parameter"] ?? true,
        editFunctionPublicNamedParameter:
            map["edit_function_public_named_parameter"] ?? true,
        editMultipleVariable: map["edit_multiple_variable"] ?? true,
        editPrivateInFunction: map["edit_private_in_function"] ?? true,
        editRelativeImport: map["edit_relative_import"] ?? true,
        editFileLengthByPathList:
            (map["edit_file_length_by_path_list"] as List?)
                ?.map(
                  (e) => LengthItem.fromYaml(e),
                )
                .toList(),
        //
        priority: map["priority"] ?? 100,
      );
}
