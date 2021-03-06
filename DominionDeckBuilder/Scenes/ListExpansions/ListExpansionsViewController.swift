//
//  ListExpansionsViewController.swift
//  DominionDeckBuilder
//
//  Created by David on 2/2/17.
//  Copyright (c) 2017 damarte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListExpansionsViewControllerInput
{
    func displayFetchedExpansions(viewModel: ListExpansions.FetchExpansions.ViewModel)
}

protocol ListExpansionsViewControllerOutput
{
    func fetchExpansions(request: ListExpansions.FetchExpansions.Request)
}

class ListExpansionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListExpansionsViewControllerInput
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var generateButton: UIButton!
    
    var output: ListExpansionsViewControllerOutput!
    var router: ListExpansionsRouter!
    var displayedExpansions: [ListExpansions.FetchExpansions.ViewModel.DisplayedExpansion] = []
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        ListExpansionsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.setEditing(true, animated: true)
        
        fetchExpansionsOnLoad()
    }
    
    // MARK: - Event handling
    
    func fetchExpansionsOnLoad()
    {
        let request = ListExpansions.FetchExpansions.Request()
        output.fetchExpansions(request: request)
    }
    
    // MARK: - Display logic
    
    func displayFetchedExpansions(viewModel: ListExpansions.FetchExpansions.ViewModel)
    {
        displayedExpansions = viewModel.displayedExpansions
        tableView.reloadData()
    }
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return displayedExpansions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let displayedExpansion = displayedExpansions[(indexPath as NSIndexPath).row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "ExpansionTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "ExpansionTableViewCell")
        }
        cell?.textLabel?.text = displayedExpansion.name
        cell?.detailTextLabel?.text = "\(displayedExpansion.numCards) cards"
        return cell!
    }
    
    // MARK: Table view delegate
}
