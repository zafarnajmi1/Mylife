//
//	SearchPeopleData.swift
//
//	Create by Apple PC on 2/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SearchPeopleData : NSObject, NSCoding{

	var email : String!
	var fullName : String!
	var id : Int!
	var image : String!
    public var friends : Array<Friends>?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		email = dictionary["email"] as? String
		fullName = dictionary["full_name"] as? String
		id = dictionary["id"] as? Int
		image = dictionary["image"] as? String
        
        if (dictionary["friends"] != nil) { friends = Friends.modelsFromDictionaryArray(array: dictionary["friends"] as! NSArray) }
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
		if image != nil{
			dictionary["image"] = image
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
         image = aDecoder.decodeObject(forKey: "image") as? String

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
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}

	}

}

public class Friends {
    public var id : Int?
    public var user_id : Int?
    public var friend_id : Int?
    public var sender_id : Int?
    public var is_friend : Bool?
    public var created_at : Int?
    public var updated_at : Int?
    public var deleted_at : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let friends_list = Friends.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Friends Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Friends]
    {
        var models:[Friends] = []
        for item in array
        {
            models.append(Friends(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let friends = Friends(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Friends Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        user_id = dictionary["user_id"] as? Int
        friend_id = dictionary["friend_id"] as? Int
        sender_id = dictionary["sender_id"] as? Int
        is_friend = dictionary["is_friend"] as? Bool
        created_at = dictionary["created_at"] as? Int
        updated_at = dictionary["updated_at"] as? Int
        deleted_at = dictionary["deleted_at"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.friend_id, forKey: "friend_id")
        dictionary.setValue(self.sender_id, forKey: "sender_id")
        dictionary.setValue(self.is_friend, forKey: "is_friend")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.deleted_at, forKey: "deleted_at")
        
        return dictionary
    }
    
}

