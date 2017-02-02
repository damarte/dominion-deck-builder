//
//  ListExpansionsConfigurator.swift
//  DominionDeckBuilder
//
//  Created by David on 2/2/17.
//  Copyright (c) 2017 damarte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension ListExpansionsViewController: ListExpansionsPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension ListExpansionsInteractor: ListExpansionsViewControllerOutput
{
}

extension ListExpansionsPresenter: ListExpansionsInteractorOutput
{
}

class ListExpansionsConfigurator
{
  // MARK: - Object lifecycle
  
  static let sharedInstance = ListExpansionsConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: ListExpansionsViewController)
  {
    let router = ListExpansionsRouter()
    router.viewController = viewController
    
    let presenter = ListExpansionsPresenter()
    presenter.output = viewController
    
    let interactor = ListExpansionsInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
