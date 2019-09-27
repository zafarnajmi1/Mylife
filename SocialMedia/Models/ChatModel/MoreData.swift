//
//  MoreData.swift
//  SocialMedia
//
//  Created by iOSDev on 7/16/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

public class MoreData {
    public var success : Int?
    public var data : DataComplete?
    public var message : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [MoreData]
    {
        var models:[MoreData] = []
        for item in array
        {
            models.append(MoreData(dictionary: item as! NSDictionary)!)
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
        
        success = dictionary["success"] as? Int
        if (dictionary["data"] != nil) { data = DataComplete(dictionary: dictionary["data"] as! NSDictionary) }
        message = dictionary["message"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
        dictionary.setValue(self.message, forKey: "message")
        
        return dictionary
    }
    
}


public class DataComplete {
    public var percent : Int?
    public var place : Int?
    public var pointer : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [DataComplete]
    {
        var models:[DataComplete] = []
        for item in array
        {
            models.append(DataComplete(dictionary: item as! NSDictionary)!)
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
        
        percent = dictionary["percent"] as? Int
        place = dictionary["place"] as? Int
        pointer = dictionary["pointer"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.percent, forKey: "percent")
        dictionary.setValue(self.place, forKey: "place")
        dictionary.setValue(self.pointer, forKey: "pointer")
        
        return dictionary
    }
    
}

