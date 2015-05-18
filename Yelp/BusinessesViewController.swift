//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    var searchTerm: String = ""
    var sortBy:YelpSortMode? = .BestMatched
    var distance: String = "Auto"
    var deals = false
    var categories: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func loadBusinessData() {
        Business.searchWithTerm(searchTerm, sort: sortBy, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.text = searchTerm
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        loadBusinessData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTerm = searchText
        
        loadBusinessData()
    }
    
    func filtersViewContoller(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        sortBy = filters["sort"] as? YelpSortMode
        distance = filters["distance"] as? String ?? "Auto"
        deals = filters["deals"] as? Bool ?? false
        
        categories = filters["categories"] as? [String] ?? []
        
        loadBusinessData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewContoller = navigationController.topViewController as! FiltersViewController
        
        filtersViewContoller.delegate = self
        
    }
}
