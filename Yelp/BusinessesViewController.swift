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
    var searchBar: UISearchBar!
    
    var categories : [String]!
    var radius_filter:Double!
    var sort :Int!
    var sortBy : YelpSortMode!
    var deals : Bool!
    var searchText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.estimatedRowHeight = 100
        restaurantTableView.rowHeight = UITableViewAutomaticDimension
        
        searchText = ""

        Business.searchWithTerm(searchText,offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
        restaurantTableView.reloadData()
        initSearchBar()
        setupInfiniteScroll()
    }
    
    func initSearchBar() {
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
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
        
        if let s = sender as? UIBarButtonItem {
            /////////////////////@@@@@@Get VC from Navigation VC@@@@@////////////////////////
            let filterVC = navigationVC.topViewController as! FilterViewController
            /////////////////////@@@@@@@@@@@////////////////////////
            filterVC.delegate = self
        }else {
            let detailVC = navigationVC.topViewController as! DetailsController
            let ip = restaurantTableView.indexPathForSelectedRow
            detailVC.business = businesses[(ip!.row)]
        }
        
       
    }
    

}




extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
}


extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = ""
        Business.searchWithTerm(searchText,offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
        restaurantTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = searchBar.text
        Business.searchWithTerm(searchText,offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
        restaurantTableView.reloadData()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if(searchText.isEmpty){
            searchBar.resignFirstResponder()
            self.searchText = searchText
            Business.searchWithTerm(self.searchText,offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.restaurantTableView.reloadData()
            }
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
        
        Business.searchWithTerm(searchText,offset: 0, sort: sortBy, categories: categories, deals: deals,radius_filter:radius_filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
    }
}



