//
//  PriceListHeaderViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/8/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class PriceListHeaderViewController: UIViewController {
    
    var currUser: String = ""
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeUserLabel.text = currUser
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonAction(sender: UIButton) {
        dateSelected = ""
        shoppingList.removeAll()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
