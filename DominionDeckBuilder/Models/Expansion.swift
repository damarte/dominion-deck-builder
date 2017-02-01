import Foundation

struct Expansion: Equatable
{
    var name: String
}

func ==(lhs: Expansion, rhs: Expansion) -> Bool
{
    return lhs.name == rhs.name
}

