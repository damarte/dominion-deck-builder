//
//  ListExpansionsInteractorTests.swift
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

class ListExpansionsInteractorTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ListExpansionsInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupListExpansionsInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListExpansionsInteractor()
    {
        sut = ListExpansionsInteractor()
    }
    
    // MARK: - Test doubles
    class ListExpansionsInteractorOutputSpy: ListExpansionsInteractorOutput
    {
        // MARK: Method call expectations
        var presentFetchedExpansionCalled = false
        
        // MARK: Spied methods
        func presentFetchedExpansions(response: ListExpansions.FetchExpansions.Response)
        {
            presentFetchedExpansionCalled = true
        }
    }
    
    class ExpansionsWorkerSpy: ExpansionsWorker
    {
        // MARK: Method call expectations
        var fetchExpansionsCalled = false
        
        // MARK: Spied methods
        override func fetchExpansions(completionHandler: @escaping ([Expansion]) -> Void) {
            fetchExpansionsCalled = true
            completionHandler([])
        }
    }
    
    // MARK: - Tests
    
    func testFetchOrdersShouldAskOrdersWorkerToFetchOrdersAndPresenterToFormatResult()
    {
        // Given
        let listExpansionsInteractorOutputSpy = ListExpansionsInteractorOutputSpy()
        sut.output = listExpansionsInteractorOutputSpy
        let expansionsWorkerSpy = ExpansionsWorkerSpy(expansionStore: ExpansionsMemStore())
        sut.expansionsWorker = expansionsWorkerSpy
        
        // When
        let request = ListExpansions.FetchExpansions.Request()
        sut.fetchExpansions(request: request)
        
        // Then
        XCTAssert(expansionsWorkerSpy.fetchExpansionsCalled, "FetchExpansions() should ask Worker to fetch expansions")
        XCTAssert(listExpansionsInteractorOutputSpy.presentFetchedExpansionCalled, "FetchExpansions() should ask presenter to format orders result")
    }
}
