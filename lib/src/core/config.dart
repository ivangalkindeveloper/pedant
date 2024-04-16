import 'package:pedant/src/core/match_config.dart';

class Config {
  const Config({
    this.indicateAbsoluteImport = true,
    this.indicateAbstractIPrefix = true,
    this.indicateClassConstructor = true,
    this.indicateVariableType = true,
    this.indicateConst = true,
    this.indicateArrowFunctions = true,
    this.indicateRequiredPropertiesFunctions = true,
    this.indicateIfBracets = true,
    //
    this.indicateBlocPart = true,
    this.indicateBlocSealedEvent = true,
    this.indicateBlocSealedState = true,
    //
    this.indicatePrefix = true,
    this.prefixList,
    //
    this.indicateSuffix = true,
    this.suffixList,
    //
    this.deleteType = true,
    this.typeBlackList,
    //
    this.deletePackage = true,
    this.packageBlackList,
    //
    this.deleteImplSuffix = true,
    this.deletePrint = true,
  });

  final bool indicateAbsoluteImport;
  final bool indicateAbstractIPrefix;
  final bool indicateClassConstructor;
  final bool indicateVariableType;
  final bool indicateConst;
  final bool indicateArrowFunctions;
  final bool indicateRequiredPropertiesFunctions;
  final bool indicateIfBracets;
  //
  final bool indicateBlocPart;
  final bool indicateBlocSealedEvent;
  final bool indicateBlocSealedState;
  //
  final bool indicatePrefix;
  final List<MatchConfig>? prefixList;
  //
  final bool indicateSuffix;
  final List<MatchConfig>? suffixList;
  //
  final bool deletePackage;
  final List<String>? packageBlackList;
  //
  final bool deleteType;
  final List<String>? typeBlackList;
  //
  final bool deleteImplSuffix; //
  final bool deletePrint;
}
