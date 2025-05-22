import 'package:orange_lang/src/expressions.dart';
import 'package:orange_lang/src/token.dart';

class Parser {
  final List<Token> tokens;
  int current = 0;

  Parser(this.tokens);

  List<Expr> parse() {
    List<Expr> expressions = [];
    while (!isAtEnd()) {
      expressions.add(statement());
    }
    return expressions;
  }

  Expr statement() {
    if (match(TokenType.moteghayer)) {
      return moteghayerStatement();
    }
    return expressionStatement();
  }

  Expr moteghayerStatement() {
    Token name = consume(TokenType.identifier, "Expected variable name after 'moteghayer'");
    consume(TokenType.equals, "Expected '=' after variable name");
    Expr initializer = expression();
    consume(TokenType.semicolon, "Expected ';' after variable declaration");
    return Assign(name.lexeme, initializer);
  }

  Expr expressionStatement() {
    Expr expr = expression();
    consume(TokenType.semicolon, "Expected ';' after expression");
    return expr;
  }

  Expr expression() {
    return assignment();
  }

  Expr assignment() {
    Expr expr = addition();

    if (match(TokenType.equals)) {
      Token equals = previous();
      Expr value = assignment();

      if (expr is Variable) {
        return Assign(expr.name, value);
      }

      throw Exception('Invalid assignment target.');
    }

    return expr;
  }

  Expr addition() {
    Expr expr = primary();

    while (match(TokenType.plus)) {
      Token operator = previous();
      Expr right = primary();
      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr primary() {
    if (match(TokenType.number)) {
      return Number(previous().literal);
    }

    if (match(TokenType.identifier)) {
      return Variable(previous().lexeme);
    }

    throw Exception('Expected expression.');
  }

  // Helper methods
  bool match(TokenType type) {
    if (check(type)) {
      advance();
      return true;
    }
    return false;
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  Token advance() {
    if (!isAtEnd()) current++;
    return previous();
  }

  bool isAtEnd() => peek().type == TokenType.eof;

  Token peek() => tokens[current];

  Token previous() => tokens[current - 1];

  Token consume(TokenType type, String message) {
    if (check(type)) return advance();
    throw Exception(message);
  }
}