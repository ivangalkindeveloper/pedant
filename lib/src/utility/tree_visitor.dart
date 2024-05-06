import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class TreeVisitor extends RecursiveAstVisitor<void> {
  const TreeVisitor({
    required this.onVariableDeclaration,
  });

  final void Function(
    VariableDeclaration node,
  ) onVariableDeclaration;

  @override
  void visitVariableDeclaration(
    VariableDeclaration node,
  ) =>
      this.onVariableDeclaration(
        node,
      );
}
