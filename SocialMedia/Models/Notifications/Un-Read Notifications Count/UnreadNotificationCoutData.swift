//
//	UnreadNotificationCoutData.swift
//
//	Create by Apple PC on 16/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UnreadNotificationCoutData : NSObject, NSCoding{

	var unreadNotification : Int?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		unreadNotification = dictionary["unreadNotification"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if unreadNotification != nil{
			dictionary["unreadNotification"] = unreadNotification
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         unreadNotification = aDecoder.decodeObject(forKey: "unreadNotification") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if unreadNotification != nil{
			aCoder.encode(unreadNotification, forKey: "unreadNotification")
		}

	}

}
