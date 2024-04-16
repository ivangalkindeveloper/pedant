// import 'package:analyzer/dart/analysis/results.dart';
// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/error/error.dart';
// import 'package:custom_lint_builder/custom_lint_builder.dart';
// import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
// import 'package:analyzer_plugin/protocol/protocol_generated.dart';

// void main(List<String> arguments) {
//   startPlugin();
// }

// class Pedant extends PluginBase {
//   @override
//   List<LintRule> getLintRules(
//     CustomLintConfigs configs,
//   ) {
//     // TODO: implement getLintRules
//     throw UnimplementedError();
//   }

//   @override
//   Stream<LintCode> getLints(
//     ResolvedUnitResult unit,
//   ) async* {
//     final library = unit.libraryElement;
//     final fileName = library.source.shortName;
//     final filePath = library.source.fullName;
//     final location = unit.lineInfo.getLocation(0);

//     print("$fileName $filePath ${location.lineNumber}");

//     final classes = library.topLevelElements.whereType<ClassElement>().toList();

//     for (final classElement in classes) {
//       final classLocation = classElement.location;
//       if (classElement.name.contains("Service") ||
//           classElement.name.contains("service")) {
//         yield LintCode(
//           name: "Lint name",
//           problemMessage: "Problem message",
//           correctionMessage: "Correction Message",
//           errorSeverity: ErrorSeverity.ERROR,
//           // getAnalysisErrorFixes: (Lint lint) async* {
//           //    final changeBuilder = ChangeBuilder(session: unit.session,);
//           //    await changeBuilder.addDartFileEdit(filePath, (builder) {
//           //         builder.addReplacement(SourceRange(classLocation!.offset, classLocation!.length,),
//           //            (editBuilder) {
//           //              editBuilder.write(classElement.name.replaceAll("Service", ""));
//           //            },
//           //         );
//           //      },
//           //    );
//           //
//           //    yield AnalysisErrorFixes(
//           //      lint.asAnalysisError(),
//           //      fixes: [
//           //        PrioritizedSourceChange(0, changeBuilder.sourceChange..message = "Fix this shit",),
//           //      ],
//           //    );
//           // },
//         );
//       }
//     }
//   }
// }
