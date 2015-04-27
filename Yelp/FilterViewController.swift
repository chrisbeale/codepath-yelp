//
//  FilterViewController.swift
//  Yelp
//
//  Created by Chris Beale on 4/22/15.
//  Copyright (c) 2015 Chris Beale. All rights reserved.
//

import UIKit


protocol FilterViewControllerDelegate: class
{
    func filterViewController(filterViewController: FilterViewController, filtersDidChange filters: [String : String])
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterCellDelegate, SegmentedControlCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FilterViewControllerDelegate?

    var categories: [[String : String]]?
    var selectedCategories = Set<String>()
    var dealsFilterOn: Bool?
    var sortFilter: Int?
    var distanceFilter: Int?
    
    var filters: [String : String] {
        get {
            var filters = [String : String]()
            
            if selectedCategories.count > 0 {
                var count = 1
                var categoryString = reduce(selectedCategories, "") {
                    wholeString, category in
                    let comma = count++ < selectedCategories.count ? "," : ""
                    return "\(wholeString)\(category)\(comma)"
                }
                filters["category_filter"] = categoryString

            }
            
            if let dealsFilterOn = dealsFilterOn {
                filters["deals_filter"] = "\(dealsFilterOn)"
            }
            
            if let sortFilter = sortFilter {
                filters["sort"] = "\(sortFilter)"
            }
            
            if let distanceFilter = distanceFilter {
                filters["radius_filter"] = "\(distanceFilter)"
            }
            
            return filters
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        initializeCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
    
        switch section {
        case 0:
            title = "Sort by"
        case 1:
            title = "Distance"
        case 2:
            title = "Deals"
        default:
            title = "Categories"
            
        }
        return title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0

        switch section {
        case 3:
            if let categories = categories {
                rows = categories.count
            }
        default:
            rows = 1
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.filterLabel.text = "With deals"
            cell.filterSwitch.on = false
            cell.delegate = self
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            if let categories = categories {
                var category = categories[indexPath.row]
                cell.filterLabel.text = category["name"]!
                cell.filterSwitch.on = false
            }
            cell.delegate = self
            return cell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("SegmentedControlCell", forIndexPath: indexPath) as! SegmentedControlCell
            
            if (indexPath.section == 0) {
                cell.segmentedControl.setTitle("Best Match", forSegmentAtIndex: 0)
                cell.segmentedControl.setTitle("Distance", forSegmentAtIndex: 1)
                cell.segmentedControl.setTitle("Rating", forSegmentAtIndex: 2)
            } else {
                cell.segmentedControl.setTitle("Best Match", forSegmentAtIndex: 0)
                cell.segmentedControl.setTitle("1 km", forSegmentAtIndex: 1)
                cell.segmentedControl.setTitle("5 km", forSegmentAtIndex: 2)
            }
            
            cell.delegate = self
            return cell
        }

    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSearchClicked(sender: AnyObject) {        
        delegate?.filterViewController(self, filtersDidChange: filters)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterCell(filterCell: FilterCell, switchValueChanged value: Bool) {
        var indexPath = tableView.indexPathForCell(filterCell)
        if let indexPath = indexPath {
            switch indexPath.section {
            case 2:
                dealsFilterOn = value
            default:
                if let categories = categories {
                    var category = categories[indexPath.row]
                    if value {
                        selectedCategories.insert(category["code"]!)
                    } else {
                        selectedCategories.remove(category["code"]!)
                    }
                }
            }
        }
    }
    
    func segmentedControlCell(segmentedControlCell: SegmentedControlCell, controlValueChanged value: Int) {
        var indexPath = tableView.indexPathForCell(segmentedControlCell)
        if let indexPath = indexPath {
            switch indexPath.section {
            case 0:
                sortFilter = value
            default:
                switch value {
                case 1:
                    distanceFilter = 1000
                case 2:
                    distanceFilter = 5000
                default:
                    distanceFilter = nil
                }
            }
        }
    }
    
    func initializeCategories() {
        
        var url = NSURL(string: "https://raw.githubusercontent.com/Yelp/yelp-api/master/category_lists/en/category.json")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! Array<NSDictionary>
            
            for responseField in responseArray {
                if responseField["alias"] as! String == "restaurants" {
                    let restaurants = responseField["category"] as! Array<NSDictionary>
                    self.categories = [[String : String]]()
                    for restaurant in restaurants {
                        let name = restaurant["title"] as! String
                        let alias = restaurant["alias"] as! String
                        
                        self.categories?.append(["name": name, "code": alias])
                    }
                }
            }
            self.tableView.reloadData()
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
