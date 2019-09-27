//
//  UnreadMessage.swift
//  SocialMedia
//
//  Created by iOSDev on 7/30/18.
//  Copyright © 2018 My Technology. All rights reserved.
//



import Foundation


class UnreadMessage : NSObject, NSCoding{
    
    var unread : Int?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        unread = dictionary["unread"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if unread != nil{
            dictionary["unread"] = unread
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        unread = aDecoder.decodeObject(forKey: "unread") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if unread != nil{
            aCoder.encode(unread, forKey: "unread")
        }
        
    }
    
}
