//
//  User.swift
//  StirApp
//
//  Created by 松下慶大 on 2015/06/13.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class User: NSObject {
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var fakeUser: User?
    var image: UIImage!
    
    override init() {
        super.init()
        self.image = UIImage(named: "kinoponpopo")
    }
    
}
