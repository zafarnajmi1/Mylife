//
//  FriendsHandler.swift
//  SocialMedia
//
//  Created by Macbook on 17/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire

class FriendsHandler{
    // MARK: - Get All Friends
    class func getAllFriends(params: NSDictionary,success: @escaping (UserGetAllFriendsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.MyFriends
        print(url)
        print(params)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objFriends = UserGetAllFriendsModel(fromDictionary: dictionary)
            success(objFriends)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }

    }
    
    // MARK: - Search Friends
    class func getAllSearchedFriends(subString: String,success: @escaping (UserGetAllFriendsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.SearchFriendRequest + subString
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = UserGetAllFriendsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Remove Friends
    class func removeFriends(params: NSDictionary,success: @escaping (UnFriendModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.RemoveFriendRequest
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = UnFriendModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - My Friend Request
    class func myFriendRequest(success: @escaping (MyFriendRequestModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.MyFriendRequest
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = MyFriendRequestModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    // MARK: - My Friend Request
    class func EmojiRequest(success: @escaping (EmojiModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.MyEmojis
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = EmojiModel(dictionary: dictionary as NSDictionary)
            success(objData!)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    // MARK: - ACCEPT FRIEND REQUEST
    class func acceptFriendRequest(params: NSDictionary,success: @escaping (AcceptFriendRequestModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.AcceptFriendRequest
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = AcceptFriendRequestModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - REJECT FRIEND REQUEST
    class func rejectFriendRequest(params: NSDictionary,success: @escaping (RejectFriendRequestModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.RejectFriendRequest
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = RejectFriendRequestModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - SEND FRIEND REQUEST
    class func sendFriendRequest(params: NSDictionary,success: @escaping (SendFriendRequestModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.SendFriendRequest
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = SendFriendRequestModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - FOLLOW THE USER
    class func followTheUser(params: NSDictionary,success: @escaping (FollowUnFollowUsersModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.FollowTheUser
        print(url)
        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = FollowUnFollowUsersModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Un-FOLLOW THE USER
    class func unFollowTheUser(params: NSDictionary,success: @escaping (FollowUnFollowUsersModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.UnFollowThaUser
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = FollowUnFollowUsersModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - GET ONLINE FRIENDS
    class func getOnlineFriends(success: @escaping (UserOnlineFriendsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.OnlineFriends
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let model = UserOnlineFriendsModel(fromDictionary: dictionary)
            print(model)
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
