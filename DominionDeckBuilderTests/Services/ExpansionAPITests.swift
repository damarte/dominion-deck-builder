@testable import DominionDeckBuilder
import XCTest

class ExpansionsAPITests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ExpansionsAPI!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupExpansionsAPI()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupExpansionsAPI()
    {
        sut = ExpansionsAPI()
    }
    
    // MARK: - Test CRUD operations - Optional error
    
    func testFetchExpansionsShouldReturnListOfExpansions_OptionalError()
    {
        // Given
        
        // When
        var returnedExpansions = [Expansion]()
        let expect = expectation(description: "Wait for fetchExpansions() to return")

        sut.fetchExpansions { (expansions: [Expansion], error: ExpansionsStoreError?) -> Void in
            returnedExpansions = expansions
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "El error tiene que ser nil")
        }
        
        // Then
        XCTAssertGreaterThan(returnedExpansions.count, 0, "Tiene que devolver más de una expansion")
    }
    
    func testFetchExpansionShouldReturnExpansion_OptionalError()
    {
        // Given
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: "Dominion") { (expansion: Expansion?, error: ExpansionsStoreError?) -> Void in
            returnedExpansion = expansion
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "El error tiene que ser nil")
        }
        
        // Then
        XCTAssertNotNil(returnedExpansion, "fetchExpansion() should return an expansion")
    }
    
    // MARK: - Test CRUD operations - Generic enum result type
    
    func testFetchOrdersShouldReturnListOfOrders_GenericEnumResultType()
    {
        // Given
        
        // When
        
        // Then
    }
    
    func testFetchOrderShouldReturnOrder_GenericEnumResultType()
    {
        // Given
        
        // When
        
        // Then
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    func testFetchOrdersShouldReturnListOfOrders_InnerClosure()
    {
        // Given
        
        // When
        
        // Then
    }
    
    func testFetchOrderShouldReturnOrder_InnerClosure()
    {
        // Given
        
        // When
        
        // Then
    }
}
