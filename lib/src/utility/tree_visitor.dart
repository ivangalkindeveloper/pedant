import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class TreeVisitor extends RecursiveAstVisitor<void> {
  const TreeVisitor({
    this.onFieldFormalParameter,
    this.onVariableDeclaration,
  });

  final void Function(
    FieldFormalParameter node,
  )? onFieldFormalParameter;
  final void Function(
    VariableDeclaration node,
  )? onVariableDeclaration;

  @override
  void visitFieldFormalParameter(
    FieldFormalParameter node,
  ) =>
      this.onFieldFormalParameter?.call(
            node,
          );

  @override
  void visitVariableDeclaration(
    VariableDeclaration node,
  ) =>
      this.onVariableDeclaration?.call(
            node,
          );
}
