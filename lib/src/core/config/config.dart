import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/keyword_list_name_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';

class Config {
  const Config({
    this.addBlocPart = true,
    this.addBlocSealedEvent = true,
    this.addBlocSealedState = true,
    //
    this.addClassPostfixByKeywordList,
    this.addClassPostfixByPathList,
    this.addClassPrefixByKeywordList,
    this.addClassPrefixByPathList,
    this.addConstConstructor = true,
    this.addConstVariable = true,
    this.addConstructor = true,
    this.addFinal = true,
    this.addIfBracets = true,
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
    this.editArrowFunctions = true,
    this.editMultipleVariable = true,
    this.editPrivateInFunction = true,
    this.editRelativeImport = true,
    this.editRequiredProperties = true,
    this.editLengthFile,
    //
    this.priority = 100,
  });

  final bool addBlocPart;
  final bool addBlocSealedEvent;
  final bool addBlocSealedState;
  //
  final List<KeywordListNameItem>? addClassPostfixByKeywordList; //
  final List<PathNameListItem>? addClassPostfixByPathList; //
  final List<KeywordListNameItem>? addClassPrefixByKeywordList; //
  final List<PathNameListItem>? addClassPrefixByPathList; //
  final bool addConstConstructor; //
  final bool addConstVariable;
  final bool addConstructor; //
  final bool addFinal;
  final bool addIfBracets;
  final bool addOverride; // +
  final bool addThis;
  final bool addType; // +
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
  final bool editArrowFunctions;
  final bool editMultipleVariable; //
  final bool editPrivateInFunction; //
  final bool editRelativeImport; //
  final bool editRequiredProperties; // +
  final List<LengthItem>? editLengthFile; // +
  //
  final int priority;

  factory Config.fromJson({
    required Map<String, dynamic>? json,
  }) =>
      Config(
        addBlocPart: json?["add_bloc_part"] ?? true,
        addBlocSealedEvent: json?["add_bloc_sealed_event"] ?? true,
        addBlocSealedState: json?["add_bloc_sealed_state"] ?? true,
        //
        addClassPostfixByKeywordList:
            json?["add_class_postfix_by_keyword_list"],
        addClassPostfixByPathList: json?["add_class_postfix_by_path_list"],
        addClassPrefixByKeywordList: json?["add_class_prefix_by_keyword_list"],
        addClassPrefixByPathList: json?["add_class_prefix_by_path_list"],
        addConstConstructor: json?["add_const_constructor"] ?? true,
        addConstVariable: json?["add_const_variable"] ?? true,
        addConstructor: json?["add_constructor"] ?? true,
        addFinal: json?["add_final"] ?? true,
        addIfBracets: json?["add_if_bracets"] ?? true,
        addOverride: json?["add_override"] ?? true,
        addThis: json?["add_this"] ?? true,
        addType: json?["add_type"] ?? true,
        //
        deleteBlocDependentBloc: json?["delete_bloc_dependent_bloc"] ?? true,
        deleteBlocDependentFlutter:
            json?["delete_bloc_dependent_flutter"] ?? true,
        deleteBlocPublicProperty: json?["delete_bloc_public_property"] ?? true,
        deleteClassPostfixList: json?["delete_class_postfix_list"],
        deleteClassPrefixList: json?["delete_class_prefix_list"],
        deleteFunctionList: json?["delete_function_list"],
        deleteNew: json?["delete_new"] ?? true,
        deletePackageList: json?["delete_package_list"],
        deleteTypeList: json?["delete_type_list"],
        //
        editArrowFunctions: json?["edit_arrow_functions"] ?? true,
        editMultipleVariable: json?["edit_multiple_variable"] ?? true,
        editPrivateInFunction: json?["edit_private_in_function"] ?? true,
        editRelativeImport: json?["edit_relative_import"] ?? true,
        editRequiredProperties: json?["edit_required_properties"] ?? true,
        editLengthFile: json?["edit_length_file"],
        //
        priority: json?["priority"] ?? 100,
      );
}
