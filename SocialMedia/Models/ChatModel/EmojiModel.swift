//
//  EmojiModel.swift
//  SocialMedia
//
//  Created by iOSDev on 7/17/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
public class EmojiModel {
    public var message : String?
    public var data : EmojiData?
    public var status_code : Int?
    public var pagination : EmojiPagination?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [EmojiModel]
    {
        var models:[EmojiModel] = []
        for item in array
        {
            models.append(EmojiModel(dictionary: item as! NSDictionary)!)
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
        if (dictionary["data"] != nil) { data = EmojiData(dictionary: dictionary["data"] as! NSDictionary) }
        status_code = dictionary["status_code"] as? Int
        if (dictionary["pagination"] != nil) { pagination = EmojiPagination(dictionary: dictionary["pagination"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
        dictionary.setValue(self.status_code, forKey: "status_code")
        dictionary.setValue(self.pagination?.dictionaryRepresentation(), forKey: "pagination")
        
        return dictionary
    }
    
}

public class EmojiPagination {
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let pagination_list = Pagination.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Pagination Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [EmojiPagination]
    {
        var models:[EmojiPagination] = []
        for item in array
        {
            models.append(EmojiPagination(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let pagination = Pagination(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Pagination Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }
    
}

public class EmojiData {
    public var emoji : Array<Emoji>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [EmojiData]
    {
        var models:[EmojiData] = []
        for item in array
        {
            models.append(EmojiData(dictionary: item as! NSDictionary)!)
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
        
        if (dictionary["emoji"] != nil) { emoji = Emoji.modelsFromDictionaryArray(array: dictionary["emoji"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }
    
}

public class Emoji {
    public var name : String?
    public var icons : Array<Icons>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let emoji_list = Emoji.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Emoji Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Emoji]
    {
        var models:[Emoji] = []
        for item in array
        {
            models.append(Emoji(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let emoji = Emoji(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Emoji Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        if (dictionary["icons"] != nil) { icons = Icons.modelsFromDictionaryArray(array: dictionary["icons"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.name, forKey: "name")
        
        return dictionary
    }
    
}

public class Icons {
    public var name : String?
    public var image : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let icons_list = Icons.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Icons Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Icons]
    {
        var models:[Icons] = []
        for item in array
        {
            models.append(Icons(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let icons = Icons(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Icons Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        image = dictionary["image"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
    
}

