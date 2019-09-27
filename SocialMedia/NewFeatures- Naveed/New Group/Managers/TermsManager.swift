//
//  TermsManager.swift
//  SocialMedia
//
//  Created by My Technology on 20/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper




class TermsManager:BaseManager{
    static let shared = TermsManager()
    
    
    
    
    func fetchTermsList(completion: @escaping( String?, RootTermsModel?) -> Void) {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
      
        var path =  " "
        
        
        
        if lang == "ar" {
          path = ApiCalls.getTermsAr
        }
        else {
             path = ApiCalls.getTermsEn
        }
            
       
        
     
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers:nil)
        
        request.responseObject { (response : DataResponse<RootTermsModel>) in
            
            //response Http
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





