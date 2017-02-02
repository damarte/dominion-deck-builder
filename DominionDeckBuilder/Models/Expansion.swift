import Foundation

struct Expansion: Equatable
{
    var name: String
    var numCards: Int
}

func ==(lhs: Expansion, rhs: Expansion) -> Bool
{
    return lhs.name == rhs.name
}

