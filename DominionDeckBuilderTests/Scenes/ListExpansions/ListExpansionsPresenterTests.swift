//
//  ListExpansionsPresenterTests.swift
//  DominionDeckBuilder
//
//  Created by David on 2/2/17.
//  Copyright (c) 2017 damarte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import XCTest
@testable import DominionDeckBuilder

class ListExpansionsPresenterTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ListExpansionsPresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupListExpansionsPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListExpansionsPresenter()
    {
        sut = ListExpansionsPresenter()
    }
    
    // MARK: - Test doubles
    class ListExpansionsPresenterOutputSpy: ListExpansionsPresenterOutput
    {
        // MARK: Method call expectations
        var displayFetchedExpansionsCalled = false
        
        // MARK: Argument expectations
        var viewModel: ListExpansions.FetchExpansions.ViewModel!
        
        // MARK: Spied methods
        func displayFetchedExpansions(viewModel: ListExpansions.FetchExpansions.ViewModel)
        {
            displayFetchedExpansionsCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    func testPresentFetchedExpansionsShouldFormatFetchedExpansionsForDisplay()
    {
        // Given
        let listExpansionsPresenterOutputSpy = ListExpansionsPresenterOutputSpy()
        sut.output = listExpansionsPresenterOutputSpy
        
        let expansions = [Expansion(name: "Dominion", numCards: 0)]
        let response = ListExpansions.FetchExpansions.Response(expansions: expansions)
        
        // When
        sut.presentFetchedExpansions(response: response)
        
        // Then
        let displayedExpansions = listExpansionsPresenterOutputSpy.viewModel.displayedExpansions
        for displayedExpansion in displayedExpansions{
            XCTAssertEqual(displayedExpansion.name, "Dominion", "Presenting fetched expansions should properly format name")
            XCTAssertEqual(displayedExpansion.numCards, 0, "Presenting fetched expansions should properly format number of cards")
        }
    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders()
    {
        // Given
        let listExpansionsPresenterOutputSpy = ListExpansionsPresenterOutputSpy()
        sut.output = listExpansionsPresenterOutputSpy
        
        let expansions = [Expansion(name: "Dominion", numCards: 0)]
        let response = ListExpansions.FetchExpansions.Response(expansions: expansions)
        
        // When
        sut.presentFetchedExpansions(response: response)
        
        // Then
        XCTAssert(listExpansionsPresenterOutputSpy.displayFetchedExpansionsCalled, "Presenting fetched expansions should ask view controller to display them")
    }
}
