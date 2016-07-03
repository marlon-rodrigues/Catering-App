//
//  LoginViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Used to determine which textfield currently hold focus
    var activeTextField: String = ""
    
    var currUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change the color of the navigation bar
        navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController!.navigationBar.tintColor = UIColor(red: CGFloat(213) / 255.0, green: CGFloat(97) / 255.0, blue: CGFloat(0), alpha: 1.0)
        
        // Remove navigation bar "border"
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        // Hide keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
        // Delegate to itself - used with the UITextFieldDelegate to hide keyboard on return key press
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Update textfields border color
        let textFieldCustomColor : UIColor = UIColor( red: CGFloat(204) / 255.0, green: CGFloat(204) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0 )
        emailTextField.layer.cornerRadius = 0
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = textFieldCustomColor.CGColor
        emailTextField.layer.borderWidth = 1.0
        
        passwordTextField.layer.cornerRadius = 0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = textFieldCustomColor.CGColor
        passwordTextField.layer.borderWidth = 1.0
        
        
        //UNCOMMENT IT FOR REAL DEVICE
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Hide the keyboard on tap outside text field
    func tap(gesture: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // Hide the keyboard on return key press
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 {
            activeTextField = "password"
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = ""
    }

    func keyboardWillShow(sender: NSNotification) {
        if(activeTextField == "password") {
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
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if(activeTextField == "password") {
            let userInfo: [NSObject : AnyObject] = sender.userInfo!
            let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    

    @IBAction func signInAction(sender: UIButton) {
        let username = emailTextField.text as String!
        let password = passwordTextField.text as String!

        validateUser(username, psw: password)
    }
    
    func validateUser(username: String, psw: String) {
        Alamofire.request(.GET, "https://usihosting.ungerboeck.com/PollosLocos/PolloLoco.asmx/Login", parameters: nil)
            .responseJSON { response in
                switch response.result {
                    
                case .Success(let _data):
                    if let DataObject = _data as? [NSDictionary] {
                        for user in DataObject {
                            if ((user["AccountEmail"] as! String).lowercaseString == username.lowercaseString && psw == "123") {
                                self.loginUser(user)
                            } else {
                                let alert = UIAlertController(title: "Login Failed", message: "Please, verify your credentials and try again", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
                case .Failure(let errorMessage):
                    print("Login Failed:")
                    print(errorMessage)
                }
        }
        
        // FOR TEST
        /*currUser.setUser("Marlon", accountCompany: "123", accountEmail: "123", accountCode: "123", orgCode: "123", companyCode: "123")
        
        performSegueWithIdentifier("segueDelivery", sender: self)*/
    }
    
    func loginUser(user: NSDictionary) {
        // Set the user object
        currUser.setUser(user["AccountName"] as! String, accountCompany: user["AccountCompany"] as! String, accountEmail: user["AccountEmail"] as! String, accountCode: user["AccountCode"] as! String, orgCode: user["OrgCode"] as! String, companyCode: user["CompanyCode"] as! String)
        
        performSegueWithIdentifier("segueDelivery", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueDelivery" {
            if let deliveryViewController = segue.destinationViewController as? DeliveryViewController {
                        deliveryViewController.currUser = currUser
            }
        }
    }
    
}
