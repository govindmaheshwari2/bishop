part of '../variant.dart';

/// This is a work in progress.
/// Many rules, specifically those related to dropping, are not implemented yet.
class Shogi {
  static const defaultFen =
      'lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL[-] w 0 1';

  static PieceType pawn() =>
      PieceType.fromBetza('fW', promoOptions: promotesToGold);
  static PieceType silver() =>
      PieceType.fromBetza('FfW', promoOptions: promotesToGold);
  static PieceType lance() =>
      PieceType.fromBetza('fR', promoOptions: promotesToGold);
  static PieceType knight() =>
      PieceType.fromBetza('fN', promoOptions: promotesToGold);
  static PieceType gold() => PieceType.fromBetza('WfF');

  static PieceType bishop() => PieceType.fromBetza(
        'B',
        promoOptions: PiecePromoOptions.promotesToOne('H'),
      );
  static PieceType dragonHorse() => PieceType.fromBetza('WB');

  static PieceType rook() => PieceType.fromBetza(
        'R',
        promoOptions: PiecePromoOptions.promotesToOne('D'),
      );
  static PieceType dragonKing() => PieceType.fromBetza('FR');

  static PiecePromoOptions get promotesToGold =>
      PiecePromoOptions.promotesToOne('G');

  static Variant shogi() => Variant(
        name: 'Shogi',
        boardSize: BoardSize(9, 9),
        pieceTypes: {
          'K': PieceType.king(),
          'N': knight(),
          'S': silver(),
          'L': lance(),
          'P': pawn(),
          'G': gold(),
          'R': rook(),
          'D': dragonKing(),
          'B': bishop(),
          'H': dragonHorse(),
        },
        startPosition: defaultFen,
        handOptions: HandOptions.captures,
        promotionOptions: PromotionOptions.optional(
          ranks: [Bishop.rank7, Bishop.rank3],
        ),
      );
}
