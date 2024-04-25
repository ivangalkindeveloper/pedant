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
    this.addTypePrefixList = const [],
    this.addTypeSuffixList = const [],
    //
    this.addPathPrefixList = const [],
    this.addPathSuffixList = const [],
    //
    this.addBlocPart = true,
    this.addBlocSealedEvent = true,
    this.addBlocSealedState = true,
    //
    this.deletePackage = true,
    this.deletePackageList = const [],
    //
    this.deleteType = true,
    this.deleteTypeList = const [],
    //
    this.deleteFunction = true,
    this.deleteFunctionList = const [],
    //
    this.deletePrefix = true,
    this.deletePrefixList = const [],
    //
    this.deleteSuffix = true,
    this.deleteSuffixList = const [],
    //
    this.deleteNew = true,
    this.deletePrivateInFunction = true,
    //
    this.lengthList = const [],
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
  final List<TypeListNameItem> addTypePrefixList;
  final List<TypeListNameItem> addTypeSuffixList;
  //
  final List<PathNameListItem> addPathPrefixList;
  final List<PathNameListItem> addPathSuffixList;
  //
  final bool addBlocPart;
  final bool addBlocSealedEvent;
  final bool addBlocSealedState;
  //
  final bool deletePackage;
  final List<DeleteListItem> deletePackageList;
  //
  final bool deleteType;
  final List<DeleteListItem> deleteTypeList;
  //
  final bool deleteFunction;
  final List<DeleteListItem> deleteFunctionList;
  //
  final bool deletePrefix;
  final List<DeleteListItem> deletePrefixList;
  //
  final bool deleteSuffix;
  final List<DeleteListItem> deleteSuffixList;
  //
  final bool deleteNew;
  final bool deletePrivateInFunction;
  //
  final List<LengthItem> lengthList;

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
        addTypePrefixList: json?["add_type_prefix_list"] ?? const [],
        addTypeSuffixList: json?["add_type_suffix_list"] ?? const [],
        //
        addPathPrefixList: json?["add_path_prefix_list"] ?? const [],
        addPathSuffixList: json?["add_path_suffix_list"] ?? const [],
        //
        addBlocPart: json?["add_bloc_part"] ?? true,
        addBlocSealedEvent: json?["add_bloc_sealed_event"] ?? true,
        addBlocSealedState: json?["add_bloc_sealed_state"] ?? true,
        //
        deletePackage: json?["delete_package"] ?? true,
        deletePackageList: json?["delete_package_list"] ?? const [],
        //
        deleteType: json?["delete_type"] ?? true,
        deleteTypeList: json?["delete_type_list"] ?? const [],
        //
        deleteFunction: json?["delete_function"] ?? true,
        deleteFunctionList: json?["delete_function_list"] ?? const [],
        //
        deletePrefix: json?["delete_prefix"] ?? true,
        deletePrefixList: json?["delete_prefix_list"] ?? const [],
        //
        deleteSuffix: json?["delete_suffix"] ?? true,
        deleteSuffixList: json?["delete_suffix_list"] ?? const [],
        //
        deleteNew: json?["delete_new"] ?? true,
        deletePrivateInFunction: json?["delete_private_in_function"] ?? true,
        //
        lengthList: json?["length_list"] ?? const [],
      );
}
