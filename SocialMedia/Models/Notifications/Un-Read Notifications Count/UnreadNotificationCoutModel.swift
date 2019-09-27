//
//	UnreadNotificationCoutModel.swift
//
//	Create by Apple PC on 16/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UnreadNotificationCoutModel : NSObject, NSCoding{

	var data : UnreadNotificationCoutData!
	var message : String!
	var pagination : UnreadNotificationCoutPagination!
	var statusCode : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let dataData = dictionary["data"] as? [String:Any]{
			data = UnreadNotificationCoutData(fromDictionary: dataData)
		}
		message = dictionary["message"] as? String
		if let paginationData = dictionary["pagination"] as? [String:Any]{
			pagination = UnreadNotificationCoutPagination(fromDictionary: paginationData)
		}
		statusCode = dictionary["status_code"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			dictionary["data"] = data.toDictionary()
		}
		if message != nil{
			dictionary["message"] = message
		}
		if pagination != nil{
			dictionary["pagination"] = pagination.toDictionary()
		}
		if statusCode != nil{
			dictionary["status_code"] = statusCode
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? UnreadNotificationCoutData
         message = aDecoder.decodeObject(forKey: "message") as? String
         pagination = aDecoder.decodeObject(forKey: "pagination") as? UnreadNotificationCoutPagination
         statusCode = aDecoder.decodeObject(forKey: "status_code") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if pagination != nil{
			aCoder.encode(pagination, forKey: "pagination")
		}
		if statusCode != nil{
			aCoder.encode(statusCode, forKey: "status_code")
		}

	}

}