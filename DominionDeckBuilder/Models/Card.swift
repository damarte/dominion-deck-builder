import Foundation

struct Card: Equatable
{
    var costPotions: Int
    var costTreasure: Int
    var description: String
    var expansion: Expansion
    var id: String
    var isAttack: Bool
    var isReaction: Bool
    var name: String
    var plusActions: Int
    var plusBuys: Int
    var plusCards: Int
    var plusTreasure: Int
    var trashes: Int
    var treasure: Int
    var victoryPoints: Int
}

func ==(lhs: Card, rhs: Card) -> Bool
{
    return lhs.costPotions == rhs.costPotions
        && lhs.costTreasure == rhs.costTreasure
        && lhs.description == rhs.description
        && lhs.expansion == rhs.expansion
        && lhs.id == rhs.id
        && lhs.isAttack == rhs.isAttack
        && lhs.isReaction == rhs.isReaction
        && lhs.name == rhs.name
        && lhs.plusActions == rhs.plusActions
        && lhs.plusBuys == rhs.plusBuys
        && lhs.plusCards == rhs.plusCards
        && lhs.plusTreasure == rhs.plusTreasure
        && lhs.trashes == rhs.trashes
        && lhs.treasure == rhs.treasure
        && lhs.victoryPoints == rhs.victoryPoints
}

