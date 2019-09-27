//
//  NetworkHandler.swift
//  GoRich
//
//  Created by Apple PC on 30/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler {
    
    
    class func postRequest(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        if Network.isAvailable {
            
            var headers: HTTPHeaders
            
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
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
            
            manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) -> Void in
                
                print(response)
                
                if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                    print(userToken)
                    debugPrint(userToken)
                    UserDefaults.standard.setValue(userToken, forKey: "userAuthToken")
                    debugPrint("\(UserDefaults.standard.value(forKey: "userAuthToken")!)")
                }
                
                guard let statusCode = response.response?.statusCode else {
                    var networkError = NetworkError()
                    
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                    return
                    
                }
                
                if statusCode == 422 {
                    var networkError = NetworkError()
                    
                    let response = response.result.value!
                    let dictionary = response as! [String: AnyObject]
                    
                    guard let message = dictionary["error"] as! String? else {
                        networkError.status = statusCode
                        networkError.message = "Validation Error"
                        
                        failure(networkError)
                        
                        return
                    }
                    networkError.status = statusCode
                    networkError.message = message
                    
                    failure(networkError)
                    
                    
                }else{
                    switch (response.result) {
                    case .success:
                        let response = response.result.value!
                        success(response)
                        break
                    case .failure(let error):
                        var networkError = NetworkError()
                        
                        if error._code == NSURLErrorTimedOut {
                            networkError.status = Constants.NetworkError.timout
                            networkError.message = Constants.NetworkError.timoutError
                            
                            failure(networkError)
                        } else {
                            networkError.status = Constants.NetworkError.generic
                            networkError.message = Constants.NetworkError.genericError
                            
                            failure(networkError)
                        }
                        
                        break
                    }
                }
            
            }
            
            
            
        } else {
            let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
            failure(networkError)
        }
        
    
    }
    
    
    
    
    class func getRequest(url: String, parameters: Parameters?, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval

        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            print(userToken)

            headers = [
                "Accept": "application/json",
                "Authorization" : userToken
              
            ]
        } else {
            headers = [
                "Accept": "application/json",
            ]
        }
        print(headers)
        
        manager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) -> Void in
            
            print(response)
            
            
            switch response.result{
            //Case 1
            case .success:
                let response = response.result.value!
                success(response)
                
                
                break
            case .failure (let error):
                // print(error)
                
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
                break
            }
        }
    }
    
    // MARK: Upload Multipart File
    
    class func upload(url: String, fileUrl: URL, fileName: String, params: Parameters?, uploadProgress: @escaping (Int) -> Void, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken//"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        print(headers)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.uploadingTimeOutInterval
        
        manager.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(fileUrl, withName: fileName)
            
            if let parameters = params {
                for (key, value) in parameters {
                    //multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    multipartFormData.append(String(describing: value).data(using:.utf8, allowLossyConversion: false)!, withName: key)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progress = Int(progress.fractionCompleted * 100)
                    uploadProgress(progress)
                })
                upload.responseJSON { response in
                    print(response)
                    guard let returnValue = response.result.value else {
                        var networkError = NetworkError()
                        networkError.status = Constants.NetworkError.generic
                        networkError.message = Constants.NetworkError.genericError
                        
                        failure(networkError)
                        return
                    }
                    
                    if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                        
                        print("User Token is \(userToken)")
                        UserDefaults.standard.set(userToken, forKey: "userAuthToken")
                        UserDefaults.standard.synchronize()
                        
                    }
                    
                    success(returnValue)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
            }
        })
    }
    
    // MARK: Upload two Multipart File
    
    class func uploadMultiple(url: String, fileUrl: URL,fileUrl2: URL, fileName: String,fileName2: String, params: Parameters?, uploadProgress: @escaping (Int) -> Void, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken//"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        print(headers)
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(fileUrl, withName: fileName)
             multipartFormData.append(fileUrl2, withName: fileName2)
            
            if let parameters = params {
                for (key, value) in parameters {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progress = Int(progress.fractionCompleted * 100)
                    uploadProgress(progress)
                })
                upload.responseJSON { response in
                    print(response)
                    
                    let returnValue = response.result.value!
                    
                    if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                        
                        print("User Token is \(userToken)")
                        UserDefaults.standard.set(userToken, forKey: "userAuthToken")
                        UserDefaults.standard.synchronize()
                        
                    }
                    
                    success(returnValue)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
            }
        })
    }
    
    class func uploadMultiple(url: String, fileUrls: [URL], fileName: String, params: Parameters?, uploadProgress: @escaping (Int) -> Void, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken//"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        print(headers)
        print(params)
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            for i in 0..<fileUrls.count {
                let name = fileName + String(i) + "]"
                multipartFormData.append(fileUrls[i], withName: name)
            }
            
            if let parameters = params {
                for (key, value) in parameters {
                    
                    multipartFormData.append(String(describing: value).data(using:.utf8, allowLossyConversion: false)!, withName: key)
                    
                   // multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progress = Int(progress.fractionCompleted * 100)
                    uploadProgress(progress)
                })
                upload.responseJSON { response in
                    print(response)
                    
                    let returnValue = response.result.value!
                    
                    if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                        
                        print("User Token is \(userToken)")
                        UserDefaults.standard.set(userToken, forKey: "userAuthToken")
                        UserDefaults.standard.synchronize()
                        
                    }
                    
                    success(returnValue)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
            }
        })
    }
    
}

struct NetworkError {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}

struct NetworkSuccess {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}


