//
//  PostManager.swift
//  SocialMedia
//
//  Created by My Technology on 24/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class PostManager: BaseManager {
    
    static let shared = PostManager()
    
    
    func reportPostBy(postId: Int, completion: @escaping( String?, RootReportPostModel?) -> Void) {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var path =  " "
        
        
        
        if lang == "ar" {
            path = ApiCalls.reportPostByIdAr
        }
        else {
            path = ApiCalls.reportPostByIdEn
        }
        let params = ["post_id": postId ] as [String: AnyObject]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers:self.headers)
        //response
        request.responseObject { (response : DataResponse<RootReportPostModel>) in
            
            
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
