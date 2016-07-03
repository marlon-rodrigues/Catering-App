//
//  DeliveryContainerViewController.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class DeliveryContainerViewController: UIViewController, UITextFieldDelegate {

    // Used to determine which textfield currently hold focus
    var activeTextField: Bool = false
    
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var suiteAddressTextField: UITextField!
    @IBOutlet weak var cityAddressTextField: UITextField!
    @IBOutlet weak var stateAddressTextField: UITextField!
    @IBOutlet weak var zipCodeAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Format textfields 
        let paddingViewStreet = UIView(frame: CGRectMake(0, 0, 10, self.streetAddressTextField.frame.height))
        streetAddressTextField.leftView = paddingViewStreet
        streetAddressTextField.leftViewMode = UITextFieldViewMode.Always
        streetAddressTextField.delegate = self

        let paddingViewSuite = UIView(frame: CGRectMake(0, 0, 10, self.streetAddressTextField.frame.height))
        suiteAddressTextField.leftView = paddingViewSuite
        suiteAddressTextField.leftViewMode = UITextFieldViewMode.Always
        suiteAddressTextField.delegate = self

        let paddingViewCity = UIView(frame: CGRectMake(0, 0, 10, self.streetAddressTextField.frame.height))
        cityAddressTextField.leftView = paddingViewCity
        cityAddressTextField.leftViewMode = UITextFieldViewMode.Always
        cityAddressTextField.delegate = self

        let paddingViewState = UIView(frame: CGRectMake(0, 0, 10, self.streetAddressTextField.frame.height))
        stateAddressTextField.leftView = paddingViewState
        stateAddressTextField.leftViewMode = UITextFieldViewMode.Always
        stateAddressTextField.delegate = self

        let paddingViewZip = UIView(frame: CGRectMake(0, 0, 10, self.streetAddressTextField.frame.height))
        zipCodeAddressTextField.leftView = paddingViewZip
        zipCodeAddressTextField.leftViewMode = UITextFieldViewMode.Always
        zipCodeAddressTextField.delegate = self
        
        // Hide keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
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
    
    // Hide the keyboard on tap outside text field
    func tap(gesture: UITapGestureRecognizer) {
        streetAddressTextField.resignFirstResponder()
        suiteAddressTextField.resignFirstResponder()
        cityAddressTextField.resignFirstResponder()
        stateAddressTextField.resignFirstResponder()
        zipCodeAddressTextField.resignFirstResponder()
    }
    
    // Hide the keyboard on return key press
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 4 || textField.tag == 3 || textField.tag == 2) {
            activeTextField = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = false
    }
    
    func keyboardWillShow(sender: NSNotification) { 
        if(activeTextField == true) {
            let userInfo: [NSObject : AnyObject] = sender.userInfo!
            
            let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
            
            if keyboardSize.height == offset.height {
                if self.view.frame.origin.y == 0 {
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.view.frame.origin.y -= keyboardSize.height - 90
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
        if(activeTextField == true) {
            let userInfo: [NSObject : AnyObject] = sender.userInfo!
            let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            self.view.frame.origin.y += keyboardSize.height - 90
        }
    }

}
