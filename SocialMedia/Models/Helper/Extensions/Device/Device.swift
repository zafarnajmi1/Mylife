//
//  Device.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 22/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import DeviceKit

extension UIDevice {
    
    public enum DeviceType {
        case iPhone
        case iPhoneX
        case iPad
    }
    
    public static var deviceType: DeviceType {
        if UIDevice.isiPad {
            return DeviceType.iPad
        } else {
            if UIDevice.isiPhoneX {
                return DeviceType.iPhoneX
            } else {
                return DeviceType.iPhone
            }
        }
    }
    
    public static var isiPad: Bool {
        let device = Device()
        
        if device.isPad {
            return true
        } else  {
            return false
        }
    }
    
    public static var isiPhone: Bool {
        let device = Device()
        
        if device.isPhone {
            return true
        } else  {
            return false
        }
    }
    
    public static var isSimulator: Bool {
        let device = Device()
        
        if device.isSimulator {
            return true
        } else {
            return false
        }
    }
    
    public static var isiPhoneX: Bool {
        let device = Device()
        
        switch device {
        case .simulator(.iPhoneX):
            
            return true
            
        case .iPhoneX:
            
            return true
            
        default:
            return false
        }
    }
    
    public static var isiPhonePlus: Bool {
        let device = Device()
        
        switch device {
        case .simulator(.iPhone6Plus), .simulator(.iPhone7Plus), .simulator(.iPhone8Plus):
            
            return true
            
        case .iPhone6Plus, .iPhone7Plus, .iPhone8Plus:
            
            return true
            
            
        default:
            return false
        }
    }
    
    public static var isiPhone5: Bool {
        let device = Device()
        
        switch device {
        case .simulator(.iPhone5), .simulator(.iPhone5s), .simulator(.iPhoneSE):
            
            return true
            
        case .iPhone5, .iPhone5s, .iPhoneSE:
            return true
            
        default:
            return false
        }
    }
}
