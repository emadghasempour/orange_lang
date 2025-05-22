import 'package:orange_lang/src/expressions.dart';
import 'package:orange_lang/src/token.dart';

class Interpreter implements ExprVisitor<num> {
  final Map<String, num> variables = {};

  
  void interpret(List<Expr> expressions) {
    try {
      for (Expr expression in expressions) {
        num result = expression.accept(this);
        if (expression == expressions.last) {
          print('Result: $result');
        }
      }
    } catch (e) {
      print('Runtime error: $e');
    }
  }

  @override
  num visitNumberExpr(Number expr) {
    return expr.value;
  }

  @override
  num visitVariableExpr(Variable expr) {
    if (variables.containsKey(expr.name)) {
      return variables[expr.name]!;
    }
    throw Exception('Undefined variable: ${expr.name}');
  }

  @override
  num visitBinaryExpr(Binary expr) {
    num left = expr.left.accept(this);
    num right = expr.right.accept(this);

    switch (expr.operator.type) {
      case TokenType.plus:
        return left + right;
      default:
        throw Exception('Unknown operator: ${expr.operator.type}');
    }
  }

  @override
  num visitAssignExpr(Assign expr) {
    num value = expr.value.accept(this);
    variables[expr.name] = value;
    return value;
  }
}