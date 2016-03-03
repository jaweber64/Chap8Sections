//
//  SearchResultsController.swift
//  Sections
//
//  Created by Janet Weber on 3/3/16.
//  Copyright © 2016 Weber Solutions. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController,
        UISearchResultsUpdating {
    private static let longNameSize = 6
    private static let shortNamesButtonIndex = 1
    private static let longNamesButtonIndex = 2
    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: sectionsTableIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UISearchResultsUpdating Conformance
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredNames.removeAll(keepCapacity: true)
            
            if !searchString.isEmpty {
                let filter: String -> Bool = {name in
                    // Filter out long or short names depending on which scopt button is selected
                    let nameLength = name.characters.count
                    if (buttonIndex == SearchResultsController.shortNamesButtonIndex &&
                        nameLength >= SearchResultsController.longNameSize) ||
                        (buttonIndex == SearchResultsController.longNamesButtonIndex &&
                            nameLength < SearchResultsController.longNameSize) {
                                return false
                    }
                    
                    let range = name.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    return range != nil
                }
                for key in keys {
                    let namesForKey = names[key]!
                    let matches = namesForKey.filter(filter)
                    filteredNames += matches
                }
            }
        
        tableView.reloadData()
        }
    } // end of updateSearchResultsForSearchController
    
    
    // MARK: Table View Data Source Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier)
        cell!.textLabel?.text = filteredNames[indexPath.row]
        return cell!
    }

}
