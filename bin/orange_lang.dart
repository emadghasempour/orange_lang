import 'package:orange_lang/src/token.dart';
import 'package:orange_lang/src/scanner.dart';
import 'package:orange_lang/src/expressions.dart';
import 'package:orange_lang/src/parser.dart';
import 'package:orange_lang/src/interpreter.dart';

void main(List<String> args) {
  String program = '''
    moteghayer first = 32;
    moteghayer second = 3;
    moteghayer z = first + second;
    
    z;
  ''';

  Scanner scanner = Scanner(program);
  List<Token> tokens = scanner.scanTokens();
  Parser parser = Parser(tokens);
  List<Expr> expressions = parser.parse();

  Interpreter interpreter = Interpreter();
  interpreter.interpret(expressions);
}