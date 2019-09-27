//
//	UserPhotoesModel.swift
//
//	Create by Apple PC on 13/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserPhotoesModel : NSObject, NSCoding{

	var data : UserPhotoesData!
	var message : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let dataData = dictionary["data"] as? [String:Any]{
			data = UserPhotoesData(fromDictionary: dataData)
		}
		message = dictionary["message"] as? String
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? UserPhotoesData
         message = aDecoder.decodeObject(forKey: "message") as? String

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

	}

}