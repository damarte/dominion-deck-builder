import XCTest
@testable import DominionDeckBuilder

class CardsAPITests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: CardsAPI!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupCardsAPI()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupCardsAPI()
    {
        sut = CardsAPI()
    }
    
    // MARK: - Test CRUD operations - Optional error
    
    func testFetchCardsShouldReturnListOfCards_OptionalError()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards { (cards: [Card], error: CardsStoreError?) -> Void in
            XCTAssertNil(error, "fetchCards() should not return an error: \(error)")
            returnedCards = cards
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an card")
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_OptionalError()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: Expansion(name: "Dominion", numCards: 0)) { (cards: [Card], error: CardsStoreError?) -> Void in
            XCTAssertNil(error, "fetchCards() should not return an error: \(error)")
            returnedCards = cards
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an card")
    }
    
    func testFetchCardShouldReturnCard_OptionalError()
    {
        // Given
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: "1") { (card: Card?, error: CardsStoreError?) -> Void in
            XCTAssertNil(error, "fetchCard() should not return an error: \(error)")
            returnedCard = card
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedCard, "fetchCard() should return an card")
    }
    
    // MARK: - Test CRUD operations - Generic enum result type
    
    func testFetchCardsShouldReturnListOfCards_GenericEnumResultType()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards { (result: CardsStoreResult<[Card]>) -> Void in
            switch (result) {
            case .Success(let cards):
                returnedCards = cards
            case .Failure(let error):
                XCTFail("fetchCards() should not return an error: \(error)")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an Card")
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_GenericEnumResultType()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: Expansion(name: "Dominion", numCards: 0)) { (result: CardsStoreResult<[Card]>) -> Void in
            switch (result) {
            case .Success(let cards):
                returnedCards = cards
            case .Failure(let error):
                XCTFail("fetchCards() should not return an error: \(error)")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an Card")
    }
    
    func testFetchCardsShouldReturnCard_GenericEnumResultType()
    {
        // Given
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: "1") { (result: CardsStoreResult<Card>) in
            switch (result) {
            case .Success(let card):
                returnedCard = card
            case .Failure(let error):
                XCTFail("fetchCard() should not return an error: \(error)")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedCard, "fetchCard() should return an Card")
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    func testFetchCardsShouldReturnListOfCards_InnerClosure()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards { (cards: () throws -> [Card]) -> Void in
            returnedCards = try! cards()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an Card")
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_InnerClosure()
    {
        // Given
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: Expansion(name: "Dominion", numCards: 0)) { (cards: () throws -> [Card]) -> Void in
            returnedCards = try! cards()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertGreaterThan(returnedCards.count, 0, "fetchCards() should return an Card")
    }
    
    func testFetchCardShouldReturnCard_InnerClosure()
    {
        // Given
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: "1") { (card: () throws -> Card?) -> Void in
            do {
                returnedCard = try card()
            } catch {
                returnedCard = nil
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertNotNil(returnedCard, "fetchCard() should return an Card")
    }
}
