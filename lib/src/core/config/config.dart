import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/keyword_list_name_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';

class Config {
  const Config({
    this.addBlocEventPostfix = true,
    this.addBlocEventSealed = true,
    this.addBlocPart = true,
    this.addBlocPostfix = true,
    this.addBlocStatePostfix = true,
    this.addBlocStateSealed = true,
    //
    this.addClassPostfixByKeywordList,
    this.addClassPostfixByPathList,
    this.addClassPrefixByKeywordList,
    this.addClassPrefixByPathList,
    this.addComma = true,
    this.addConstConstructor = true,
    this.addConstVariable = true,
    this.addConstructor = true,
    this.addCubitPostfix = true,
    this.addExtensionPostfix = true,
    // this.addFinal = true,
    this.addIfBraces = true,
    this.addMixinPostfix = true,
    this.addOverride = true,
    this.addThis = true,
    this.addType = true,
    //
    this.deleteBlocDependentBloc = true,
    this.deleteBlocDependentFlutter = true,
    this.deleteBlocPublicProperty = true,
    this.deleteClassPostfixList,
    this.deleteClassPrefixList,
    this.deleteFunctionList,
    this.deleteNew = true,
    this.deletePackageList,
    this.deleteTypeList,
    //
    this.editArrowFunction = true,
    this.editContructorPrivateNamedParameter = true,
    this.editContructorPublicNamedParameter = true,
    this.editFunctionPrivateNamedParameter = true,
    this.editFunctionPublicNamedParameter = true,
    this.editMultipleVariable = true,
    this.editPrivateInFunction = true,
    this.editRelativeImport = true,
    this.editLengthFile,
    //
    this.priority = 100,
  });

  final bool addBlocEventPostfix; //
  final bool addBlocEventSealed; //
  final bool addBlocPart;
  final bool addBlocPostfix; //
  final bool addBlocStatePostfix; //
  final bool addBlocStateSealed; //
  //
  final List<KeywordListNameItem>? addClassPostfixByKeywordList; //
  final List<PathNameListItem>? addClassPostfixByPathList; //
  final List<KeywordListNameItem>? addClassPrefixByKeywordList; //
  final List<PathNameListItem>? addClassPrefixByPathList; //
  final bool addComma; //
  final bool addConstConstructor; //
  final bool addConstVariable; // ?
  final bool addConstructor; //
  final bool addCubitPostfix; //
  final bool addExtensionPostfix; //
  // final bool addFinal;
  final bool addIfBraces; //
  final bool addMixinPostfix; //
  final bool addOverride; //
  final bool addThis; // ?
  final bool addType; //
  //
  final bool deleteBlocDependentBloc; //
  final bool deleteBlocDependentFlutter; //
  final bool deleteBlocPublicProperty; //
  final List<DeleteListItem>? deleteClassPostfixList; //
  final List<DeleteListItem>? deleteClassPrefixList; //
  final List<DeleteListItem>? deleteFunctionList; //
  final bool deleteNew; //
  final List<DeleteListItem>? deletePackageList; //
  final List<DeleteListItem>? deleteTypeList; //
  //
  final bool editArrowFunction; //
  final bool editContructorPrivateNamedParameter; //
  final bool editContructorPublicNamedParameter; //
  final bool editFunctionPrivateNamedParameter; //
  final bool editFunctionPublicNamedParameter; //
  final bool editMultipleVariable; //
  final bool editPrivateInFunction; //
  final bool editRelativeImport; //
  final List<LengthItem>? editLengthFile;
  //
  final int priority;

  factory Config.fromYaml({
    required Map<String, dynamic> map,
  }) =>
      Config(
        addBlocEventPostfix: map["add_bloc_event_postfix"] ?? true,
        addBlocEventSealed: map["add_bloc_event_sealed"] ?? true,
        addBlocPart: map["add_bloc_part"] ?? true,
        addBlocPostfix: map["add_bloc_postfix"] ?? true,
        addBlocStatePostfix: map["add_bloc_state_postfix"] ?? true,
        addBlocStateSealed: map["add_bloc_state_sealed"] ?? true,
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
        addCubitPostfix: map["add_cubit_postfix"] ?? true,
        addExtensionPostfix: map["add_extension_postfix"] ?? true,
        // addFinal: map["add_final"] ?? true,
        addIfBraces: map["add_if_braces"] ?? true,
        addMixinPostfix: map["add_mixin_postfix"] ?? true,
        addOverride: map["add_override"] ?? true,
        addThis: map["add_this"] ?? true,
        addType: map["add_type"] ?? true,
        //
        deleteBlocDependentBloc: map["delete_bloc_dependent_bloc"] ?? true,
        deleteBlocDependentFlutter:
            map["delete_bloc_dependent_flutter"] ?? true,
        deleteBlocPublicProperty: map["delete_bloc_public_property"] ?? true,
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
        editLengthFile: (map["edit_length_file"] as List?)
            ?.map(
              (e) => LengthItem.fromYaml(e),
            )
            .toList(),
        //
        priority: map["priority"] ?? 100,
      );
}
