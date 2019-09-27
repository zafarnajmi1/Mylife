//
//  NewsFeedPostAttachment.swift
//  SocialMedia
//
//  Created by iOSDev on 10/23/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct NewsFeedPostAttachment{
    
    var createdAt : Int!
    var id : Int!
    var path : String!
    var postId : Int!
    var thumbnail : String!
    var type : String!
    var updatedAt : Int!
    
    
    init(fromDictionary postAttachemntArray: NSArray){
        
                for i in 0..<postAttachemntArray.count{
        
                    //let messagesInfo  = MessagesInfo()
                    //Getting Message Data
                    createdAt = ((postAttachemntArray[i] as! NSDictionary).value(forKey: "created_at") as? Int)
                    id =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "id") as? Int)
                    path =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "path") as? String)
                    postId =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "post_id") as? Int)
                    thumbnail =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "thumbnail") as? String)
                    type =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "type") as? String)
                    updatedAt =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "updated_at") as? Int)
        
        
                    print("created at index \(i)",createdAt)
                }
        
        //Use for dictionary
//        createdAt = dictionary["created_at"] as? Int
//        id = dictionary["id"] as? Int
//        path = dictionary["path"] as? String
//        postId = dictionary["post_id"] as? Int
//        thumbnail = dictionary["thumbnail"] as? String
//        type = dictionary["type"] as? String
//        updatedAt = dictionary["updated_at"] as? Int
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        
//        for i in 0..<postAttachemntArray.count{
//
//            //let messagesInfo  = MessagesInfo()
//            //Getting Message Data
//            createdAt = ((postAttachemntArray[i] as! NSDictionary).value(forKey: "created_at") as? Int)
//            id =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "id") as? Int)
//            path =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "path") as? String)
//            postId =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "post_id") as? Int)
//            thumbnail =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "thumbnail") as? String)
//            type =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "type") as? String)
//            updatedAt =    ((postAttachemntArray[i] as! NSDictionary).value(forKey: "updated_at") as? Int)
//
//
//            print("created at index \(i)",createdAt)
//        }
        
        //Use for dictionary
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        path = dictionary["path"] as? String
        postId = dictionary["post_id"] as? Int
        thumbnail = dictionary["thumbnail"] as? String
        type = dictionary["type"] as? String
        updatedAt = dictionary["updated_at"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if path != nil{
            dictionary["path"] = path
        }
        if postId != nil{
            dictionary["post_id"] = postId
        }
        if thumbnail != nil{
            dictionary["thumbnail"] = thumbnail
        }
        if type != nil{
            dictionary["type"] = type
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
