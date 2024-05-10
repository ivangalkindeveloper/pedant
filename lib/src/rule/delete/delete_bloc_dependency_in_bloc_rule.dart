import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/bloc_type_checker.dart';
import 'package:pedant/src/utility/tree_visitor.dart';

class DeleteBlocDependencyInBlocRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.deleteBlocDependencyInBloc == false) {
      return;
    }

    ruleList.add(
      const DeleteBlocDependencyInBlocRule(),
    );
  }

  const DeleteBlocDependencyInBlocRule()
      : super(
          code: const LintCode(
            name: "delete_bloc_dependency_in_bloc",
            problemMessage: "Delete Bloc dependency in current Bloc.",
            correctionMessage:
                "Please delete this Bloc dependency. Communication between Bloc's should occur only through widgets.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.registry.addClassDeclaration(
        (
          ClassDeclaration node,
        ) {
          final ClassElement? declaredElement = node.declaredElement;
          if (declaredElement == null) {
            return;
          }

          if (blocTypeChecker.isAssignableFromType(
                declaredElement.thisType,
              ) ==
              false) {
            return;
          }

          node.visitChildren(
            TreeVisitor(
              onDefaultFormalParameter: (
                DefaultFormalParameter node,
              ) {
                final ParameterElement? declaredElement = node.declaredElement;
                if (declaredElement == null) {
                  return;
                }

                if (blocTypeChecker.isAssignableFromType(
                      declaredElement.type,
                    ) ==
                    false) {
                  return;
                }

                reporter.reportErrorForElement(
                  this.code,
                  declaredElement,
                );
              },
              // onVariableDeclaration: (
              //   VariableDeclaration node,
              // ) {
              //   final VariableElement? declaredElement = node.declaredElement;
              //   if (declaredElement == null) {
              //     return;
              //   }

              //   if (declaredElement.isPrivate) {
              //     return;
              //   }

              //   reporter.reportErrorForElement(
              //     this.code,
              //     declaredElement,
              //   );
              // },
            ),
          );
        },
      );

  // @override
  // List<Fix> getFixes() => [
  //       _Fix(),
  //     ];
}

// class _Fix extends DartFix {
//   _Fix();

//   @override
//   void run(
//     CustomLintResolver resolver,
//     ChangeReporter reporter,
//     CustomLintContext context,
//     AnalysisError analysisError,
//     List<AnalysisError> others,
//   ) {
//     context.registry.addFieldFormalParameter(
//       (
//         FieldFormalParameter node,
//       ) {
//         if (analysisError.sourceRange.intersects(
//               node.sourceRange,
//             ) ==
//             false) {
//           return;
//         }

//         final ParameterElement? declaredElement = node.declaredElement;
//         if (declaredElement == null) {
//           return;
//         }

//         final String validName =
//             "${declaredElement.type.getDisplayString(withNullability: true)} ${declaredElement.displayName}";
//         final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
//           message: "pedant: Rename to '$validName'",
//           priority: 1000,
//         );
//         changeBuilder.addDartFileEdit(
//           (
//             DartFileEditBuilder builder,
//           ) =>
//               builder.addSimpleReplacement(
//             analysisError.sourceRange,
//             validName,
//           ),
//         );
//       },
//     );
//     context.registry.addVariableDeclaration(
//       (
//         VariableDeclaration node,
//       ) {
//         if (analysisError.sourceRange.intersects(
//               node.sourceRange,
//             ) ==
//             false) {
//           return;
//         }

//         final VariableElement? declaredElement = node.declaredElement;
//         if (declaredElement == null) {
//           return;
//         }

//         final String validName = "_${declaredElement.displayName}";
//         final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
//           message: "pedant: Rename to '$validName'",
//           priority: 1000,
//         );
//         changeBuilder.addDartFileEdit(
//           (
//             DartFileEditBuilder builder,
//           ) =>
//               builder.addSimpleReplacement(
//             analysisError.sourceRange,
//             validName,
//           ),
//         );
//       },
//     );
//   }
// }
