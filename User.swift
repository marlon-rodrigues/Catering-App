//
//  User.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/7/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String = ""
    var company: String = ""
    var email: String = ""
    var code: String = ""
    var org: String = ""
    var compCode: String = ""
    
    func setUser(accountName: String, accountCompany: String, accountEmail: String, accountCode: String, orgCode: String, companyCode: String) {
        self.name = accountName
        self.company = accountCompany
        self.email = accountEmail
        self.code = accountCode
        self.org = orgCode
        self.compCode = companyCode
    }
    
    func destroyUser() {
        self.name = ""
        self.company = ""
        self.email = ""
        self.code = ""
        self.org = ""
        self.compCode = ""
    }
}