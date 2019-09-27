//
//  FaqsTranslation.swift
//  SocialMedia
//
//  Created by iOSDev on 11/3/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct FaqsTranslation{
    
    var answer : String!
    var createdAt : Int!
    var id : Int!
    var languageId : Int!
    var question : String!
    var questionId : Int!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        answer = dictionary["answer"] as? String
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        languageId = dictionary["language_id"] as? Int
        question = dictionary["question"] as? String
        questionId = dictionary["question_id"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if answer != nil{
            dictionary["answer"] = answer
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if languageId != nil{
            dictionary["language_id"] = languageId
        }
        if question != nil{
            dictionary["question"] = question
        }
        if questionId != nil{
            dictionary["question_id"] = questionId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
