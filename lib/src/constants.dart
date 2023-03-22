// ignore_for_file: constant_identifier_names

import 'package:bishop/bishop.dart';

typedef Colour = int;

extension Opponent on Colour {
  Colour get opponent => 1 - this;
}

typedef Hand = List<int>;

// TODO: there's a lot of stuff here now, maybe refactor and not call this constants?
class Bishop {
  static const version = '1.3.0';

  static const Colour white = 0;
  static const Colour black = 1;
  static const List<Colour> colours = [white, black];
  static const Colour neutralHostile = 2;
  static const Colour neutralPassive = 3;

  static const int boardStart = 0;
  static const int invalid = -1;
  static const int hand = -2;
  static const Square empty = 0;
  static const defaultSeed = 7363661891;

  static const List<int> playerDirection = [-1, 1, -1, -1];
  static const List<String> playerName = [
    'White',
    'Black',
    'Neutral',
    'Neutral',
  ];
  // temporary, this will be controllable/generative eventually
  static const numPlayers = 4;

  static const int asciiA = 97;
  static const int mateLower = 90000;
  static const int mateUpper = 100000;
  static const int defaultPieceValue = 200;

  static const int flagsStartBit = 18;

  // Just shorthands for building variants
  static const int fileA = 0;
  static const int fileB = 1;
  static const int fileC = 2;
  static const int fileD = 3;
  static const int fileE = 4;
  static const int fileF = 5;
  static const int fileG = 6;
  static const int fileH = 7;
  static const int fileI = 8;
  static const int fileJ = 9;
  static const int fileK = 10;
  static const int fileL = 11;
  static const int fileM = 12;
  static const int fileN = 13;
  static const int fileO = 14;
  static const int fileP = 15;

  static const int rank1 = 0;
  static const int rank2 = 1;
  static const int rank3 = 2;
  static const int rank4 = 3;
  static const int rank5 = 4;
  static const int rank6 = 5;
  static const int rank7 = 6;
  static const int rank8 = 7;
  static const int rank9 = 8;
  static const int rank10 = 9;
  static const int rank11 = 10;
  static const int rank12 = 11;
  static const int rank13 = 12;
  static const int rank14 = 13;
  static const int rank15 = 14;
  static const int rank16 = 15;

  static const Map<String, String> unicodePieces = {
    'R': '♜',
    'N': '♞',
    'B': '♝',
    'Q': '♛',
    'K': '♚',
    'P': '♟',
    'r': '♖',
    'n': '♘',
    'b': '♗',
    'q': '♕',
    'k': '♔',
    'p': '♙',
    '.': '·'
  };

  /// Gets the file for [square], according to [size].
  static int file(int square, [BoardSize size = BoardSize.standard]) =>
      size.file(square);

  /// Gets the rank for [square], according to [size].
  static int rank(int square, [BoardSize size = BoardSize.standard]) =>
      size.rank(square);

  /// Returns the square index at [file] and [rank], according to [size].
  static int square(
    int file,
    int rank, [
    BoardSize size = BoardSize.standard,
  ]) =>
      size.square(file, rank);

  /// Determines whether a square is on the board.
  static bool onBoard(int square, [BoardSize size = const BoardSize(8, 8)]) =>
      size.onBoard(square);

  /// Returns the name for a square, according to chess conventions, e.g. c6, b1.
  static String squareName(
    int square, [
    BoardSize size = const BoardSize(8, 8),
  ]) =>
      size.squareName(square);

  /// Returns the square id for a square with [name].
  static int squareNumber(
    String name, [
    BoardSize size = const BoardSize(8, 8),
  ]) =>
      size.squareNumber(name);
}

enum Modality {
  quiet('m'),
  capture('c'),
  both('');

  final String betza;
  const Modality(this.betza);
  factory Modality.fromBetza(String betza) =>
      values.firstWhere((e) => e.betza == betza);
}

enum GatingMode {
  none,
  flex,
  fixed;

  bool operator >(GatingMode other) => index > other.index;
  bool operator <(GatingMode other) => index < other.index;
  bool operator >=(GatingMode other) => index >= other.index;
  bool operator <=(GatingMode other) => index <= other.index;
}

/// All built in variants.
enum Variants {
  chess(Variant.standard),
  standard(Variant.standard),
  chess960(CommonVariants.chess960),
  crazyhouse(CommonVariants.crazyhouse),
  capablanca(LargeVariants.capablanca),
  grand(LargeVariants.grand),
  shako(LargeVariants.shako),
  mini(SmallVariants.mini),
  miniRandom(SmallVariants.miniRandom),
  micro(SmallVariants.micro),
  nano(SmallVariants.nano),
  seirawan(CommonVariants.seirawan),
  threeCheck(CommonVariants.threeCheck),
  koth(CommonVariants.kingOfTheHill),
  atomic(CommonVariants.atomic),
  horde(CommonVariants.horde),
  racingKings(CommonVariants.racingKings),
  antichess(CommonVariants.antichess),
  musketeer(Musketeer.variant),
  xiangqi(Xiangqi.xiangqi),
  miniXiangqi(Xiangqi.mini),
  manchu(Xiangqi.manchu),
  shogi(Shogi.shogi),
  dobutsu(Dobutsu.dobutsu),
  spawn(MiscVariants.spawn),
  kinglet(MiscVariants.kinglet),
  threeKings(MiscVariants.threeKings),
  domination(MiscVariants.domination),
  dart(MiscVariants.dart),
  andernach(MiscVariants.andernach),
  jesonMor(MiscVariants.jesonMor),
  legan(MiscVariants.legan),
  hoppelPoppel(FairyVariants.hoppelPoppel),
  grasshopper(FairyVariants.grasshopper),
  berolina(FairyVariants.berolina),
  orda(Orda.orda),
  ordaMirror(Orda.ordaMirror);

  final Variant Function() builder;
  const Variants(this.builder);

  /// Builds a `Variant` for use with `Game`.
  Variant build() => builder();
}

class BishopException {
  final String? message;
  const BishopException([this.message]);

  @override
  String toString() =>
      message == null ? 'BishopException' : 'BishopException($message)';
}

typedef MoveChecker = bool Function(MoveParams params);

class MoveParams {
  final int colour;
  final BishopState state;
  final BuiltVariant variant;
  const MoveParams({
    required this.colour,
    required this.state,
    required this.variant,
  });
}

/// Defines forced capture behaviour.
/// Currently only [any] is supported, meaning that any capture move is allowed
/// if there are capture moves, but no non-capturing (quiet) moves.
enum ForcedCapture {
  any;
  // todo: support 'most pieces' option like draughts, and highest value

  const ForcedCapture();
  static ForcedCapture fromName(String name) =>
      values.firstWhere((e) => e.name == name);
}
