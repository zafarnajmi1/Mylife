//
//  UserData.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 26/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation


class UserData : NSObject, NSCoding{
    
    var aboutMe : String!
    var birthday : Int!
    var coverPhotoPath : String!
    var createdAt : Int!
    var educationDetails : [AnyObject]!
    var email : String!
    var fullName : String!
    var gender : String!
    var id : Int!
    var isOnline : Bool!
    var livingPlace : String!
    var mobile : String!
    var profilePicturePath : String!
    var relationship : String!
    var totalFollowers : Int!
    var updatedAt : Int!
    var workDetails : [AnyObject]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aboutMe = dictionary["about_me"] as? String
        birthday = dictionary["birthday"] as? Int
        coverPhotoPath = dictionary["cover_photo_path"] as? String
        createdAt = dictionary["created_at"] as? Int
        educationDetails = dictionary["educationDetails"] as? [AnyObject]
        email = dictionary["email"] as? String
        fullName = dictionary["full_name"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        isOnline = dictionary["is_online"] as? Bool
        livingPlace = dictionary["living_place"] as? String
        mobile = dictionary["mobile"] as? String
        profilePicturePath = dictionary["profile_picture_path"] as? String
        relationship = dictionary["relationship"] as? String
        totalFollowers = dictionary["total_followers"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
        workDetails = dictionary["workDetails"] as? [AnyObject]
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
        if coverPhotoPath != nil{
            dictionary["cover_photo_path"] = coverPhotoPath
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if educationDetails != nil{
            dictionary["educationDetails"] = educationDetails
        }
        if email != nil{
            dictionary["email"] = email
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
        if isOnline != nil{
            dictionary["is_online"] = isOnline
        }
        if livingPlace != nil{
            dictionary["living_place"] = livingPlace
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if profilePicturePath != nil{
            dictionary["profile_picture_path"] = profilePicturePath
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
            dictionary["workDetails"] = workDetails
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        aboutMe = aDecoder.decodeObject(forKey: "about_me") as? String
        birthday = aDecoder.decodeObject(forKey: "birthday") as? Int
        coverPhotoPath = aDecoder.decodeObject(forKey: "cover_photo_path") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
        educationDetails = aDecoder.decodeObject(forKey: "educationDetails") as? [AnyObject]
        email = aDecoder.decodeObject(forKey: "email") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isOnline = aDecoder.decodeObject(forKey: "is_online") as? Bool
        livingPlace = aDecoder.decodeObject(forKey: "living_place") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        profilePicturePath = aDecoder.decodeObject(forKey: "profile_picture_path") as? String
        relationship = aDecoder.decodeObject(forKey: "relationship") as? String
        totalFollowers = aDecoder.decodeObject(forKey: "total_followers") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
        workDetails = aDecoder.decodeObject(forKey: "workDetails") as? [AnyObject]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if aboutMe != nil{
            aCoder.encode(aboutMe, forKey: "about_me")
        }
        if birthday != nil{
            aCoder.encode(birthday, forKey: "birthday")
        }
        if coverPhotoPath != nil{
            aCoder.encode(coverPhotoPath, forKey: "cover_photo_path")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if educationDetails != nil{
            aCoder.encode(educationDetails, forKey: "educationDetails")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isOnline != nil{
            aCoder.encode(isOnline, forKey: "is_online")
        }
        if livingPlace != nil{
            aCoder.encode(livingPlace, forKey: "living_place")
        }
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        if profilePicturePath != nil{
            aCoder.encode(profilePicturePath, forKey: "profile_picture_path")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }
        if totalFollowers != nil{
            aCoder.encode(totalFollowers, forKey: "total_followers")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if workDetails != nil{
            aCoder.encode(workDetails, forKey: "workDetails")
        }
        
    }
    
}
