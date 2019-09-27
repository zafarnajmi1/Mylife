//
//  RootReportPostModel.swift
//  SocialMedia
//
//  Created by My Technology on 24/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class RootReportPostModel : NSObject, Mappable {
    var message : String?
    var data : ReportPostDataModel?
    
    
    
    class func newInstance(map: Map) -> Mappable?{
        return RootReportPostModel()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map) {
        
        message <- map["message"]
        data <- map["data"]
       
        
    }
    
}


