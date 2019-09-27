//
//  BaseManager.swift
//  SocialMedia
//
//  Created by My Technology on 20/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//


import Foundation
import Alamofire


class BaseManager: NSObject {
    
    var sessionManager: SessionManager
//    var basePath: String
//    var rawHeader: HTTPHeaders
    var headers: HTTPHeaders
    
    override init() {
        
        
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String{
            if  UserHandler.sharedInstance.isLoginCall{
                UserHandler.sharedInstance.isLoginCall = false
                headers = [
                    "Accept": "application/json"
                ]
            }else{
                headers = [
                    "Accept": "application/json",
                    "Authorization" : userToken
                ]
            }
        } else {
            headers = [
                "Accept": "application/json"
            ]
        }
        print(headers)
        
        
        
        
        sessionManager = Alamofire.SessionManager.default
       
    }
    
    
    
   
}
