//
//	UserOnlineFriendsPagination.swift
//
//	Create by Apple PC on 16/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserOnlineFriendsPagination : NSObject, NSCoding{

	var currentPage : Int!
	var from : Int!
	var lastPage : Int!
	var nextPageUrl : AnyObject!
	var path : String!
	var perPage : Int!
	var prevPageUrl : AnyObject!
	var to : Int!
	var total : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		currentPage = dictionary["current_page"] as? Int
		from = dictionary["from"] as? Int
		lastPage = dictionary["last_page"] as? Int
		nextPageUrl = dictionary["next_page_url"] as? AnyObject
		path = dictionary["path"] as? String
		perPage = dictionary["per_page"] as? Int
		prevPageUrl = dictionary["prev_page_url"] as? AnyObject
		to = dictionary["to"] as? Int
		total = dictionary["total"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if currentPage != nil{
			dictionary["current_page"] = currentPage
		}
		if from != nil{
			dictionary["from"] = from
		}
		if lastPage != nil{
			dictionary["last_page"] = lastPage
		}
		if nextPageUrl != nil{
			dictionary["next_page_url"] = nextPageUrl
		}
		if path != nil{
			dictionary["path"] = path
		}
		if perPage != nil{
			dictionary["per_page"] = perPage
		}
		if prevPageUrl != nil{
			dictionary["prev_page_url"] = prevPageUrl
		}
		if to != nil{
			dictionary["to"] = to
		}
		if total != nil{
			dictionary["total"] = total
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         currentPage = aDecoder.decodeObject(forKey: "current_page") as? Int
         from = aDecoder.decodeObject(forKey: "from") as? Int
         lastPage = aDecoder.decodeObject(forKey: "last_page") as? Int
         nextPageUrl = aDecoder.decodeObject(forKey: "next_page_url") as? AnyObject
         path = aDecoder.decodeObject(forKey: "path") as? String
         perPage = aDecoder.decodeObject(forKey: "per_page") as? Int
         prevPageUrl = aDecoder.decodeObject(forKey: "prev_page_url") as? AnyObject
         to = aDecoder.decodeObject(forKey: "to") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if currentPage != nil{
			aCoder.encode(currentPage, forKey: "current_page")
		}
		if from != nil{
			aCoder.encode(from, forKey: "from")
		}
		if lastPage != nil{
			aCoder.encode(lastPage, forKey: "last_page")
		}
		if nextPageUrl != nil{
			aCoder.encode(nextPageUrl, forKey: "next_page_url")
		}
		if path != nil{
			aCoder.encode(path, forKey: "path")
		}
		if perPage != nil{
			aCoder.encode(perPage, forKey: "per_page")
		}
		if prevPageUrl != nil{
			aCoder.encode(prevPageUrl, forKey: "prev_page_url")
		}
		if to != nil{
			aCoder.encode(to, forKey: "to")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}

	}

}