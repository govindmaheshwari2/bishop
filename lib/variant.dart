import 'piece_type.dart';

class Variant {
  final String name;
  final BoardSize boardSize;
  final Map<String, PieceType> pieceTypes;
  final bool castling;
  final String? castleTarget;
  final String startPosition;
  final bool promotion;

  Variant({
    required this.name,
    required this.boardSize,
    required this.pieceTypes,
    this.castling = false,
    this.castleTarget,
    required this.startPosition,
    this.promotion = false,
  }) {
    normalisePieces();
  }

  void normalisePieces() {
    pieceTypes.forEach((_, p) => p.normalise(boardSize));
  }

  factory Variant.standard() {
    return Variant(
      name: 'Chess',
      boardSize: BoardSize.standard(),
      castling: true,
      castleTarget: 'R',
      startPosition: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      promotion: true,
      pieceTypes: {
        'P': PieceType.pawn(),
        'N': PieceType.knight(),
        'B': PieceType.bishop(),
        'R': PieceType.rook(),
        'Q': PieceType.queen(),
        'K': PieceType.king(),
      },
    );
  }
}

class BoardSize {
  final int h;
  final int v;
  int get numSquares => h * v;
  const BoardSize(this.h, this.v);
  factory BoardSize.standard() => BoardSize(8, 8);
}
