import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:pedant/src/utility/visitor/ast_tree_visitor.dart';

void validateConstInitializer({
  required Expression initializer,
  required void Function() onSuccess,
}) {
  if (initializer is MethodInvocation) {
    return;
  }

  if (initializer is InstanceCreationExpression) {
    validateConstInstance(
      instanceCreationExpression: initializer,
      onSuccess: onSuccess,
    );
    return;
  }

  _validateInstanceChildren(
    expression: initializer,
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

  _validateInstanceChildren(
    expression: instanceCreationExpression,
    onSuccess: onSuccess,
  );
}

void _validateInstanceChildren({
  required Expression expression,
  required void Function() onSuccess,
}) {
  bool isConstInstanceCreationExpression = true;

  expression.visitChildren(
    AstTreeVisitor(
      onInstanceCreationExpression: (
        InstanceCreationExpression instanceCreationExpression,
      ) {
        final ConstructorElement? childrenStaticElement =
            instanceCreationExpression.constructorName.staticElement;
        if (childrenStaticElement == null) {
          isConstInstanceCreationExpression = false;
          return;
        }
        if (childrenStaticElement.isConst == false) {
          isConstInstanceCreationExpression = false;
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
        if (staticElement is! PropertyAccessorElement) {
          return;
        }

        final PropertyInducingElement? variable2 = staticElement.variable2;
        if (variable2 == null) {
          isConstInstanceCreationExpression = false;
          return;
        }
        if (variable2.isConst == false) {
          isConstInstanceCreationExpression = false;
          return;
        }
      },
      onMethodInvocation: (
        MethodInvocation methodInvocation,
      ) {
        isConstInstanceCreationExpression = false;
      },
    ),
  );

  if (isConstInstanceCreationExpression == false) {
    return;
  }

  onSuccess();
}
