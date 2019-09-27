//
//  ShareData.swift
//  Salon Station
//
//  Created by Muhammad Umer on 19/04/2018.
//  Copyright © 2018 Apple PC. All rights reserved.
//

import UIKit


class ShareData  {
    static let sharedUserInfo = ShareData()
 
    var flagimage : Bool!
    var comment : String?
    var pickedImnageUrl : URL?
    var attactment : String?
    var flagAPI: Bool!


    var areaId: Int!
    var cityId: Int!
    
    var notification_count = 0

    
    
}

