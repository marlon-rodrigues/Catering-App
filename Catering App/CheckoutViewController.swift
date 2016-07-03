//
//  CheckoutViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/10/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit
import Alamofire

class CheckoutViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Holds the user currently logged in
    var currUser = User()
    
    @IBOutlet weak var menuTabBar: UITabBar!
    @IBOutlet weak var checkoutListTableView: UITableView!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTabBar.delegate = self
        
        checkoutListTableView.delegate = self
        checkoutListTableView.dataSource = self
        
        welcomeUserLabel.text = "Hi, " + currUser.name
        
        let lineView = UIView(frame: CGRectMake(15, 0, 600, 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: CGFloat(188) / 255.0, green: CGFloat(186) / 255.0, blue: CGFloat(193) / 255.0, alpha: 0.8 ).CGColor
        checkoutListTableView.addSubview(lineView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTotal", name: "shoppingListUpdated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCheckoutList", name: "shoppingListItemRemoved", object: nil)
        
        updateTotal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonAction(sender: UIButton) {
        currUser.destroyUser()
        dateSelected = ""
        shoppingList.removeAll()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func downloadImage(url: NSURL, cell: CheckoutItemTableViewCell) {
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                cell.itemImage.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CheckoutItemTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CheckoutItemTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Fetches the appropriate meal for the data source layout
        let item = shoppingList[indexPath.row]
        
        let textFieldCustomColor : UIColor = UIColor( red: CGFloat(204) / 255.0, green: CGFloat(204) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0 )
        cell.itemQtyTextField.layer.cornerRadius = 0
        cell.itemQtyTextField.layer.masksToBounds = true
        cell.itemQtyTextField.layer.borderColor = textFieldCustomColor.CGColor
        cell.itemQtyTextField.layer.borderWidth = 1.0
        
        cell.itemDescriptionLabel.text = item.description
        cell.itemPriceLabel.text = "$" + (NSString(format: "%.2f", item.total) as String)
        cell.itemQtyTextField.text = String(item.quantity)
        cell.cellIndexPathLabel.text = String(indexPath.row)
        
        // Get Image for the item
        if let checkedUrl = NSURL(string: "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/GetImage?SequenceNumber=" + item.seqNumber+"&IsThumbnail=True") {
            cell.itemImage.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl, cell: cell)
        }
        
        // Use "View" button Tag property to store the indexPath.row for the selected item - This allows the current Item object to
        // be passed through the segue
        /*cell.viewButton.tag = indexPath.row
        cell.addToOrderButton.tag = indexPath.row*/
        
        return cell
    }
    
    func updateTotal() {
        var orderTotal: Float = 0.0
        
        for item in shoppingList {
            orderTotal += item.total
        }
        
        orderTotalLabel.text = "TOTAL: $" + (NSString(format: "%.2f", orderTotal) as String)
    }
    
    func updateCheckoutList() {
        checkoutListTableView.reloadData()
        updateTotal()
    }

    @IBAction func placeOrderButton(sender: UIButton) {
        if shoppingList.count <= 0 {
            let alert = UIAlertController(title: "Checkout Failed", message: "Your shopping cart is empty. Please, select an item before proceeding.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            placeOrder()
            performSegueWithIdentifier("segueThankYou", sender: self)
        }
    }
    
    func placeOrder() {
        var orderTotal: Float = 0.0
        
        var jsonItemsString = ""
        
        for item in shoppingList {
            jsonItemsString +=
                "{" +
                "'resourcecode': '" + item.resourceCode + "'," +
                "'quantity': '" + String(item.quantity) + "'," +
                "'startdate': '" + dateSelected + "'," +
                "'enddate': '" + dateSelected + "'," +
                "'description': '" + item.description + "'," +
                "'resourcetype': '" + item.typeCode + "'," +
                "'pricelistdetail': '" + item.seqNumber + "'," +
                "'price': '" + (NSString(format: "%.2f", item.price) as String) + "'" +
                "},"
            
            orderTotal += item.total
        }
        
        let jsonItemsStringFormatted = String(jsonItemsString.characters.dropLast())
        
        let jsonObject = ["OrderData": "{'total': '" + String(orderTotal) + "', 'items': [" + jsonItemsStringFormatted + "]}"]
        
        Alamofire.request(.POST, "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/CreateOrder", parameters: jsonObject, encoding: .JSON)
            .responseData { response in
                switch response.result {
                    
                case .Success(let _data):
                    print(_data)
                    print("Order Placed Successfully")
                case .Failure(let errorMessage):
                    print("Place Order Failed:")
                    print(errorMessage)
                }
        }
        
        // Clear shopping list cart
        shoppingList.removeAll()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 {
            navigationController?.popViewControllerAnimated(true)
        } else if item.tag == 1 {
            performSegueWithIdentifier("segueCheckoutDelivery", sender: self)
        } else if item.tag == 2 {
            performSegueWithIdentifier("segueCheckoutDateSelection", sender: self)
        } else if item.tag == 3 {
            performSegueWithIdentifier("segueCheckoutPriceList", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCheckoutDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                deliveryViewController.currUser = currUser
            }
        } else if segue.identifier == "segueCheckoutDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        } else if segue.identifier == "segueCheckoutPriceList" {
            if let priceListViewController = segue.destinationViewController as? PriceListTableViewController {
                priceListViewController.currUser = currUser
            }
        } else if segue.identifier == "segueThankYou" {
            if let thankYouViewController = segue.destinationViewController as? ThankYouViewController {
                thankYouViewController.currUser = currUser
            }
        }
    }
}
