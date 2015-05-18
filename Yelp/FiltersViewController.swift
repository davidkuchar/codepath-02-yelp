//
//  FiltersViewController.swift
//  Yelp
//
//  Created by David Kuchar on 5/17/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

enum FilterType: Int {
    case Deals = 0, SortBy, Distance, Categories
}

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewContoller(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var deals = false
    let sortByOptions = ["Best Match", "Distance", "Highest Rated"]
    var sortBy:YelpSortMode? = .BestMatched
    let distanceOptions = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distance: String = "Auto"
    var categories = Categories()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String:AnyObject]()
        
        filters["deals"] = deals
        filters["sort"] = sortBy as? AnyObject
        filters["distance"] = distance
        
        let selectedCategories = categories.getSelected()
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewContoller?(self, didUpdateFilters: filters)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch FilterType(rawValue: section) {
        case .Some(.Deals):
            return "Deals"
        case .Some(.SortBy):
            return "Sort By"
        case .Some(.Distance):
            return "Distance"
        case .Some(.Categories):
            return "Categories"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FilterType(rawValue: section) {
        case .Some(.Deals):
            return 1
        case .Some(.SortBy):
            return sortByOptions.count
        case .Some(.Distance):
            return distanceOptions.count
        case .Some(.Categories):
            return categories.list.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch FilterType(rawValue: indexPath.section) {
        case .Some(.Deals):
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            
            cell.onSwitch.on = deals
            
            return cell
        case .Some(.SortBy):
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectCell
           
            cell.selectionLabel.text = sortByOptions[indexPath.row]
            
            if sortBy?.hashValue == indexPath.row {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        case .Some(.Distance):
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectCell
            
            cell.selectionLabel.text = distanceOptions[indexPath.row]
            
            if distance == distanceOptions[indexPath.row] {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        case .Some(.Categories):
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

            cell.switchLabel.text = categories.list[indexPath.row]["name"]
            cell.delegate = self
            
            cell.onSwitch.on = categories.isSelected(indexPath.row)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch FilterType(rawValue: indexPath.section) {
        case .Some(.SortBy):
            sortBy = YelpSortMode(rawValue: indexPath.row)
            tableView.reloadData()
        case .Some(.Distance):
            distance = distanceOptions[indexPath.row]
            tableView.reloadData()
        default:
            break
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        switch FilterType(rawValue: indexPath.section) {
        case .Some(.Deals):
            deals = value
        case .Some(.Categories):
            categories.setSelected(indexPath.row, value: value)
        default:
            return
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
