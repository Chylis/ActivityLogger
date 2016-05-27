//
//  TableOverviewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 17/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit
import Swiftilities

class TableOverviewController: BaseOverviewPresentationController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Private
    
    private var dataSource: [ (title: String, activities: [ActivityModel]) ] = []
    
    //MARK: Overridden
    
    override func setupUI() {
     //TODO: Configure table view
    }
    
    override func reloadData() {
        dataSource = viewModel.tableViewDataSourceForCurrentViewState()
        tableView.reloadData()
        tableView.animateTransition()
    }
}

//MARK: UITableViewDataSource
extension TableOverviewController: UITableViewDataSource {
    
    private static let tableViewCellId = "ActivityOverviewTableViewCell"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            TableOverviewController.tableViewCellId, forIndexPath: indexPath) as! ActivityOverviewTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: ActivityOverviewTableViewCell, indexPath: NSIndexPath) {
        let activities = dataSource[indexPath.section].activities
        let activity = activities[indexPath.row]
        cell.textLabel?.text = viewModel.titleForActivity(activity)
    }
}

//MARK: UITableViewDelegate
extension TableOverviewController: UITableViewDelegate {
    

}