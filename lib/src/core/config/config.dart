import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';
import 'package:pedant/src/core/data/type_list_name_item.dart';

class Config {
  const Config({
    this.addBlocPart = true,
    this.addBlocSealedEvent = true,
    this.addBlocSealedState = true,
    //
    this.addConst = true,
    this.addConstructor = true,
    this.addFinal = true,
    this.addIfBracets = true,
    this.addOverride = true,
    this.addPostfixByPathList,
    this.addPostfixByTypeList,
    this.addPrefixByPathList,
    this.addPrefixByTypeList,
    this.addThis = true,
    this.addType = true,
    //
    this.deleteBlocDependentBloc = true,
    this.deleteBlocDependentFlutter = true,
    this.deleteBlocPublicProperty = true,
    this.deleteFunctionList,
    this.deleteNew = true,
    this.deletePackageList,
    this.deletePostfixList,
    this.deletePrefixList,
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
  final bool addConst;
  final bool addConstructor; //
  final bool addFinal;
  final bool addIfBracets;
  final bool addOverride; // +
  final List<PathNameListItem>? addPostfixByPathList; // +
  final List<TypeListNameItem>? addPostfixByTypeList; // +
  final List<PathNameListItem>? addPrefixByPathList; // +
  final List<TypeListNameItem>? addPrefixByTypeList; // +
  final bool addThis;
  final bool addType; // +
  //
  final bool deleteBlocDependentBloc; //
  final bool deleteBlocDependentFlutter; //
  final bool deleteBlocPublicProperty; //
  final List<DeleteListItem>? deleteFunctionList; //
  final bool deleteNew; //
  final List<DeleteListItem>? deletePackageList; //
  final List<DeleteListItem>? deletePostfixList; //
  final List<DeleteListItem>? deletePrefixList; //
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
        addConst: json?["add_const"] ?? true,
        addConstructor: json?["add_constructor"] ?? true,
        addFinal: json?["add_final"] ?? true,
        addIfBracets: json?["add_if_bracets"] ?? true,
        addOverride: json?["add_override"] ?? true,
        addPostfixByPathList: json?["add_postfix_by_path_list"],
        addPostfixByTypeList: json?["add_postfix_by_type_list"],
        addPrefixByPathList: json?["add_prefix_by_path_list"],
        addPrefixByTypeList: json?["add_prefix_by_type_list"],
        addThis: json?["add_this"] ?? true,
        addType: json?["add_type"] ?? true,
        //
        deleteBlocDependentBloc: json?["delete_bloc_dependent_bloc"] ?? true,
        deleteBlocDependentFlutter:
            json?["delete_bloc_dependent_flutter"] ?? true,
        deleteBlocPublicProperty: json?["delete_bloc_public_property"] ?? true,
        deleteFunctionList: json?["delete_function_list"],
        deleteNew: json?["delete_new"] ?? true,
        deletePackageList: json?["delete_package_list"],
        deletePostfixList: json?["delete_postfix_list"],
        deletePrefixList: json?["delete_prefix_list"],
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
