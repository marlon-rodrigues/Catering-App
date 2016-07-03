//
//  ShoppingListItem.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/10/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListItem {
    var resourceCode: String = ""
    var quantity: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    var description: String = ""
    var resourceType: String = ""
    var typeCode: String = ""
    var price: Float = 0.0
    var total: Float = 0.0
    var seqNumber: String = ""
    
    func setShoppingItem(ResCode: String, Qty: Int, Start: String, End: String, ResourceDesc: String, Type: String,
        ItemTotal: Float, TypeCode: String, SequenceNumber: String, Price: Float) {
        self.resourceCode = ResCode
        self.quantity = Qty
        self.startDate = Start
        self.endDate = End
        self.description = ResourceDesc
        self.resourceType = Type
        self.typeCode = TypeCode
        self.total = ItemTotal
        self.seqNumber = SequenceNumber
        self.price = Price
    }
}