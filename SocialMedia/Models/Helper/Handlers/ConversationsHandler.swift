//
//  ConversationsHandler.swift
//  SocialMedia
//
//  Created by Macbook on 17/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire

class ConversationsHandler {
    // MARK: - CONVERSATION
    class func getConversation(success: @escaping (UserConversationModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.UserConversation
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objData = UserConversationModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - DELETE CONVERSATION
    class func deleteConversation(params: NSDictionary,success: @escaping (DeleteConversationModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.DeleteUserConversation
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = DeleteConversationModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - Get Conversation Messages
    class func getConversationMessages (params: NSDictionary,success: @escaping (ChatModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.getConversationMessages
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print("response : \(dictionary)")
            let objData = ChatModel.init(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK; - Post Chat Messages
    class func postConversationMessage (params: NSDictionary,success: @escaping (SendMessageModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.postConversationMessage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = SendMessageModel.init(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - Post Chat Messages With Attachment
    class func postCoversationMessageWithAttachment(fileUrl:URL, params: NSDictionary,success: @escaping (SendMessageModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let url = ApiCalls.baseUrlBuild + ApiCalls.postConversationMessage
        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "attachment", params: params as? Parameters, uploadProgress: { (progress) in
            print(progress)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = SendMessageModel.init(fromDictionary: dictionary)
            success(objData)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - Post Chat Messages With Video Attachment
    class func postCoversationMessageWithVideoAttachment (fileUrl:URL,fileUrl2:URL, params: NSDictionary, success: @escaping (SendMessageModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.postConversationMessage
        print(url)
        print(params)
     
        NetworkHandler.uploadMultiple(url: url, fileUrl: fileUrl, fileUrl2: fileUrl2, fileName: "attachment", fileName2: "thumbnail", params: params as? Parameters, uploadProgress: { (progess) in
            print(progess)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = SendMessageModel.init(fromDictionary: dictionary)
            success(objData)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK; - Delete Chat Messages
    class func deleteConversationMessage (params: NSDictionary,success: @escaping (DeleteConversationModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.deleteConversationMessage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = DeleteConversationModel.init(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - CREATE GROUP
    class func createGroupChat (params: NSDictionary,success: @escaping (CreateGroupChatModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.CreateGroupChat
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = CreateGroupChatModel.init(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - Change GROUP Picture
    class func editGroupPicture(fileName:String,fileUrl:URL, params: NSDictionary,success: @escaping (CreateGroupChatModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let url = ApiCalls.baseUrlBuild + ApiCalls.CreateGroupChat
        print(url)
        
        
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: fileName, params: params as? Parameters, uploadProgress: { (progress) in
            print(progress)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = CreateGroupChatModel.init(fromDictionary: dictionary)
            success(objData)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Update GROUP
    class func updateGroupDetail (params: NSDictionary,success: @escaping (CreateGroupChatModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let url = ApiCalls.baseUrlBuild + ApiCalls.CreateGroupChat
        print(url)

        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = CreateGroupChatModel.init(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
