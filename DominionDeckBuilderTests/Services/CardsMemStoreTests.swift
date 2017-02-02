@testable import DominionDeckBuilder
import XCTest

class CardsMemStoreTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: CardsMemStore!
    var testCards: [Card]!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupCardsMemStore()
    }
    
    override func tearDown()
    {
        resetCardsMemStore()
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupCardsMemStore()
    {
        sut = CardsMemStore()
        
        testCards = sut.cards
    }
    
    func resetCardsMemStore()
    {
        testCards = []
        sut = nil
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
        XCTAssertEqual(returnedCards.count, testCards.count, "fetchExpansions() should return a list of expansions")
        for card in returnedCards {
            XCTAssert(testCards.contains(card), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_OptionalError()
    {
        // Given
        let expansionToFetch = testCards.first?.expansion
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: expansionToFetch!) { (cards: [Card], error: CardsStoreError?) -> Void in
            XCTAssertNil(error, "fetchCards() should not return an error: \(error)")
            returnedCards = cards
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        for card in returnedCards {
            XCTAssertTrue(card.expansion == expansionToFetch, "Card have incorrect expansion")
        }
    }
    
    func testFetchCardShouldReturnCard_OptionalError()
    {
        // Given
        let cardToFetch = testCards.first!
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: cardToFetch.id) { (card: Card?, error: CardsStoreError?) -> Void in
            XCTAssertNil(error, "fetchCard() should not return an error: \(error)")
            returnedCard = card
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertEqual(returnedCard, cardToFetch, "fetchExpansion() should return an expansion")
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
        XCTAssertEqual(returnedCards.count, testCards.count, "fetchExpansions() should return a list of expansions")
        for card in returnedCards {
            XCTAssert(testCards.contains(card), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_GenericEnumResultType()
    {
        // Given
        let expansionToFetch = testCards.first?.expansion
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: expansionToFetch!) { (result: CardsStoreResult<[Card]>) -> Void in
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
        for card in returnedCards {
            XCTAssertTrue(card.expansion == expansionToFetch, "Card have incorrect expansion")
        }
    }
    
    func testFetchCardsShouldReturnCard_GenericEnumResultType()
    {
        // Given
        let cardToFetch = testCards.first!
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: cardToFetch.id) { (result: CardsStoreResult<Card>) in
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
        XCTAssertEqual(returnedCard, cardToFetch, "fetchExpansion() should return an expansion")
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
        XCTAssertEqual(returnedCards.count, testCards.count, "fetchExpansions() should return a list of expansions")
        for card in returnedCards {
            XCTAssert(testCards.contains(card), "Returned expansions should match the expansions in the data store")
        }
    }
    
    func testFetchCardsShouldReturnListOfCardsOfExpansion_InnerClosure()
    {
        // Given
        let expansionToFetch = testCards.first?.expansion
        
        // When
        var returnedCards = [Card]()
        let expect = expectation(description: "Wait for fetchCards() to return")
        
        sut.fetchCards(expansion: expansionToFetch!) { (cards: () throws -> [Card]) -> Void in
            returnedCards = try! cards()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        for card in returnedCards {
            XCTAssertTrue(card.expansion == expansionToFetch, "Card have incorrect expansion")
        }
    }
    
    func testFetchCardShouldReturnCard_InnerClosure()
    {
        // Given
        let cardToFetch = testCards.first!
        
        // When
        var returnedCard: Card?
        let expect = expectation(description: "Wait for fetchCard() to return")
        sut.fetchCard(id: cardToFetch.id) { (card: () throws -> Card?) -> Void in
            returnedCard = try! card()
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            XCTAssertNil(error, "Timeout")
        }
        
        // Then
        XCTAssertEqual(returnedCard, cardToFetch, "fetchExpansion() should return an expansion")
    }
}
