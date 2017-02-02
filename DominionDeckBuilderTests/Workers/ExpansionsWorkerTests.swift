@testable import DominionDeckBuilder
import XCTest

class ExpansionsWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: ExpansionsWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupExpansionsWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupExpansionsWorker()
    {
        sut = ExpansionsWorker(expansionStore: ExpansionsMemStoreSpy())
    }
    
    // MARK: Test doubles
    
    class ExpansionsMemStoreSpy: ExpansionsMemStore
    {
        // MARK: Method call expectations
        var fetchedExpansionsCalled = false
        
        // MARK: Spied methods
        override func fetchExpansions(completionHandler: @escaping (() throws -> [Expansion]) -> Void) {
            fetchedExpansionsCalled = true
            let oneSecond = DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: oneSecond, execute: {
                completionHandler {
                    return [
                        Expansion(name: "Dominion"),
                        Expansion(name: "Dark Ages"),
                        ]
                }
            })
        }
    }
    
    // MARK: Tests
    
    func testFetchExpansionsShouldReturnListOfExpansions()
    {
        // Given
        let ExpansionsMemStoreSpy = sut.expansionStore as! ExpansionsMemStoreSpy
        
        // When
        let expectation = self.expectation(description: "Wait for fetchExpansions() to return")
        sut.fetchExpansions { (Expansions: [Expansion]) -> Void in
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(ExpansionsMemStoreSpy.fetchedExpansionsCalled, "Calling fetchExpansions() should ask the data store for a list of Expansions")
        waitForExpectations(timeout: 1.1) { _ in
            XCTAssert(true, "Calling fetchExpansions() should result in the completion handler being called with the fetched Expansions result")
        }
    }
}
