//
//  DeliveryViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {

    // Holds the user currently logged in
    var currUser = User()
    
    @IBOutlet weak var deliveryContainer: UIView!
    @IBOutlet weak var pickupContainer: UIView!
    @IBOutlet weak var deliveryButtonLabel: UIButton!
    @IBOutlet weak var pickupButtonLabel: UIButton!
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        
        pickupContainer.hidden = true
        deliveryContainer.hidden = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        welcomeUserLabel.text = "Hi, " + currUser.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    @IBAction func pickupButtonAction(sender: UIButton) {
        deliveryContainer.hidden = true
        pickupContainer.hidden = false
        
        deliveryButtonLabel.setTitleColor( UIColor(red: CGFloat(213) / 255.0, green: CGFloat(67) / 255.0, blue: CGFloat(0), alpha: 1.0), forState: UIControlState.Normal)
        pickupButtonLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func deliveryButtonAction(sender: UIButton) {
        deliveryContainer.hidden = false
        pickupContainer.hidden = true
        
        pickupButtonLabel.setTitleColor( UIColor(red: CGFloat(213) / 255.0, green: CGFloat(67) / 255.0, blue: CGFloat(0), alpha: 1.0), forState: UIControlState.Normal)
        deliveryButtonLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func continueButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueDateSelection", sender: self)
    }
    
    @IBAction func signOutButton(sender: UIButton) {
        currUser.destroyUser()
        dateSelected = ""
        shoppingList.removeAll()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
