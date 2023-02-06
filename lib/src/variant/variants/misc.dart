part of '../variant.dart';

class MiscVariants {
  static Variant hoppelPoppel() => Variant.standard()
      .copyWith(name: 'Hoppel-Poppel')
      .withPieces({'N': PieceType.knibis(), 'B': PieceType.biskni()});

  static Variant spawn() => Variant.standard().copyWith(
        name: 'Spawn Chess',
        description:
            'Moving the exposed king adds a pawn to the player\'s hand.',
        startPosition: 'rnb1nbnr/8/3k4/8/8/4K3/8/RNBN1BNR[PPpp] w - - 0 1',
        handOptions: HandOptions.enabledOnly,
        castlingOptions: CastlingOptions.none,
        pieceTypes: {
          'P': PieceType.pawn(),
          'N': PieceType.knight(),
          'B': PieceType.fromBetza('B2'),
          'R': PieceType.fromBetza('R3'),
          'Q': PieceType.queen(),
          'K': PieceType.king().copyWith(
            actions: [ActionAddToHand('P')],
          ),
        },
      );
}