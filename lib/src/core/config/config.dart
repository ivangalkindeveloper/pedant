import 'package:pedant/src/core/black_list/black_list_item.dart';
import 'package:pedant/src/core/config/match_count_config.dart';
import 'package:pedant/src/core/config/match_name_config.dart';

class Config {
  const Config({
    this.indicateAbsoluteImport = true,
    this.indicateAbstractIPrefix = true,
    this.indicateConstructor = true,
    this.indicateType = true,
    this.indicateConst = true,
    this.indicateOverride = true,
    this.indicateArrowFunctions = true,
    this.indicateRequiredProperties = true,
    this.indicateThis = true,
    this.indicateIfBracets = true,
    this.indicateIfIndent = true,
    this.indicateReturnIndent = true,
    //
    this.indicateBlocPart = true,
    this.indicateBlocSealedEvent = true,
    this.indicateBlocSealedState = true,
    //
    this.prefixList = const [],
    this.suffixList = const [],
    //
    this.deletePackage = true,
    this.packageBlackList = const [],
    //
    this.deleteType = true,
    this.typeBlackList = const [],
    //
    this.deleteNew = true,
    this.deletePrint = true,
    this.deleteImplementationSuffix = true,
    this.deleteModelSuffix = true,
    //
    this.maxLengthList = const [],
  });

  final bool indicateAbsoluteImport;
  final bool indicateAbstractIPrefix;
  final bool indicateConstructor;
  final bool indicateType;
  final bool indicateConst;
  final bool indicateOverride;
  final bool indicateArrowFunctions;
  final bool indicateRequiredProperties;
  final bool indicateThis;
  final bool indicateIfBracets;
  final bool indicateIfIndent;
  final bool indicateReturnIndent;
  //
  final bool indicateBlocPart;
  final bool indicateBlocSealedEvent;
  final bool indicateBlocSealedState;
  //
  final List<MatchNameConfig> prefixList;
  final List<MatchNameConfig> suffixList;
  //
  final bool deletePackage; //
  final List<BlackListItem> packageBlackList; //
  //
  final bool deleteType; //
  final List<BlackListItem> typeBlackList; //
  //
  final bool deleteNew; //
  final bool deletePrint; //
  final bool deleteImplementationSuffix; //
  final bool deleteModelSuffix; //
  //
  final List<MatchLengthConfig> maxLengthList;
}

// Script
// - Sort and fix absolute imports
// - Adding all commas in code
