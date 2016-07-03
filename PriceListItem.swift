//
//  PriceListItem.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/8/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import Foundation
import UIKit

class PriceListItem {
    var org: String = ""
    var seqNumber: String = ""
    var typeDesc: String = ""
    var typeCode: String = ""
    var resourceCode:String = ""
    var description:String = ""
    var price:Float = 0.0
    
    func setItem(OrgCode: String, SequenceNumber: String, TypeDescription: String, ResourceCode: String, TypeCode: String, ItemDescription: String, Price: Float) {
        self.org = OrgCode
        self.seqNumber = SequenceNumber
        self.typeDesc = TypeDescription
        self.resourceCode = ResourceCode
        self.typeCode = TypeCode
        self.description = ItemDescription
        self.price = Price
    }
    
    /*init(ItemDescription: String, Price: Float) {
        self.description = ItemDescription
        self.price = Price
    }*/
}