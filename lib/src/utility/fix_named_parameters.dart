import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

void fixNamedParameters({
  required ChangeReporter reporter,
  required AnalysisError analysisError,
  required int priority,
  required List<ParameterElement> parameterList,
  required SourceRange range,
  required bool isConstructor,
}) {
  final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
    message: "Pedant: Edit all parameters to named ",
    priority: priority,
  );
  changeBuilder.addDartFileEdit(
    (
      DartFileEditBuilder builder,
    ) {
      final List<String> parameterLineList = [
        "{",
      ];
      final List<String> privateInitilizePramaterList = [];

      for (int index = 0; index < parameterList.length; index++) {
        final ParameterElement parameterElement = parameterList[index];

        String parameterLine = "";
        if (parameterElement.type.nullabilitySuffix !=
            NullabilitySuffix.question) {
          parameterLine += "required ";
        }
        if (parameterElement.isSuperFormal == true) {
          parameterLine += "super.";
        } else if (parameterElement.isInitializingFormal == true &&
            parameterElement.isPrivate == false) {
          parameterLine += "this.";
        } else {
          parameterLine += "${parameterElement.type.getDisplayString()} ";
        }
        if (parameterElement.isPrivate == true) {
          final String parameterName = parameterElement.name.replaceFirst(
            "_",
            "",
          );
          parameterLine += "$parameterName,";
          privateInitilizePramaterList.add(
            "this._${parameterName} = ${parameterName}",
          );
        } else {
          parameterLine += "${parameterElement.name},";
        }

        parameterLineList.add(
          parameterLine,
        );
      }
      parameterLineList.add(
        "}",
      );

      final String parameterLineResult = parameterLineList.join();
      final String privateInitilizeResult = privateInitilizePramaterList.isEmpty
          ? ""
          : ") : ${privateInitilizePramaterList.join(
              ", ",
            )}";
      final String result = "${parameterLineResult}${privateInitilizeResult}";

      builder.addSimpleReplacement(
        SourceRange(
          range.offset,
          privateInitilizePramaterList.isEmpty
              ? range.length
              : range.length + 1,
        ),
        result,
      );
    },
  );
}
