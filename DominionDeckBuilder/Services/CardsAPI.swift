import Foundation
import FirebaseDatabase

class CardsAPI: CardsStoreProtocol
{
    // MARK: - CRUD operations - Optional error
    
    func fetchCards(completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: [[String: AnyObject]]]
            var cards: [Card] = []
            
            for value in values! {
                for data in value.value {
                    cards.append(self.cardFromDictionary(dictionary: data))
                }
            }
            
            completionHandler(cards, nil)
            
        }) { (error) in
            completionHandler([], CardsStoreError.CannotFetch("Cannot fetch cards"))
        }
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping ([Card], CardsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/\(expansion.name)").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [[String: AnyObject]]
            var cards: [Card] = []
            
            for data in values! {
                cards.append(self.cardFromDictionary(dictionary: data))
            }
            
            completionHandler(cards, nil)
            
        }) { (error) in
            completionHandler([], CardsStoreError.CannotFetch("Cannot fetch cards"))
        }
    }
    
    func fetchCard(id: String, completionHandler: @escaping (Card?, CardsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: [[String: AnyObject]]]
            var card: Card?
            
            for value in values! {
                for data in value.value {
                    if(String(data["id"] as! Int) == id){
                        card = self.cardFromDictionary(dictionary: data) as Card?
                        break
                    }
                }
            }
            
            completionHandler(card, nil)
            
        }) { (error) in
            completionHandler(nil, CardsStoreError.CannotFetch("Cannot fetch card"))
        }
    }
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchCards(completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    {
        self.fetchCards { (cards, error) in
            if let error = error {
                completionHandler(CardsStoreResult.Failure(error: error))
            }
            else{
                completionHandler(CardsStoreResult.Success(result: cards))
            }
        }
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping CardsStoreFetchCardsCompletionHandler)
    {
        self.fetchCards(expansion: expansion) { (cards, error) in
            if let error = error {
                completionHandler(CardsStoreResult.Failure(error: error))
            }
            else{
                completionHandler(CardsStoreResult.Success(result: cards))
            }
        }
    }
    
    func fetchCard(id: String, completionHandler: @escaping CardsStoreFetchCardCompletionHandler)
    {
        self.fetchCard(id: id) { (card, error) in
            if let error = error {
                completionHandler(CardsStoreResult.Failure(error: error))
            }
            else{
                if let card = card {
                    completionHandler(CardsStoreResult.Success(result: card))
                }
                else{
                    completionHandler(CardsStoreResult.Failure(error: CardsStoreError.CannotFetch("Cannot fetch card with id \(id)")))
                }
            }
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchCards(completionHandler: @escaping (() throws -> [Card]) -> Void)
    {
        self.fetchCards { (cards, error) in
            if let error = error {
                completionHandler { throw CardsStoreError.CannotFetch(error.localizedDescription) }
            }
            else{
                completionHandler { return cards }
            }
        }
    }
    
    func fetchCards(expansion: Expansion, completionHandler: @escaping (() throws -> [Card]) -> Void)
    {
        self.fetchCards(expansion: expansion) { (cards, error) in
            if let error = error {
                completionHandler { throw CardsStoreError.CannotFetch(error.localizedDescription) }
            }
            else{
                completionHandler { return cards }
            }
        }
    }
    
    func fetchCard(id: String, completionHandler: @escaping (() throws -> Card?) -> Void)
    {
        self.fetchCard(id: id) { (card, error) in
            if let error = error {
                completionHandler{ throw CardsStoreError.CannotFetch(error.localizedDescription) }
            }
            else{
                if let card = card {
                    completionHandler{ return card }
                }
                else{
                    completionHandler { throw CardsStoreError.CannotFetch("Cannot fetch card with id \(id)") }
                }
            }
        }
    }
    
    // MARK: - Utilities
    
    func cardFromDictionary(dictionary: [String: AnyObject]) -> Card {
        return Card(costPotions: (dictionary["cost_potions"] != nil) ? dictionary["cost_potions"] as! Int : 0,
                    costTreasure: (dictionary["cost_treasure"] != nil) ? dictionary["cost_treasure"] as! Int : 0,
                    description: (dictionary["description"] != nil) ? dictionary["description"] as! String : "",
                    expansion: Expansion(name: (dictionary["expansion"] != nil) ? dictionary["expansion"] as! String : ""),
                    id: String((dictionary["id"] != nil) ? dictionary["id"] as! Int : 0),
                    isAttack: dictionary["is_attack"] as! Bool,
                    isReaction: dictionary["is_reaction"] as! Bool,
                    name: (dictionary["name"] != nil) ? dictionary["name"] as! String : "",
                    plusActions: (dictionary["plus_actions"] != nil) ? dictionary["plus_actions"] as! Int : 0,
                    plusBuys: (dictionary["plus_buys"] != nil) ? dictionary["plus_buys"] as! Int : 0,
                    plusCards: (dictionary["plus_cards"] != nil) ? dictionary["plus_cards"] as! Int : 0,
                    plusTreasure: (dictionary["plus_treasure"] != nil) ? dictionary["plus_treasure"] as! Int : 0,
                    trashes: (dictionary["trashes"] != nil) ? dictionary["trashes"] as! Int : 0,
                    treasure: (dictionary["treasure"] != nil) ? dictionary["treasure"] as! Int : 0,
                    victoryPoints: (dictionary["victory_points"] != nil) ? dictionary["victory_points"] as! Int : 0)
    }
}
