//
//  Constants.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 06/07/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import DeviceKit
import UIKit

extension RawRepresentable where RawValue == String {
    var description: String {
        return rawValue
    }
}

enum ViewControllerSegue: String {
    case unnamed = ""
}

struct AppColor {
    static let primaryBlue = 0x41B3F6
    static let blueColor = "0x41B3F6"
}

class Constants {
    enum FontSize: CGFloat {
        
        case normal, iPhone = 16
        case iPad = 18
        
        var normal: CGFloat {
            return 16
        }
        
        var iPhone: CGFloat {
            return 16
        }
        
        var iPad: CGFloat {
            return 24
        }
        
        var iPhonex: CGFloat {
            return 18
        }
        
        public static var navigationBarTitle: CGFloat {
            let device = UIDevice.deviceType
            
            switch device {
            case .iPhoneX:
                return 20
            case .iPhone:
                return 18
            case .iPad:
                return 22
            }
        }
    }
    
    struct Observer {
        static let generic = "MyTechnologyObserver"
    }
    
    struct Color {
        static let primary = 0x41B3F6
        static let primaryDark = 0x0A367C
        static let primaryGreen = 0x00897b
        static let primaryLight = 0x78b9fb
    }
    
    struct Api {
        
        struct status {
            static let ok = 200
            static let error = 400
        }
    }
    
    struct NetworkError {
        static let timeOutInterval: TimeInterval = 2
        static let uploadingTimeOutInterval: TimeInterval = 2
        
        static let error = "Error"
        static let internetNotAvailable = "Internet Not Available"
        static let pleaseTryAgain = "Please Try Again"
        
        static let generic = 4000
        static let genericError = "Please Try Again."
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available"
        static let serverError = "Server Not Availabe, Please Try Later."
        
        static let timout = 4001
        static let timoutError = "Network Time Out, Please Try Again.".localized
        
        static let login = 4003
        static let loginMessage = "Unable To Login"
        static let loginError = "Please Try Again."
        
        static let internet = 4004
        static let internetError = "Internet Not Available"
    }
    
    struct NetworkSuccess {
        static let statusOK = 200
    }
}
