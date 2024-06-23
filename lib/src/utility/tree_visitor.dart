import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class TreeVisitor extends RecursiveAstVisitor<void> {
  const TreeVisitor({
    this.onClassDeclaration,
    this.onClassTypeAlias,
    this.onConstructorDeclaration,
    this.onConstructorFieldInitializer,
    this.onDefaultFormalParameter,
    this.onFieldDeclaration,
    this.onFieldFormalParameter,
    this.onFormalParameterList,
    this.onFunctionDeclaration,
    this.onInstanceCreationExpression,
    this.onMethodDeclaration,
    this.onMethodInvocation,
    this.onPropertyAccess,
    this.onSimpleFormalParameter,
    this.onSimpleIdentifier,
    this.onVariableDeclaration,
  });

  final void Function(
    ClassDeclaration node,
  )? onClassDeclaration;

  final void Function(
    ClassTypeAlias node,
  )? onClassTypeAlias;

  final void Function(
    ConstructorDeclaration node,
  )? onConstructorDeclaration;

  final void Function(
    ConstructorFieldInitializer node,
  )? onConstructorFieldInitializer;

  final void Function(
    DefaultFormalParameter node,
  )? onDefaultFormalParameter;

  final void Function(
    FieldDeclaration node,
  )? onFieldDeclaration;

  final void Function(
    FieldFormalParameter node,
  )? onFieldFormalParameter;

  final void Function(
    FormalParameterList node,
  )? onFormalParameterList;

  final void Function(
    FunctionDeclaration node,
  )? onFunctionDeclaration;

  final void Function(
    InstanceCreationExpression node,
  )? onInstanceCreationExpression;

  final void Function(
    MethodDeclaration node,
  )? onMethodDeclaration;

  final void Function(
    MethodInvocation node,
  )? onMethodInvocation;

  final void Function(
    PropertyAccess node,
  )? onPropertyAccess;

  final void Function(
    SimpleFormalParameter node,
  )? onSimpleFormalParameter;

  final void Function(
    SimpleIdentifier node,
  )? onSimpleIdentifier;

  final void Function(
    VariableDeclaration node,
  )? onVariableDeclaration;

  @override
  void visitClassDeclaration(
    ClassDeclaration node,
  ) {
    super.visitClassDeclaration(node);
    this.onClassDeclaration?.call(
          node,
        );
  }

  @override
  void visitClassTypeAlias(
    ClassTypeAlias node,
  ) {
    super.visitClassTypeAlias(node);
    this.onClassTypeAlias?.call(
          node,
        );
  }

  @override
  void visitConstructorDeclaration(
    ConstructorDeclaration node,
  ) {
    super.visitConstructorDeclaration(node);
    this.onConstructorDeclaration?.call(
          node,
        );
  }

  @override
  void visitConstructorFieldInitializer(
    ConstructorFieldInitializer node,
  ) {
    super.visitConstructorFieldInitializer(node);
    this.onConstructorFieldInitializer?.call(
          node,
        );
  }

  @override
  void visitDefaultFormalParameter(
    DefaultFormalParameter node,
  ) {
    super.visitDefaultFormalParameter(node);
    this.onDefaultFormalParameter?.call(
          node,
        );
  }

  @override
  void visitFieldDeclaration(
    FieldDeclaration node,
  ) {
    super.visitFieldDeclaration(node);
    this.onFieldDeclaration?.call(
          node,
        );
  }

  @override
  void visitFieldFormalParameter(
    FieldFormalParameter node,
  ) {
    super.visitFieldFormalParameter(node);
    this.onFieldFormalParameter?.call(
          node,
        );
  }

  @override
  void visitFormalParameterList(
    FormalParameterList node,
  ) {
    super.visitFormalParameterList(node);
    this.onFormalParameterList?.call(
          node,
        );
  }

  @override
  void visitFunctionDeclaration(
    FunctionDeclaration node,
  ) {
    super.visitFunctionDeclaration(node);
    this.onFunctionDeclaration?.call(
          node,
        );
  }

  @override
  void visitInstanceCreationExpression(
    InstanceCreationExpression node,
  ) {
    super.visitInstanceCreationExpression(node);
    this.onInstanceCreationExpression?.call(
          node,
        );
  }

  @override
  void visitPropertyAccess(
    PropertyAccess node,
  ) {
    super.visitPropertyAccess(node);
    this.onPropertyAccess?.call(
          node,
        );
  }

  @override
  void visitMethodDeclaration(
    MethodDeclaration node,
  ) {
    super.visitMethodDeclaration(node);
    this.onMethodDeclaration?.call(
          node,
        );
  }

  @override
  void visitMethodInvocation(
    MethodInvocation node,
  ) {
    super.visitMethodInvocation(node);
    this.onMethodInvocation?.call(
          node,
        );
  }

  @override
  void visitSimpleFormalParameter(
    SimpleFormalParameter node,
  ) {
    super.visitSimpleFormalParameter(node);
    this.onSimpleFormalParameter?.call(
          node,
        );
  }

  @override
  void visitSimpleIdentifier(
    SimpleIdentifier node,
  ) {
    super.visitSimpleIdentifier(node);
    this.onSimpleIdentifier?.call(
          node,
        );
  }

  @override
  void visitVariableDeclaration(
    VariableDeclaration node,
  ) {
    super.visitVariableDeclaration(node);
    this.onVariableDeclaration?.call(
          node,
        );
  }
}

// node.visitChildren(
//     TreeVisitor(
//       onClassDeclaration: (node) => print(
//         "onClassDeclaration: $node",
//       ),
//       onClassTypeAlias: (node) => print(
//         "onClassTypeAlias: $node",
//       ),
//       onConstructorDeclaration: (node) => print(
//         "onConstructorDeclaration: $node",
//       ),
//       onConstructorFieldInitializer: (node) => print(
//         "onConstructorFieldInitializer: $node",
//       ),
//       onDefaultFormalParameter: (node) => print(
//         "onDefaultFormalParameter: $node",
//       ),
//       onFieldDeclaration: (node) => print(
//         "onFieldDeclaration: $node",
//       ),
//       onFieldFormalParameter: (node) => print(
//         "onFieldFormalParameter: $node",
//       ),
//       onFunctionDeclaration: (node) => print(
//         "onFunctionDeclaration: $node",
//       ),
//       onMethodDeclaration: (node) => print(
//         "onMethodDeclaration: $node",
//       ),
//       onSimpleFormalParameter: (node) => print(
//         "onSimpleFormalParameter: $node",
//       ),
//             onSimpleIdentifier: (node) => print(
//         "onSimpleIdentifier: $node",
//       ),
//       onVariableDeclaration: (node) => print(
//         "onVariableDeclaration: $node",
//       ),
//     ),
//   );
