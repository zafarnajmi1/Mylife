//
//	UserGetAllFriendsData.swift
//
//	Create by Apple PC on 27/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserGetAllFriendsData : NSObject, NSCoding{

	var email : String!
	var fullName : String!
	var id : Int!
    var is_online : Int!
	var profilePicturePath : String!
    var birthday : Int!
    var isTagged = false
    
     var isSelect = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		email = dictionary["email"] as? String
		fullName = dictionary["full_name"] as? String
		id = dictionary["id"] as? Int
		profilePicturePath = dictionary["image"] as? String
        birthday = dictionary["birthday"] as? Int
          is_online = dictionary["is_online"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if email != nil{
			dictionary["email"] = email
		}
		if fullName != nil{
			dictionary["full_name"] = fullName
		}
		if id != nil{
			dictionary["id"] = id
		}
        
        if is_online != nil{
            dictionary["is_online"] = is_online
        }
        
		if profilePicturePath != nil{
			dictionary["image"] = profilePicturePath
		}
        if birthday != nil{
            dictionary["birthday"] = birthday
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         email = aDecoder.decodeObject(forKey: "email") as? String
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
        is_online = aDecoder.decodeObject(forKey: "is_online") as? Int

         profilePicturePath = aDecoder.decodeObject(forKey: "image") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
        if is_online != nil{
            aCoder.encode(is_online, forKey: "is_online")
        }
        
		if profilePicturePath != nil{
			aCoder.encode(profilePicturePath, forKey: "image")
		}

	}

}
