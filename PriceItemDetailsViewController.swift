//
//  PriceItemDetailsViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/9/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class PriceItemDetailsViewController: UIViewController, UITabBarDelegate, UITextFieldDelegate {

    // Holds the user currently logged in
    var currUser = User()
    var currItem = PriceListItem()
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var itemQtyTextField: UITextField!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var menuTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format textfields
        itemQtyTextField.leftViewMode = UITextFieldViewMode.Always
        itemQtyTextField.delegate = self
        let textFieldCustomColor : UIColor = UIColor( red: CGFloat(204) / 255.0, green: CGFloat(204) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0 )
        itemQtyTextField.layer.cornerRadius = 0
        itemQtyTextField.layer.masksToBounds = true
        itemQtyTextField.layer.borderColor = textFieldCustomColor.CGColor
        itemQtyTextField.layer.borderWidth = 1.0
        
        welcomeUserLabel.text = "Hi, " + currUser.name
        
        menuTabBar.delegate = self
        
        loadItemDetails()
        
        addDoneButton()
        
        //UNCOMMENT IT FOR REAL DEVICE
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func loadItemDetails() {
        itemDescriptionLabel.text = currItem.description
        itemPriceLabel.text = "$" + (NSString(format: "%.2f", currItem.price) as String)
        itemQtyTextField.text = "0"
        
        // Get Image for the item
        if let checkedUrl = NSURL(string: "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/GetImage?SequenceNumber=" + currItem.seqNumber+"&IsThumbnail=False") {
            //itemImage.contentMode = .ScaleAspectFit
            itemImage.contentMode = .ScaleAspectFill
            downloadImage(checkedUrl)
        }
    }
    
    func downloadImage(url: NSURL) {
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.itemImage.image = UIImage(data: data)
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
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        itemQtyTextField.inputAccessoryView = keyboardToolbar
    }
    
    // Hide the keyboard on return key press
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 0 {
            if textField.text == "0" {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 0 {
            if textField.text == "" {
                textField.text = "0"
            }
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    @IBAction func signOutButtonAction(sender: UIButton) {
        currUser.destroyUser()
        dateSelected = ""
        shoppingList.removeAll()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func itemIncrementalButton(sender: UIButton) {
        var currQty:Int? = Int(itemQtyTextField.text!)
        currQty = currQty! + 1
        itemQtyTextField.text = String(currQty!)
    }
    
    @IBAction func itemDecrementalButton(sender: UIButton) {
        var currQty:Int? = Int(itemQtyTextField.text!)
        if currQty > 0 {
            currQty = currQty! - 1
            itemQtyTextField.text = String(currQty!)
        } else {
            itemQtyTextField.text = "0"
        }
    }
    
    @IBAction func addToOrderButtonAction(sender: UIButton) {
        let currQty:Int? = Int(itemQtyTextField.text!)
        if currQty > 0 {
            let itemForShoppingList = ShoppingListItem()
            itemForShoppingList.resourceCode = currItem.resourceCode
            itemForShoppingList.description = currItem.description
            itemForShoppingList.seqNumber = currItem.seqNumber
            itemForShoppingList.typeCode = currItem.typeCode
            itemForShoppingList.quantity = currQty!
            itemForShoppingList.price = currItem.price
            itemForShoppingList.total = currItem.price * Float(currQty!)
            
            // Verify if item already exists in shopping list - If it does, updates quantity, otherwise adds to shopping list
            var indexExistingItemInShoppingList = -1
            var listCount = 0
            
            for item in shoppingList {
                if item.resourceCode == currItem.resourceCode {
                    indexExistingItemInShoppingList = listCount
                }
                listCount++
            }
            
            if indexExistingItemInShoppingList >= 0 {
                shoppingList[indexExistingItemInShoppingList] = itemForShoppingList
            } else {
                shoppingList += [itemForShoppingList]
            }
         
            performSegueWithIdentifier("segueItemDetailsCheckout", sender: self)
        } else {
            let alert = UIAlertController(title: "Invalid Item", message: "Please, inform the quantity before adding item to Shopping Cart", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkoutButtonAction(sender: UIButton) {
        performSegueWithIdentifier("segueItemDetailsCheckout", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueItemDetailsDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                deliveryViewController.currUser = currUser
            }
        } else if segue.identifier == "segueItemDetailsDateSelection" {
            if let dateSelectionViewController = segue.destinationViewController as? DateSelectionViewController {
                dateSelectionViewController.currUser = currUser
            }
        } else if segue.identifier == "segueItemDetailsPriceList" {
            if let priceListViewController = segue.destinationViewController as? PriceListTableViewController {
                priceListViewController.currUser = currUser
            }
        } else if segue.identifier == "segueItemDetailsCheckout" {
            if let checkoutViewController = segue.destinationViewController as? CheckoutViewController {
                checkoutViewController.currUser = currUser
            }
        }

    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 {
            navigationController?.popViewControllerAnimated(true)
        } else if item.tag == 1 {
            performSegueWithIdentifier("segueItemDetailsDelivery", sender: self)
        } else if item.tag == 2 {
            performSegueWithIdentifier("segueItemDetailsDateSelection", sender: self)
        } else if item.tag == 3 {
            performSegueWithIdentifier("segueItemDetailsPriceList", sender: self)
        } else if item.tag == 4 {
            performSegueWithIdentifier("segueItemDetailsCheckout", sender: self)
        }
    }

}
