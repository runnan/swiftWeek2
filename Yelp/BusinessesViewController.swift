//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businesses = [Business]()
    
    @IBOutlet weak var restaurantTableView: UITableView!
    var searchController: UISearchController!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.estimatedRowHeight = 100
        restaurantTableView.rowHeight = UITableViewAutomaticDimension

        loadData("Thai",offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter)
        
        initSearchBar()
        setupInfiniteScroll()

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func initSearchBar() {
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        searchDisplayController?.displaysSearchBarInNavigationBar = true
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        // By default the navigation bar hides when presenting the
        // search interface.  Obviously we don't want this to happen if
        // our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationVC = segue.destinationViewController as! UINavigationController
        
        /////////////////////@@@@@@Get VC from Navigation VC@@@@@////////////////////////
        let filterVC = navigationVC.topViewController as! FilterViewController
        /////////////////////@@@@@@@@@@@////////////////////////
        filterVC.delegate = self
    }
    

}




extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        if indexPath.row == (businesses.count) - 1{
            print(indexPath.row)
            //loadData(indexPath.row)
        }
        return cell
    }
}

extension BusinessesViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            //filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            //    return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            //})
            
            restaurantTableView.reloadData()
        }
    }
}

extension BusinessesViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = restaurantTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - restaurantTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && restaurantTableView.dragging) {
                print("Load More")
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, restaurantTableView.contentSize.height, restaurantTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadData("Thai",offset: businesses.count, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter)
            }
            
        }
 
        
    }
    
    func loadData(term: String, offset: NSNumber, sort: YelpSortMode?, categories: [String]?, deals: Bool?,radius_filter: Double?) {
        Business.searchWithTerm(term,offset: offset, sort: sort, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()

            for item in businesses {
                self.businesses.append(item)
            }
            self.restaurantTableView.reloadData()
        }
    }
    
    func setupInfiniteScroll(){
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, restaurantTableView.contentSize.height, restaurantTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        restaurantTableView.addSubview(loadingMoreView!)
        
        var insets = restaurantTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        restaurantTableView.contentInset = insets
    }
}

var categories : [String]!
var radius_filter:Double!
var sort :Int!
var sortBy : YelpSortMode!
var deals : Bool!

extension BusinessesViewController: FilterViewControllerDelegate{
    func filterViewControllerDelegate(filterViewController: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        categories = filters["categories"] as? [String]
        radius_filter = filters["distance"] as? Double
        if(radius_filter != nil){
            radius_filter = radius_filter!*1609.34
        }
        
        sort = filters["sortBy"] as? Int
        sortBy = YelpSortMode.BestMatched
        if(sort != nil){
            if(sort == 1){
                sortBy = YelpSortMode.Distance
            }else{
                sortBy = YelpSortMode.HighestRated
            }
        }
        
        deals = filters["deal"] as! Bool
        
        Business.searchWithTerm("Thai",offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
    }
}



