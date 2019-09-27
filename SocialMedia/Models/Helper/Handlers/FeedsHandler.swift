//
//  FeedsHandler.swift
//  SocialMedia
//
//  Created by Macbook on 19/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire
import GooglePlaces

class FeedsHandler{
    // Mark: - Get Stories
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    static let sharedInstance = FeedsHandler()
    var isFeelingSelected = false
    var objFeeling : FeelingsData?
    var isStatusUpdated = false

    var isFriendsTagged = false
    var taggedFriends: [UserGetAllFriendsData]?
    
    var selectedPlace : GMSPlace?
    var isPlaceSelected = false
    
    var isStatusPosted = false
    
    var isVideoSelected = false
    var selectedVideoUrl : URL?
    
    var isSelectdImage = false
    var selectedImage : UIImage?
    var selectedImageUrl : URL?
    
    class func getStories(success: @escaping (StoriesModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en")
        {
            url = ApiCalls.baseUrlBuild + ApiCalls.getStories
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.getStories
        }
        print(url)        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            print(successResponse)
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let model = StoriesModel.init(fromDictionary: dictionary)
            print(model)
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    //MARK:- Get Permanent Stories
    class func getPermanentStories(success: @escaping (StoriesModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en")
        {
            url = ApiCalls.baseUrlBuild + ApiCalls.getPermanentStories
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.getPermanentStories
        }
        print(url)
        let objUser = UserHandler.sharedInstance.userData
        let userID: Int = (objUser?.id)!
        let parameter : Parameters = ["user_id":userID]
        NetworkHandler.getRequest(url: url, parameters: parameter, success: { (successResponse) in
            print(successResponse)
            
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let model = StoriesModel.init(fromDictionary: dictionary)
            print(model)
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Get News Feed
    class func getNewsfeed (url: String,success: @escaping (NewsFeedModel)-> Void, failure: @escaping (NetworkError?)->Void){
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print("this is new feed resposne",dictionary)
            let model = NewsFeedModel.init(fromDictionary: dictionary)
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Get My Schedule
    class func getMySchedules (sortOrder: String??,success: @escaping (NewsFeedModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
            url = ApiCalls.baseUrlBuild + ApiCalls.getMySchedule
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.getMySchedule
        }
        print(url)

        url = url + "?sort_order=\(sortOrder!!)"
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print("\(dictionary)")
            let model = NewsFeedModel.init(fromDictionary: dictionary)
            success(model)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    class func getMyShedulesNextPage (url: String,success: @escaping (NewsFeedModel)-> Void, failure: @escaping (NetworkError?)->Void){
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print("\(dictionary)")
            let model = NewsFeedModel.init(fromDictionary: dictionary)
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Share Post/Feed
    class func shareFeed (params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
           url = ApiCalls.baseUrlBuild + ApiCalls.shareFeed
        }else{
            url = ApiCalls.baseUrlBuildAR + ApiCalls.shareFeed
            
        }
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            success(dictionary as NSDictionary)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    // MARK: - Like Post/Feed
    class func postLike (params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
         url = ApiCalls.baseUrlBuild + ApiCalls.postLike
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.postLike
        }
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            success(dictionary as NSDictionary)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    // MARK: - Get User Timeline
    class func getUserTimeline (url: String,params: NSDictionary, success: @escaping (TimelineModel)-> Void, failure: @escaping (NetworkError?)->Void){
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objTimeline = TimelineModel.init(fromDictionary: dictionary)
            success(objTimeline)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    // MARK: - Get Feelings
    class func getFeelings ( success: @escaping (FeelingsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
        url = ApiCalls.baseUrlBuild + ApiCalls.getFeelings
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.getFeelings
        }
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objFeeling = FeelingsModel.init(fromDictionary: dictionary)
            success(objFeeling)
        }) { (errorResponse) in
            print(errorResponse)
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    // MARK: - Post Status
    class func postStatus (params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
          url = ApiCalls.baseUrlBuild + ApiCalls.createPost
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.createPost
        }
        print("url for post status...",url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            print(successResponse)
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            success(dictionary as NSDictionary)
            
        }) { (errorResponse) in
            print(errorResponse)
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    // MARK: - Post Status With Image
//    class func postStatusWithImage (fileUrl:URL, params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
//        let url = ApiCalls.baseUrlBuild + ApiCalls.createPost
//        print(url)
//        print(params)
//
//        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "attachment", params: params as? Parameters, uploadProgress: { (progess) in
//            print(Progress())
//        }, success: { (successResponse) in
//            let dictionary = successResponse as! [String: AnyObject]
//            success(dictionary as NSDictionary)
//        }) { (error) in
//            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
//        }
//    }
    
    class func postStatusWithImage (fileUrl:URL,fileUrl2:URL, params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
          url = ApiCalls.baseUrlBuild + ApiCalls.createPost
        }else{
           url = ApiCalls.baseUrlBuildAR + ApiCalls.createPost
        }
        print(url)
        print(params)
        
        NetworkHandler.uploadMultiple(url: url, fileUrl: fileUrl, fileUrl2: fileUrl2, fileName: "attachment[0]", fileName2: "", params: params as? Parameters, uploadProgress: { (progess) in
            print(progess)
            print(params)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            success(dictionary as NSDictionary)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }

        NetworkHandler.uploadMultiple(url: url, fileUrl: fileUrl2, fileUrl2: fileUrl2, fileName: "thumbnail", fileName2: "", params: params as? Parameters, uploadProgress: { (progess) in
            print(progess)
            print(params)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            success(dictionary as NSDictionary)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func postStatusWithImage (fileUrls:[URL], params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
         url = ApiCalls.baseUrlBuild + ApiCalls.createPost
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.createPost
        }
        print(url)
        print(params)
        
        NetworkHandler.uploadMultiple(url: url, fileUrls: fileUrls, fileName: "attachment[", params: params as? Parameters, uploadProgress: { progress in
            print(progress)
        }, success: { successResponse in
            let dictionary = successResponse as! [String: AnyObject]
            success(dictionary as NSDictionary)
        }) { error in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    // MARK: - Remove Post
    class func removePost (params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
          url = ApiCalls.baseUrlBuild + ApiCalls.RemovePost
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.RemovePost
        }
        print(url)
        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            success(dictionary as NSDictionary)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    // MARK: - Post Sotry
    class func uploadStory (fileUrl:URL, params: NSDictionary, success: @escaping (NSDictionary)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = ""
        if(lang == "en" )
        {
         url = ApiCalls.baseUrlBuild + ApiCalls.UploadStory
        }else
        {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UploadStory
        }
        print(url)
        print(params)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "media", params: params as? Parameters, uploadProgress: { (progess) in
            print(progess)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            success(dictionary as NSDictionary)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
}
