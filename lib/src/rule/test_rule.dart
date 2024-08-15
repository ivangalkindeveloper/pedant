import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';

class TestRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) =>
      ruleList.add(
        TestRule(),
      );

  const TestRule()
      : super(
          code: const LintCode(
            name: "test",
            problemMessage: "Pedant: Test.",
            errorSeverity: error.ErrorSeverity.ERROR,
          ),
        );

  @override
  List<String> get filesToAnalyze => const [
        "**.dart",
      ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addAdjacentStrings((node) {
      print("addAdjacentStrings");
      print("${node.toString()}\n");
    });
    context.registry.addAnnotatedNode((node) {
      print("addAnnotatedNode");
      print("${node.toString()}\n");
    });
    context.registry.addAnnotation((node) {
      print("addAnnotation");
      print("${node.toString()}\n");
    });
    context.registry.addArgumentList((node) {
      print("addArgumentList");
      print("${node.toString()}\n");
    });
    context.registry.addAsExpression((node) {
      print("addAsExpression");
      print("${node.toString()}\n");
    });
    context.registry.addAssertInitializer((node) {
      print("addAssertInitializer");
      print("${node.toString()}\n");
    });
    context.registry.addAssertStatement((node) {
      print("addAssertStatement");
      print("${node.toString()}\n");
    });
    context.registry.addAssignedVariablePattern((node) {
      print("addAssignedVariablePattern");
      print("${node.toString()}\n");
    });
    context.registry.addAssignmentExpression((node) {
      print("addAssignedVariablePattern");
      print("${node.toString()}\n");
    });
    context.registry.addAugmentationImportDirective((node) {
      print("addAugmentationImportDirective");
      print("${node.toString()}\n");
    });
    context.registry.addAwaitExpression((node) {
      print("addAwaitExpression");
      print("${node.toString()}\n");
    });
    context.registry.addBinaryExpression((node) {
      print("addBinaryExpression");
      print("${node.toString()}\n");
    });
    context.registry.addBlock((node) {
      print("addBlock");
      print("${node.toString()}\n");
    });
    context.registry.addBlockFunctionBody((node) {
      print("addBlockFunctionBody");
      print("${node.toString()}\n");
    });
    context.registry.addBooleanLiteral((node) {
      print("addBooleanLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addBreakStatement((node) {
      print("addBreakStatement");
      print("${node.toString()}\n");
    });
    context.registry.addCascadeExpression((node) {
      print("addCascadeExpression");
      print("${node.toString()}\n");
    });
    context.registry.addCaseClause((node) {
      print("addCaseClause");
      print("${node.toString()}\n");
    });
    context.registry.addCastPattern((node) {
      print("addCastPattern");
      print("${node.toString()}\n");
    });
    context.registry.addCatchClause((node) {
      print("addCatchClause");
      print("${node.toString()}\n");
    });
    context.registry.addCatchClauseParameter((node) {
      print("addCatchClauseParameter");
      print("${node.toString()}\n");
    });
    context.registry.addClassDeclaration((node) {
      print("addClassDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addClassMember((node) {
      print("addClassMember");
      print("${node.toString()}\n");
    });
    context.registry.addClassTypeAlias((node) {
      print("addClassTypeAlias");
      print("${node.toString()}\n");
    });
    context.registry.addCollectionElement((node) {
      print("addCollectionElement");
      print("${node.toString()}\n");
    });
    context.registry.addCombinator((node) {
      print("addCombinator");
      print("${node.toString()}\n");
    });
    context.registry.addComment((node) {
      print("addComment");
      print("${node.toString()}\n");
    });
    context.registry.addComment((node) {
      print("addComment");
      print("${node.toString()}\n");
    });
    context.registry.addCommentReference((node) {
      print("addCommentReference");
      print("${node.toString()}\n");
    });
    context.registry.addCompilationUnit((node) {
      print("addCompilationUnit");
      print("${node.toString()}\n");
    });
    context.registry.addCompilationUnitMember((node) {
      print("addCompilationUnitMember");
      print("${node.toString()}\n");
    });
    context.registry.addConditionalExpression((node) {
      print("addConditionalExpression");
      print("${node.toString()}\n");
    });
    context.registry.addConfiguration((node) {
      print("addConfiguration");
      print("${node.toString()}\n");
    });
    context.registry.addConstantPattern((node) {
      print("addConstantPattern");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorDeclaration((node) {
      print("addConstructorDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorFieldInitializer((node) {
      print("addConstructorFieldInitializer");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorInitializer((node) {
      print("addConstructorInitializer");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorName((node) {
      print("addConstructorName");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorReference((node) {
      print("addConstructorReference");
      print("${node.toString()}\n");
    });
    context.registry.addConstructorSelector((node) {
      print("addConstructorSelector");
      print("${node.toString()}\n");
    });
    context.registry.addContinueStatement((node) {
      print("addContinueStatement");
      print("${node.toString()}\n");
    });
    context.registry.addDartPattern((node) {
      print("addDartPattern");
      print("${node.toString()}\n");
    });
    context.registry.addDeclaration((node) {
      print("addDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addDeclaredIdentifier((node) {
      print("addDeclaredIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addDeclaredVariablePattern((node) {
      print("addDeclaredVariablePattern");
      print("${node.toString()}\n");
    });
    context.registry.addDefaultFormalParameter((node) {
      print("addDefaultFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addDirective((node) {
      print("addDirective");
      print("${node.toString()}\n");
    });
    context.registry.addDoStatement((node) {
      print("addDoStatement");
      print("${node.toString()}\n");
    });
    context.registry.addDottedName((node) {
      print("addDottedName");
      print("${node.toString()}\n");
    });
    context.registry.addDoubleLiteral((node) {
      print("addDoubleLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addEmptyFunctionBody((node) {
      print("addEmptyFunctionBody");
      print("${node.toString()}\n");
    });
    context.registry.addEmptyStatement((node) {
      print("addEmptyStatement");
      print("${node.toString()}\n");
    });
    context.registry.addEnumConstantArguments((node) {
      print("addEnumConstantArguments");
      print("${node.toString()}\n");
    });
    context.registry.addEnumConstantDeclaration((node) {
      print("addEnumConstantDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addEnumDeclaration((node) {
      print("addEnumDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addExportDirective((node) {
      print("addExportDirective");
      print("${node.toString()}\n");
    });
    context.registry.addExpression((node) {
      print("addExpression");
      print("${node.toString()}\n");
    });
    context.registry.addExpressionFunctionBody((node) {
      print("addExpressionFunctionBody");
      print("${node.toString()}\n");
    });
    context.registry.addExpressionStatement((node) {
      print("addExpressionStatement");
      print("${node.toString()}\n");
    });
    context.registry.addExtendsClause((node) {
      print("addExtendsClause");
      print("${node.toString()}\n");
    });
    context.registry.addExtensionDeclaration((node) {
      print("addExtensionDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addExtensionOverride((node) {
      print("addExtensionOverride");
      print("${node.toString()}\n");
    });
    context.registry.addFieldDeclaration((node) {
      print("addFieldDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addFieldDeclaration((node) {
      print("addFieldDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addFieldFormalParameter((node) {
      print("addFieldFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addForEachParts((node) {
      print("addForEachParts");
      print("${node.toString()}\n");
    });
    context.registry.addForEachPartsWithDeclaration((node) {
      print("addForEachPartsWithDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addForEachPartsWithIdentifier((node) {
      print("addForEachPartsWithIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addForEachPartsWithPattern((node) {
      print("addForEachPartsWithPattern");
      print("${node.toString()}\n");
    });
    context.registry.addForElement((node) {
      print("addForElement");
      print("${node.toString()}\n");
    });
    context.registry.addForParts((node) {
      print("addForParts");
      print("${node.toString()}\n");
    });
    context.registry.addForPartsWithDeclarations((node) {
      print("addForPartsWithDeclarations");
      print("${node.toString()}\n");
    });
    context.registry.addForPartsWithExpression((node) {
      print("addForPartsWithExpression");
      print("${node.toString()}\n");
    });
    context.registry.addForPartsWithPattern((node) {
      print("addForPartsWithPattern");
      print("${node.toString()}\n");
    });
    context.registry.addForStatement((node) {
      print("addForStatement");
      print("${node.toString()}\n");
    });
    context.registry.addFormalParameter((node) {
      print("addFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addFormalParameterList((node) {
      print("addFormalParameterList");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionBody((node) {
      print("addFunctionBody");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionDeclaration((node) {
      print("addFunctionDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionDeclarationStatement((node) {
      print("addFunctionDeclarationStatement");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionExpression((node) {
      print("addFunctionExpression");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionExpressionInvocation((node) {
      print("addFunctionExpressionInvocation");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionReference((node) {
      print("addFunctionReference");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionTypeAlias((node) {
      print("addFunctionTypeAlias");
      print("${node.toString()}\n");
    });
    context.registry.addFunctionTypedFormalParameter((node) {
      print("addFunctionTypedFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addGenericFunctionType((node) {
      print("addGenericFunctionType");
      print("${node.toString()}\n");
    });
    context.registry.addGenericTypeAlias((node) {
      print("addGenericTypeAlias");
      print("${node.toString()}\n");
    });
    context.registry.addGuardedPattern((node) {
      print("addGuardedPattern");
      print("${node.toString()}\n");
    });
    context.registry.addHideCombinator((node) {
      print("addHideCombinator");
      print("${node.toString()}\n");
    });
    context.registry.addIdentifier((node) {
      print("addIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addIfElement((node) {
      print("addIfElement");
      print("${node.toString()}\n");
    });
    context.registry.addIfStatement((node) {
      print("addIfStatement");
      print("${node.toString()}\n");
    });
    context.registry.addImplementsClause((node) {
      print("addImplementsClause");
      print("${node.toString()}\n");
    });
    context.registry.addImplicitCallReference((node) {
      print("addImplicitCallReference");
      print("${node.toString()}\n");
    });
    context.registry.addImportDirective((node) {
      print("addImportDirective");
      print("${node.toString()}\n");
    });
    context.registry.addImportPrefixReference((node) {
      print("addImportPrefixReference");
      print("${node.toString()}\n");
    });
    context.registry.addIndexExpression((node) {
      print("addIndexExpression");
      print("${node.toString()}\n");
    });
    context.registry.addInstanceCreationExpression((node) {
      print("addInstanceCreationExpression");
      print("${node.toString()}\n");
    });
    context.registry.addIntegerLiteral((node) {
      print("addIntegerLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addInterpolationElement((node) {
      print("addInterpolationElement");
      print("${node.toString()}\n");
    });
    context.registry.addInterpolationExpression((node) {
      print("addInterpolationExpression");
      print("${node.toString()}\n");
    });
    context.registry.addInterpolationString((node) {
      print("addInterpolationString");
      print("${node.toString()}\n");
    });
    context.registry.addInvocationExpression((node) {
      print("addInvocationExpression");
      print("${node.toString()}\n");
    });
    context.registry.addIsExpression((node) {
      print("addIsExpression");
      print("${node.toString()}\n");
    });
    context.registry.addLabel((node) {
      print("addLabel");
      print("${node.toString()}\n");
    });
    context.registry.addLabeledStatement((node) {
      print("addLabeledStatement");
      print("${node.toString()}\n");
    });
    context.registry.addLibraryAugmentationDirective((node) {
      print("addLibraryAugmentationDirective");
      print("${node.toString()}\n");
    });
    context.registry.addLibraryDirective((node) {
      print("addLibraryDirective");
      print("${node.toString()}\n");
    });
    context.registry.addLibraryIdentifier((node) {
      print("addLibraryIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addListLiteral((node) {
      print("addListLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addListPattern((node) {
      print("addListPattern");
      print("${node.toString()}\n");
    });
    context.registry.addLiteral((node) {
      print("addLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addLogicalAndPattern((node) {
      print("addLogicalAndPattern");
      print("${node.toString()}\n");
    });
    context.registry.addLogicalOrPattern((node) {
      print("addLogicalOrPattern");
      print("${node.toString()}\n");
    });
    context.registry.addMapLiteralEntry((node) {
      print("addMapLiteralEntry");
      print("${node.toString()}\n");
    });
    context.registry.addMapPattern((node) {
      print("addMapPattern");
      print("${node.toString()}\n");
    });
    context.registry.addMapPatternEntry((node) {
      print("addMapPatternEntry");
      print("${node.toString()}\n");
    });
    context.registry.addMethodDeclaration((node) {
      print("addMethodDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addMethodInvocation((node) {
      print("addMethodInvocation");
      print("${node.toString()}\n");
    });
    context.registry.addMixinDeclaration((node) {
      print("addMixinDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addNamedCompilationUnitMember((node) {
      print("addNamedCompilationUnitMember");
      print("${node.toString()}\n");
    });
    context.registry.addNamedExpression((node) {
      print("addNamedExpression");
      print("${node.toString()}\n");
    });
    context.registry.addNamedType((node) {
      print("addNamedType");
      print("${node.toString()}\n");
    });
    context.registry.addNamespaceDirective((node) {
      print("addNamespaceDirective");
      print("${node.toString()}\n");
    });
    context.registry.addNativeClause((node) {
      print("addNamespaceDirective");
      print("${node.toString()}\n");
    });
    context.registry.addNativeFunctionBody((node) {
      print("addNativeFunctionBody");
      print("${node.toString()}\n");
    });
    context.registry.addNode((node) {
      print("addNode");
      print("${node.toString()}\n");
    });
    context.registry.addNormalFormalParameter((node) {
      print("addNormalFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addNullAssertPattern((node) {
      print("addNullAssertPattern");
      print("${node.toString()}\n");
    });
    context.registry.addNullCheckPattern((node) {
      print("addNullCheckPattern");
      print("${node.toString()}\n");
    });
    context.registry.addNullLiteral((node) {
      print("addNullLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addObjectPattern((node) {
      print("addObjectPattern");
      print("${node.toString()}\n");
    });
    context.registry.addParenthesizedExpression((node) {
      print("addParenthesizedExpression");
      print("${node.toString()}\n");
    });
    context.registry.addParenthesizedPattern((node) {
      print("addParenthesizedPattern");
      print("${node.toString()}\n");
    });
    context.registry.addPartDirective((node) {
      print("addPartDirective");
      print("${node.toString()}\n");
    });
    context.registry.addPartOfDirective((node) {
      print("addPartOfDirective");
      print("${node.toString()}\n");
    });
    context.registry.addPatternAssignment((node) {
      print("addPatternAssignment");
      print("${node.toString()}\n");
    });
    context.registry.addPatternField((node) {
      print("addPatternField");
      print("${node.toString()}\n");
    });
    context.registry.addPatternFieldName((node) {
      print("addPatternFieldName");
      print("${node.toString()}\n");
    });
    context.registry.addPatternVariableDeclaration((node) {
      print("addPatternVariableDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addPatternVariableDeclarationStatement((node) {
      print("addPatternVariableDeclarationStatement");
      print("${node.toString()}\n");
    });
    context.registry.addPostfixExpression((node) {
      print("addPostfixExpression");
      print("${node.toString()}\n");
    });
    context.registry.addPrefixExpression((node) {
      print("addPrefixExpression");
      print("${node.toString()}\n");
    });
    context.registry.addPrefixedIdentifier((node) {
      print("addPrefixedIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addPropertyAccess((node) {
      print("addPropertyAccess");
      print("${node.toString()}\n");
    });
    context.registry.addRecordLiteral((node) {
      print("addRecordLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addRecordPattern((node) {
      print("addRecordPattern");
      print("${node.toString()}\n");
    });
    context.registry.addRecordTypeAnnotation((node) {
      print("addRecordTypeAnnotation");
      print("${node.toString()}\n");
    });
    context.registry.addRecordTypeAnnotationField((node) {
      print("addRecordTypeAnnotationField");
      print("${node.toString()}\n");
    });
    context.registry.addRecordTypeAnnotationNamedField((node) {
      print("addRecordTypeAnnotationNamedField");
      print("${node.toString()}\n");
    });
    context.registry.addRecordTypeAnnotationNamedFields((node) {
      print("addRecordTypeAnnotationNamedFields");
      print("${node.toString()}\n");
    });
    context.registry.addRecordTypeAnnotationPositionalField((node) {
      print("addRecordTypeAnnotationPositionalField");
      print("${node.toString()}\n");
    });
    context.registry.addRedirectingConstructorInvocation((node) {
      print("addRedirectingConstructorInvocation");
      print("${node.toString()}\n");
    });
    context.registry.addRelationalPattern((node) {
      print("addRelationalPattern");
      print("${node.toString()}\n");
    });
    context.registry.addRestPatternElement((node) {
      print("addRestPatternElement");
      print("${node.toString()}\n");
    });
    context.registry.addRethrowExpression((node) {
      print("addRethrowExpression");
      print("${node.toString()}\n");
    });
    context.registry.addReturnStatement((node) {
      print("addReturnStatement");
      print("${node.toString()}\n");
    });
    context.registry.addScriptTag((node) {
      print("addScriptTag");
      print("${node.toString()}\n");
    });
    context.registry.addScriptTag((node) {
      print("addScriptTag");
      print("${node.toString()}\n");
    });
    context.registry.addSetOrMapLiteral((node) {
      print("addSetOrMapLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addShowCombinator((node) {
      print("addShowCombinator");
      print("${node.toString()}\n");
    });
    context.registry.addSimpleFormalParameter((node) {
      print("addSimpleFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addSimpleIdentifier((node) {
      print("addSimpleIdentifier");
      print("${node.toString()}\n");
    });
    context.registry.addSimpleStringLiteral((node) {
      print("addSimpleStringLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addSingleStringLiteral((node) {
      print("addSingleStringLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addSpreadElement((node) {
      print("addSpreadElement");
      print("${node.toString()}\n");
    });
    context.registry.addStatement((node) {
      print("addStatement");
      print("${node.toString()}\n");
    });
    context.registry.addStringInterpolation((node) {
      print("addStringInterpolation");
      print("${node.toString()}\n");
    });
    context.registry.addStringLiteral((node) {
      print("addStringLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addSuperConstructorInvocation((node) {
      print("addSuperConstructorInvocation");
      print("${node.toString()}\n");
    });
    context.registry.addSuperExpression((node) {
      print("addSuperExpression");
      print("${node.toString()}\n");
    });
    context.registry.addSuperFormalParameter((node) {
      print("addSuperFormalParameter");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchCase((node) {
      print("addSwitchCase");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchDefault((node) {
      print("addSwitchDefault");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchExpression((node) {
      print("addSwitchExpression");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchExpressionCase((node) {
      print("addSwitchExpressionCase");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchMember((node) {
      print("addSwitchMember");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchPatternCase((node) {
      print("addSwitchPatternCase");
      print("${node.toString()}\n");
    });
    context.registry.addSwitchStatement((node) {
      print("addSwitchStatement");
      print("${node.toString()}\n");
    });
    context.registry.addSymbolLiteral((node) {
      print("addSymbolLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addThisExpression((node) {
      print("addThisExpression");
      print("${node.toString()}\n");
    });
    context.registry.addThrowExpression((node) {
      print("addThrowExpression");
      print("${node.toString()}\n");
    });
    context.registry.addTopLevelVariableDeclaration((node) {
      print("addTopLevelVariableDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addTryStatement((node) {
      print("addTryStatement");
      print("${node.toString()}\n");
    });
    context.registry.addTypeAlias((node) {
      print("addTypeAlias");
      print("${node.toString()}\n");
    });
    context.registry.addTypeAnnotation((node) {
      print("addTypeAnnotation");
      print("${node.toString()}\n");
    });
    context.registry.addTypeArgumentList((node) {
      print("addTypeArgumentList");
      print("${node.toString()}\n");
    });
    context.registry.addTypeLiteral((node) {
      print("addTypeLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addTypeParameter((node) {
      print("addTypeParameter");
      print("${node.toString()}\n");
    });
    context.registry.addTypeParameterList((node) {
      print("addTypeParameterList");
      print("${node.toString()}\n");
    });
    context.registry.addTypedLiteral((node) {
      print("addTypedLiteral");
      print("${node.toString()}\n");
    });
    context.registry.addUriBasedDirective((node) {
      print("addUriBasedDirective");
      print("${node.toString()}\n");
    });
    context.registry.addVariableDeclaration((node) {
      print("addVariableDeclaration");
      print("${node.toString()}\n");
    });
    context.registry.addVariableDeclarationList((node) {
      print("addVariableDeclarationList");
      print("${node.toString()}\n");
    });
    context.registry.addVariableDeclarationStatement((node) {
      print("addVariableDeclarationStatement");
      print("${node.toString()}\n");
    });
    context.registry.addWhenClause((node) {
      print("addWhenClause");
      print("${node.toString()}\n");
    });
    context.registry.addWhileStatement((node) {
      print("addWhileStatement");
      print("${node.toString()}\n");
    });
    context.registry.addWildcardPattern((node) {
      print("addWildcardPattern");
      print("${node.toString()}\n");
    });
    context.registry.addWithClause((node) {
      print("addWithClause");
      print("${node.toString()}\n");
    });
    context.registry.addYieldStatement((node) {
      print("addYieldStatement");
      print("${node.toString()}\n");
    });
  }
}
