// identified tokens of orange lang.
enum TokenType {
  moteghayer, identifier, number, equals, plus, semicolon, eof
}

class Token {
  final TokenType type;
  final String lexeme;
  final dynamic literal;

  Token(this.type, this.lexeme, [this.literal]);

  @override
  String toString() => 'Token($type, "$lexeme", $literal)';
}
