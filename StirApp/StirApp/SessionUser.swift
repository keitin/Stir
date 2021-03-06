//
//  SessionUser.swift
//  StirApp
//
//  Created by 松下慶大 on 2015/06/13.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit
import Alamofire

class SessionUser: NSObject {

    
    class func signUp(user: User, callBackClosure:(Dictionary<String, AnyObject>) -> Void) {
        
        var params: [String: AnyObject] = [
            "name": user.name,
            "email": user.email,
            "password": user.password,
            "password_confirmation": user.confirmPassword
        ]
        
        var returnParams: Dictionary<String, AnyObject> = [:]
        let image = UIImage(named: "\(arc4random() % 11)")
        let httpMethod = Alamofire.Method.POST.rawValue
        let path = String.localhost() + "/api/users"
        let urlRequest = NSData.urlRequestWithComponents(httpMethod, urlString: path, parameters: params, image: image!)
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .responseJSON { (request, response, JSON, error) in
                var messageArray = JSON!["error_message"] as! Array<AnyObject>
                if messageArray.isEmpty {
                    
                    returnParams["error_message"] = []
                    returnParams["auth_token"] = JSON!["auth_token"]
                    returnParams["email"] = JSON!["email"]
                    
                    let currentUser = CurrentUser.sharedInstance
                    currentUser.authToken = JSON!["auth_token"]
                    currentUser.name = JSON!["name"] as! String
                    currentUser.saveCurrentUserInUserDefault()
    
                } else {
                    var messages = messageArray[0] as! Array<AnyObject>
                    returnParams["error_message"] = messages
                }
                callBackClosure(returnParams)
        }
    }
    
    
    
    class func login(user: User, callBackClosure: (Dictionary<String, AnyObject>) -> Void) {
        
        var params: [String: AnyObject] = [
            "email": user.email,
            "password": user.password,
        ]
        
        var returnParams: Dictionary<String, AnyObject> = [:]
        let path = String.localhost() + "/api/sessions"
        Alamofire.request(.POST, path, parameters: params, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                var messageArray = JSON!["error_message"] as! Array<AnyObject>
                
                if messageArray.isEmpty {

                    let currentUser = CurrentUser.sharedInstance
                    currentUser.authToken = JSON!["auth_token"]
                    currentUser.name = JSON!["name"] as! String
                    currentUser.saveCurrentUserInUserDefault()
                    
                } else {
                    returnParams["error_message"] = messageArray
                }
                callBackClosure(returnParams)
        }
    }
    
    
}
