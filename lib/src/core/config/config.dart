import 'package:pedant/src/core/data/length_item.dart';
import 'package:pedant/src/core/data/name_list_item.dart';
import 'package:pedant/src/core/data/delete_list_item.dart';

class Config {
  const Config({
    this.addAbsoluteImport = true,
    this.addAbstractIPrefix = true,
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
    this.addPrefixList = const [],
    this.addSuffixList = const [],
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
    this.deletePrivateInsideFunction = true,
    //
    this.lengthList = const [],
  });

  final bool addAbsoluteImport;
  final bool addAbstractIPrefix;
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
  final List<NameListItem> addPrefixList;
  final List<NameListItem> addSuffixList;
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
  final bool deletePrivateInsideFunction;
  //
  final List<LengthItem> lengthList;
}

// Script
// - Sort and fix absolute imports
// - Adding all commas in code
