//
//	UpdateUserInformationData.swift
//
//	Create by Apple PC on 26/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UpdateUserInformationData : NSObject, NSCoding{

	var aboutMe : String!
	var birthday : Int!
	var cover : String!
	var createdAt : Int!
	var email : String!
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


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		aboutMe = dictionary["about_me"] as? String
		birthday = dictionary["birthday"] as? Int
		cover = dictionary["cover"] as? String
		createdAt = dictionary["created_at"] as? Int
		email = dictionary["email"] as? String
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
		if cover != nil{
			dictionary["cover"] = cover
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
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
         cover = aDecoder.decodeObject(forKey: "cover") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         email = aDecoder.decodeObject(forKey: "email") as? String
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         gender = aDecoder.decodeObject(forKey: "gender") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         isOnline = aDecoder.decodeObject(forKey: "is_online") as? Bool
         livingPlace = aDecoder.decodeObject(forKey: "living_place") as? String
         mobile = aDecoder.decodeObject(forKey: "mobile") as? String
         notifiyFriendRequest = aDecoder.decodeObject(forKey: "notifiy_friend_request") as? Bool
         notifiyPostComment = aDecoder.decodeObject(forKey: "notifiy_post_comment") as? Bool
         notifiyPostLike = aDecoder.decodeObject(forKey: "notifiy_post_like") as? Bool
         notifiyPostShare = aDecoder.decodeObject(forKey: "notifiy_post_share") as? Bool
         notifiyRequestAccepted = aDecoder.decodeObject(forKey: "notifiy_request_accepted") as? Bool
         relationship = aDecoder.decodeObject(forKey: "relationship") as? String
         totalFollowers = aDecoder.decodeObject(forKey: "total_followers") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

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
		if cover != nil{
			aCoder.encode(cover, forKey: "cover")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
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
		if image != nil{
			aCoder.encode(image, forKey: "image")
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
		if notifiyFriendRequest != nil{
			aCoder.encode(notifiyFriendRequest, forKey: "notifiy_friend_request")
		}
		if notifiyPostComment != nil{
			aCoder.encode(notifiyPostComment, forKey: "notifiy_post_comment")
		}
		if notifiyPostLike != nil{
			aCoder.encode(notifiyPostLike, forKey: "notifiy_post_like")
		}
		if notifiyPostShare != nil{
			aCoder.encode(notifiyPostShare, forKey: "notifiy_post_share")
		}
		if notifiyRequestAccepted != nil{
			aCoder.encode(notifiyRequestAccepted, forKey: "notifiy_request_accepted")
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

	}

}