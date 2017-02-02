@testable import DominionDeckBuilder
import XCTest

class CardsWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: CardsWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupCardsWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupCardsWorker()
    {
        sut = CardsWorker(CardStore: CardsMemStoreSpy())
    }
    
    // MARK: Test doubles
    
    class CardsMemStoreSpy: CardsMemStore
    {
        // MARK: Method call expectations
        var fetchedCardsCalled = false
        
        // MARK: Spied methods
        override func fetchCards(completionHandler: @escaping (() throws -> [Card]) -> Void) {
            fetchedCardsCalled = true
            let oneSecond = DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: oneSecond, execute: {
                completionHandler {
                    return [
                        Card(costPotions: 0, costTreasure: 3, description: "Prueba1", expansion: Expansion(name: "Dominion"), id: "1", isAttack: false, isReaction: false, name: "Prueba1", plusActions: 2, plusBuys: 2, plusCards: 2, plusTreasure: 0, trashes: 0, treasure: 0, victoryPoints: 0),
                        Card(costPotions: 0, costTreasure: 2, description: "Prueba2", expansion: Expansion(name: "Dark Age"), id: "1", isAttack: false, isReaction: false, name: "Prueba2", plusActions: 1, plusBuys: 1, plusCards: 1, plusTreasure: 0, trashes: 0, treasure: 0, victoryPoints: 0),
                        ]
                }
            })
        }
    }
    
    // MARK: Tests
    
    func testFetchCardsShouldReturnListOfCards()
    {
        // Given
        let CardsMemStoreSpy = sut.CardStore as! CardsMemStoreSpy
        
        // When
        let expectation = self.expectation(description: "Wait for fetchCards() to return")
        sut.fetchCards { (cards: [Card]) -> Void in
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(CardsMemStoreSpy.fetchedCardsCalled, "Calling fetchCards() should ask the data store for a list of Cards")
        waitForExpectations(timeout: 1.1) { _ in
            XCTAssert(true, "Calling fetchCards() should result in the completion handler being called with the fetched Cards result")
        }
    }
}
