//
//  UserProfileData.swift
//  SocialMedia
//
//  Created by iOSDev on 11/1/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct UserProfileData{
    
    var aboutMe : String!
    var birthday : Int!
    var contacts : [AnyObject]!
    var cover : String!
    var createdAt : Int!
    var educationDetails : [UserProfileEducationDetail]!
    var email : String!
    var followStatus : String!
    var friendStatus : String!
    var friendsCount : Int!
    var fullName : String!
    var gender : String!
    var id : Int!
    var image : String!
    var isOnline : Bool!
    var livingPlace : String!
    var mobile : String!
    var notifiyFriendRequest : Bool!
    var notifiyPostComment : Bool!
    var notifiyPostLike : Bool!
    var notifiyPostShare : Bool!
    var notifiyRequestAccepted : Bool!
    var relationship : String!
    var totalFollowers : Int!
    var updatedAt : Int!
    var workDetails : [UserProfileWorkDetail]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aboutMe = dictionary["about_me"] as? String
        birthday = dictionary["birthday"] as? Int
        contacts = dictionary["contacts"] as? [AnyObject]
        cover = dictionary["cover"] as? String
        createdAt = dictionary["created_at"] as? Int
        educationDetails = [UserProfileEducationDetail]()
        if let educationDetailsArray = dictionary["educationDetails"] as? [[String:Any]]{
            for dic in educationDetailsArray{
                let value = UserProfileEducationDetail(fromDictionary: dic)
                educationDetails.append(value)
            }
        }
        email = dictionary["email"] as? String
        followStatus = dictionary["follow_status"] as? String
        friendStatus = dictionary["friend_status"] as? String
        friendsCount = dictionary["friends_count"] as? Int
        fullName = dictionary["full_name"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? String
        isOnline = dictionary["is_online"] as? Bool
        livingPlace = dictionary["living_place"] as? String
        mobile = dictionary["mobile"] as? String
        notifiyFriendRequest = dictionary["notifiy_friend_request"] as? Bool
        notifiyPostComment = dictionary["notifiy_post_comment"] as? Bool
        notifiyPostLike = dictionary["notifiy_post_like"] as? Bool
        notifiyPostShare = dictionary["notifiy_post_share"] as? Bool
        notifiyRequestAccepted = dictionary["notifiy_request_accepted"] as? Bool
        relationship = dictionary["relationship"] as? String
        totalFollowers = dictionary["total_followers"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
        workDetails = [UserProfileWorkDetail]()
        if let workDetailsArray = dictionary["workDetails"] as? [[String:Any]]{
            for dic in workDetailsArray{
                let value = UserProfileWorkDetail(fromDictionary: dic)
                workDetails.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aboutMe != nil{
            dictionary["about_me"] = aboutMe
        }
        if birthday != nil{
            dictionary["birthday"] = birthday
        }
        if contacts != nil{
            dictionary["contacts"] = contacts
        }
        if cover != nil{
            dictionary["cover"] = cover
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if educationDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for educationDetailsElement in educationDetails {
                dictionaryElements.append(educationDetailsElement.toDictionary())
            }
            dictionary["educationDetails"] = dictionaryElements
        }
        if email != nil{
            dictionary["email"] = email
        }
        if followStatus != nil{
            dictionary["follow_status"] = followStatus
        }
        if friendStatus != nil{
            dictionary["friend_status"] = friendStatus
        }
        if friendsCount != nil{
            dictionary["friends_count"] = friendsCount
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if isOnline != nil{
            dictionary["is_online"] = isOnline
        }
        if livingPlace != nil{
            dictionary["living_place"] = livingPlace
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if notifiyFriendRequest != nil{
            dictionary["notifiy_friend_request"] = notifiyFriendRequest
        }
        if notifiyPostComment != nil{
            dictionary["notifiy_post_comment"] = notifiyPostComment
        }
        if notifiyPostLike != nil{
            dictionary["notifiy_post_like"] = notifiyPostLike
        }
        if notifiyPostShare != nil{
            dictionary["notifiy_post_share"] = notifiyPostShare
        }
        if notifiyRequestAccepted != nil{
            dictionary["notifiy_request_accepted"] = notifiyRequestAccepted
        }
        if relationship != nil{
            dictionary["relationship"] = relationship
        }
        if totalFollowers != nil{
            dictionary["total_followers"] = totalFollowers
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if workDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for workDetailsElement in workDetails {
                dictionaryElements.append(workDetailsElement.toDictionary())
            }
            dictionary["workDetails"] = dictionaryElements
        }
        return dictionary
    }
    
}
