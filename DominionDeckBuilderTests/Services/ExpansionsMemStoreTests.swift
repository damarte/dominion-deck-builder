import XCTest
@testable import DominionDeckBuilder

class ExpansionsMemStoreTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ExpansionsMemStore!
    var testExpansions: [Expansion]!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupExpansionsMemStore()
    }
    
    override func tearDown()
    {
        resetCardsMemStore()
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupExpansionsMemStore()
    {
        sut = ExpansionsMemStore()
        
        testExpansions = sut.expansions
    }
    
    func resetCardsMemStore()
    {
        testExpansions = []
        sut = nil
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
        XCTAssertEqual(returnedExpansions.count, testExpansions.count, "fetchExpansions() should return a list of expansions")
        for expansion in returnedExpansions {
            XCTAssert(testExpansions.contains(expansion), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchExpansionShouldReturnExpansion_OptionalError()
    {
        // Given
        let expansionToFetch = testExpansions.first!
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: expansionToFetch.name) { (expansion: Expansion?, error: ExpansionsStoreError?) -> Void in
            XCTAssertNil(error, "fetchExpansion() should not return an error: \(error)")
            returnedExpansion = expansion
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertEqual(returnedExpansion, expansionToFetch, "fetchExpansion() should return an expansion")
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
        XCTAssertEqual(returnedExpansions.count, testExpansions.count, "fetchExpansions() should return a list of expansions")
        for expansion in returnedExpansions {
            XCTAssert(testExpansions.contains(expansion), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchExpansionShouldReturnExpansion_GenericEnumResultType()
    {
        // Given
        let expansionToFetch = testExpansions.first!
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: expansionToFetch.name) { (result: ExpansionsStoreResult<Expansion>) in
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
        XCTAssertEqual(returnedExpansion, expansionToFetch, "fetchExpansion() should return an expansion")
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
        XCTAssertEqual(returnedExpansions.count, testExpansions.count, "fetchExpansions() should return a list of expansions")
        for expansion in returnedExpansions {
            XCTAssert(testExpansions.contains(expansion), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchExpansionShouldReturnExpansion_InnerClosure()
    {
        // Given
        let expansionToFetch = testExpansions.first!
        
        // When
        var returnedExpansion: Expansion?
        let expect = expectation(description: "Wait for fetchExpansion() to return")
        sut.fetchExpansion(id: expansionToFetch.name) { (expansion: () throws -> Expansion?) -> Void in
            returnedExpansion = try! expansion()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertEqual(returnedExpansion, expansionToFetch, "fetchExpansion() should return an expansion")
    }
}
