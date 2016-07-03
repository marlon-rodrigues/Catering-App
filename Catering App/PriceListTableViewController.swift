//
//  PriceListTableViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/8/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit
import Alamofire

class PriceListTableViewController: UITableViewController, UITabBarDelegate {
    
    // Holds the user currently logged in
    var currUser = User()
    
    var items = [PriceListItem]()
    
    @IBOutlet weak var menuTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTabBar.delegate = self
        
        loadItemsList()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Make sure UITabBar is always visible
        menuTabBar.frame = CGRectMake(self.menuTabBar.frame.origin.x, self.tableView.bounds.origin.y + self.tableView.frame.height - menuTabBar.frame.height, self.menuTabBar.frame.size.width, self.menuTabBar.frame.size.height)
    }
    
    func loadItemsList() {
        Alamofire.request(.GET, "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/GetPriceListItemsInfo", parameters: nil)
            .responseJSON { response in
                switch response.result {
        
                case .Success(let _data):
                    if let DataObject = _data as? [NSDictionary] {
                        for item in DataObject {
                            let tableItem = PriceListItem()
                            tableItem.setItem(item["OrgCode"] as! String, SequenceNumber: item["SequenceNumber"] as! String, TypeDescription: item["TypeDescription"] as! String, ResourceCode: item["ResourceCode"] as! String, TypeCode: item["TypeCode"] as! String, ItemDescription: item["ItemDescription"] as! String, Price: (item["Price"] as! NSString).floatValue)
                            
                            self.items += [tableItem]
                        }
                    }
                    // Make sure to load the table again because of the async call made to the web service
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Reload table data with retrieved data
                        self.tableView.reloadData()
                        // Make sure UITabBar is always visible
                        self.menuTabBar.frame = CGRectMake(self.menuTabBar.frame.origin.x, self.tableView.bounds.origin.y + self.tableView.frame.height - self.menuTabBar.frame.height, self.menuTabBar.frame.size.width, self.menuTabBar.frame.size.height)
                    })
                case .Failure(let errorMessage):
                    print("Retrieving Items Failed:")
                    print(errorMessage)
                }
        }
    }
    
    func downloadImage(url: NSURL, cell: PriceItemsTableViewCell) {
        //print("Download Started")
        //print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print(response?.suggestedFilename ?? "")
                //print("Download Finished")
                cell.itemImageLabel.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PriceItemTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PriceItemsTableViewCell

        // Fetches the appropriate meal for the data source layout
        let item = items[indexPath.row]
    
        cell.itemDescriptionLabel.text = item.description
        cell.itemPriceLabel.text = "$" + (NSString(format: "%.2f", item.price) as String)
        
        // Get Image for the item
        if let checkedUrl = NSURL(string: "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/GetImage?SequenceNumber=" + item.seqNumber+"&IsThumbnail=True") {
            cell.itemImageLabel.contentMode = .ScaleAspectFill
            downloadImage(checkedUrl, cell: cell)
        }
        
        // Use "View" button Tag property to store the indexPath.row for the selected item - This allows the current Item object to
        // be passed through the segue
        cell.viewButton.tag = indexPath.row
        cell.addToOrderButton.tag = indexPath.row

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueContainerHeader" {
            if let headerViewController = segue.destinationViewController as? PriceListHeaderViewController {
                headerViewController.currUser = "Hi, " + currUser.name
            }
        } else if segue.identifier == "seguePriceListDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                deliveryViewController.currUser = currUser
            }
        } else if segue.identifier == "seguePriveListDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        } else if segue.identifier == "seguePriceListHome" {
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.currUser = currUser
            }
        } else if segue.identifier == "seguePriceListItemDetails" {
            if let viewButton:UIButton = (sender as! UIButton) {
                let index = viewButton.tag
                let item = items[index]
                
                if let itemViewController = segue.destinationViewController as? PriceItemDetailsViewController {
                    itemViewController.currUser = currUser
                    itemViewController.currItem = item
                }
            }
        } else if segue.identifier == "seguePriceListItemDetailsOrder" {
            if let addToOrderButton:UIButton = (sender as! UIButton) {
                let index = addToOrderButton.tag
                let item = items[index]
                
                if let itemViewController = segue.destinationViewController as? PriceItemDetailsViewController {
                    itemViewController.currUser = currUser
                    itemViewController.currItem = item
                }
            }
        } else if segue.identifier == "seguePriceListCheckout" {
            if let checkoutViewController = segue.destinationViewController as? CheckoutViewController {
                checkoutViewController.currUser = currUser
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 {
            navigationController?.popViewControllerAnimated(true)
        } else if item.tag == 1 {
            performSegueWithIdentifier("seguePriceListDelivery", sender: self)
        } else if item.tag == 2 {
            performSegueWithIdentifier("seguePriceListDateSelection", sender: self)
        } else if item.tag == 3 {
            performSegueWithIdentifier("seguePriceListHome", sender: self)
        } else if item.tag == 4 {
            performSegueWithIdentifier("seguePriceListCheckout", sender: self)
        }
    }
}
