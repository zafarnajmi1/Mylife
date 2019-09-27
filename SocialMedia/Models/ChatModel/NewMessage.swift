//
//  NewMessage.swift
//  SocialMedia
//
//  Created by iOSDev on 8/3/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit


public class NewMessage {
    public var message : String?
    public var data : NewData?
    public var success : Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewMessage]
    {
        var models:[NewMessage] = []
        for item in array
        {
            models.append(NewMessage(dictionary: item as! NSDictionary)!)
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
        if (dictionary["data"] != nil) { data = NewData(dictionary: dictionary["data"] as! NSDictionary) }
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


public class NewData {
    public var id : Int?
    public var sender_id : Int?
    public var chat_group_id : Int?
    public var conversation_id : Int?
    public var receiver_id : Int?
    public var deleted_by : String?
    public var message : String?
    public var attachment : String?
    public var attachment_type : String?
    public var thumbnail : String?
    public var is_read : Int?
    public var created_at : Int?
    public var updated_at : Int?
    public var sender : NewSender?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewData]
    {
        var models:[NewData] = []
        for item in array
        {
            models.append(NewData(dictionary: item as! NSDictionary)!)
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
        
        id = dictionary["id"] as? Int
        sender_id = dictionary["sender_id"] as? Int
        chat_group_id = dictionary["chat_group_id"] as? Int
        conversation_id = dictionary["conversation_id"] as? Int
        receiver_id = dictionary["receiver_id"] as? Int
        deleted_by = dictionary["deleted_by"] as? String
        message = dictionary["message"] as? String
        attachment = dictionary["attachment"] as? String
        attachment_type = dictionary["attachment_type"] as? String
        thumbnail = dictionary["thumbnail"] as? String
        is_read = dictionary["is_read"] as? Int
        created_at = dictionary["created_at"] as? Int
        updated_at = dictionary["updated_at"] as? Int
        if (dictionary["sender"] != nil) { sender = NewSender(dictionary: dictionary["sender"] as! NSDictionary) }
    
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.sender_id, forKey: "sender_id")
        dictionary.setValue(self.chat_group_id, forKey: "chat_group_id")
        dictionary.setValue(self.conversation_id, forKey: "conversation_id")
        dictionary.setValue(self.receiver_id, forKey: "receiver_id")
        dictionary.setValue(self.deleted_by, forKey: "deleted_by")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.attachment, forKey: "attachment")
        dictionary.setValue(self.attachment_type, forKey: "attachment_type")
        dictionary.setValue(self.thumbnail, forKey: "thumbnail")
        dictionary.setValue(self.is_read, forKey: "is_read")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.sender?.dictionaryRepresentation(), forKey: "sender")

        return dictionary
    }
    
}


public class NewSender {
    public var id : Int?
    public var full_name : String?
    public var is_online : Int?
    public var gender : String?
    public var image : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let sender_list = Sender.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Sender Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewSender]
    {
        var models:[NewSender] = []
        for item in array
        {
            models.append(NewSender(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let sender = Sender(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Sender Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        full_name = dictionary["full_name"] as? String
        is_online = dictionary["is_online"] as? Int
        gender = dictionary["gender"] as? String
        image = dictionary["image"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.full_name, forKey: "full_name")
        dictionary.setValue(self.is_online, forKey: "is_online")
        dictionary.setValue(self.gender, forKey: "gender")
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
    
}

