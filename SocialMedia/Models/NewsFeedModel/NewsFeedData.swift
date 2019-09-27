//
//  NewsFeedData.swift
//  SocialMedia
//
//  Created by Macbook on 19/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct NewsFeedData{
    
    var checkinPlace : String!
    var createdAt : Int!
    var descriptionField : String!
    var feeling : NewsFeedFeeling!
    var feelingId : Int!
    var id : Int!
    var latitude : String!
    var longitude : String!
    var myLikeCount : Int!
    var parentId : Int!
    var postAttachment : NewsFeedPostAttachment!
    var postAttachmentData : [NewsFeedPostAttachment]!
    var postType : String!
    var scheduleAt : Int!
    var sharingType : String!
    var tagFriends : [NewsFeedTagFriend]!
    var totalComments : Int!
    var totalLikes : Int!
    var totalShares : Int!
    var updatedAt : Int!
    var user : NewsFeedUser!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        print("\(dictionary)")
        checkinPlace = dictionary["checkin_place"] as? String
        createdAt = dictionary["created_at"] as? Int
        descriptionField = dictionary["description"] as? String
        if let feelingData = dictionary["feeling"] as? [String:Any]{
            feeling = NewsFeedFeeling(fromDictionary: feelingData)
        }
        feelingId = dictionary["feeling_id"] as? Int
        id = dictionary["id"] as? Int
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        myLikeCount = dictionary["my_like_count"] as? Int
        parentId = dictionary["parent_id"] as? Int
        if let _postAttachmentData = dictionary["post_attachment"] as? NSArray{
            postAttachment = NewsFeedPostAttachment(fromDictionary: _postAttachmentData)
            postAttachmentData = []
            for value in _postAttachmentData {
                let dictionary = value as? NSDictionary
                let data  : NewsFeedPostAttachment = NewsFeedPostAttachment(fromDictionary: dictionary!)
                postAttachmentData.append(data)
            }
        }
        
        postType = dictionary["post_type"] as? String
        scheduleAt = dictionary["schedule_at"] as? Int
        sharingType = dictionary["sharing_type"] as? String
        tagFriends = [NewsFeedTagFriend]()
        if let tagFriendsArray = dictionary["tag_friends"] as? [[String:Any]]{
            for dic in tagFriendsArray{
                let value = NewsFeedTagFriend(fromDictionary: dic)
                tagFriends.append(value)
            }
        }
        totalComments = dictionary["total_comments"] as? Int
        totalLikes = dictionary["total_likes"] as? Int
        totalShares = dictionary["total_shares"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
        if let userData = dictionary["user"] as? [String:Any]{
            user = NewsFeedUser(fromDictionary: userData)
        }
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if checkinPlace != nil{
            dictionary["checkin_place"] = checkinPlace
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if feeling != nil{
            dictionary["feeling"] = feeling.toDictionary()
        }
        if feelingId != nil{
            dictionary["feeling_id"] = feelingId
        }
        if id != nil{
            dictionary["id"] = id
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if myLikeCount != nil{
            dictionary["my_like_count"] = myLikeCount
        }
        if parentId != nil{
            dictionary["parent_id"] = parentId
        }
        if postAttachment != nil{
            dictionary["post_attachment"] = postAttachment.toDictionary()
        }
        if postType != nil{
            dictionary["post_type"] = postType
        }
        if scheduleAt != nil{
            dictionary["schedule_at"] = scheduleAt
        }
        if sharingType != nil{
            dictionary["sharing_type"] = sharingType
        }
        if tagFriends != nil{
            var dictionaryElements = [[String:Any]]()
            for tagFriendsElement in tagFriends {
                dictionaryElements.append(tagFriendsElement.toDictionary())
            }
            dictionary["tag_friends"] = dictionaryElements
        }
        if totalComments != nil{
            dictionary["total_comments"] = totalComments
        }
        if totalLikes != nil{
            dictionary["total_likes"] = totalLikes
        }
        if totalShares != nil{
            dictionary["total_shares"] = totalShares
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if user != nil{
            dictionary["user"] = user.toDictionary()
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
