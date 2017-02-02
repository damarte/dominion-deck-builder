import Foundation

class ExpansionsMemStore: ExpansionsStoreProtocol
{
    // MARK: - Data
    
    var expansions = [
        Expansion(name: "Dominion"),
        Expansion(name: "Dark Ages"),
    ]
    
    // MARK: - CRUD operations - Optional error
    
    func fetchExpansions(completionHandler: @escaping ([Expansion], ExpansionsStoreError?) -> Void)
    {
        completionHandler(expansions, nil)
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping (Expansion?, ExpansionsStoreError?) -> Void)
    {
        let expansion = expansions.filter { (expansion: Expansion) -> Bool in
            return expansion.name == id
        }.first
        if let _ = expansion {
            completionHandler(expansion, nil)
        } else {
            completionHandler(nil, ExpansionsStoreError.CannotFetch("Cannot fetch expansion with id \(id)"))
        }
    }
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchExpansions(completionHandler: @escaping ExpansionsStoreFetchExpansionsCompletionHandler)
    {
        completionHandler(ExpansionsStoreResult.Success(result: expansions))
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping ExpansionsStoreFetchExpansionCompletionHandler)
    {
        let expansion = expansions.filter { (expansion: Expansion) -> Bool in
            return expansion.name == id
            }.first
        if let expansion = expansion {
            completionHandler(ExpansionsStoreResult.Success(result: expansion))
        } else {
            completionHandler(ExpansionsStoreResult.Failure(error: ExpansionsStoreError.CannotFetch("Cannot fetch expansion with id \(id)")))
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchExpansions(completionHandler: @escaping (() throws -> [Expansion]) -> Void)
    {
        completionHandler { return expansions }
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping (() throws -> Expansion?) -> Void)
    {
        let expansion = expansions.filter { (expansion: Expansion) -> Bool in
            return expansion.name == id
            }.first
        if let expansion = expansion {
            completionHandler { return expansion }
        } else {
            completionHandler { throw ExpansionsStoreError.CannotFetch("Cannot fetch expansion with id \(id)") }
        }
    }
}
