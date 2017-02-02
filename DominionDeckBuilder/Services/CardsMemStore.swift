import Foundation

class CardsMemStore: CardsStoreProtocol
{
    // MARK: - Data
    
    var cards = [
        Card(costPotions: 0, costTreasure: 3, description: "Prueba1", expansion: Expansion(name: "Dominion", numCards: 0), id: "1", isAttack: false, isReaction: false, name: "Prueba1", plusActions: 2, plusBuys: 2, plusCards: 2, plusTreasure: 0, trashes: 0, treasure: 0, victoryPoints: 0),
        Card(costPotions: 0, costTreasure: 2, description: "Prueba2", expansion: Expansion(name: "Dark Age", numCards: 0), id: "1", isAttack: false, isReaction: false, name: "Prueba2", plusActions: 1, plusBuys: 1, plusCards: 1, plusTreasure: 0, trashes: 0, treasure: 0, victoryPoints: 0),
    ]
    
    // MARK: - CRUD operations - Optional error
    
    func fetchCards(completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    {
        completionHandler(cards, nil)
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    {
        let filterCards = cards.filter { (card: Card) -> Bool in
            return card.expansion == expansion
            }

        completionHandler(filterCards, nil)
    }
    
    func fetchCard(id: String, completionHandler: @escaping (Card?, CardsStoreError?) -> Void)
    {
        let card = cards.filter { (card: Card) -> Bool in
            return card.id == id
            }.first
        if let _ = card {
            completionHandler(card, nil)
        } else {
            completionHandler(nil, CardsStoreError.CannotFetch("Cannot fetch card with id \(id)"))
        }
    }
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchCards(completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    {
        completionHandler(CardsStoreResult.Success(result: cards))
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    {
        let filterCards = cards.filter { (card: Card) -> Bool in
            return card.expansion == expansion
        }
        
        completionHandler(CardsStoreResult.Success(result: filterCards))
    }
    
    func fetchCard(id: String, completionHandler: @escaping CardsStoreFetchCardCompletionHandler)
    {
        let card = cards.filter { (card: Card) -> Bool in
            return card.id == id
            }.first
        if let card = card {
            completionHandler(CardsStoreResult.Success(result: card))
        } else {
            completionHandler(CardsStoreResult.Failure(error: CardsStoreError.CannotFetch("Cannot fetch card with id \(id)")))
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchCards(completionHandler: @escaping (() throws -> [Card]) -> Void)
    {
        completionHandler { return cards }
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping (() throws -> [Card]) -> Void)
    {
        let filterCards = cards.filter { (card: Card) -> Bool in
            return card.expansion == expansion
        }
        
        completionHandler { return filterCards }
    }
    
    func fetchCard(id: String, completionHandler: @escaping (() throws -> Card?) -> Void)
    {
        let card = cards.filter { (card: Card) -> Bool in
            return card.id == id
            }.first
        if let card = card {
            completionHandler { return card }
        } else {
            completionHandler { throw CardsStoreError.CannotFetch("Cannot fetch card with id \(id)") }
        }
    }
}
