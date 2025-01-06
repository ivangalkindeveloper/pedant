import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

void validateConstVariableList({
  required VariableDeclarationList variableList,
  required void Function() onSuccess,
}) {
  final NodeList<VariableDeclaration> variables = variableList.variables;
  if (variables.isEmpty) {
    onSuccess();
    return;
  }
  if (variableList.isConst == true) {
    return;
  }
  if (variableList.isLate == true) {
    return;
  }
  if (variableList.isFinal == false) {
    return;
  }

  for (final VariableDeclaration variableDeclaration in variables) {
    final Expression? initializer = variableDeclaration.initializer;
    if (initializer == null) {
      continue;
    }

    bool isConstInitializer = false;
    _validateConstInitializer(
      initializer: initializer,
      onSuccess: () => isConstInitializer = true,
    );
    if (isConstInitializer == false) {
      return;
    }
  }

  onSuccess();
}

void _validateConstInitializer({
  required Expression initializer,
  required void Function() onSuccess,
}) {
  if (initializer is MethodInvocation) {
    return;
  }
  if (initializer is ListLiteral) {
    return;
  }
  if (initializer is SetOrMapLiteral) {
    return;
  }

  if (initializer is InstanceCreationExpression) {
    validateConstInstance(
      instanceCreationExpression: initializer,
      onSuccess: onSuccess,
    );
    return;
  }

  validateConstChildren(
    node: initializer,
    element: initializer.staticParameterElement,
    onSuccess: onSuccess,
  );
}

void validateConstInstance({
  required InstanceCreationExpression instanceCreationExpression,
  required void Function() onSuccess,
}) {
  if (instanceCreationExpression.isConst == true) {
    return;
  }
  if (instanceCreationExpression.inConstantContext == true) {
    return;
  }

  final ConstructorElement? staticElement =
      instanceCreationExpression.constructorName.staticElement;
  if (staticElement == null) {
    return;
  }
  if (staticElement.isConst == false) {
    return;
  }

  validateConstChildren(
    node: instanceCreationExpression,
    element: staticElement,
    onSuccess: onSuccess,
  );
}

void validateConstChildren({
  required AstNode node,
  required Element? element,
  required void Function() onSuccess,
}) {
  bool isConstExpression = true;

  node.visitChildren(
    AstTreeVisitor(
      onInstanceCreationExpression: (
        InstanceCreationExpression instanceCreationExpression,
      ) {
        final ConstructorElement? childrenStaticElement =
            instanceCreationExpression.constructorName.staticElement;
        if (childrenStaticElement == null) {
          isConstExpression = false;
          return;
        }
        if (childrenStaticElement.isConst == false) {
          isConstExpression = false;
          return;
        }
      },
      onSimpleIdentifier: (
        SimpleIdentifier simpleIdentifier,
      ) {
        final Element? staticElement = simpleIdentifier.staticElement;
        if (staticElement == null) {
          return;
        }
        if (staticElement is PropertyAccessorElement) {
          final PropertyInducingElement? variable2 = staticElement.variable2;
          if (variable2 == null) {
            isConstExpression = false;
            return;
          }
          if (variable2.isConst == false) {
            isConstExpression = false;
            return;
          }
        }
        if (staticElement is FunctionElement) {
          isConstExpression = false;
          return;
        }
        if (staticElement is LocalVariableElement) {
          if (staticElement.isConst == false) {
            isConstExpression = false;
            return;
          }
        }
        if (staticElement is ParameterElement &&
            staticElement.enclosingElement3 != element) {
          isConstExpression = false;
          return;
        }
      },
      onMethodInvocation: (
        MethodInvocation methodInvocation,
      ) {
        isConstExpression = false;
      },
    ),
  );

  if (isConstExpression == false) {
    return;
  }

  onSuccess();
}
