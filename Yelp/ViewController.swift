//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    FilterViewControllerDelegate, UISearchBarDelegate {
    var client: YelpClient!
    var businesses: [Business]?
    
    var filterSearch = UISearchBar()
    var filters: [String : String]?
    var searchTerm = "Beer"
    
    @IBOutlet weak var tableView: UITableView!
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        title = "Yelp"
        navigationItem.titleView = filterSearch
        filterSearch.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        doSearch(searchTerm, filters: filters)
    }
    
    func doSearch(term: String, filters: [String : String]?) {
        client.searchWithTerm(term, params: filters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            
            let businesses = response.valueForKey("businesses") as! [NSDictionary]
            self.businesses = Business.businessesWithDictionaries(businesses)
            
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0,0,1,1), animated: true)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businsses = businesses {
            return businesses!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        if let business = businesses?[indexPath.row] {
            cell.business = business
        }
        
        return cell
    }
    
 /*   // This is doing what autolayout *should* be doing which using the constraints to determine cell
    // height as needed. Currently, even with correctly setting prefferedMaxLayoutWidth on
    // labels within cells, heights calculated correctly at all times.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let contentView: UIView = tableView.dataSource!.tableView(tableView, cellForRowAtIndexPath: indexPath)
        contentView.updateConstraintsIfNeeded()
        contentView.layoutIfNeeded()
        return contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }*/
    
    func filterViewController(filterViewController: FilterViewController, filtersDidChange filters: [String : String]) {
        self.filters = filters
        doSearch(searchTerm, filters: filters)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        var nav = segue.destinationViewController as! UINavigationController
        var vc = nav.topViewController as! FilterViewController
        vc.delegate = self;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchTerm = searchBar.text
        doSearch(searchTerm, filters: filters)
        searchBar.resignFirstResponder()
    }
    
}

