//
//  DateSelectionViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class DateSelectionViewController: UIViewController {

    // Holds the user currently logged in
    var currUser = User()
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var selectedDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        /*let backBtn = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonAction:")
        navigationItem.leftBarButtonItem = backBtn
        //navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "YourFontName", size: 20)!], forState: UIControlState.Normal)
        navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController!.navigationBar.tintColor = UIColor(red: CGFloat(213) / 255.0, green: CGFloat(67) / 255.0, blue: CGFloat(0), alpha: 1.0)*/
        
        welcomeUserLabel.text = "Hi, " + currUser.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = true
    }

    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signOutButton(sender: UIButton) {
        currUser.destroyUser()
        dateSelected = ""
        shoppingList.removeAll()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func continueButtonAction(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.000 a"
        dateSelected = dateFormatter.stringFromDate(selectedDate.date)
        
        performSegueWithIdentifier("segueHome", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueHome" {
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.currUser = currUser
            }
        }
    }
}
