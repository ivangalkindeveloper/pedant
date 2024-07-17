import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class ElementTreeVisitor extends RecursiveElementVisitor {
  const ElementTreeVisitor({
    this.onLocalVariableElement,
  });

  final void Function(
    LocalVariableElement node,
  )? onLocalVariableElement;

  @override
  void visitLocalVariableElement(
    LocalVariableElement element,
  ) {
    super.visitLocalVariableElement(
      element,
    );
    this.onLocalVariableElement?.call(
          element,
        );
  }
}
