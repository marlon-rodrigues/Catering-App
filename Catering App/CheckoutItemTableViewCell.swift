//
//  CheckoutItemTableViewCell.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/10/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class CheckoutItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQtyTextField: UITextField!
    @IBOutlet weak var cellIndexPathLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonRemoveItem(sender: UIButton) {
        let currIndex:Int? = Int(cellIndexPathLabel.text!)
        shoppingList.removeAtIndex(currIndex!)
        
        // Send notification to view controller
        NSNotificationCenter.defaultCenter().postNotificationName("shoppingListItemRemoved", object: nil)
    }

    @IBAction func incrementalButtonAction(sender: UIButton) {
        var currQty:Int? = Int(itemQtyTextField.text!)
        currQty = currQty! + 1
        itemQtyTextField.text = String(currQty!)
        
        let currIndex:Int? = Int(cellIndexPathLabel.text!)
        let currItemPrice = shoppingList[currIndex!].price
        let currItemTotal = Float(currQty!) * currItemPrice
        itemPriceLabel.text = "$" + (NSString(format: "%.2f", currItemTotal) as String)
        
        // Update shopping list
        shoppingList[currIndex!].quantity = currQty!
        shoppingList[currIndex!].total = currItemTotal
        
        // Send notification to view controller
        NSNotificationCenter.defaultCenter().postNotificationName("shoppingListUpdated", object: nil)
    }
    
    @IBAction func decrementalButtonAction(sender: UIButton) {
        var currQty:Int? = Int(itemQtyTextField.text!)
        let currIndex:Int? = Int(cellIndexPathLabel.text!)
        var currItemTotal:Float = 0.0
        
        if currQty > 1 {
            currQty = currQty! - 1
            itemQtyTextField.text = String(currQty!)
            
            let currItemPrice = shoppingList[currIndex!].price
            currItemTotal = Float(currQty!) * currItemPrice
        } else {
            currQty = 1
            currItemTotal = shoppingList[currIndex!].price
            itemQtyTextField.text = "1"
        }
        
        itemPriceLabel.text = "$" + (NSString(format: "%.2f", currItemTotal) as String)

        // Update shopping list
        shoppingList[currIndex!].quantity = currQty!
        shoppingList[currIndex!].total = currItemTotal
        
        // Send notification to view controller
        NSNotificationCenter.defaultCenter().postNotificationName("shoppingListUpdated", object: nil)
    }
}
