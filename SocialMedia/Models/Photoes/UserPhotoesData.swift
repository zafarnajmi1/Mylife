//
//	UserPhotoesData.swift
//
//	Create by Apple PC on 16/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserPhotoesData : NSObject, NSCoding{

	var id : Int!
	var postAttachment : UserPhotoesPostAttachment!
    var postAttachmentData : [UserPhotoesPostAttachment]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["id"] as? Int
        if let _postAttachmentData = dictionary["post_attachment"] as? NSArray{
//            postAttachment = UserPhotoesPostAttachment(fromDictionary: _postAttachmentData)
            postAttachmentData = []
            for value in _postAttachmentData {
                let dictionary = value as? NSDictionary
                let data  : UserPhotoesPostAttachment = UserPhotoesPostAttachment(fromDictionary: dictionary! as! [String : Any])
                postAttachmentData.append(data)
            }
        }
//        if let postAttachmentData = dictionary["post_attachment"] as? [String:Any]{
//            postAttachment = UserPhotoesPostAttachment(fromDictionary: postAttachmentData)
//        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if postAttachment != nil{
			dictionary["post_attachment"] = postAttachment.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         postAttachment = aDecoder.decodeObject(forKey: "post_attachment") as? UserPhotoesPostAttachment

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if postAttachment != nil{
			aCoder.encode(postAttachment, forKey: "post_attachment")
		}

	}

}
