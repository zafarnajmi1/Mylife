//
//  ReportPostDataModel.swift
//  SocialMedia
//
//  Created by My Technology on 24/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class ReportPostDataModel : NSObject, Mappable {
    var postId :Int?
    var userId :Int?
    var id :Int?
   
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ReportPostDataModel()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map) {
        
        postId <- map["post_id"]
        userId <- map["user_id"]
        id <- map["id"]
        
    }
    
}

