//
//  Typing.swift
//  SocialMedia
//
//  Created by iOSDev on 7/16/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

public class Typing {
    public var message : String?
    public var data : TypingData?
    public var success : Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Typing]
    {
        var models:[Typing] = []
        for item in array
        {
            models.append(Typing(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        message = dictionary["message"] as? String
        if (dictionary["data"] != nil) { data = TypingData(dictionary: dictionary["data"] as! NSDictionary) }
        success = dictionary["success"] as? Bool
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
        dictionary.setValue(self.success, forKey: "success")
        
        return dictionary
    }
    
}
public class TypingData {
    public var receiver_id : Int?
    public var chat_group_id : Int?
    public var conversation_id : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [TypingData]
    {
        var models:[TypingData] = []
        for item in array
        {
            models.append(TypingData(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let data = Data(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Data Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        receiver_id = dictionary["receiver_id"] as? Int
        chat_group_id = dictionary["chat_group_id"] as? Int
        conversation_id = dictionary["conversation_id"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.receiver_id, forKey: "receiver_id")
        dictionary.setValue(self.chat_group_id, forKey: "chat_group_id")
        dictionary.setValue(self.conversation_id, forKey: "conversation_id")
        
        return dictionary
    }
    
}
