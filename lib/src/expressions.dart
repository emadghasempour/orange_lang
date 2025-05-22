import 'token.dart';

abstract class Expr {
  R accept<R>(ExprVisitor<R> visitor);
}

abstract class ExprVisitor<R> {
  R visitNumberExpr(Number expr);
  R visitVariableExpr(Variable expr);
  R visitBinaryExpr(Binary expr);
  R visitAssignExpr(Assign expr);
}

class Number implements Expr {
  final num value;
  Number(this.value);

  @override
  R accept<R>(ExprVisitor<R> visitor) => visitor.visitNumberExpr(this);
}

class Variable implements Expr {
  final String name;
  Variable(this.name);

  @override
  R accept<R>(ExprVisitor<R> visitor) => visitor.visitVariableExpr(this);
}

class Binary implements Expr {
  final Expr left;
  final Token operator;
  final Expr right;
  Binary(this.left, this.operator, this.right);

  @override
  R accept<R>(ExprVisitor<R> visitor) => visitor.visitBinaryExpr(this);
}

class Assign implements Expr {
  final String name;
  final Expr value;
  Assign(this.name, this.value);

  @override
  R accept<R>(ExprVisitor<R> visitor) => visitor.visitAssignExpr(this);
}