import Foundation
import FirebaseDatabase

class ExpansionsAPI: ExpansionsStoreProtocol
{
    // MARK: - CRUD operations - Optional error
    
    func fetchExpansions(completionHandler: @escaping ([Expansion], ExpansionsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: [[String: AnyObject]]]
            var expansions: [Expansion] = []
            
            for value in values! {
                expansions.append(Expansion(name: value.key))
            }
            
            completionHandler(expansions, nil)
            
        }) { (error) in
            completionHandler([], ExpansionsStoreError.CannotFetch("Cannot fetch expansions"))
        }
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping (Expansion?, ExpansionsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: [[String: AnyObject]]]
            var expansion: Expansion?
            
            for value in values! {
                if(value.key == id){
                    expansion = Expansion(name: value.key)
                }
            }
            
            completionHandler(expansion, nil)
            
        }) { (error) in
            completionHandler(nil, ExpansionsStoreError.CannotFetch("Cannot fetch expansion"))
        }
    }
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchExpansions(completionHandler: @escaping ExpansionsStoreFetchExpansionsCompletionHandler)
    {
        self.fetchExpansions { (expansions, error) in
            if let error = error {
                completionHandler(ExpansionsStoreResult.Failure(error: error))
            }
            else{
                completionHandler(ExpansionsStoreResult.Success(result: expansions))
            }
        }
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping ExpansionsStoreFetchExpansionCompletionHandler)
    {
        self.fetchExpansion(id:id) { (expansion, error) in
            if let error = error {
                completionHandler(ExpansionsStoreResult.Failure(error: error))
            }
            else{
                if let expansion = expansion {
                    completionHandler(ExpansionsStoreResult.Success(result: expansion))
                }
                else{
                    completionHandler(ExpansionsStoreResult.Failure(error: ExpansionsStoreError.CannotFetch("Cannot fetch expansion with id \(id)")))
                }
            }
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchExpansions(completionHandler: @escaping (() throws -> [Expansion]) -> Void)
    {
        self.fetchExpansions { (expansions, error) in
            if let error = error {
                completionHandler { throw ExpansionsStoreError.CannotFetch(error.localizedDescription) }
            }
            else{
                completionHandler { return expansions }
            }
        }
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping (() throws -> Expansion?) -> Void)
    {
        self.fetchExpansion(id:id) { (expansion, error) in
            if let error = error {
                completionHandler{ throw ExpansionsStoreError.CannotFetch(error.localizedDescription) }
            }
            else{
                if let expansion = expansion {
                    completionHandler{ return expansion }
                }
                else{
                    completionHandler { throw ExpansionsStoreError.CannotFetch("Cannot fetch expansion with id \(id)") }
                }
            }
        }
    }
}
