import XCTest
@testable import DominionDeckBuilder

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
            XCTAssertNil(error, "fetchExpansions() should not return an error: \(error)")
            returnedExpansions = expansions
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedExpansions.count, 0, "fetchExpansions() should return an expansion")
    }
    
    func testFetchExpansionShouldReturnExpansion_OptionalError()
    {
        // Given
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: "Dominion") { (expansion: Expansion?, error: ExpansionsStoreError?) -> Void in
            XCTAssertNil(error, "fetchExpansion() should not return an error: \(error)")
            returnedExpansion = expansion
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedExpansion, "fetchExpansion() should return an expansion")
    }
    
    // MARK: - Test CRUD operations - Generic enum result type
    
    func testFetchExpansionsShouldReturnListOfExpansions_GenericEnumResultType()
    {
        // Given
        
        // When
        var returnedExpansions = [Expansion]()
        let expect = expectation(description: "Wait for fetchExpansions() to return")
        
        sut.fetchExpansions { (result: ExpansionsStoreResult<[Expansion]>) -> Void in
            switch (result) {
            case .Success(let expansions):
                returnedExpansions = expansions
            case .Failure(let error):
                XCTFail("fetchExpansions() should not return an error: \(error)")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedExpansions.count, 0, "fetchExpansions() should return an expansion")
    }
    
    func testFetchExpansionShouldReturnExpansion_GenericEnumResultType()
    {
        // Given
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: "Dominion") { (result: ExpansionsStoreResult<Expansion>) in
            switch (result) {
            case .Success(let expansion):
                returnedExpansion = expansion
            case .Failure(let error):
                XCTFail("fetchExpansion() should not return an error: \(error)")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedExpansion, "fetchExpansion() should return an expansion")
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    func testFetchExpansionsShouldReturnListOfExpansions_InnerClosure()
    {
        // Given
        
        // When
        var returnedExpansions = [Expansion]()
        let expect = expectation(description: "Wait for fetchExpansions() to return")
        
        sut.fetchExpansions { (expansions: () throws -> [Expansion]) -> Void in
            returnedExpansions = try! expansions()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedExpansions.count, 0, "fetchExpansions() should return an expansion")
    }
    
    func testFetchExpansionShouldReturnExpansion_InnerClosure()
    {
        // Given
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: "Dominion") { (expansion: () throws -> Expansion?) -> Void in
            do {
                returnedExpansion = try expansion()
            } catch {
                returnedExpansion = nil
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedExpansion, "fetchExpansion() should return an expansion")
    }
}
