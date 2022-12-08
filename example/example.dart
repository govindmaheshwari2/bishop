import 'package:bishop/bishop.dart';

void main(List<String> args) async {
  String v = args.isNotEmpty ? args.first : 'standard';
  Variant variant = variantFromString(v) ?? Variant.standard();
  print('Starting game with variant ${variant.name}');
  await Future.delayed(const Duration(seconds: 3));
  Game game = Game(variant: variant);
  while (!game.gameOver) {
    print(game.ascii());
    print(game.fen);
    Move m = game.getRandomMove();
    print('${Bishop.playerName[game.turn]}: ${game.toSan(m)}');
    game.makeMove(m);
  }
  print(game.ascii());
  print(game.pgn());
}
