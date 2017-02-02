import Foundation

// MARK: - Orders worker

class ExpansionsWorker
{
    var expansionStore: ExpansionsStoreProtocol
    
    init(expansionStore: ExpansionsStoreProtocol)
    {
        self.expansionStore = expansionStore
    }
    
    func fetchExpansions(completionHandler: @escaping ([Expansion]) -> Void)
    {
        expansionStore.fetchExpansions { (expansions: () throws -> [Expansion]) -> Void in
            do {
                let expansions = try expansions()
                completionHandler(expansions)
            } catch {
                completionHandler([])
            }
        }
    }
}

// MARK: - Orders store API

protocol ExpansionsStoreProtocol
{
    // MARK: CRUD operations - Optional error
    
    func fetchExpansions(completionHandler: @escaping ([Expansion], ExpansionsStoreError?) -> Void)
    func fetchExpansion(id: String, completionHandler: @escaping (Expansion?, ExpansionsStoreError?) -> Void)
    
    // MARK: CRUD operations - Generic enum result type
    
    func fetchExpansions(completionHandler: @escaping ExpansionsStoreFetchExpansionsCompletionHandler)
    func fetchExpansion(id: String, completionHandler: @escaping ExpansionsStoreFetchExpansionCompletionHandler)
    
    // MARK: CRUD operations - Inner closure
    
    func fetchExpansions(completionHandler: @escaping (() throws -> [Expansion]) -> Void)
    func fetchExpansion(id: String, completionHandler: @escaping (() throws -> Expansion?) -> Void)
}

// MARK: - Orders store CRUD operation results

typealias ExpansionsStoreFetchExpansionsCompletionHandler = (ExpansionsStoreResult<[Expansion]>) -> Void
typealias ExpansionsStoreFetchExpansionCompletionHandler = (ExpansionsStoreResult<Expansion>) -> Void

enum ExpansionsStoreResult<U>
{
    case Success(result: U)
    case Failure(error: ExpansionsStoreError)
}

// MARK: - Orders store CRUD operation errors

enum ExpansionsStoreError: Equatable, Error
{
    case CannotFetch(String)
}

func ==(lhs: ExpansionsStoreError, rhs: ExpansionsStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}
