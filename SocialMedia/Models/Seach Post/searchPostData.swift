//
//	searchPostData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class searchPostData : NSObject, NSCoding{

	var checkinPlace : String!
	var createdAt : Int!
	var descriptionField : String!
	var feeling : searchPostFeeling!
	var feelingId : Int!
	var id : Int!
	var latitude : String!
	var longitude : String!
	var myLikeCount : Int!
	var parentId : Int!
    var postAttachment : searchPostPostAttachment!
    var postAttachmentData : [searchPostPostAttachment]!
	var postType : String!
	var scheduleAt : Int!
	var sharingType : String!
	var tagFriends : [AnyObject]!
	var totalComments : Int!
	var totalLikes : Int!
	var totalShares : Int!
	var updatedAt : Int!
	var user : searchPostUser!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		checkinPlace = dictionary["checkin_place"] as? String
		createdAt = dictionary["created_at"] as? Int
		descriptionField = dictionary["description"] as? String
		if let feelingData = dictionary["feeling"] as? [String:Any]{
			feeling = searchPostFeeling(fromDictionary: feelingData)
		}
		feelingId = dictionary["feeling_id"] as? Int
		id = dictionary["id"] as? Int
		latitude = dictionary["latitude"] as? String
		longitude = dictionary["longitude"] as? String
		myLikeCount = dictionary["my_like_count"] as? Int
		parentId = dictionary["parent_id"] as? Int
//        if let postAttachmentData = dictionary["post_attachment"] as? [String:Any]{
//            postAttachment = searchPostPostAttachment(fromDictionary: postAttachmentData)
//        }
        if let _postAttachmentData = dictionary["post_attachment"] as? NSArray{
//            postAttachment = searchPostPostAttachment(fromDictionary: _postAttachmentData)
            postAttachmentData = []
            for value in _postAttachmentData {
                let dictionary = value as? NSDictionary
                let data  : searchPostPostAttachment = searchPostPostAttachment(fromDictionary: dictionary! as! [String : Any])
                postAttachmentData.append(data)
            }
        }
		postType = dictionary["post_type"] as? String
		scheduleAt = dictionary["schedule_at"] as? Int
		sharingType = dictionary["sharing_type"] as? String
		tagFriends = dictionary["tag_friends"] as? [AnyObject]
		totalComments = dictionary["total_comments"] as? Int
		totalLikes = dictionary["total_likes"] as? Int
		totalShares = dictionary["total_shares"] as? Int
		updatedAt = dictionary["updated_at"] as? Int
		if let userData = dictionary["user"] as? [String:Any]{
			user = searchPostUser(fromDictionary: userData)
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
			dictionary["tag_friends"] = tagFriends
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

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         checkinPlace = aDecoder.decodeObject(forKey: "checkin_place") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         feeling = aDecoder.decodeObject(forKey: "feeling") as? searchPostFeeling
         feelingId = aDecoder.decodeObject(forKey: "feeling_id") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         latitude = aDecoder.decodeObject(forKey: "latitude") as? String
         longitude = aDecoder.decodeObject(forKey: "longitude") as? String
         myLikeCount = aDecoder.decodeObject(forKey: "my_like_count") as? Int
         parentId = aDecoder.decodeObject(forKey: "parent_id") as? Int
         postAttachment = aDecoder.decodeObject(forKey: "post_attachment") as? searchPostPostAttachment
         postType = aDecoder.decodeObject(forKey: "post_type") as? String
         scheduleAt = aDecoder.decodeObject(forKey: "schedule_at") as? Int
         sharingType = aDecoder.decodeObject(forKey: "sharing_type") as? String
         tagFriends = aDecoder.decodeObject(forKey: "tag_friends") as? [AnyObject]
         totalComments = aDecoder.decodeObject(forKey: "total_comments") as? Int
         totalLikes = aDecoder.decodeObject(forKey: "total_likes") as? Int
         totalShares = aDecoder.decodeObject(forKey: "total_shares") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? searchPostUser
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if checkinPlace != nil{
			aCoder.encode(checkinPlace, forKey: "checkin_place")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if feeling != nil{
			aCoder.encode(feeling, forKey: "feeling")
		}
		if feelingId != nil{
			aCoder.encode(feelingId, forKey: "feeling_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if latitude != nil{
			aCoder.encode(latitude, forKey: "latitude")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "longitude")
		}
		if myLikeCount != nil{
			aCoder.encode(myLikeCount, forKey: "my_like_count")
		}
		if parentId != nil{
			aCoder.encode(parentId, forKey: "parent_id")
		}
		if postAttachment != nil{
			aCoder.encode(postAttachment, forKey: "post_attachment")
		}
		if postType != nil{
			aCoder.encode(postType, forKey: "post_type")
		}
		if scheduleAt != nil{
			aCoder.encode(scheduleAt, forKey: "schedule_at")
		}
		if sharingType != nil{
			aCoder.encode(sharingType, forKey: "sharing_type")
		}
		if tagFriends != nil{
			aCoder.encode(tagFriends, forKey: "tag_friends")
		}
		if totalComments != nil{
			aCoder.encode(totalComments, forKey: "total_comments")
		}
		if totalLikes != nil{
			aCoder.encode(totalLikes, forKey: "total_likes")
		}
		if totalShares != nil{
			aCoder.encode(totalShares, forKey: "total_shares")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
