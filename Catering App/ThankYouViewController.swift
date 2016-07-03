//
//  ThankYouViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/10/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController, UITabBarDelegate {

    // Holds the user currently logged in
    var currUser = User()
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var menuTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeUserLabel.text = "Hi, " + currUser.name
        
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

    @IBAction func returnToMenuButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueThankYouHome", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueThankYouDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                deliveryViewController.currUser = currUser
            }
        } else if segue.identifier == "segueThankYouDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        } else if segue.identifier == "segueThankYouHome" {
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.currUser = currUser
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 {
            performSegueWithIdentifier("segueThankYouDelivery", sender: self)
        } else if item.tag == 1 {
            performSegueWithIdentifier("segueThankYouDateSelection", sender: self)
        } else if item.tag == 2 {
            performSegueWithIdentifier("segueThankYouHome", sender: self)
        }
    }

}
