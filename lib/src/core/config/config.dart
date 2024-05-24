import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';
import 'package:pedant/src/core/data/type_list_name_item.dart';

class Config {
  const Config({
    this.addConstructor = true,
    this.addConst = true,
    this.addType = true,
    this.addOverride = true,
    this.addFinal = true,
    this.addThis = true,
    this.editArrowFunctions = true,
    this.editRequiredProperties = true,
    this.addIfBracets = true,
    //
    this.addTypePrefixList,
    this.addTypePostfixList,
    this.addPathPrefixList,
    this.addPathPostfixList,
    //
    this.addBlocPart = true,
    this.addBlocSealedEvent = true,
    this.addBlocSealedState = true,
    //
    this.deleteBlocDependentBloc = true,
    this.deleteBlocDependentFlutter = true,
    this.deleteBlocPublicProperty = true,
    //
    this.deleteFunctionList,
    this.editMultipleVariable = true,
    this.deleteNew = true,
    this.deletePackageList,
    this.deletePostfixList,
    this.deletePrefixList,
    this.editPrivateInFunction = true,
    this.editRelativeImport = true,
    this.deleteTypeList,
    //
    this.lengthList,
    this.priority = 100,
  });

  final bool addBlocPart;
  final bool addBlocSealedEvent;
  final bool addBlocSealedState;
  //
  final bool addConst;
  final bool addConstructor; // +
  final bool addFinal;
  final bool addIfBracets;
  final bool addOverride; // +
  final List<PathNameListItem>? addPathPostfixList; // +
  final List<PathNameListItem>? addPathPrefixList; // +
  final bool addThis;
  final bool addType; // +
  final List<TypeListNameItem>? addTypePostfixList; // +
  final List<TypeListNameItem>? addTypePrefixList; // +
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
  //
  final List<LengthItem>? lengthList; // +
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
        addPathPostfixList: json?["add_path_postfix_list"],
        addPathPrefixList: json?["add_path_prefix_list"],
        addThis: json?["add_this"] ?? true,
        addType: json?["add_type"] ?? true,
        addTypePostfixList: json?["add_type_postfix_list"],
        addTypePrefixList: json?["add_type_prefix_list"],
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
        //
        lengthList: json?["length_list"],
        //
        priority: json?["priority"] ?? 100,
      );
}
