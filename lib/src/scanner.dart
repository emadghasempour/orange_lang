import 'package:orange_lang/src/token.dart';

class Scanner {
  final String source;
  final List<Token> tokens = [];
  int start = 0;
  int current = 0;

  static final Map<String, TokenType> keywords = {
    'moteghayer': TokenType.moteghayer,
  };

  Scanner(this.source);

  List<Token> scanTokens() {
    while (!isAtEnd()) {
      start = current;
      scanToken();
    }
    tokens.add(Token(TokenType.eof, '', null));
    return tokens;
  }

  bool isAtEnd() => current >= source.length;

  void scanToken() {
    String c = advance();
    switch (c) {
      case ' ':
      case '\r':
      case '\t':
      case '\n':
        break;
      case '=':
        addToken(TokenType.equals);
        break;
      case '+':
        addToken(TokenType.plus);
        break;
      case ';':
        addToken(TokenType.semicolon);
        break;
      default:
        if (isDigit(c)) {
          number();
        } else if (isAlpha(c)) {
          identifier();
        } else {
          throw Exception('Unexpected character: $c');
        }
    }
  }

  String advance() => source[current++];

  void addToken(TokenType type, [dynamic literal]) {
    String text = source.substring(start, current);
    tokens.add(Token(type, text, literal));
  }

  bool isDigit(String c) => c.compareTo('0') >= 0 && c.compareTo('9') <= 0;

  bool isAlpha(String c) =>
      (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
      (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) ||
      c == '_';

  bool isAlphaNumeric(String c) => isAlpha(c) || isDigit(c);

  void number() {
    while (isDigit(peek())) advance();

    // Parse as double to handle both integers and decimals
    String text = source.substring(start, current);
    addToken(TokenType.number, num.parse(text));
  }

  void identifier() {
    while (isAlphaNumeric(peek())) advance();

    String text = source.substring(start, current);
    TokenType type = keywords[text] ?? TokenType.identifier;
    addToken(type);
  }

  String peek() => isAtEnd() ? '\0' : source[current];
}