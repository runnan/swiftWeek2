//
//  FilterViewController.swift
//  Yelp
//
//  Created by Khang Le on 7/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filterViewControllerDelegate (filterViewController:FilterViewController, didUpdateFilters filters:[String:AnyObject])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var switchTableView: UITableView!
    
    var statuses = [Bool]()
    
    var categories = yelpCategories()
    var switchStates = [Int:Bool]()
    var selectedDistance = [String:String]()
    var selectedDeal = false
    
    var distances = createDistances()
    var switchOn = false
    
    weak var delegate:FilterViewControllerDelegate?
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates{
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if(selectedCategories.count > 0){
            filters["categories"] = selectedCategories
        }
        if(selectedDistance.count > 0){
            filters["distance"] = Double(selectedDistance["code"]!)
        }
        filters["deal"] = selectedDeal
        
        delegate?.filterViewControllerDelegate?(self, didUpdateFilters: filters)
        print("OnSearch from FilterVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchTableView.delegate = self
        switchTableView.dataSource = self
        
        switchTableView.estimatedRowHeight = 50
        switchTableView.rowHeight = UITableViewAutomaticDimension
        
        switchTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

func yelpCategories() -> [[String:String]] {
    return [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
}

func createDistances() -> [[String:String]] {
    return [["name" : "Auto", "code": "0"],
            ["name" : "0.1 miles", "code": "0.1"],
            ["name" : "0.2 miles", "code": "0.2"],
            ["name" : "0.5 miles", "code": "0.5"],
            ["name" : "1 mile", "code": "1"],
            ["name" : "2 miles", "code": "2"],
            ["name" : "5 miles", "code": "5"],
            ["name" : "10 miles", "code": "10"]]
}



extension FilterViewController: UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DistanceCellDelegate{
    func distanceCellDidSwitchChanged(switchCell: DistanceCell) {
        switchOn = switchCell.isClick;
        switchTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return distances.count + 1
            case 2: return categories.count
            default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.catalogyLabel.text = "Offering a Deal"
            cell.delegate = self
            
            ////////////////////////////////////////////////////////////
            
            //Need write in here because when it render the cell for table -> each cell have different value, otherwise it will reuse same value (dequeue func)
            cell.categogyStatusSwitch.on = selectedDeal
            
            /////////////////////////////////////////////////////////////

            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("DistanceCell", forIndexPath: indexPath) as! DistanceCell
                cell.delegate = self
                cell.isClick = switchOn
                if(selectedDistance.count > 0){
                    cell.distanceValueLabel.text = selectedDistance["name"]
                    if(selectedDistance["code"] != "0"){
                        cell.toggleImage.image = UIImage.fontAwesomeIconWithName(.Check, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
                    }else{
                        selectedDistance = [String:String]()
                        cell.toggleImage.image = UIImage.fontAwesomeIconWithName(.CaretDown, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
                    }
                    
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectCell
                cell.mileLabel.text = distances[(indexPath.row-1)]["name"]
                return cell

            }

        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.catalogyLabel.text = categories[(indexPath.row)]["name"]
            
            cell.delegate = self
            
            ////////////////////////////////////////////////////////////
            
            //Need write in here because when it render the cell for table -> each cell have different value, otherwise it will reuse same value (dequeue func)
            cell.categogyStatusSwitch.on = switchStates[indexPath.row] ?? false
            
            /////////////////////////////////////////////////////////////
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0;
        }
        return 40;
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.backgroundColor = UIColor.grayColor()

        switch section {
            case 1:
                header.text = "Distance"
            case 2:
                header.text = "Categories"
            default:
                return header
        }
        return header
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if switchOn {
            return 44
        } else {
            switch indexPath.section {
            case 0: return 44
            case 1: return indexPath.row == 0 ? 44 : 0
            case 2: return 44
            default: return 0
            }
        }
    }
    
    //Trigger when click table cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row != 0 {//click at children
                selectedDistance = distances[indexPath.row - 1]
                switchOn = !switchOn
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func switchCell(swichCell: SwitchCell, didChangeValue: Bool) {
        let indexPath = switchTableView.indexPathForCell(swichCell)!
        if(indexPath.section == 0){
            selectedDeal = didChangeValue
        }else{
            switchStates[indexPath.row] = didChangeValue
        }
        print("VC got switch from Cell\(indexPath.row) with value \(switchStates[indexPath.row])")
    }
}
