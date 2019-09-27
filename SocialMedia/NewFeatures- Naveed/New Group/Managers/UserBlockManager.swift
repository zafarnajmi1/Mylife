//
//  UserBlockManager.swift
//  SocialMedia
//
//  Created by My Technology on 21/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper




class UserBlockManager:BaseManager{
    static let shared = UserBlockManager()
    
    
    
    
    func fetchBlockUserList(completion: @escaping( String?, RootBlockedUserModel?) -> Void) {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var path =  " "
        
        if lang == "ar" {
            path = ApiCalls.blockedUsersAr
        }
        else {
            path = ApiCalls.blockedUsersEn
        }
        

        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers:self.headers)
          //response 
        request.responseObject { (response : DataResponse<RootBlockedUserModel>) in
            
          
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            
            //response result API
            switch response.result {
            case .success(_):
                let object = response.result.value
                completion(nil, object)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
            
            
        }
        
    }
    
    
    
    func blockUserBy(userId: Int, completion: @escaping( String?, RootBlockedUserModel?) -> Void) {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var path =  " "
        
        
        
        if lang == "ar" {
            path = ApiCalls.blockUserByIdAr
        }
        else {
            path = ApiCalls.blockUserByIdEn
        }
        let params = ["blocked_user_id": userId ] as [String: AnyObject]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers:self.headers)
        //response
        request.responseObject { (response : DataResponse<RootBlockedUserModel>) in
            
            
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            
            //response result API
            switch response.result {
            case .success(_):
                let object = response.result.value
                completion(nil, object)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
            
            
        }
        
    }
    
    
    
    func unblockUserBy(userId: Int, completion: @escaping( String?, RootBlockedUserModel?) -> Void) {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var path =  " "
        
        
        
        if lang == "ar" {
            path = ApiCalls.unblockUserByIdAr
        }
        else {
            path = ApiCalls.unblockUserByIdEn
        }
        let params = ["blocked_user_id": userId ] as [String: AnyObject]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers:self.headers)
        //response
        request.responseObject { (response : DataResponse<RootBlockedUserModel>) in
            
            
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            
            //response result API
            switch response.result {
            case .success(_):
                let object = response.result.value
                completion(nil, object)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
            
            
        }
        
    }
}

