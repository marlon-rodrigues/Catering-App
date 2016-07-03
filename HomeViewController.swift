//
//  HomeViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

//Global var to be used through out the lifecycle of the application
var shoppingList = [ShoppingListItem]()

//Global var to hold date selected value through out the lifecycle of the application
var dateSelected: String = ""

class HomeViewController: UIViewController, UITabBarDelegate {

    // Holds the user currently logged in
    var currUser = User()
    
    @IBOutlet weak var welcomeLabelUser: UILabel!
    @IBOutlet weak var menuTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabelUser.text = "Hi, " + currUser.name
        
        menuTabBar.delegate = self
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
    
    @IBAction func breakfastButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueMenuPriceList", sender: self)
    }
    
    @IBAction func lunchButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueMenuPriceList", sender: self)
    }
    
    @IBAction func dinnerButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueMenuPriceList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueMenuDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                deliveryViewController.currUser = currUser
            }
        } else if segue.identifier == "segueMenuDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        } else if segue.identifier == "segueMenuPriceList" {
            if let priceListViewController = segue.destinationViewController as? PriceListTableViewController {
                priceListViewController.currUser = currUser
            }
        } else if segue.identifier == "segueMenuCheckout" {
            if let checkoutViewController = segue.destinationViewController as? CheckoutViewController {
                checkoutViewController.currUser = currUser
            }
        }
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 {
            performSegueWithIdentifier("segueMenuDelivery", sender: self)
        } else if item.tag == 1 {
            performSegueWithIdentifier("segueMenuDateSelection", sender: self)
        } else if item.tag == 2 {
            performSegueWithIdentifier("segueMenuPriceList", sender: self)
        } else if item.tag == 3 {
            performSegueWithIdentifier("segueMenuCheckout", sender: self)
        }
    }

}
