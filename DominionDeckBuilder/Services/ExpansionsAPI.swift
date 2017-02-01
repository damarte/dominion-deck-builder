import Foundation
import FirebaseDatabase

class ExpansionsAPI: ExpansionsStoreProtocol
{
    // MARK: - CRUD operations - Optional error
    
    func fetchExpansions(completionHandler: @escaping ([Expansion], ExpansionsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? NSDictionary
            var expansions: [Expansion] = []
            
            for value in values?.allKeys as! [String] {
                expansions.append(Expansion(name: value))
            }
            
            completionHandler(expansions, nil)
            
        }) { (error) in
            completionHandler([], ExpansionsStoreError.CannotFetch("No se han podido obtener las expanciones"))
        }
    }
    
    func fetchExpansion(id: String, completionHandler: @escaping (Expansion?, ExpansionsStoreError?) -> Void)
    {
        let ref = FIRDatabase.database().reference()
        
        ref.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? NSDictionary
            var expansion: Expansion?
            
            for value in values?.allKeys as! [String] {
                if(value == id){
                    expansion = Expansion(name: value)
                }
            }
            
            completionHandler(expansion, nil)
            
        }) { (error) in
            completionHandler(nil, ExpansionsStoreError.CannotFetch("No se han podido obtener la expansión"))
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
    
    func fetchExpansions(completionHandler: (() throws -> [Expansion]) -> Void)
    {
    }
    
    func fetchExpansion(id: String, completionHandler: (() throws -> Expansion?) -> Void)
    {
    }
}
