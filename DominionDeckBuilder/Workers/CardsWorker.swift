import Foundation

// MARK: - Orders worker

class CardsWorker
{
    var CardStore: CardsStoreProtocol
    
    init(CardStore: CardsStoreProtocol)
    {
        self.CardStore = CardStore
    }
    
    func fetchCards(completionHandler: @escaping ([Card]) -> Void)
    {
        CardStore.fetchCards { (Cards: () throws -> [Card]) -> Void in
            do {
                let Cards = try Cards()
                completionHandler(Cards)
            } catch {
                completionHandler([])
            }
        }
    }
}

// MARK: - Orders store API

protocol CardsStoreProtocol
{
    // MARK: CRUD operations - Optional error
    
    func fetchCards(completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    func fetchCards(expansion: Expansion, completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    func fetchCard(id: String, completionHandler: @escaping (Card?, CardsStoreError?) -> Void)
    
    // MARK: CRUD operations - Generic enum result type
    
    func fetchCards(completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    func fetchCards(expansion: Expansion, completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    func fetchCard(id: String, completionHandler: @escaping CardsStoreFetchCardCompletionHandler)
    
    // MARK: CRUD operations - Inner closure
    
    func fetchCards(completionHandler: @escaping (() throws -> [Card]) -> Void)
    func fetchCards(expansion: Expansion, completionHandler: @escaping (() throws -> [Card]) -> Void)
    func fetchCard(id: String, completionHandler: @escaping (() throws -> Card?) -> Void)
}

// MARK: - Orders store CRUD operation results

typealias CardsStoreFetchCardsCompletionHandler = (CardsStoreResult<[Card]>) -> Void
typealias CardsStoreFetchCardCompletionHandler = (CardsStoreResult<Card>) -> Void

enum CardsStoreResult<U>
{
    case Success(result: U)
    case Failure(error: CardsStoreError)
}

// MARK: - Orders store CRUD operation errors

enum CardsStoreError: Equatable, Error
{
    case CannotFetch(String)
}

func ==(lhs: CardsStoreError, rhs: CardsStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}
