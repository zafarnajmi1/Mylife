//
//  SearchHandler.swift
//  Freestyle
//
//  Created by Macbook on 05/07/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire

class SearchHandler{
    
    static let sharedInstance = SearchHandler()

    // MARK: - SEARCH PHOTOS/VIDEOS
    class func getPost(params: NSDictionary,success: @escaping (searchPostModel)-> Void, failure: @escaping (NetworkError?)->Void){
        //+ "?page=" + pageNo
        let url = ApiCalls.baseUrlBuild + ApiCalls.searchPost
        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = searchPostModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - SEARCH PHOTOS/VIDEOS
    class func getPostDetails(params: NSDictionary,success: @escaping (PostDetailsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        //+ "?page=" + pageNo
        let url = ApiCalls.baseUrlBuild + ApiCalls.postDetails
        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostDetailsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
}

