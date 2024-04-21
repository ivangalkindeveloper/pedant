import 'package:pedant/src/core/delete/delete_item.dart';
import 'package:pedant/src/core/config/length_config.dart';
import 'package:pedant/src/core/config/name_list_config.dart';
import 'package:pedant/src/core/delete/delete_list_item.dart';

class Config {
  const Config({
    this.indicateAbsoluteImport = true,
    this.indicateAbstractIPrefix = true,
    this.indicateConstructor = true,
    this.indicateConst = true,
    this.indicateType = true,
    this.indicateOverride = true,
    this.indicateFinal = true,
    this.indicateThis = true,
    this.indicateArrowFunctions = true,
    this.indicateRequiredProperties = true,
    this.indicateIfBracets = true,
    this.indicateIfIndent = true,
    this.indicateReturnIndent = true,
    //
    this.indicatePrefixList = const [],
    this.indicateSuffixList = const [],
    //
    this.indicateBlocPart = true,
    this.indicateBlocSealedEvent = true,
    this.indicateBlocSealedState = true,
    //
    this.deletePackage = true,
    this.deletePackageList = const [],
    //
    this.deleteType = true,
    this.deleteTypeList = const [],
    //
    this.deleteNew = true,
    this.deletePrint = true,
    this.deletePrivateInsideFunction = true,
    this.deleteImplementationSuffix = true,
    this.deleteModelSuffix = true,
    //
    this.lengthList = const [],
  });

  final bool indicateAbsoluteImport;
  final bool indicateAbstractIPrefix;
  final bool indicateConstructor;
  final bool indicateConst;
  final bool indicateType;
  final bool indicateOverride;
  final bool indicateFinal;
  final bool indicateThis;
  final bool indicateArrowFunctions;
  final bool indicateRequiredProperties;
  final bool indicateIfBracets;
  final bool indicateIfIndent;
  final bool indicateReturnIndent;
  //
  final List<NameListConfig> indicatePrefixList;
  final List<NameListConfig> indicateSuffixList;
  //
  final bool indicateBlocPart;
  final bool indicateBlocSealedEvent;
  final bool indicateBlocSealedState;
  //
  final bool deletePackage; //
  final List<DeleteListItem> deletePackageList; //
  //
  final bool deleteType; //
  final List<DeleteItem> deleteTypeList; //
  //
  final bool deleteNew; //
  final bool deletePrint; //
  final bool deletePrivateInsideFunction;
  final bool deleteImplementationSuffix; //
  final bool deleteModelSuffix; //
  //
  final List<LengthConfig> lengthList;
}

// Script
// - Sort and fix absolute imports
// - Adding all commas in code
