//
//	addEditEducationInformationData.swift
//
//	Create by Apple PC on 12/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class addEditEducationInformationData : NSObject, NSCoding{

	var createdAt : Int!
	var dateFrom : Int!
	var dateTo : Int!
	var degree : String!
	var id : Int!
	var school : String!
	var updatedAt : Int!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? Int
		dateFrom = dictionary["date_from"] as? Int
		dateTo = dictionary["date_to"] as? Int
		degree = dictionary["degree"] as? String
		id = dictionary["id"] as? Int
		school = dictionary["school"] as? String
		updatedAt = dictionary["updated_at"] as? Int
		userId = dictionary["user_id"] as? Int
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
		if dateFrom != nil{
			dictionary["date_from"] = dateFrom
		}
		if dateTo != nil{
			dictionary["date_to"] = dateTo
		}
		if degree != nil{
			dictionary["degree"] = degree
		}
		if id != nil{
			dictionary["id"] = id
		}
		if school != nil{
			dictionary["school"] = school
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
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
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         dateFrom = aDecoder.decodeObject(forKey: "date_from") as? Int
         dateTo = aDecoder.decodeObject(forKey: "date_to") as? Int
         degree = aDecoder.decodeObject(forKey: "degree") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         school = aDecoder.decodeObject(forKey: "school") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if dateFrom != nil{
			aCoder.encode(dateFrom, forKey: "date_from")
		}
		if dateTo != nil{
			aCoder.encode(dateTo, forKey: "date_to")
		}
		if degree != nil{
			aCoder.encode(degree, forKey: "degree")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if school != nil{
			aCoder.encode(school, forKey: "school")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}