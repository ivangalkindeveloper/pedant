import 'package:pedant/src/core/data/delete_list_item.dart';
import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/path_name_list_item.dart';
import 'package:pedant/src/core/data/type_list_name_item.dart';

class Config {
  const Config({
    this.addAbsoluteImport = true,
    this.addConstructor = true,
    this.addConst = true,
    this.addType = true,
    this.addOverride = true,
    this.addFinal = true,
    this.addThis = true,
    this.addArrowFunctions = true,
    this.addRequiredProperties = true,
    this.addIfBracets = true,
    this.addIfIndent = true,
    this.addReturnIndent = true,
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
    this.deleteBlocDependencyInBloc = true,
    this.deleteFunctionList,
    this.deleteMultipleVariable = true,
    this.deleteNew = true,
    this.deletePackageList,
    this.deletePostfixList,
    this.deletePrefixList,
    this.deletePrivateInFunction = true,
    this.deletePublicInBloc = true,
    this.deleteTypeList,
    //
    this.lengthList,
  });

  final bool addAbsoluteImport;
  final bool addConstructor;
  final bool addConst;
  final bool addType;
  final bool addOverride;
  final bool addFinal;
  final bool addThis;
  final bool addArrowFunctions;
  final bool addRequiredProperties;
  final bool addIfBracets;
  final bool addIfIndent;
  final bool addReturnIndent;
  //
  final List<TypeListNameItem>? addTypePrefixList;
  final List<TypeListNameItem>? addTypePostfixList;
  final List<PathNameListItem>? addPathPrefixList;
  final List<PathNameListItem>? addPathPostfixList;
  //
  final bool addBlocPart;
  final bool addBlocSealedEvent;
  final bool addBlocSealedState;
  //
  final bool deleteBlocDependencyInBloc;
  final List<DeleteListItem>? deleteFunctionList; //
  final bool deleteMultipleVariable;
  final bool deleteNew; //
  final List<DeleteListItem>? deletePackageList; //
  final List<DeleteListItem>? deletePostfixList; //
  final List<DeleteListItem>? deletePrefixList; //
  final bool deletePrivateInFunction; //
  final bool deletePublicInBloc; //
  final List<DeleteListItem>? deleteTypeList; //
  //
  final List<LengthItem>? lengthList;

  factory Config.fromJson({
    required Map<String, dynamic>? json,
  }) =>
      Config(
        addAbsoluteImport: json?["add_absolute_import"] ?? true,
        addConstructor: json?["add_constructor"] ?? true,
        addConst: json?["add_const"] ?? true,
        addType: json?["add_type"] ?? true,
        addOverride: json?["add_override"] ?? true,
        addFinal: json?["add_final"] ?? true,
        addThis: json?["add_this"] ?? true,
        addArrowFunctions: json?["add_arrow_functions"] ?? true,
        addRequiredProperties: json?["add_required_properties"] ?? true,
        addIfBracets: json?["add_if_bracets"] ?? true,
        addIfIndent: json?["add_if_indent"] ?? true,
        addReturnIndent: json?["add_return_indent"] ?? true,
        //
        addTypePrefixList: json?["add_type_prefix_list"],
        addTypePostfixList: json?["add_type_postfix_list"],
        addPathPrefixList: json?["add_path_prefix_list"],
        addPathPostfixList: json?["add_path_postfix_list"],
        //
        addBlocPart: json?["add_bloc_part"] ?? true,
        addBlocSealedEvent: json?["add_bloc_sealed_event"] ?? true,
        addBlocSealedState: json?["add_bloc_sealed_state"] ?? true,
        //
        deleteBlocDependencyInBloc:
            json?["delete_bloc_dependency_in_bloc"] ?? true,
        deleteFunctionList: json?["delete_function_list"],
        deleteMultipleVariable: json?["delete_multiple_variable"] ?? true,
        deleteNew: json?["delete_new"] ?? true,
        deletePackageList: json?["delete_package_list"],
        deletePostfixList: json?["delete_postfix_list"],
        deletePrefixList: json?["delete_prefix_list"],
        deletePrivateInFunction: json?["delete_private_in_function"] ?? true,
        deletePublicInBloc: json?["delete_public_in_bloc"] ?? true,
        deleteTypeList: json?["delete_type_list"],
        //
        lengthList: json?["length_list"],
      );
}
